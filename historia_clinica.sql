CREATE TABLE `HistoriaClinica` (
  `id_historiaclinica` int NOT NULL AUTO_INCREMENT,
  `Tiene_OtrasAlergias` tinyint(1) NOT NULL,
  `Tienedieta_especial` tinyint(1) NOT NULL,
  `alcoholismo` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `alergico_medicamento` tinyint(1) NOT NULL,
  `altura` int NOT NULL,
  `apariencia_personal` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `cafeina` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `cirugias` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `comunicacion_no_verbal` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `comunicacion_verbal` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `continencia` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `cuidado_personal` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `dieta_especial` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `diagnosticos` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `discapacidades` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `emer_medica` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `eps` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `estado_de_animo` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `fecha_ingreso` date NOT NULL,
  `frecuencia_cardiaca` decimal(10,0) NOT NULL,
  `historial_cirugias` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `id_usuario` int NOT NULL,
  `limitaciones` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `maltratado` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `maltrato` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `medicamentos_alergia` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `motivo_ingreso` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `observ_dietaEspecial` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `observ_otrasalergias` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `observaciones_iniciales` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `otras_alergias` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `peso` decimal(10,0) NOT NULL,
  `presion_arterial` decimal(10,0) NOT NULL,
  `sustanciaspsico` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `tabaquismo` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `telefono_emermedica` varchar(17) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `temperatura_corporal` decimal(10,0) NOT NULL,
  `tipo_alimentacion` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `tipo_de_movilidad` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `tipo_de_sueno` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `tipo_sangre` enum('A+','A-','B+','B-','AB+','AB-','O+','O-') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id_historiaclinica`),
  KEY `id_usuario` (`id_usuario`),
  CONSTRAINT `HistoriaClinica_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `Usuarios` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `MedicamentosPorUsuario` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_historiaClinica` int DEFAULT NULL,
  `medicamento` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `periodicidad` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `observaciones` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `id_historiaClinica` (`id_historiaClinica`),
  CONSTRAINT `MedicamentosPorUsuario_ibfk_1` FOREIGN KEY (`id_historiaClinica`) REFERENCES `HistoriaClinica` (`id_historiaclinica`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `CuidadosEnfermeriaPorUsuario` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_historiaClinica` int DEFAULT NULL,
  `diagnostico` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `frecuencia` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `intervencion` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `id_historiaClinica` (`id_historiaClinica`),
  CONSTRAINT `CuidadosEnfermeriaPorUsuario_ibfk_1` FOREIGN KEY (`id_historiaClinica`) REFERENCES `HistoriaClinica` (`id_historiaclinica`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `IntervencionPorUsuario` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_historiaClinica` int DEFAULT NULL,
  `diagnostico` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `frecuencia` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `intervencion` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `id_historiaClinica` (`id_historiaClinica`),
  CONSTRAINT `IntervencionPorUsuario_ibfk_1` FOREIGN KEY (`id_historiaClinica`) REFERENCES `HistoriaClinica` (`id_historiaclinica`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `VacunasPorUsuario` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_historiaClinica` int DEFAULT NULL,
  `efectos_secundarios` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `fecha_administracion` date DEFAULT NULL,
  `fecha_proxima` date DEFAULT NULL,
  `vacuna` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `id_historiaClinica` (`id_historiaClinica`),
  CONSTRAINT `VacunasPorUsuario_ibfk_1` FOREIGN KEY (`id_historiaClinica`) REFERENCES `HistoriaClinica` (`id_historiaclinica`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `ApoyosPorUsuario` (
  `id_tipoapoyo` int NOT NULL,
  `id_historiaClinica` int NOT NULL,
  `periodicidad` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `Fecha_inicio` date DEFAULT NULL,
  `fecha_fin` date DEFAULT NULL,
  PRIMARY KEY (`id_tipoapoyo`,`id_historiaClinica`),
  KEY `id_historiaClinica` (`id_historiaClinica`),
  CONSTRAINT `ApoyosPorUsuario_ibfk_1` FOREIGN KEY (`id_tipoapoyo`) REFERENCES `TipoApoyoTratamientos` (`id_TipoApoyoTratamiento`),
  CONSTRAINT `ApoyosPorUsuario_ibfk_2` FOREIGN KEY (`id_historiaClinica`) REFERENCES `HistoriaClinica` (`id_historiaclinica`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `EsquemaVacunacion` (
  `id_vacuna` int NOT NULL,
  `id_historiaClinica` int NOT NULL,
  `fecha_aplicacion` date DEFAULT NULL,
  PRIMARY KEY (`id_vacuna`,`id_historiaClinica`),
  KEY `id_historiaClinica` (`id_historiaClinica`),
  CONSTRAINT `EsquemaVacunacion_ibfk_1` FOREIGN KEY (`id_vacuna`) REFERENCES `Vacunas` (`id_vacuna`),
  CONSTRAINT `EsquemaVacunacion_ibfk_2` FOREIGN KEY (`id_historiaClinica`) REFERENCES `HistoriaClinica` (`id_historiaclinica`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `TipoDiscaPorUsuarios` (
  `id_tipodiscapacidad` int NOT NULL,
  `id_historiaClinica` int NOT NULL,
  `observación` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id_tipodiscapacidad`,`id_historiaClinica`),
  KEY `id_historiaClinica` (`id_historiaClinica`),
  CONSTRAINT `TipoDiscaPorUsuarios_ibfk_1` FOREIGN KEY (`id_tipodiscapacidad`) REFERENCES `TipoDiscapacidad` (`id_tipodiscapacidad`),
  CONSTRAINT `TipoDiscaPorUsuarios_ibfk_2` FOREIGN KEY (`id_historiaClinica`) REFERENCES `HistoriaClinica` (`id_historiaclinica`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `TipoLimitPorUsuarios` (
  `id_tipolimitacion` int NOT NULL,
  `id_historiaClinica` int NOT NULL,
  `observación` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id_tipolimitacion`,`id_historiaClinica`),
  KEY `id_historiaClinica` (`id_historiaClinica`),
  CONSTRAINT `TipoLimitPorUsuarios_ibfk_1` FOREIGN KEY (`id_tipolimitacion`) REFERENCES `TipoLimitacion` (`id_tipolimitacion`),
  CONSTRAINT `TipoLimitPorUsuarios_ibfk_2` FOREIGN KEY (`id_historiaClinica`) REFERENCES `HistoriaClinica` (`id_historiaclinica`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
