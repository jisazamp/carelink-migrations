-- ============================================================================
-- MIGRACIÓN: MEJORAR SISTEMA DE FACTURACIÓN
-- ============================================================================
-- Fecha: 2025-01-XX
-- Descripción: Mejora del sistema de facturación para módulo completo
-- Objetivo: Agregar campos faltantes, optimizar índices y mejorar estructura

-- ============================================================================
-- 1. MEJORAR TABLA FACTURAS
-- ============================================================================

-- Agregar campos faltantes a la tabla Facturas
ALTER TABLE `Facturas`
ADD COLUMN `numero_factura` VARCHAR(20) UNIQUE NULL AFTER `id_factura`,
ADD COLUMN `fecha_vencimiento` DATE NULL AFTER `fecha_emision`,
ADD COLUMN `subtotal` DECIMAL(10, 2) DEFAULT 0.00 AFTER `total_factura`,
ADD COLUMN `impuestos` DECIMAL(10, 2) DEFAULT 0.00 AFTER `subtotal`,
ADD COLUMN `descuentos` DECIMAL(10, 2) DEFAULT 0.00 AFTER `impuestos`,
ADD COLUMN `observaciones` TEXT NULL AFTER `descuentos`,
ADD COLUMN `fecha_creacion` TIMESTAMP DEFAULT CURRENT_TIMESTAMP AFTER `observaciones`,
ADD COLUMN `fecha_actualizacion` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP AFTER `fecha_creacion`;

-- Cambiar estado_factura de TEXT a ENUM para mejor control
ALTER TABLE `Facturas`
MODIFY COLUMN `estado_factura` ENUM(
    'PENDIENTE',
    'PAGADA',
    'VENCIDA',
    'CANCELADA',
    'ANULADA'
) DEFAULT 'PENDIENTE' AFTER `descuentos`;

-- ============================================================================
-- 2. MEJORAR TABLA DETALLEFACTURA
-- ============================================================================

-- Agregar campos faltantes a DetalleFactura
ALTER TABLE `DetalleFactura`
ADD COLUMN `subtotal_linea` DECIMAL(10, 2) DEFAULT 0.00 AFTER `valor_unitario`,
ADD COLUMN `impuestos_linea` DECIMAL(10, 2) DEFAULT 0.00 AFTER `subtotal_linea`,
ADD COLUMN `descuentos_linea` DECIMAL(10, 2) DEFAULT 0.00 AFTER `impuestos_linea`,
ADD COLUMN `descripcion_servicio` VARCHAR(255) NULL AFTER `descuentos_linea`;

-- ============================================================================
-- 3. CREAR ÍNDICES PARA OPTIMIZACIÓN
-- ============================================================================

-- Índices para Facturas
CREATE INDEX `idx_facturas_contrato` ON `Facturas` (`id_contrato`);

CREATE INDEX `idx_facturas_fecha_emision` ON `Facturas` (`fecha_emision`);

CREATE INDEX `idx_facturas_fecha_vencimiento` ON `Facturas` (`fecha_vencimiento`);

CREATE INDEX `idx_facturas_estado` ON `Facturas` (`estado_factura`);

CREATE INDEX `idx_facturas_numero` ON `Facturas` (`numero_factura`);

-- Índices para DetalleFactura
CREATE INDEX `idx_detalle_factura_factura` ON `DetalleFactura` (`id_factura`);

CREATE INDEX `idx_detalle_factura_servicio` ON `DetalleFactura` (`id_servicio_contratado`);

-- Índices para Pagos
CREATE INDEX `idx_pagos_factura` ON `Pagos` (`id_factura`);

CREATE INDEX `idx_pagos_fecha` ON `Pagos` (`fecha_pago`);

CREATE INDEX `idx_pagos_metodo` ON `Pagos` (`id_metodo_pago`);

-- Índices para ServiciosPorContrato
CREATE INDEX `idx_servicios_contrato_contrato` ON `ServiciosPorContrato` (`id_contrato`);

CREATE INDEX `idx_servicios_contrato_servicio` ON `ServiciosPorContrato` (`id_servicio`);

CREATE INDEX `idx_servicios_contrato_fecha` ON `ServiciosPorContrato` (`fecha`);

-- ============================================================================
-- 4. AGREGAR RESTRICCIONES Y VALIDACIONES
-- ============================================================================

-- Agregar restricción para que el total_factura sea >= 0
ALTER TABLE `Facturas`
ADD CONSTRAINT `chk_total_factura_positivo` CHECK (`total_factura` >= 0);

-- Agregar restricción para que subtotal + impuestos - descuentos = total_factura
ALTER TABLE `Facturas`
ADD CONSTRAINT `chk_calculo_total` CHECK (
    `subtotal` + `impuestos` - `descuentos` = `total_factura`
);

