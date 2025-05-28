CREATE TABLE Contratos (
    id_contrato INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT,
    tipo_contrato ENUM('Nuevo', 'Recurrente') NOT NULL,
    fecha_inicio DATE,
    fecha_fin DATE,
    facturar_contrato BOOLEAN DEFAULT FALSE,

    FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario)
);

CREATE TABLE Servicios (
    id_servicio INT AUTO_INCREMENT PRIMARY KEY,
    nombre TEXT NOT NULL,
    descripcion TEXT
);

CREATE TABLE TarifasServicioPorAnio (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_servicio INT,
    anio YEAR NOT NULL,
    precio_por_dia DECIMAL(10, 2) NOT NULL,

    FOREIGN KEY (id_servicio) REFERENCES Servicios(id_servicio) ON DELETE CASCADE
);

CREATE TABLE ServiciosPorContrato (
    id_servicio_contratado INT AUTO_INCREMENT PRIMARY KEY,
    id_contrato INT,
    id_servicio INT,
    fecha DATE,
    descripcion TEXT,
    precio_por_dia DECIMAL(10, 2),

    FOREIGN KEY (id_contrato) REFERENCES Contratos(id_contrato) ON DELETE CASCADE,
    FOREIGN KEY (id_servicio) REFERENCES Servicios(id_servicio)
);

CREATE TABLE FechasServicio (
    id_fecha_servicio INT AUTO_INCREMENT PRIMARY KEY,
    id_servicio_contratado INT,
    fecha DATE,

    FOREIGN KEY (id_servicio_contratado) REFERENCES ServiciosPorContrato(id_servicio_contratado) ON DELETE CASCADE
);

CREATE TABLE Facturas (
    id_factura INT AUTO_INCREMENT PRIMARY KEY,
    id_contrato INT,
    fecha_emision DATE,
    total_factura DECIMAL(10, 2),
    estado_factura TEXT,

    FOREIGN KEY (id_contrato) REFERENCES Contratos(id_contrato) ON DELETE CASCADE
);

CREATE TABLE DetalleFactura (
    id_detalle_factura INT AUTO_INCREMENT PRIMARY KEY,
    id_factura INT,
    id_servicio_contratado INT,
    cantidad INT,
    valor_unitario DECIMAL(10, 2),

    FOREIGN KEY (id_factura) REFERENCES Facturas(id_factura) ON DELETE CASCADE,
    FOREIGN KEY (id_servicio_contratado) REFERENCES ServiciosPorContrato(id_servicio_contratado) ON DELETE CASCADE
);

CREATE TABLE MetodoPago (
    id_metodo_pago INT AUTO_INCREMENT PRIMARY KEY,
    nombre TEXT
);

CREATE TABLE TipoPago (
    id_tipo_pago INT AUTO_INCREMENT PRIMARY KEY,
    nombre TEXT
);

CREATE TABLE Pagos (
    id_pago INT AUTO_INCREMENT PRIMARY KEY,
    id_factura INT,
    id_metodo_pago INT,
    id_tipo_pago INT,
    fecha_pago DATE,
    valor DECIMAL(10, 2),

    FOREIGN KEY (id_factura) REFERENCES Facturas(id_factura) ON DELETE CASCADE,
    FOREIGN KEY (id_metodo_pago) REFERENCES MetodoPago(id_metodo_pago),
    FOREIGN KEY (id_tipo_pago) REFERENCES TipoPago(id_tipo_pago)
);
