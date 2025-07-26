CREATE TABLE `VisitasDomiciliariasporprofesional` (
  `id_visitadomiciliaria` int NOT NULL,
  `id_profesional` int NOT NULL,
  `fecha_asignacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `estado_asignacion` enum('ACTIVA','INACTIVA','COMPLETADA') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'ACTIVA',
  `observaciones_asignacion` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `fecha_creacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_actualizacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_visitadomiciliaria`,`id_profesional`),
  KEY `idx_profesional` (`id_profesional`),
  KEY `idx_estado_asignacion` (`estado_asignacion`),
  KEY `idx_fecha_asignacion` (`fecha_asignacion`),
  KEY `idx_fecha_creacion` (`fecha_creacion`),
  CONSTRAINT `fk_visitas_profesional_profesional` FOREIGN KEY (`id_profesional`) REFERENCES `Profesionales` (`id_profesional`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_visitas_profesional_visita` FOREIGN KEY (`id_visitadomiciliaria`) REFERENCES `VisitasDomiciliarias` (`id_visitadomiciliaria`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
