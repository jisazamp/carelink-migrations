CREATE TABLE `ActividadesUsuarios` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_actividad` int NOT NULL,
  `id_usuario` int NOT NULL,
  `fecha_asignacion` datetime DEFAULT CURRENT_TIMESTAMP,
  `estado_participacion` enum('CONFIRMADO','PENDIENTE','CANCELADO') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'PENDIENTE',
  `observaciones` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `fecha_creacion` datetime DEFAULT CURRENT_TIMESTAMP,
  `fecha_actualizacion` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_actividad_usuario` (`id_actividad`,`id_usuario`),
  KEY `fk_actividades_usuarios_actividad` (`id_actividad`),
  KEY `fk_actividades_usuarios_usuario` (`id_usuario`),
  CONSTRAINT `fk_actividades_usuarios_actividad` FOREIGN KEY (`id_actividad`) REFERENCES `ActividadesGrupales` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_actividades_usuarios_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `Usuarios` (`id_usuario`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