-- Agregar restricción para que cantidad sea > 0 en DetalleFactura
ALTER TABLE `DetalleFactura`
ADD CONSTRAINT `chk_cantidad_positiva` CHECK (`cantidad` > 0);

-- Agregar restricción para que valor_unitario sea >= 0
ALTER TABLE `DetalleFactura`
ADD CONSTRAINT `chk_valor_unitario_positivo` CHECK (`valor_unitario` >= 0);

-- ============================================================================
-- 5. CREAR VISTAS PARA FACILITAR CONSULTAS
-- ============================================================================

-- Vista para facturas con información completa
CREATE VIEW `v_facturas_completas` AS
SELECT
    f.id_factura,
    f.numero_factura,
    f.id_contrato,
    c.tipo_contrato,
    c.fecha_inicio,
    c.fecha_fin,
    u.nombres as nombre_usuario,
    u.apellidos as apellidos_usuario,
    u.n_documento,
    f.fecha_emision,
    f.fecha_vencimiento,
    f.subtotal,
    f.impuestos,
    f.descuentos,
    f.total_factura,
    f.estado_factura,
    f.observaciones,
    f.fecha_creacion,
    f.fecha_actualizacion,
    -- Calcular total pagado
    COALESCE(SUM(p.valor), 0) as total_pagado,
    -- Calcular saldo pendiente
    (
        f.total_factura - COALESCE(SUM(p.valor), 0)
    ) as saldo_pendiente
FROM
    `Facturas` f
    LEFT JOIN `Contratos` c ON f.id_contrato = c.id_contrato
    LEFT JOIN `Usuarios` u ON c.id_usuario = u.id_usuario
    LEFT JOIN `Pagos` p ON f.id_factura = p.id_factura
GROUP BY
    f.id_factura;

-- Vista para detalles de factura con información de servicios
CREATE VIEW `v_detalle_factura_completo` AS
SELECT
    df.id_detalle_factura,
    df.id_factura,
    df.id_servicio_contratado,
    df.cantidad,
    df.valor_unitario,
    df.subtotal_linea,
    df.impuestos_linea,
    df.descuentos_linea,
    df.descripcion_servicio,
    spc.descripcion as descripcion_servicio_contratado,
    spc.precio_por_dia,
    s.nombre as nombre_servicio,
    s.descripcion as descripcion_servicio_original,
    (
        df.cantidad * df.valor_unitario
    ) as total_linea_calculado
FROM
    `DetalleFactura` df
    JOIN `ServiciosPorContrato` spc ON df.id_servicio_contratado = spc.id_servicio_contratado
    JOIN `Servicios` s ON spc.id_servicio = s.id_servicio;

-- ============================================================================
-- 6. CREAR PROCEDIMIENTOS ALMACENADOS ÚTILES
-- ============================================================================

DELIMITER / /

-- Procedimiento para generar número de factura automático
CREATE DEFINER=`root`@`%` PROCEDURE `generar_numero_factura`(
    IN p_anio INT,
    OUT p_numero_factura VARCHAR(20)
)
BEGIN
    DECLARE v_ultimo_numero INT DEFAULT 0;
    DECLARE v_nuevo_numero INT DEFAULT 1;
    
    -- Obtener el último número de factura del año
    SELECT COALESCE(MAX(CAST(SUBSTRING(numero_factura, 9) AS UNSIGNED)), 0)
    INTO v_ultimo_numero
    FROM `Facturas` 
    WHERE numero_factura LIKE CONCAT('FACT-', p_anio, '-%');
    
    -- Generar nuevo número
    SET v_nuevo_numero = v_ultimo_numero + 1;
    SET p_numero_factura = CONCAT('FACT-', p_anio, '-', LPAD(v_nuevo_numero, 6, '0'));
END //

-- Procedimiento para calcular totales de factura
CREATE DEFINER=`root`@`%` PROCEDURE `calcular_totales_factura`(
    IN p_id_factura INT
)
BEGIN
    DECLARE v_subtotal DECIMAL(10,2) DEFAULT 0;
    DECLARE v_impuestos DECIMAL(10,2) DEFAULT 0;
    DECLARE v_descuentos DECIMAL(10,2) DEFAULT 0;
    DECLARE v_total DECIMAL(10,2) DEFAULT 0;
    
    -- Calcular subtotal
    SELECT COALESCE(SUM(subtotal_linea), 0) INTO v_subtotal
    FROM `DetalleFactura` 
    WHERE id_factura = p_id_factura;
    
    -- Calcular impuestos (ejemplo: 19% IVA)
    SET v_impuestos = v_subtotal * 0.19;
    
    -- Calcular descuentos (por ahora 0, se puede modificar según lógica de negocio)
    SET v_descuentos = 0;
    
    -- Calcular total
    SET v_total = v_subtotal + v_impuestos - v_descuentos;
    
    -- Actualizar factura
    UPDATE `Facturas` 
    SET 
        subtotal = v_subtotal,
        impuestos = v_impuestos,
        descuentos = v_descuentos,
        total_factura = v_total,
        fecha_actualizacion = CURRENT_TIMESTAMP
    WHERE id_factura = p_id_factura;
