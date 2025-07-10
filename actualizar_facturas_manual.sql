-- ============================================================================
-- SCRIPT PARA ACTUALIZAR MANUALMENTE LA TABLA FACTURAS
-- Ejecutar este script desde DBeaver para agregar las columnas faltantes
-- ============================================================================

-- 1. Agregar columna numero_factura
ALTER TABLE Facturas
ADD COLUMN numero_factura VARCHAR(20) UNIQUE NULL AFTER id_factura;

-- 2. Agregar columna fecha_vencimiento
ALTER TABLE Facturas
ADD COLUMN fecha_vencimiento DATE NULL AFTER fecha_emision;

-- 3. Agregar columna subtotal
ALTER TABLE Facturas
ADD COLUMN subtotal DECIMAL(10, 2) DEFAULT 0.00 AFTER total_factura;

-- 4. Agregar columna impuestos
ALTER TABLE Facturas
ADD COLUMN impuestos DECIMAL(10, 2) DEFAULT 0.00 AFTER subtotal;

-- 5. Agregar columna descuentos
ALTER TABLE Facturas
ADD COLUMN descuentos DECIMAL(10, 2) DEFAULT 0.00 AFTER impuestos;

-- 6. Agregar columna observaciones
ALTER TABLE Facturas
ADD COLUMN observaciones TEXT NULL AFTER estado_factura;

-- 7. Agregar columna fecha_creacion
ALTER TABLE Facturas
ADD COLUMN fecha_creacion TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP AFTER observaciones;

-- 8. Agregar columna fecha_actualizacion
ALTER TABLE Facturas
ADD COLUMN fecha_actualizacion TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP AFTER fecha_creacion;

-- 9. Actualizar el ENUM de estado_factura para que coincida con el modelo
ALTER TABLE Facturas
MODIFY COLUMN estado_factura ENUM(
    'PENDIENTE',
    'PAGADA',
    'VENCIDA',
    'CANCELADA',
    'ANULADA'
) DEFAULT 'PENDIENTE';

-- 10. Verificar que la tabla se actualizó correctamente
DESCRIBE Facturas;

-- 11. Mostrar las columnas agregadas
SELECT
    COLUMN_NAME,
    DATA_TYPE,
    IS_NULLABLE,
    COLUMN_DEFAULT,
    COLUMN_KEY
FROM INFORMATION_SCHEMA.COLUMNS
WHERE
    TABLE_SCHEMA = 'carelink'
    AND TABLE_NAME = 'Facturas'
ORDER BY ORDINAL_POSITION;