CREATE TABLE `Contratos` (
  `id_contrato` int NOT NULL AUTO_INCREMENT,
  `id_usuario` int DEFAULT NULL,
  `tipo_contrato` enum('Nuevo','Recurrente') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `fecha_inicio` date DEFAULT NULL,
  `fecha_fin` date DEFAULT NULL,
  `facturar_contrato` tinyint(1) DEFAULT '0',
  `estado` enum('ACTIVO','VENCIDO','CANCELADO') COLLATE utf8mb4_unicode_ci DEFAULT 'ACTIVO',
  PRIMARY KEY (`id_contrato`),
  KEY `id_usuario` (`id_usuario`),
  CONSTRAINT `Contratos_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `Usuarios` (`id_usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `Servicios` (
  `id_servicio` int NOT NULL AUTO_INCREMENT,
  `nombre` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id_servicio`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `TarifasServicioPorAnio` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_servicio` int DEFAULT NULL,
  `anio` year NOT NULL,
  `precio_por_dia` decimal(10,2) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `id_servicio` (`id_servicio`),
  CONSTRAINT `TarifasServicioPorAnio_ibfk_1` FOREIGN KEY (`id_servicio`) REFERENCES `Servicios` (`id_servicio`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `ServiciosPorContrato` (
  `id_servicio_contratado` int NOT NULL AUTO_INCREMENT,
  `id_contrato` int DEFAULT NULL,
  `id_servicio` int DEFAULT NULL,
  `fecha` date DEFAULT NULL,
  `descripcion` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `precio_por_dia` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`id_servicio_contratado`),
  KEY `id_contrato` (`id_contrato`),
  KEY `id_servicio` (`id_servicio`),
  CONSTRAINT `ServiciosPorContrato_ibfk_1` FOREIGN KEY (`id_contrato`) REFERENCES `Contratos` (`id_contrato`) ON DELETE CASCADE,
  CONSTRAINT `ServiciosPorContrato_ibfk_2` FOREIGN KEY (`id_servicio`) REFERENCES `Servicios` (`id_servicio`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `FechasServicio` (
  `id_fecha_servicio` int NOT NULL AUTO_INCREMENT,
  `id_servicio_contratado` int DEFAULT NULL,
  `fecha` date DEFAULT NULL,
  PRIMARY KEY (`id_fecha_servicio`),
  KEY `id_servicio_contratado` (`id_servicio_contratado`),
  CONSTRAINT `FechasServicio_ibfk_1` FOREIGN KEY (`id_servicio_contratado`) REFERENCES `ServiciosPorContrato` (`id_servicio_contratado`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `Facturas` (
  `id_factura` int NOT NULL AUTO_INCREMENT,
  `numero_factura` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `id_contrato` int DEFAULT NULL,
  `fecha_emision` date DEFAULT NULL,
  `fecha_vencimiento` date DEFAULT NULL,
  `total_factura` decimal(10,2) DEFAULT NULL,
  `subtotal` decimal(10,2) DEFAULT '0.00',
  `impuestos` decimal(10,2) DEFAULT '0.00',
  `descuentos` decimal(10,2) DEFAULT '0.00',
  `estado_factura` enum('PENDIENTE','PAGADA','VENCIDA','CANCELADA','ANULADA') COLLATE utf8mb4_unicode_ci DEFAULT 'PENDIENTE',
  `observaciones` text COLLATE utf8mb4_unicode_ci,
  `fecha_creacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_actualizacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `id_visita_domiciliaria` int DEFAULT NULL,
  PRIMARY KEY (`id_factura`),
  UNIQUE KEY `numero_factura` (`numero_factura`),
  KEY `id_contrato` (`id_contrato`),
  KEY `idx_facturas_visita_domiciliaria` (`id_visita_domiciliaria`),
  CONSTRAINT `Facturas_ibfk_1` FOREIGN KEY (`id_contrato`) REFERENCES `Contratos` (`id_contrato`) ON DELETE CASCADE,
  CONSTRAINT `fk_facturas_visita_domiciliaria` FOREIGN KEY (`id_visita_domiciliaria`) REFERENCES `VisitasDomiciliarias` (`id_visitadomiciliaria`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `DetalleFactura` (
  `id_detalle_factura` int NOT NULL AUTO_INCREMENT,
  `id_factura` int DEFAULT NULL,
  `id_servicio_contratado` int DEFAULT NULL,
  `cantidad` int DEFAULT NULL,
  `valor_unitario` decimal(10,2) DEFAULT NULL,
  `subtotal_linea` decimal(10,2) DEFAULT '0.00',
  `impuestos_linea` decimal(10,2) DEFAULT '0.00',
  `descuentos_linea` decimal(10,2) DEFAULT '0.00',
  `descripcion_servicio` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id_detalle_factura`),
  KEY `id_factura` (`id_factura`),
  KEY `id_servicio_contratado` (`id_servicio_contratado`),
  CONSTRAINT `DetalleFactura_ibfk_1` FOREIGN KEY (`id_factura`) REFERENCES `Facturas` (`id_factura`) ON DELETE CASCADE,
  CONSTRAINT `DetalleFactura_ibfk_2` FOREIGN KEY (`id_servicio_contratado`) REFERENCES `ServiciosPorContrato` (`id_servicio_contratado`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `MetodoPago` (
  `id_metodo_pago` int NOT NULL AUTO_INCREMENT,
  `nombre` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id_metodo_pago`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `TipoPago` (
  `id_tipo_pago` int NOT NULL AUTO_INCREMENT,
  `nombre` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id_tipo_pago`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `Pagos` (
  `id_pago` int NOT NULL AUTO_INCREMENT,
  `id_factura` int DEFAULT NULL,
  `id_metodo_pago` int DEFAULT NULL,
  `id_tipo_pago` int DEFAULT NULL,
  `fecha_pago` date DEFAULT NULL,
  `valor` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`id_pago`),
  KEY `id_factura` (`id_factura`),
  KEY `id_metodo_pago` (`id_metodo_pago`),
  KEY `id_tipo_pago` (`id_tipo_pago`),
  CONSTRAINT `Pagos_ibfk_1` FOREIGN KEY (`id_factura`) REFERENCES `Facturas` (`id_factura`) ON DELETE CASCADE,
  CONSTRAINT `Pagos_ibfk_2` FOREIGN KEY (`id_metodo_pago`) REFERENCES `MetodoPago` (`id_metodo_pago`),
  CONSTRAINT `Pagos_ibfk_3` FOREIGN KEY (`id_tipo_pago`) REFERENCES `TipoPago` (`id_tipo_pago`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
