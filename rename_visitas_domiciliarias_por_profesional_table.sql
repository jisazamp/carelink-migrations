-- Migración para renombrar la tabla VisitasDomiciliariasPorProfesional
-- Cambia la capitalización para que coincida con el modelo SQLAlchemy

-- Renombrar la tabla existente
RENAME TABLE `VisitasDomiciliariasPorProfesional` TO `VisitasDomiciliariasporprofesional`;

-- Comentario explicativo
-- Esta migración corrige la capitalización de la tabla para que coincida
-- con el modelo SQLAlchemy definido en home_visit.py
-- La tabla ahora usa la capitalización correcta: VisitasDomiciliariasporprofesional