CREATE TABLE `familiares_y_acudientes_por_usuario` (
  `id_acudiente` int NOT NULL,
  `id_usuario` int NOT NULL,
  `parentesco` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id_acudiente`,`id_usuario`),
  KEY `fk_usuario` (`id_usuario`),
  CONSTRAINT `fk_acudiente` FOREIGN KEY (`id_acudiente`) REFERENCES `Familiares` (`id_acudiente`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `Usuarios` (`id_usuario`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
