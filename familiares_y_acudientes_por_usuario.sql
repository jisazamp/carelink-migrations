CREATE TABLE familiares_y_acudientes_por_usuario (
    id_acudiente INT NOT NULL,
    id_usuario INT NOT NULL,
    parentesco TEXT,
    
    PRIMARY KEY (id_acudiente, id_usuario),
    
    CONSTRAINT fk_acudiente FOREIGN KEY (id_acudiente) REFERENCES Familiares(id_acudiente)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    
    CONSTRAINT fk_usuario FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
