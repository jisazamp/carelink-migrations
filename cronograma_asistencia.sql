-- carelink-migrations/cronograma_asistencia.sql

CREATE TABLE `cronograma_asistencia` (
  `id_cronograma` int NOT NULL AUTO_INCREMENT,
  `id_profesional` int NOT NULL,
  `fecha` date NOT NULL,
  `comentario` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `fecha_creacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_actualizacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_cronograma`),
  KEY `id_profesional` (`id_profesional`),
  CONSTRAINT `cronograma_asistencia_ibfk_1` FOREIGN KEY (`id_profesional`) REFERENCES `Profesionales` (`id_profesional`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `cronograma_asistencia_pacientes` (
  `id_cronograma_paciente` int NOT NULL AUTO_INCREMENT,
  `id_cronograma` int NOT NULL,
  `id_usuario` int NOT NULL,
  `id_contrato` int DEFAULT NULL,
  `estado_asistencia` enum('PENDIENTE','ASISTIO','NO_ASISTIO','CANCELADO','REAGENDADO') COLLATE utf8mb4_unicode_ci DEFAULT 'PENDIENTE',
  `requiere_transporte` tinyint(1) DEFAULT '0',
  `observaciones` text COLLATE utf8mb4_unicode_ci,
  `fecha_creacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_actualizacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_cronograma_paciente`),
  KEY `id_cronograma` (`id_cronograma`),
  KEY `id_usuario` (`id_usuario`),
  KEY `id_contrato` (`id_contrato`),
  CONSTRAINT `cronograma_asistencia_pacientes_ibfk_1` FOREIGN KEY (`id_cronograma`) REFERENCES `cronograma_asistencia` (`id_cronograma`) ON DELETE CASCADE,
  CONSTRAINT `cronograma_asistencia_pacientes_ibfk_2` FOREIGN KEY (`id_usuario`) REFERENCES `Usuarios` (`id_usuario`),
  CONSTRAINT `cronograma_asistencia_pacientes_ibfk_3` FOREIGN KEY (`id_contrato`) REFERENCES `Contratos` (`id_contrato`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
