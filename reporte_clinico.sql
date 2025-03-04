CREATE TABLE ReportesClinicos (
    id_reporteclinico INT AUTO_INCREMENT PRIMARY KEY,
    id_historiaclinica INT,
    id_profesional INT,
    Circunferencia_cadera FLOAT,
    Frecuencia_cardiaca INT,
    IMC DECIMAL(5,2),
    Obs_habitosalimenticios TEXT,
    Porc_grasacorporal DECIMAL(5,2),
    Porc_masamuscular DECIMAL(5,2),
    area_afectiva TEXT,
    area_comportamental TEXT,
    areacognitiva TEXT,
    areainterpersonal TEXT,
    areasomatica TEXT,
    circunferencia_cintura FLOAT,
    consumo_aguadiaria FLOAT,
    diagnostico TEXT,
    fecha_registro DATE,
    frecuencia_actividadfisica ENUM('Baja', 'Moderada', 'Alta'),
    frecuencia_respiratoria INT,
    motivo_consulta TEXT,
    nivel_dolor INT,
    observaciones TEXT,
    peso INT,
    presion_arterial INT,
    pruebas_examenes TEXT,
    recomendaciones TEXT,
    remision TEXT,
    saturacionOxigeno INT,
    temperatura_corporal FLOAT,
    tipo_reporte TEXT,
    FOREIGN KEY (id_historiaclinica) REFERENCES HistoriaClinica(id_historiaclinica),
    FOREIGN KEY (id_profesional) REFERENCES Profesionales(id_profesional)
);

CREATE TABLE OrientacionEspacial (
    id_OrientacionEspacial INT AUTO_INCREMENT PRIMARY KEY,
    nom_OrientacionEspacial TEXT
);

CREATE TABLE ExpresionEmosional (
    id_expresionemosional INT AUTO_INCREMENT PRIMARY KEY,
    nom_expresionemocional TEXT
);

CREATE TABLE AtencionMemoria (
    id_AtencionMemoria INT AUTO_INCREMENT PRIMARY KEY,
    nom_AtencionMemoria TEXT
);

CREATE TABLE ActitudPresente (
    id_ActitudPresente INT AUTO_INCREMENT PRIMARY KEY,
    nom_ActitudPresente TEXT
);

CREATE TABLE ActitudTemporal (
    id_ActitudTemporal INT AUTO_INCREMENT PRIMARY KEY,
    nom_ActidudTemporal TEXT
);

CREATE TABLE TipoReporteClinico (
    id_TipoReporte INT AUTO_INCREMENT PRIMARY KEY,
    nom_TipoReporte TEXT
);

CREATE TABLE EvolucionesClinicas (
    id_TipoReporte INT AUTO_INCREMENT PRIMARY KEY,
    id_reporteclinico INT,
    fecha_evolucion DATE,
    observacion_evolucion TEXT,
    FOREIGN KEY (id_reporteclinico) REFERENCES ReportesClinicos(id_reporteclinico)
);

CREATE TABLE DocumentoAdjuntoExam (
    id_DocumentoAdjunto INT AUTO_INCREMENT PRIMARY KEY,
    ruta_DocumentoAdjunto TEXT,
    nom_DocumentoAdjunto TEXT,
    peso_DocumentoAdjunto FLOAT,
    Tipo_DocumentoAdjunto TEXT
);

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
