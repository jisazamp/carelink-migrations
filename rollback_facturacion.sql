-- ============================================================================
-- SCRIPT DE ROLLBACK PARA MIGRACIÓN DE FACTURACIÓN
-- ============================================================================
-- SOLO USAR EN CASO DE EMERGENCIA
-- Este script revierte los cambios de migracion_facturacion_segura.sql

-- ⚠️ ADVERTENCIA: Este script eliminará los campos agregados
-- ⚠️ ADVERTENCIA: Los datos en estos campos se perderán
-- ⚠️ ADVERTENCIA: Solo ejecutar si es absolutamente necesario

-- 1. ELIMINAR VISTA CREADA
DROP VIEW IF EXISTS vista_facturas_completas;

-- 2. ELIMINAR ÍNDICES CREADOS
DROP INDEX IF EXISTS idx_facturas_estado ON Facturas;

DROP INDEX IF EXISTS idx_facturas_fecha_emision ON Facturas;

DROP INDEX IF EXISTS idx_facturas_fecha_vencimiento ON Facturas;

DROP INDEX IF EXISTS idx_facturas_contrato ON Facturas;

DROP INDEX IF EXISTS idx_detalle_factura_factura ON DetalleFactura;

DROP INDEX IF EXISTS idx_detalle_factura_servicio ON DetalleFactura;

-- 3. ELIMINAR RESTRICCIONES DE INTEGRIDAD
ALTER TABLE Facturas
DROP CONSTRAINT IF EXISTS chk_facturas_total,
DROP CONSTRAINT IF EXISTS chk_facturas_subtotal,
DROP CONSTRAINT IF EXISTS chk_facturas_impuestos,
DROP CONSTRAINT IF EXISTS chk_facturas_descuentos;

ALTER TABLE DetalleFactura
DROP CONSTRAINT IF EXISTS chk_detalle_valor_unitario,
DROP CONSTRAINT IF EXISTS chk_detalle_cantidad,
DROP CONSTRAINT IF EXISTS chk_detalle_subtotal_linea,
DROP CONSTRAINT IF EXISTS chk_detalle_impuestos_linea,
DROP CONSTRAINT IF EXISTS chk_detalle_descuentos_linea;

-- 4. REVERTIR CAMPO estado_factura A TEXT
ALTER TABLE Facturas
MODIFY COLUMN estado_factura TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 5. ELIMINAR CAMPOS AGREGADOS A DetalleFactura
ALTER TABLE DetalleFactura
DROP COLUMN IF EXISTS subtotal_linea,
DROP COLUMN IF EXISTS impuestos_linea,
DROP COLUMN IF EXISTS descuentos_linea,
DROP COLUMN IF EXISTS descripcion_servicio;

-- 6. ELIMINAR CAMPOS AGREGADOS A Facturas
ALTER TABLE Facturas
DROP COLUMN IF EXISTS numero_factura,
DROP COLUMN IF EXISTS fecha_vencimiento,
DROP COLUMN IF EXISTS subtotal,
DROP COLUMN IF EXISTS impuestos,
DROP COLUMN IF EXISTS descuentos,
DROP COLUMN IF EXISTS observaciones,
DROP COLUMN IF EXISTS fecha_creacion,
DROP COLUMN IF EXISTS fecha_actualizacion;

-- 7. VERIFICACIÓN FINAL
SELECT 'Rollback completado' as resultado;

SELECT COUNT(*) as total_facturas FROM Facturas;

SELECT COUNT(*) as total_detalles FROM DetalleFactura;

SELECT COUNT(*) as total_pagos FROM Pagos;

-- ⚠️ NOTA: Después del rollback, es posible que necesites:
-- 1. Restaurar el modelo SQLAlchemy a la versión anterior
-- 2. Reiniciar la aplicación backend
-- 3. Verificar que el frontend funcione correctamente