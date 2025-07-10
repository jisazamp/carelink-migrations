-- ============================================================================
-- MIGRACIÓN PARA PREVENIR DOBLE AGENDAMIENTO
-- ============================================================================
-- Ejecutar: mysql -u root -p carelink < prevent_double_booking.sql

-- 1. Agregar índice único para prevenir doble agendamiento
-- Este índice único asegura que un paciente no pueda estar agendado más de una vez
-- en el mismo cronograma (misma fecha, mismo profesional)
ALTER TABLE cronograma_asistencia_pacientes
ADD UNIQUE INDEX idx_unique_paciente_cronograma (id_cronograma, id_usuario);

-- 2. Agregar índice para optimizar consultas de validación
CREATE INDEX idx_paciente_fecha ON cronograma_asistencia_pacientes (id_usuario, id_cronograma);

-- 3. Agregar índice para optimizar consultas por contrato
CREATE INDEX idx_contrato_paciente ON cronograma_asistencia_pacientes (id_contrato, id_usuario);

-- 4. Crear trigger para validación adicional (opcional, como respaldo)
DELIMITER / /

CREATE TRIGGER validar_doble_agendamiento
BEFORE INSERT ON cronograma_asistencia_pacientes
FOR EACH ROW
BEGIN
    DECLARE paciente_count INT DEFAULT 0;
    
    -- Verificar si el paciente ya está agendado en este cronograma
    SELECT COUNT(*) INTO paciente_count
    FROM cronograma_asistencia_pacientes
    WHERE id_cronograma = NEW.id_cronograma 
    AND id_usuario = NEW.id_usuario;
    
    IF paciente_count > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No se puede agendar un paciente dos veces en el mismo cronograma';
    END IF;
END//

DELIMITER;

-- 5. Comentarios de documentación
-- Esta migración establece las siguientes protecciones contra doble agendamiento:
-- - Índice único que previene duplicados a nivel de base de datos
-- - Índices adicionales para optimizar consultas de validación
-- - Trigger como respaldo adicional para validación
-- - Las validaciones en el código del backend son la primera línea de defensa
-- - El índice único es la segunda línea de defensa
-- - El trigger es la tercera línea de defensa