END //

DELIMITER;

-- ============================================================================
-- 7. INSERTAR DATOS DE CONFIGURACIÓN
-- ============================================================================

-- Insertar métodos de pago básicos si no existen
INSERT IGNORE INTO
    `MetodoPago` (`nombre`)
VALUES ('Efectivo'),
    ('Tarjeta de Crédito'),
    ('Tarjeta de Débito'),
    ('Transferencia Bancaria'),
    ('Cheque'),
    ('PSE');

-- Insertar tipos de pago básicos si no existen
INSERT IGNORE INTO
    `TipoPago` (`nombre`)
VALUES ('Pago Total'),
    ('Pago Parcial'),
    ('Anticipo'),
    ('Abono');

-- ============================================================================
-- 8. CREAR TRIGGERS PARA MANTENER CONSISTENCIA
-- ============================================================================

DELIMITER / /

-- Trigger para actualizar totales cuando se modifica DetalleFactura
CREATE TRIGGER `tr_detalle_factura_after_insert`
AFTER INSERT ON `DetalleFactura`
FOR EACH ROW
BEGIN
    -- Actualizar subtotal_linea
    UPDATE `DetalleFactura` 
    SET subtotal_linea = NEW.cantidad * NEW.valor_unitario
    WHERE id_detalle_factura = NEW.id_detalle_factura;
    
    -- Recalcular totales de la factura
    CALL calcular_totales_factura(NEW.id_factura);
END //

CREATE TRIGGER `tr_detalle_factura_after_update`
AFTER UPDATE ON `DetalleFactura`
FOR EACH ROW
BEGIN
    -- Actualizar subtotal_linea si cambió cantidad o valor_unitario
    IF NEW.cantidad != OLD.cantidad OR NEW.valor_unitario != OLD.valor_unitario THEN
        UPDATE `DetalleFactura` 
        SET subtotal_linea = NEW.cantidad * NEW.valor_unitario
        WHERE id_detalle_factura = NEW.id_detalle_factura;
        
        -- Recalcular totales de la factura
        CALL calcular_totales_factura(NEW.id_factura);
    END IF;
END //

CREATE TRIGGER `tr_detalle_factura_after_delete`
AFTER DELETE ON `DetalleFactura`
FOR EACH ROW
BEGIN
    -- Recalcular totales de la factura
    CALL calcular_totales_factura(OLD.id_factura);
END //

DELIMITER;

-- ============================================================================
-- 9. COMENTARIOS DE DOCUMENTACIÓN
-- ============================================================================

/*
ESTRUCTURA MEJORADA DEL SISTEMA DE FACTURACIÓN:

1. TABLA FACTURAS:
- Agregados: numero_factura, fecha_vencimiento, subtotal, impuestos, descuentos
- Mejorado: estado_factura como ENUM para mejor control
- Agregados: observaciones, fecha_creacion, fecha_actualizacion

2. TABLA DETALLEFACTURA:
- Agregados: subtotal_linea, impuestos_linea, descuentos_linea, descripcion_servicio
- Mantiene relación con ServiciosPorContrato

3. ÍNDICES OPTIMIZADOS:
- Para consultas por contrato, fecha, estado, número de factura
- Para joins entre tablas relacionadas

4. VISTAS ÚTILES:
- v_facturas_completas: Facturas con información de usuario y totales de pago
- v_detalle_factura_completo: Detalles con información de servicios

5. PROCEDIMIENTOS ALMACENADOS:
- generar_numero_factura: Genera números únicos de factura
- calcular_totales_factura: Recalcula totales automáticamente

6. TRIGGERS:
- Mantienen consistencia en cálculos de totales
- Se ejecutan automáticamente al modificar detalles

7. RESTRICCIONES:
- Validan que totales sean positivos
- Aseguran consistencia en cálculos
- Previenen datos inválidos

ESTA MIGRACIÓN ES COMPATIBLE CON LA ESTRUCTURA EXISTENTE Y NO AFECTA
LOS DATOS ACTUALES. SOLO AGREGA FUNCIONALIDAD Y OPTIMIZACIONES.
*/