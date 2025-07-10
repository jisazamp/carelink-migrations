-- Migración segura para actualizar ENUM estado_asistencia sin pérdida de datos
-- Ejecutar: mysql -u root -p carelink < fix_estado_asistencia_enum.sql

-- Verificar valores actuales
SELECT DISTINCT
    estado_asistencia
FROM
    cronograma_asistencia_pacientes;

-- Actualizar valores (si es necesario)
UPDATE cronograma_asistencia_pacientes
SET
    estado_asistencia = 'ASISTIO'
WHERE
    estado_asistencia = 'ASISTIÓ';

UPDATE cronograma_asistencia_pacientes
SET
    estado_asistencia = 'NO_ASISTIO'
WHERE
    estado_asistencia = 'NO ASISTIÓ';

-- Modificar el ENUM
ALTER TABLE cronograma_asistencia_pacientes
MODIFY COLUMN estado_asistencia ENUM(
    'PENDIENTE',
    'ASISTIO',
    'NO_ASISTIO',
    'CANCELADO',
    'REAGENDADO'
) DEFAULT 'PENDIENTE';

-- Agregar columna requiere_transporte
ALTER TABLE cronograma_asistencia_pacientes
ADD COLUMN requiere_transporte BOOLEAN DEFAULT FALSE AFTER estado_asistencia;