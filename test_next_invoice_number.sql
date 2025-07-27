-- ============================================================================
-- CONSULTA PARA VALIDAR EL PRÓXIMO NÚMERO DE FACTURA
-- ============================================================================
-- Esta consulta simula la lógica del backend para obtener el próximo número
-- de factura basado en el último id_contrato de la tabla Contratos

-- 1. Verificar el último id_contrato
SELECT 'Último ID de Contrato' as descripcion, COALESCE(MAX(id_contrato), 0) as valor
FROM Contratos;

-- 2. Calcular el próximo ID
SELECT 'Próximo ID de Contrato' as descripcion, COALESCE(MAX(id_contrato), 0) + 1 as valor
FROM Contratos;

-- 3. Obtener el año actual
SELECT 'Año Actual' as descripcion, YEAR(CURRENT_DATE()) as valor;

-- 4. Generar el número de factura completo
SELECT 'Próximo Número de Factura' as descripcion, CONCAT(
        'FACT-', YEAR(CURRENT_DATE()), '-', LPAD(
            COALESCE(MAX(id_contrato), 0) + 1, 5, '0'
        )
    ) as valor
FROM Contratos;

-- 5. Verificar todos los contratos existentes (para contexto)
SELECT
    id_contrato,
    tipo_contrato,
    fecha_inicio,
    fecha_fin,
    estado
FROM Contratos
ORDER BY id_contrato DESC
LIMIT 10;

-- 6. Verificar si hay facturas existentes (para comparar)
SELECT 'Total de Facturas' as descripcion, COUNT(*) as cantidad
FROM Facturas;

-- 7. Verificar números de factura existentes
SELECT
    numero_factura,
    id_contrato,
    fecha_emision,
    estado_factura
FROM Facturas
WHERE
    numero_factura IS NOT NULL
ORDER BY id_factura DESC
LIMIT 10;

-- ============================================================================
-- EJEMPLOS DE RESULTADOS ESPERADOS:
-- ============================================================================
--
-- Si tienes 2 contratos (id_contrato: 1, 2):
-- - Último ID: 2
-- - Próximo ID: 3
-- - Año: 2025
-- - Próximo Número: FACT-2025-00003
--
-- Si no tienes contratos:
-- - Último ID: 0
-- - Próximo ID: 1
-- - Año: 2025
-- - Próximo Número: FACT-2025-00001
--
-- Si tienes 10 contratos (id_contrato: 1-10):
-- - Último ID: 10
-- - Próximo ID: 11
-- - Año: 2025
-- - Próximo Número: FACT-2025-00011
-- ============================================================================