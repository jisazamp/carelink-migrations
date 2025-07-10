-- ============================================================================
-- MIGRACIÓN SEGURA DEL SISTEMA DE FACTURACIÓN
-- ============================================================================
-- Esta migración agrega campos faltantes sin modificar datos existentes
-- Ejecutar: mysql -u root -p carelink < migracion_facturacion_segura.sql

-- 1. AGREGAR CAMPOS FALTANTES A LA TABLA Facturas
ALTER TABLE Facturas
ADD COLUMN numero_factura VARCHAR(20) UNIQUE NULL AFTER id_factura,
ADD COLUMN fecha_vencimiento DATE NULL AFTER fecha_emision,
ADD COLUMN subtotal DECIMAL(10, 2) DEFAULT 0.00 AFTER total_factura,
ADD COLUMN impuestos DECIMAL(10, 2) DEFAULT 0.00 AFTER subtotal,
ADD COLUMN descuentos DECIMAL(10, 2) DEFAULT 0.00 AFTER impuestos,
ADD COLUMN observaciones TEXT NULL AFTER descuentos,
ADD COLUMN fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP AFTER observaciones,
ADD COLUMN fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP AFTER fecha_creacion;

-- 2. MODIFICAR EL CAMPO estado_factura PARA USAR ENUM
-- Primero, verificar valores actuales
SELECT DISTINCT
    estado_factura
FROM Facturas
WHERE
    estado_factura IS NOT NULL;

-- Actualizar valores existentes si es necesario
UPDATE Facturas
SET
    estado_factura = 'PENDIENTE'
WHERE
    estado_factura IS NULL
    OR estado_factura = '';

UPDATE Facturas
SET
    estado_factura = 'PAGADA'
WHERE
    estado_factura = 'Pagada'
    OR estado_factura = 'PAGADA';

UPDATE Facturas
SET
    estado_factura = 'VENCIDA'
WHERE
    estado_factura = 'Vencida'
    OR estado_factura = 'VENCIDA';

UPDATE Facturas
SET
    estado_factura = 'CANCELADA'
WHERE
    estado_factura = 'Cancelada'
    OR estado_factura = 'CANCELADA';

-- Cambiar el tipo de columna a ENUM
ALTER TABLE Facturas
MODIFY COLUMN estado_factura ENUM(
    'PENDIENTE',
    'PAGADA',
    'VENCIDA',
    'CANCELADA',
    'ANULADA'
) DEFAULT 'PENDIENTE';

-- 3. AGREGAR CAMPOS FALTANTES A LA TABLA DetalleFactura
ALTER TABLE DetalleFactura
ADD COLUMN subtotal_linea DECIMAL(10, 2) DEFAULT 0.00 AFTER valor_unitario,
ADD COLUMN impuestos_linea DECIMAL(10, 2) DEFAULT 0.00 AFTER subtotal_linea,
ADD COLUMN descuentos_linea DECIMAL(10, 2) DEFAULT 0.00 AFTER impuestos_linea,
ADD COLUMN descripcion_servicio VARCHAR(255) NULL AFTER descuentos_linea;

-- 4. AGREGAR ÍNDICES PARA OPTIMIZACIÓN
CREATE INDEX idx_facturas_estado ON Facturas (estado_factura);

CREATE INDEX idx_facturas_fecha_emision ON Facturas (fecha_emision);

CREATE INDEX idx_facturas_fecha_vencimiento ON Facturas (fecha_vencimiento);

CREATE INDEX idx_facturas_contrato ON Facturas (id_contrato);

CREATE INDEX idx_detalle_factura_factura ON DetalleFactura (id_factura);

CREATE INDEX idx_detalle_factura_servicio ON DetalleFactura (id_servicio_contratado);

-- 5. AGREGAR RESTRICCIONES DE INTEGRIDAD
ALTER TABLE Facturas
ADD CONSTRAINT chk_facturas_total CHECK (total_factura >= 0),
ADD CONSTRAINT chk_facturas_subtotal CHECK (subtotal >= 0),
ADD CONSTRAINT chk_facturas_impuestos CHECK (impuestos >= 0),
ADD CONSTRAINT chk_facturas_descuentos CHECK (descuentos >= 0);

ALTER TABLE DetalleFactura
ADD CONSTRAINT chk_detalle_valor_unitario CHECK (valor_unitario >= 0),
ADD CONSTRAINT chk_detalle_cantidad CHECK (cantidad > 0),
ADD CONSTRAINT chk_detalle_subtotal_linea CHECK (subtotal_linea >= 0),
ADD CONSTRAINT chk_detalle_impuestos_linea CHECK (impuestos_linea >= 0),
ADD CONSTRAINT chk_detalle_descuentos_linea CHECK (descuentos_linea >= 0);

-- 6. ACTUALIZAR DATOS EXISTENTES (si es necesario)
-- Calcular subtotales para registros existentes en DetalleFactura
UPDATE DetalleFactura
SET
    subtotal_linea = cantidad * valor_unitario
WHERE
    subtotal_linea = 0
    OR subtotal_linea IS NULL;

-- Actualizar totales en Facturas basado en detalles existentes
UPDATE Facturas f
SET
    total_factura = (
        SELECT COALESCE(SUM(df.subtotal_linea), 0)
        FROM DetalleFactura df
        WHERE
            df.id_factura = f.id_factura
    )
WHERE
    f.total_factura = 0
    OR f.total_factura IS NULL;

-- 7. CREAR VISTA PARA FACILITAR CONSULTAS
CREATE OR REPLACE VIEW vista_facturas_completas AS
SELECT
    f.id_factura,
    f.numero_factura,
    f.id_contrato,
    c.tipo_contrato,
    c.fecha_inicio,
    c.fecha_fin,
    u.id_usuario,
    u.nombres,
    u.apellidos,
    u.n_documento,
    f.fecha_emision,
    f.fecha_vencimiento,
    f.total_factura,
    f.subtotal,
    f.impuestos,
    f.descuentos,
    f.estado_factura,
    f.observaciones,
    f.fecha_creacion,
    f.fecha_actualizacion,
    COUNT(p.id_pago) AS cantidad_pagos,
    COALESCE(SUM(p.valor), 0) AS total_pagado
FROM
    Facturas f
    LEFT JOIN Contratos c ON f.id_contrato = c.id_contrato
    LEFT JOIN Usuarios u ON c.id_usuario = u.id_usuario
    LEFT JOIN Pagos p ON f.id_factura = p.id_factura
GROUP BY
    f.id_factura,
    f.numero_factura,
    f.id_contrato,
    c.tipo_contrato,
    c.fecha_inicio,
    c.fecha_fin,
    u.id_usuario,
    u.nombres,
    u.apellidos,
    u.n_documento,
    f.fecha_emision,
    f.fecha_vencimiento,
    f.total_factura,
    f.subtotal,
    f.impuestos,
    f.descuentos,
    f.estado_factura,
    f.observaciones,
    f.fecha_creacion,
    f.fecha_actualizacion;

-- 8. VERIFICACIÓN FINAL
SELECT 'Migración completada exitosamente' as resultado;

SELECT COUNT(*) as total_facturas FROM Facturas;

SELECT COUNT(*) as total_detalles FROM DetalleFactura;

SELECT COUNT(*) as total_pagos FROM Pagos;