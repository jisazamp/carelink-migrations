-- Migración para permitir valores NULL en fecha_visita y hora_visita
-- Esto permite crear visitas domiciliarias sin fecha/hora programada inicialmente

ALTER TABLE `VisitasDomiciliarias` 
MODIFY COLUMN `fecha_visita` date NULL,
MODIFY COLUMN `hora_visita` time NULL;

-- Comentario explicativo
-- Esta migración permite que las visitas domiciliarias se creen sin fecha y hora programadas
-- El usuario podrá programar la visita posteriormente en el formulario