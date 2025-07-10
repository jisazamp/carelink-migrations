CREATE TABLE `ReportesClinicos` (
  `id_reporteclinico` int NOT NULL AUTO_INCREMENT,
  `id_historiaclinica` int DEFAULT NULL,
  `id_profesional` int DEFAULT NULL,
  `Circunferencia_cadera` float DEFAULT NULL,
  `Frecuencia_cardiaca` int DEFAULT NULL,
  `IMC` decimal(5,2) DEFAULT NULL,
  `Obs_habitosalimenticios` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `Porc_grasacorporal` decimal(5,2) DEFAULT NULL,
  `Porc_masamuscular` decimal(5,2) DEFAULT NULL,
  `area_afectiva` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `area_comportamental` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `areacognitiva` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `areainterpersonal` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `areasomatica` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `circunferencia_cintura` float DEFAULT NULL,
  `consumo_aguadiaria` float DEFAULT NULL,
  `diagnostico` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `fecha_registro` date DEFAULT NULL,
  `frecuencia_actividadfisica` enum('Baja','Moderada','Alta') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `frecuencia_respiratoria` int DEFAULT NULL,
  `motivo_consulta` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `nivel_dolor` int DEFAULT NULL,
  `observaciones` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `peso` int DEFAULT NULL,
  `presion_arterial` int DEFAULT NULL,
  `pruebas_examenes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `recomendaciones` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `remision` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `saturacionOxigeno` int DEFAULT NULL,
  `temperatura_corporal` float DEFAULT NULL,
  `tipo_reporte` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id_reporteclinico`),
  KEY `id_historiaclinica` (`id_historiaclinica`),
  KEY `id_profesional` (`id_profesional`),
  CONSTRAINT `ReportesClinicos_ibfk_1` FOREIGN KEY (`id_historiaclinica`) REFERENCES `HistoriaClinica` (`id_historiaclinica`) ON DELETE CASCADE,
  CONSTRAINT `ReportesClinicos_ibfk_2` FOREIGN KEY (`id_profesional`) REFERENCES `Profesionales` (`id_profesional`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `OrientacionEspacial` (
  `id_OrientacionEspacial` int NOT NULL AUTO_INCREMENT,
  `nom_OrientacionEspacial` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id_OrientacionEspacial`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `ExpresionEmosional` (
  `id_expresionemosional` int NOT NULL AUTO_INCREMENT,
  `nom_expresionemocional` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id_expresionemosional`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `AtencionMemoria` (
  `id_AtencionMemoria` int NOT NULL AUTO_INCREMENT,
  `nom_AtencionMemoria` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id_AtencionMemoria`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `ActitudPresente` (
  `id_ActitudPresente` int NOT NULL AUTO_INCREMENT,
  `nom_ActitudPresente` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id_ActitudPresente`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `ActitudTemporal` (
  `id_ActitudTemporal` int NOT NULL AUTO_INCREMENT,
  `nom_ActidudTemporal` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id_ActitudTemporal`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `TipoReporteClinico` (
  `id_TipoReporte` int NOT NULL AUTO_INCREMENT,
  `nom_TipoReporte` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id_TipoReporte`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `EvolucionesClinicas` (
  `id_TipoReporte` int NOT NULL AUTO_INCREMENT,
  `id_reporteclinico` int DEFAULT NULL,
  `id_profesional` int DEFAULT NULL,
  `fecha_evolucion` date DEFAULT NULL,
  `observacion_evolucion` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `tipo_report` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id_TipoReporte`),
  KEY `id_reporteclinico` (`id_reporteclinico`),
  KEY `id_profesional` (`id_profesional`),
  CONSTRAINT `EvolucionesClinicas_ibfk_1` FOREIGN KEY (`id_reporteclinico`) REFERENCES `ReportesClinicos` (`id_reporteclinico`) ON DELETE CASCADE,
  CONSTRAINT `EvolucionesClinicas_ibfk_2` FOREIGN KEY (`id_profesional`) REFERENCES `Profesionales` (`id_profesional`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `DocumentoAdjuntoExam` (
  `id_DocumentoAdjunto` int NOT NULL AUTO_INCREMENT,
  `ruta_DocumentoAdjunto` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `nom_DocumentoAdjunto` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `peso_DocumentoAdjunto` float DEFAULT NULL,
  `Tipo_DocumentoAdjunto` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id_DocumentoAdjunto`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `Profesionales` (
  `id_profesional` int NOT NULL AUTO_INCREMENT,
  `nombres` varchar(35) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `apellidos` varchar(35) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `n_documento` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `t_profesional` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fecha_nacimiento` date DEFAULT NULL,
  `fecha_ingreso` date DEFAULT NULL,
  `estado` enum('Activo','Inactivo') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `profesion` enum('Médico','Enfermero','Nutricionista','Psicólogo','Fisioterapeuta') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `especialidad` enum('Cardiología','Pediatría','Nutrición','Psicología Clínica','Fisioterapia') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cargo` enum('Jefe de Departamento','Especialista','Residente') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `telefono` int DEFAULT NULL,
  `e_mail` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `direccion` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id_profesional`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
