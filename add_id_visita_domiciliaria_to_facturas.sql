-- Migración para agregar id_visita_domiciliaria a la tabla Facturas
-- Esta columna permitirá asociar facturas directamente con visitas domiciliarias
-- cuando id_contrato sea NULL

-- Agregar la nueva columna id_visita_domiciliaria
ALTER TABLE `Facturas` ADD COLUMN `id_visita_domiciliaria` INT NULL;

-- Agregar índice para mejorar el rendimiento de consultas
CREATE INDEX `idx_facturas_visita_domiciliaria` ON `Facturas` (`id_visita_domiciliaria`);

-- Agregar foreign key constraint para mantener integridad referencial
ALTER TABLE `Facturas`
ADD CONSTRAINT `fk_facturas_visita_domiciliaria` FOREIGN KEY (`id_visita_domiciliaria`) REFERENCES `VisitasDomiciliarias` (`id_visitadomiciliaria`) ON DELETE SET NULL;

-- Comentario explicativo
-- Esta migración permite que las facturas se asocien directamente con visitas domiciliarias
-- cuando no hay un contrato asociado (id_contrato = NULL)
-- Esto es necesario para el nuevo sistema de facturación de visitas domiciliarias