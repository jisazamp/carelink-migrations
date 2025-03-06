CREATE TABLE ActividadesGrupales (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_profesional INT,
    id_tipo_actividad INT,
    comentarios VARCHAR(255),
    descripcion VARCHAR(255),
    duracion INT,
    fecha DATE,
    nombre VARCHAR(50) NOT NULL,
    FOREIGN KEY (id_profesional) REFERENCES Profesionales(id_profesional),
    FOREIGN KEY (id_tipo_actividad) REFERENCES TipoActividad(id)
);

CREATE TABLE TipoActividad (
    id INT AUTO_INCREMENT PRIMARY KEY,
    tipo VARCHAR(50)
);
