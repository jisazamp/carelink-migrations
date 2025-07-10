-- ============================================================================
-- MIGRACIÓN COMPLETA DEL SISTEMA DE TRANSPORTE
-- ============================================================================

-- 1. Actualizar la tabla cronograma_asistencia_pacientes para incluir transporte
ALTER TABLE cronograma_asistencia_pacientes
ADD COLUMN requiere_transporte BOOLEAN DEFAULT FALSE AFTER estado_asistencia;

-- 2. Crear tabla principal de transporte
CREATE TABLE `cronograma_transporte` (
  `id_transporte` int NOT NULL AUTO_INCREMENT,
  `id_cronograma_paciente` int NOT NULL,
  `direccion_recogida` text COLLATE utf8mb4_unicode_ci,
  `direccion_entrega` text COLLATE utf8mb4_unicode_ci,
  `hora_recogida` time DEFAULT NULL,
  `hora_entrega` time DEFAULT NULL,
  `estado` enum('PENDIENTE','REALIZADO','CANCELADO') COLLATE utf8mb4_unicode_ci DEFAULT 'PENDIENTE',
  `observaciones` text COLLATE utf8mb4_unicode_ci,
  `fecha_creacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_actualizacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_transporte`),
  KEY `idx_estado` (`estado`),
  KEY `idx_fecha_creacion` (`fecha_creacion`),
  KEY `idx_cronograma_paciente` (`id_cronograma_paciente`),
  KEY `idx_hora_recogida` (`hora_recogida`),
  CONSTRAINT `cronograma_transporte_ibfk_1` FOREIGN KEY (`id_cronograma_paciente`) REFERENCES `cronograma_asistencia_pacientes` (`id_cronograma_paciente`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 3. Crear tabla de configuración de rutas (opcional para futuras expansiones)
CREATE TABLE `configuracion_rutas` (
  `id_configuracion` int NOT NULL AUTO_INCREMENT,
  `id_profesional` int NOT NULL,
  `nombre_ruta` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `descripcion` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `activa` tinyint(1) DEFAULT '1',
  `fecha_creacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_configuracion`),
  KEY `idx_profesional` (`id_profesional`),
  KEY `idx_activa` (`activa`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 4. Crear tabla de historial de cambios de estado de transporte
CREATE TABLE `historial_transporte` (
  `id_historial` int NOT NULL AUTO_INCREMENT,
  `id_transporte` int NOT NULL,
  `estado_anterior` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `estado_nuevo` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `observaciones` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `fecha_cambio` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `id_usuario_cambio` int DEFAULT NULL,
  PRIMARY KEY (`id_historial`),
  KEY `idx_transporte` (`id_transporte`),
  KEY `idx_fecha_cambio` (`fecha_cambio`),
  CONSTRAINT `historial_transporte_ibfk_1` FOREIGN KEY (`id_transporte`) REFERENCES `cronograma_transporte` (`id_transporte`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 5. Insertar datos de prueba para transporte (opcional)
INSERT INTO
    cronograma_transporte (
        id_cronograma_paciente,
        direccion_recogida,
        direccion_entrega,
        hora_recogida,
        hora_entrega,
        estado,
        observaciones
    )
SELECT cap.id_cronograma_paciente, CONCAT(
        'Calle ', FLOOR(RAND() * 100) + 1, ' #', FLOOR(RAND() * 50) + 1, ' - Barrio Centro'
    ), CONCAT(
        'Calle ', FLOOR(RAND() * 100) + 1, ' #', FLOOR(RAND() * 50) + 1, ' - Barrio Norte'
    ), TIME(
        '08:00:00' + INTERVAL FLOOR(RAND() * 4) HOUR
    ), TIME(
        '16:00:00' + INTERVAL FLOOR(RAND() * 2) HOUR
    ), 'PENDIENTE', 'Transporte programado'
FROM
    cronograma_asistencia_pacientes cap
WHERE
    cap.requiere_transporte = TRUE
LIMIT 5;

-- 6. Crear vista para facilitar consultas de rutas diarias
CREATE VIEW vista_rutas_diarias AS
SELECT
    ct.id_transporte,
    ct.id_cronograma_paciente,
    cap.id_usuario,
    cap.id_contrato,
    cap.estado_asistencia,
    cap.requiere_transporte,
    u.nombres,
    u.apellidos,
    u.n_documento,
    ct.direccion_recogida,
    ct.direccion_entrega,
    ct.hora_recogida,
    ct.hora_entrega,
    ct.estado as estado_transporte,
    ct.observaciones as observaciones_transporte,
    ca.fecha,
    ca.id_profesional
FROM
    cronograma_transporte ct
    JOIN cronograma_asistencia_pacientes cap ON ct.id_cronograma_paciente = cap.id_cronograma_paciente
    JOIN Usuarios u ON cap.id_usuario = u.id_usuario
    JOIN cronograma_asistencia ca ON cap.id_cronograma = ca.id_cronograma
WHERE
    cap.requiere_transporte = TRUE;

-- 7. Crear procedimiento almacenado para actualizar estado de transporte
DELIMITER /
/

CREATE DEFINER=`root`@`%` PROCEDURE `actualizar_estado_transporte`(
    IN p_id_transporte INT,
    IN p_estado_nuevo VARCHAR(20),
    IN p_observaciones TEXT,
    IN p_id_usuario_cambio INT
)
BEGIN
    DECLARE v_estado_anterior VARCHAR(20);
    
    -- Obtener estado anterior
    SELECT estado INTO v_estado_anterior 
    FROM cronograma_transporte 
    WHERE id_transporte = p_id_transporte;
    
    -- Actualizar estado
    UPDATE cronograma_transporte 
    SET 
        estado = p_estado_nuevo,
        observaciones = COALESCE(p_observaciones, observaciones),
        fecha_actualizacion = CURRENT_TIMESTAMP
    WHERE id_transporte = p_id_transporte;
    
    -- Registrar en historial
    INSERT INTO historial_transporte (
        id_transporte, 
        estado_anterior, 
        estado_nuevo, 
        observaciones, 
        id_usuario_cambio
    ) VALUES (
        p_id_transporte, 
        v_estado_anterior, 
        p_estado_nuevo, 
        p_observaciones, 
        p_id_usuario_cambio
    );
    
    COMMIT;
END
/
/

DELIMITER;

-- 8. Crear trigger para validar cambios de estado
DELIMITER /
/

CREATE TRIGGER validar_estado_transporte
BEFORE UPDATE ON cronograma_transporte
FOR EACH ROW
BEGIN
    -- Validar que el estado sea válido
    IF NEW.estado NOT IN ('PENDIENTE', 'REALIZADO', 'CANCELADO') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Estado de transporte inválido. Estados válidos: PENDIENTE, REALIZADO, CANCELADO';
    END IF;
    
    -- No permitir cambiar de REALIZADO a PENDIENTE
    IF OLD.estado = 'REALIZADO' AND NEW.estado = 'PENDIENTE' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No se puede cambiar el estado de REALIZADO a PENDIENTE';
    END IF;
END
/
/

DELIMITER;

-- 9. Crear índices adicionales para optimización
CREATE INDEX idx_transporte_fecha_hora ON cronograma_transporte (fecha_creacion, hora_recogida);

CREATE INDEX idx_transporte_estado_fecha ON cronograma_transporte (estado, fecha_creacion);

CREATE INDEX idx_cronograma_fecha ON cronograma_asistencia (fecha);

CREATE INDEX idx_cronograma_profesional_fecha ON cronograma_asistencia (id_profesional, fecha);

-- 10. Comentarios de documentación
-- Esta migración establece el sistema completo de transporte con:
-- - Tabla principal de transporte con estados y horarios
-- - Configuración de rutas para futuras expansiones
-- - Historial de cambios para auditoría
-- - Vista optimizada para consultas de rutas
-- - Procedimiento almacenado para actualizaciones seguras
-- - Triggers para validación de datos
-- - Índices para optimización de consultas