E-- Table: ReportesClinicos
CREATE TABLE ReportesClinicos (
    id_reporteclinico INT AUTO_INCREMENT PRIMARY KEY,
    id_historiaclinica INT,
    id_profesional INT,
    motivo_consulta TEXT,
    diagnostico TEXT,
    observaciones TEXT,
    recomendaciones TEXT,
    pruebas_examenes TEXT,
    remision TEXT,
    peso INT,
    presion_arterial INT,
    Frecuencia_cardiaca INT,
    IMC DECIMAL(5,2),
    circunferencia_cintura FLOAT,
    Circunferencia_cadera FLOAT,
    Porc_grasacorporal DECIMAL(5,2),
    Porc_masamuscular DECIMAL(5,2),
    Obs_habitosalimenticios TEXT,
    frecuencia_actividadfisica ENUM('Baja', 'Moderada', 'Alta'),
    consumo_aguadiaria FLOAT,
    temperatura_corporal FLOAT,
    frecuencia_respiratoria INT,
    saturacionOxigeno INT,
    nivel_dolor INT,
    area_comportamental TEXT,
    area_afectiva TEXT,
    areasomatica TEXT,
    areainterpersonal TEXT,
    areacognitiva TEXT,
    FOREIGN KEY (id_historiaclinica) REFERENCES HistoriaClinica(id_historiaclinica),
    FOREIGN KEY (id_profesional) REFERENCES Profesionales(id_profesional)
);

-- Table: OrientacionEspacial
CREATE TABLE OrientacionEspacial (
    id_OrientacionEspacial INT AUTO_INCREMENT PRIMARY KEY,
    nom_OrientacionEspacial TEXT
);

-- Table: ExpresionEmosional
CREATE TABLE ExpresionEmosional (
    id_expresionemosional INT AUTO_INCREMENT PRIMARY KEY,
    nom_expresionemocional TEXT
);

-- Table: AtencionMemoria
CREATE TABLE AtencionMemoria (
    id_AtencionMemoria INT AUTO_INCREMENT PRIMARY KEY,
    nom_AtencionMemoria TEXT
);

-- Table: ActitudPresente
CREATE TABLE ActitudPresente (
    id_ActitudPresente INT AUTO_INCREMENT PRIMARY KEY,
    nom_ActitudPresente TEXT
);

-- Table: ActitudTemporal
CREATE TABLE ActitudTemporal (
    id_ActitudTemporal INT AUTO_INCREMENT PRIMARY KEY,
    nom_ActidudTemporal TEXT
);

-- Table: TipoReporteClinico
CREATE TABLE TipoReporteClinico (
    id_TipoReporte INT AUTO_INCREMENT PRIMARY KEY,
    nom_TipoReporte TEXT
);

-- Table: EvolucionesClinicas
CREATE TABLE EvolucionesClinicas (
    id_TipoReporte INT AUTO_INCREMENT PRIMARY KEY,
    fecha_evolucion DATE,
    observacion_evolucion TEXT
);

-- Table: DocumentoAdjuntoExam
CREATE TABLE DocumentoAdjuntoExam (
    id_DocumentoAdjunto INT AUTO_INCREMENT PRIMARY KEY,
    ruta_DocumentoAdjunto TEXT,
    nom_DocumentoAdjunto TEXT,
    peso_DocumentoAdjunto FLOAT,
    Tipo_DocumentoAdjunto TEXT
);

-- Table: Profesionales
CREATE TABLE Profesionales (
    id_profesional INT AUTO_INCREMENT PRIMARY KEY,
    nombres VARCHAR(35),
    apellidos VARCHAR(35),
    n_documento VARCHAR(25),
    t_profesional VARCHAR(40),
    fecha_nacimiento DATE,
    fecha_ingreso DATE,
    estado ENUM('Activo', 'Inactivo'),
    profesion ENUM('Médico', 'Enfermero', 'Nutricionista', 'Psicólogo', 'Fisioterapeuta'),
    especialidad ENUM('Cardiología', 'Pediatría', 'Nutrición', 'Psicología Clínica', 'Fisioterapia'),
    cargo ENUM('Jefe de Departamento', 'Especialista', 'Residente'),
    telefono INT(20),
    e_mail VARCHAR(30),
    direccion VARCHAR(50)
);
