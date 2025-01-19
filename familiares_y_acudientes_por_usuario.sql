CREATE TABLE familiares_y_acudientes_por_usuario(
    id_acudiente INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    parentesco ENUM('Padre', 'Madre', 'Hermano', 'Hermana', 'Tío', 'Tía', 'Primo', 'Prima', 'Amigo', 'Otro') NOT NULL,

    CONSTRAINT fk_acudiente_usuario FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
