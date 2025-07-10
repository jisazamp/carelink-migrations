CREATE TABLE `ActividadesGrupales` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_profesional` int DEFAULT NULL,
  `id_tipo_actividad` int DEFAULT NULL,
  `comentarios` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `descripcion` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `duracion` int DEFAULT NULL,
  `fecha` date DEFAULT NULL,
  `nombre` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `id_profesional` (`id_profesional`),
  KEY `id_tipo_actividad` (`id_tipo_actividad`),
  CONSTRAINT `ActividadesGrupales_ibfk_1` FOREIGN KEY (`id_profesional`) REFERENCES `Profesionales` (`id_profesional`),
  CONSTRAINT `ActividadesGrupales_ibfk_2` FOREIGN KEY (`id_tipo_actividad`) REFERENCES `TipoActividad` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `TipoActividad` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tipo` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
