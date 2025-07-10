-- ============================================================================
-- INSERTAR TIPOS DE PAGO BÁSICOS
-- ============================================================================
-- Este script inserta los tipos de pago necesarios para el sistema

-- Insertar tipos de pago básicos si no existen
INSERT IGNORE INTO
    `TipoPago` (`id_tipo_pago`, `nombre`)
VALUES (1, 'Pago Total'),
    (2, 'Pago Parcial');

-- Verificar que se insertaron correctamente
SELECT * FROM `TipoPago` ORDER BY `id_tipo_pago`;

-- Verificar que también existen los métodos de pago básicos
INSERT IGNORE INTO
    `MetodoPago` (`id_metodo_pago`, `nombre`)
VALUES (1, 'Efectivo'),
    (2, 'Tarjeta de Crédito'),
    (3, 'Tarjeta de Débito'),
    (4, 'Transferencia Bancaria'),
    (5, 'Cheque'),
    (6, 'PSE');

-- Verificar métodos de pago
SELECT * FROM `MetodoPago` ORDER BY `id_metodo_pago`;