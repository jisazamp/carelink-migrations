CREATE TABLE Familiares (
    id_acudiente INT AUTO_INCREMENT PRIMARY KEY,
    n_documento VARCHAR(255) NOT NULL,
    nombres VARCHAR(50) NOT NULL,
    apellidos VARCHAR(50) NOT NULL,
    telefono VARCHAR(50),
    direccion VARCHAR(255),
    email VARCHAR(50) UNIQUE,
    acudiente BOOL DEFAULT FALSE,
    vive BOOL DEFAULT FALSE,
    is_deleted BOOL DEFAULT FALSE
);
