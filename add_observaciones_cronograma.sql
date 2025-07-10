-- Migración para agregar columna observaciones a cronograma_asistencia_pacientes
-- Ejecutar: mysql -u root -p carelink < add_observaciones_cronograma.sql

ALTER TABLE cronograma_asistencia_pacientes
ADD COLUMN observaciones TEXT NULL;