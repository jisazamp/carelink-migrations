CREATE TABLE HistoriaClinica (
    id_historiaclinica INT PRIMARY KEY AUTO_INCREMENT,
    Tiene_OtrasAlergias BOOLEAN NOT NULL,
    Tienedieta_especial BOOLEAN NOT NULL,
    alcoholismo TEXT,
    alergico_medicamento BOOLEAN NOT NULL,
    altura INT NOT NULL,
    apariencia_personal TEXT,
    cafeina TEXT,
    cirugias TEXT,
    comunicacion_no_verbal TEXT,
    comunicacion_verbal TEXT,
    continencia TEXT,
    cuidado_personal TEXT,
    dieta_especial TEXT,
    diagnosticos TEXT,
    discapacidades TEXT,
    emer_medica VARCHAR(30),
    eps VARCHAR(30),
    estado_de_animo TEXT,
    fecha_ingreso DATE NOT NULL,
    frecuencia_cardiaca DECIMAL NOT NULL,
    historial_cirugias TEXT,
    id_usuario INT NOT NULL,
    limitaciones TEXT,
    maltratado TEXT,
    maltrato TEXT,
    medicamentos_alergia TEXT,
    motivo_ingreso TEXT,
    observ_dietaEspecial TEXT,
    observ_otrasalergias TEXT,
    observaciones_iniciales TEXT,
    otras_alergias TEXT,
    peso DECIMAL NOT NULL,
    presion_arterial DECIMAL NOT NULL,
    sustanciaspsico TEXT,
    tabaquismo TEXT,
    telefono_emermedica VARCHAR(17),
    temperatura_corporal DECIMAL NOT NULL,
    tipo_alimentacion TEXT,
    tipo_de_movilidad TEXT,
    tipo_de_sueno TEXT,
    tipo_sangre ENUM('A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-') NOT NULL,
    FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario)
);

CREATE TABLE MedicamentosPorUsuario (
    id INT PRIMARY KEY AUTO_INCREMENT,
    id_historiaClinica INT,
    medicamento TEXT,
    periodicidad TEXT,
    observaciones TEXT,
    FOREIGN KEY (id_historiaClinica) REFERENCES HistoriaClinica(id_historiaclinica) ON DELETE CASCADE
);

CREATE TABLE CuidadosEnfermeriaPorUsuario (
    id INT PRIMARY KEY AUTO_INCREMENT,
    id_historiaClinica INT,
    diagnostico TEXT,
    frecuencia TEXT,
    intervencion TEXT,
    FOREIGN KEY (id_historiaClinica) REFERENCES HistoriaClinica(id_historiaclinica) ON DELETE CASCADE
);

CREATE TABLE IntervencionPorUsuario (
    id INT PRIMARY KEY AUTO_INCREMENT,
    id_historiaClinica INT,
    diagnostico TEXT,
    frecuencia TEXT,
    intervencion TEXT,
    FOREIGN KEY (id_historiaClinica) REFERENCES HistoriaClinica(id_historiaclinica) ON DELETE CASCADE
);

CREATE TABLE VacunasPorUsuario (
    id INT PRIMARY KEY AUTO_INCREMENT,
    id_historiaClinica INT,
    efectos_secundarios TEXT,
    fecha_administracion DATE,
    fecha_proxima DATE,
    vacuna TEXT,
    FOREIGN KEY (id_historiaClinica) REFERENCES HistoriaClinica(id_historiaclinica) ON DELETE CASCADE
);

CREATE TABLE ApoyosPorUsuario (
    id_tipoapoyo INT,
    id_historiaClinica INT,
    periodicidad TEXT,
    Fecha_inicio DATE,
    fecha_fin DATE,
    PRIMARY KEY (id_tipoapoyo, id_historiaClinica),
    FOREIGN KEY (id_tipoapoyo) REFERENCES TipoApoyoTratamientos(id_TipoApoyoTratamiento),
    FOREIGN KEY (id_historiaClinica) REFERENCES HistoriaClinica(id_historiaclinica) ON DELETE CASCADE
);

CREATE TABLE EsquemaVacunacion (
    id_vacuna INT,
    id_historiaClinica INT,
    fecha_aplicacion DATE,
    PRIMARY KEY (id_vacuna, id_historiaClinica),
    FOREIGN KEY (id_vacuna) REFERENCES Vacunas(id_vacuna),
    FOREIGN KEY (id_historiaClinica) REFERENCES HistoriaClinica(id_historiaclinica) ON DELETE CASCADE
);

CREATE TABLE TipoDiscaPorUsuarios (
    id_tipodiscapacidad INT,
    id_historiaClinica INT,
    observación TEXT,
    PRIMARY KEY (id_tipodiscapacidad, id_historiaClinica),
    FOREIGN KEY (id_tipodiscapacidad) REFERENCES TipoDiscapacidad(id_tipodiscapacidad),
    FOREIGN KEY (id_historiaClinica) REFERENCES HistoriaClinica(id_historiaclinica) ON DELETE CASCADE
);

CREATE TABLE TipoLimitPorUsuarios (
    id_tipolimitacion INT,
    id_historiaClinica INT,
    observación TEXT,
    PRIMARY KEY (id_tipolimitacion, id_historiaClinica),
    FOREIGN KEY (id_tipolimitacion) REFERENCES TipoLimitacion(id_tipolimitacion),
    FOREIGN KEY (id_historiaClinica) REFERENCES HistoriaClinica(id_historiaclinica) ON DELETE CASCADE
);
