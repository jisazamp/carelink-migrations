-- Agregar campo estado a la tabla Contratos
ALTER TABLE Contratos
ADD COLUMN estado ENUM(
    'ACTIVO',
    'VENCIDO',
    'CANCELADO'
) DEFAULT 'ACTIVO' AFTER facturar_contrato;