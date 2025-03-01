CREATE TABLE HistoriaClinica (
    id_historiaclinica INT PRIMARY KEY AUTO_INCREMENT,
    Tiene_OtrasAlergias BOOLEAN NOT NULL,
    Tienedieta_especial BOOLEAN NOT NULL,
    alcoholismo BOOLEAN NOT NULL,
    alergico_medicamento BOOLEAN NOT NULL,
    altura INT NOT NULL,
    apariencia_personal TEXT,
    cafeina BOOLEAN NOT NULL,
    cirugias TEXT,
    comunicacion_no_verbal TEXT,
    comunicacion_verbal TEXT,
    continencia BOOLEAN NOT NULL,
    cuidado_personal TEXT,
    dieta_especial TEXT,
    discapacidades TEXT,
    emer_medica VARCHAR(30),
    eps VARCHAR(30),
    estado_de_animo TEXT,
    fecha_ingreso DATE NOT NULL,
    frecuencia_cardiaca DECIMAL NOT NULL,
    historial_cirugias TEXT,
    id_usuario INT NOT NULL,
    limitaciones TEXT,
    maltratado BOOLEAN NOT NULL,
    maltrato BOOLEAN NOT NULL,
    medicamentos_alergia TEXT,
    motivo_ingreso TEXT,
    observ_dietaEspecial TEXT,
    observ_otrasalergias TEXT,
    observaciones_iniciales TEXT,
    otras_alergias TEXT,
    peso DECIMAL NOT NULL,
    presion_arterial DECIMAL NOT NULL,
    sustanciaspsico BOOLEAN NOT NULL,
    tabaquismo BOOLEAN NOT NULL,
    telefono_emermedica VARCHAR(17),
    temperatura_corporal DECIMAL NOT NULL,
    tipo_alimentacion TEXT,
    tipo_de_movilidad TEXT,
    tipo_de_sueno TEXT,
    tipo_sangre ENUM('A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-') NOT NULL,
    FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario)
);

CREATE TABLE TipoAlimentacion (
    id_tipoAlimentacion INT PRIMARY KEY AUTO_INCREMENT,
    nom_tipoalimentacion TEXT NOT NULL
);

CREATE TABLE TipoSueño (
    id_tipoSueño INT PRIMARY KEY AUTO_INCREMENT,
    nom_tipoSueño TEXT NOT NULL
);

CREATE TABLE TipoContinencia (
    id_tipoContinencia INT PRIMARY KEY AUTO_INCREMENT,
    nom_tipoContinencia TEXT NOT NULL
);

CREATE TABLE TipoMovilidad (
    id_tipoMovilidad INT PRIMARY KEY AUTO_INCREMENT,
    nom_tipoMovilidad TEXT NOT NULL
);

CREATE TABLE TipoCuidadoPersonal (
    id_tipoCuidadopersonal INT PRIMARY KEY AUTO_INCREMENT,
    nom_tipocuidadopersonal TEXT NOT NULL
);

CREATE TABLE MedicamentosPorUsuario (
    id INT PRIMARY KEY AUTO_INCREMENT,
    id_historiaClinica INT,
    medicamento TEXT,
    periodicidad TEXT,
    Fecha_inicio DATE,
    fecha_fin DATE,

    FOREIGN KEY (id_historiaClinica) REFERENCES HistoriaClinica(id_historiaclinica)
);

CREATE TABLE CuidadosEnfermeriaPorUsuario (
    id INT PRIMARY KEY AUTO_INCREMENT,
    id_historiaClinica INT,
    diagnostico TEXT,
    frecuencia TEXT,
    intervencion TEXT,

    FOREIGN KEY (id_historiaClinica) REFERENCES HistoriaClinica(id_historiaclinica)
);

CREATE TABLE IntervencionPorUsuario (
    id INT PRIMARY KEY AUTO_INCREMENT,
    id_historiaClinica INT,
    diagnostico TEXT,
    frecuencia TEXT,
    intervencion TEXT,

    FOREIGN KEY (id_historiaClinica) REFERENCES HistoriaClinica(id_historiaclinica)
);

CREATE TABLE TipoMedicamentos (
    id_TipoApoyoTratamiento INT PRIMARY KEY AUTO_INCREMENT,
    nom_Tipoapoyotratamiento TEXT NOT NULL
);

CREATE TABLE ApoyosPorUsuario (
    id_tipoapoyo INT,
    id_historiaClinica INT,
    periodicidad TEXT,
    Fecha_inicio DATE,
    fecha_fin DATE,
    PRIMARY KEY (id_tipoapoyo, id_historiaClinica),
    FOREIGN KEY (id_tipoapoyo) REFERENCES TipoApoyoTratamientos(id_TipoApoyoTratamiento),
    FOREIGN KEY (id_historiaClinica) REFERENCES HistoriaClinica(id_historiaclinica)
);

CREATE TABLE TipoApoyoTratamientos (
    id_TipoApoyoTratamiento INT PRIMARY KEY AUTO_INCREMENT,
    nom_Tipoapoyotratamiento TEXT NOT NULL
);

CREATE TABLE EsquemaVacunacion (
    id_vacuna INT,
    id_historiaClinica INT,
    fecha_aplicacion DATE,
    PRIMARY KEY (id_vacuna, id_historiaClinica),
    FOREIGN KEY (id_vacuna) REFERENCES Vacunas(id_vacuna),
    FOREIGN KEY (id_historiaClinica) REFERENCES HistoriaClinica(id_historiaclinica)
);

CREATE TABLE Vacunas (
    id_vacuna INT PRIMARY KEY AUTO_INCREMENT,
    nom_vacuna TEXT NOT NULL
);

CREATE TABLE TipoDiscaPorUsuarios (
    id_tipodiscapacidad INT,
    id_historiaClinica INT,
    observación TEXT,
    PRIMARY KEY (id_tipodiscapacidad, id_historiaClinica),
    FOREIGN KEY (id_tipodiscapacidad) REFERENCES TipoDiscapacidad(id_tipodiscapacidad),
    FOREIGN KEY (id_historiaClinica) REFERENCES HistoriaClinica(id_historiaclinica)
);

CREATE TABLE TipoDiscapacidad (
    id_tipodiscapacidad INT PRIMARY KEY AUTO_INCREMENT,
    nomdiscapacidad TEXT NOT NULL
);

CREATE TABLE TipoLimitPorUsuarios (
    id_tipolimitacion INT,
    id_historiaClinica INT,
    observación TEXT,
    PRIMARY KEY (id_tipolimitacion, id_historiaClinica),
    FOREIGN KEY (id_tipolimitacion) REFERENCES TipoLimitacion(id_tipolimitacion),
    FOREIGN KEY (id_historiaClinica) REFERENCES HistoriaClinica(id_historiaclinica)
);

CREATE TABLE TipoLimitacion (
    id_tipolimitacion INT PRIMARY KEY AUTO_INCREMENT,
    nomlimitacion TEXT NOT NULL
);
