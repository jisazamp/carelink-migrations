-- carelink-migrations/cronograma_asistencia.sql

CREATE TABLE cronograma_asistencia (
    id_cronograma INT AUTO_INCREMENT PRIMARY KEY,
    id_profesional INT NOT NULL,
    fecha DATE NOT NULL,
    comentario TEXT,
    FOREIGN KEY (id_profesional) REFERENCES users (id)
);

CREATE TABLE cronograma_asistencia_pacientes (
    id_cronograma_paciente INT AUTO_INCREMENT PRIMARY KEY,
    id_cronograma INT NOT NULL,
    id_usuario INT NOT NULL,
    id_contrato INT NOT NULL,
    estado_asistencia ENUM(
        'PENDIENTE',
        'ASISTIÓ',
        'NO ASISTIÓ',
        'CANCELADO',
        'REAGENDADO'
    ) DEFAULT 'PENDIENTE',
    FOREIGN KEY (id_cronograma) REFERENCES cronograma_asistencia (id_cronograma) ON DELETE CASCADE,
    FOREIGN KEY (id_usuario) REFERENCES Usuarios (id_usuario),
    FOREIGN KEY (id_contrato) REFERENCES Contratos (id_contrato)
);