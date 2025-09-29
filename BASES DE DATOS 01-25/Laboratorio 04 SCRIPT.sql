CREATE TABLE Area (
    id INT PRIMARY KEY,
    nombre VARCHAR(100),
    precio DECIMAL(10,2)
);

CREATE TABLE Rubro (
    id INT PRIMARY KEY,
    nombre VARCHAR(100)
);

CREATE TABLE Departamento (
    id INT PRIMARY KEY,
    nombre VARCHAR(100)
);

CREATE TABLE Puesto (
    id INT PRIMARY KEY,
    nombre VARCHAR(100)
);

CREATE TABLE Tecnologia (
    id INT PRIMARY KEY,
    nombre VARCHAR(100),
    version VARCHAR(50)
);

CREATE TABLE Capacitacion (
    id INT PRIMARY KEY,
    tema VARCHAR(100),
    fecha DATE,
    duracion INT
);

CREATE TABLE Cliente (
    id INT PRIMARY KEY,
    nombre VARCHAR(100),
    email VARCHAR(100),
    id_rubro INT
);

CREATE TABLE Categoria (
    id INT PRIMARY KEY,
    nombre VARCHAR(100),
    id_area INT
);

CREATE TABLE Empleado (
    id INT PRIMARY KEY,
    nombre VARCHAR(100),
    apellido VARCHAR(100),
    email VARCHAR(100),
    fecha_contratacion DATE,
    id_puesto INT,
    id_departamento INT
);

CREATE TABLE Proyecto (
    id INT PRIMARY KEY,
    id_categoria INT,
    titulo VARCHAR(100),
    id_cliente INT,
    id_lider INT
);

CREATE TABLE TecnologiaXProyecto (
    id_tecnologia INT,
    id_proyecto INT,
    PRIMARY KEY (id_tecnologia, id_proyecto)
);

CREATE TABLE Trabajadores (
    id_empleado INT,
    id_proyecto INT,
    PRIMARY KEY (id_empleado, id_proyecto)
);

CREATE TABLE Asistencia (
    id_capacitacion INT,
    id_empleado INT,
    PRIMARY KEY (id_capacitacion, id_empleado)
);

CREATE TABLE Supervision (
    id_empleado_supervisado INT,
    id_empleado_supervisor INT,
    PRIMARY KEY (id_empleado_supervisado, id_empleado_supervisor)
);

CREATE TABLE Evaluacion (
    id INT PRIMARY KEY,
    puntaje INT,
    id_empleado INT
);

CREATE TABLE Comentario (
    id INT PRIMARY KEY,
    descripcion TEXT,
    id_evaluacion INT
);

ALTER TABLE Cliente ADD CONSTRAINT FK_Cliente_Rubro
    FOREIGN KEY (id_rubro) REFERENCES Rubro(id);

ALTER TABLE Categoria ADD CONSTRAINT FK_Categoria_Area
    FOREIGN KEY (id_area) REFERENCES Area(id);

ALTER TABLE Empleado ADD CONSTRAINT FK_Empleado_Puesto
    FOREIGN KEY (id_puesto) REFERENCES Puesto(id);

ALTER TABLE Empleado ADD CONSTRAINT FK_Empleado_Departamento
    FOREIGN KEY (id_departamento) REFERENCES Departamento(id);

ALTER TABLE Proyecto ADD CONSTRAINT FK_Proyecto_Categoria
    FOREIGN KEY (id_categoria) REFERENCES Categoria(id);

ALTER TABLE Proyecto ADD CONSTRAINT FK_Proyecto_Cliente
    FOREIGN KEY (id_cliente) REFERENCES Cliente(id);

ALTER TABLE Proyecto ADD CONSTRAINT FK_Proyecto_Lider
    FOREIGN KEY (id_lider) REFERENCES Empleado(id);

ALTER TABLE TecnologiaXProyecto ADD CONSTRAINT FK_TXP_Tecnologia
    FOREIGN KEY (id_tecnologia) REFERENCES Tecnologia(id);

ALTER TABLE TecnologiaXProyecto ADD CONSTRAINT FK_TXP_Proyecto
    FOREIGN KEY (id_proyecto) REFERENCES Proyecto(id);

ALTER TABLE Trabajadores ADD CONSTRAINT FK_Trabajadores_Empleado
    FOREIGN KEY (id_empleado) REFERENCES Empleado(id);

ALTER TABLE Trabajadores ADD CONSTRAINT FK_Trabajadores_Proyecto
    FOREIGN KEY (id_proyecto) REFERENCES Proyecto(id);

ALTER TABLE Asistencia ADD CONSTRAINT FK_Asistencia_Capacitacion
    FOREIGN KEY (id_capacitacion) REFERENCES Capacitacion(id);

ALTER TABLE Asistencia ADD CONSTRAINT FK_Asistencia_Empleado
    FOREIGN KEY (id_empleado) REFERENCES Empleado(id);

ALTER TABLE Supervision ADD CONSTRAINT FK_Supervision_Supervisado
    FOREIGN KEY (id_empleado_supervisado) REFERENCES Empleado(id);

ALTER TABLE Supervision ADD CONSTRAINT FK_Supervision_Supervisor
    FOREIGN KEY (id_empleado_supervisor) REFERENCES Empleado(id);

ALTER TABLE Evaluacion ADD CONSTRAINT FK_Evaluacion_Empleado
    FOREIGN KEY (id_empleado) REFERENCES Empleado(id);

ALTER TABLE Comentario ADD CONSTRAINT FK_Comentario_Evaluacion
    FOREIGN KEY (id_evaluacion) REFERENCES Evaluacion(id);

INSERT INTO Area VALUES (1, 'Tecnolog�a', 500.0);
INSERT INTO Area VALUES (2, 'Metodolog�as de trabajo', 450.0);
INSERT INTO Area VALUES (3, 'Financieros', 600.0);
INSERT INTO Area VALUES (4, 'Entrenamiento de empleados', 400.0);
INSERT INTO Categoria VALUES (1, 'Desarrollo Web', 1);
INSERT INTO Categoria VALUES (2, 'Ciberseguridad', 1);
INSERT INTO Categoria VALUES (3, 'Scrum', 2);
INSERT INTO Categoria VALUES (4, 'Design Thinking', 2);
INSERT INTO Categoria VALUES (5, 'Contabilidad', 3);
INSERT INTO Categoria VALUES (6, 'An�lisis Financiero', 3);
INSERT INTO Categoria VALUES (7, 'Liderazgo', 4);
INSERT INTO Categoria VALUES (8, 'Capacitaci�n t�cnica', 4);
INSERT INTO Rubro VALUES (1, 'Salud');
INSERT INTO Rubro VALUES (2, 'Educaci�n');
INSERT INTO Rubro VALUES (3, 'Retail');
INSERT INTO Rubro VALUES (4, 'Finanzas');
INSERT INTO Rubro VALUES (5, 'Manufactura');
INSERT INTO Departamento VALUES (1, 'Tecnolog�as de la Informaci�n');
INSERT INTO Departamento VALUES (2, 'Recursos Humanos');
INSERT INTO Departamento VALUES (3, 'Finanzas');
INSERT INTO Departamento VALUES (4, 'Proyectos');
INSERT INTO Departamento VALUES (5, 'Marketing');
INSERT INTO Puesto VALUES (1, 'Analista');
INSERT INTO Puesto VALUES (2, 'Desarrollador');
INSERT INTO Puesto VALUES (3, 'Scrum Master');
INSERT INTO Puesto VALUES (4, 'Jefe de Proyecto');
INSERT INTO Puesto VALUES (5, 'Asistente');
INSERT INTO Tecnologia VALUES (1, 'Java', '11');
INSERT INTO Tecnologia VALUES (2, 'Python', '3.10');
INSERT INTO Tecnologia VALUES (3, 'JavaScript', 'ES6');
INSERT INTO Tecnologia VALUES (4, 'React', '18.2');
INSERT INTO Tecnologia VALUES (5, 'Spring Boot', '2.7');
INSERT INTO Empleado VALUES (1, 'Tomasa', 'Saez', 'cuestacaridad@yahoo.com', '2018-04-01', 2, 1);
INSERT INTO Empleado VALUES (2, 'Virginia', 'Segarra', 'gcastrillo@yahoo.com', '2018-06-08', 2, 2);
INSERT INTO Empleado VALUES (3, 'Susanita', 'Zamorano', 'doritaperal@palomo.es', '2017-11-15', 3, 5);
INSERT INTO Empleado VALUES (4, 'Bruno', 'Reig', 'alberoedgar@gmail.com', '2016-11-09', 2, 5);
INSERT INTO Empleado VALUES (5, 'Clementina', 'Rosell', 'jheredia@yahoo.com', '2020-11-21', 1, 2);
INSERT INTO Empleado VALUES (6, 'Angelina', 'Benitez', 'banoszaida@carretero-rueda.es', '2018-05-17', 4, 4);
INSERT INTO Empleado VALUES (7, 'Duilio', 'Agullo', 'baldomeroledesma@hotmail.com', '2016-09-23', 2, 5);
INSERT INTO Empleado VALUES (8, 'Ceferino', 'Gelabert', 'rivashoracio@yahoo.com', '2022-01-23', 1, 2);
INSERT INTO Empleado VALUES (9, 'Amada', 'Tenorio', 'fpalomares@segarra-cervantes.com', '2019-09-01', 1, 3);
INSERT INTO Empleado VALUES (10, 'Lourdes', 'Mor�n', 'margaritasanchez@yahoo.com', '2017-06-06', 3, 1);
INSERT INTO Empleado VALUES (11, 'Armando', 'Pomares', 'villarariadna@yahoo.com', '2022-05-18', 1, 5);
INSERT INTO Empleado VALUES (12, 'Estrella', 'Lobo', 'graucasandra@hotmail.com', '2020-03-18', 3, 2);
INSERT INTO Empleado VALUES (13, 'Bernab�', 'Oliva', 'wcastellanos@uriarte.org', '2021-04-13', 4, 5);
INSERT INTO Empleado VALUES (14, 'Samu', 'Mart�nez', 'conesamaria-jesus@amaya.es', '2024-04-08', 3, 3);
INSERT INTO Empleado VALUES (15, 'Heraclio', 'Hierro', 'pastortorrijos@valle.net', '2022-12-04', 5, 1);
INSERT INTO Empleado VALUES (16, 'Jose Carlos', 'S�enz', 'poloabigail@gmail.com', '2017-10-06', 2, 2);
INSERT INTO Empleado VALUES (17, 'Leoncio', 'Calvo', 'abrildominga@gmail.com', '2023-10-23', 2, 5);
INSERT INTO Empleado VALUES (18, 'Luna', 'Pag�s', 'samu73@hotmail.com', '2021-04-22', 5, 3);
INSERT INTO Empleado VALUES (19, 'Imelda', 'Miranda', 'sigfridobaena@hotmail.com', '2018-11-20', 3, 2);
INSERT INTO Empleado VALUES (20, 'Eva Mar�a', 'Palomar', 'marcosiban@hotmail.com', '2022-05-10', 1, 5);
INSERT INTO Cliente VALUES (1, 'Castell�, Alberola and Zurita', 'caminomariano@melero.org', 4);
INSERT INTO Cliente VALUES (2, 'Soto-Carbonell', 'stenorio@manuel.com', 4);
INSERT INTO Cliente VALUES (3, 'Figueroa-Cifuentes', 'marisasedano@nicolau-fuster.com', 2);
INSERT INTO Cliente VALUES (4, 'Gual-Sierra', 'ibanvalverde@cuesta.es', 4);
INSERT INTO Cliente VALUES (5, 'Izquierdo-Azorin', 'bespada@casanova-galvan.net', 1);
INSERT INTO Cliente VALUES (6, 'Fuentes Ltd', 'gomisvalentina@falco.es', 5);
INSERT INTO Cliente VALUES (7, 'Ramirez-Di�guez', 'dimasguerra@tamayo-cabanillas.com', 3);
INSERT INTO Cliente VALUES (8, 'Barber�-Jord�n', 'dparedes@mateo.com', 2);
INSERT INTO Cliente VALUES (9, 'Castillo, Acosta and Juan', 'gabaldonariadna@penas-alemany.net', 3);
INSERT INTO Cliente VALUES (10, 'Morera PLC', 'talaveramarianela@torralba-solsona.es', 1);
INSERT INTO Proyecto VALUES (1, 2, 'Proyecto Ad', 6, 1);
INSERT INTO Proyecto VALUES (2, 7, 'Proyecto Minima', 4, 12);
INSERT INTO Proyecto VALUES (3, 2, 'Proyecto Iure', 10, 3);
INSERT INTO Proyecto VALUES (4, 4, 'Proyecto Totam', 7, 10);
INSERT INTO Proyecto VALUES (5, 6, 'Proyecto Iure', 1, 7);
INSERT INTO Proyecto VALUES (6, 7, 'Proyecto Atque', 6, 8);
INSERT INTO Proyecto VALUES (7, 5, 'Proyecto Vero', 5, 7);
INSERT INTO Proyecto VALUES (8, 7, 'Proyecto Dolorem', 3, 17);
INSERT INTO Proyecto VALUES (9, 2, 'Proyecto Sit', 7, 20);
INSERT INTO Proyecto VALUES (10, 3, 'Proyecto Sint', 2, 9);
INSERT INTO Evaluacion VALUES (1, 34, 20);
INSERT INTO Evaluacion VALUES (2, 8, 16);
INSERT INTO Evaluacion VALUES (3, 13, 1);
INSERT INTO Evaluacion VALUES (4, 33, 4);
INSERT INTO Evaluacion VALUES (5, 71, 3);
INSERT INTO Evaluacion VALUES (6, 29, 3);
INSERT INTO Evaluacion VALUES (7, 21, 17);
INSERT INTO Evaluacion VALUES (8, 24, 7);
INSERT INTO Evaluacion VALUES (9, 60, 12);
INSERT INTO Evaluacion VALUES (10, 21, 16);
INSERT INTO Evaluacion VALUES (11, 2, 12);
INSERT INTO Evaluacion VALUES (12, 52, 12);
INSERT INTO Evaluacion VALUES (13, 34, 6);
INSERT INTO Evaluacion VALUES (14, 85, 17);
INSERT INTO Evaluacion VALUES (15, 40, 8);
INSERT INTO Evaluacion VALUES (16, 1, 3);
INSERT INTO Evaluacion VALUES (17, 18, 2);
INSERT INTO Evaluacion VALUES (18, 12, 1);
INSERT INTO Evaluacion VALUES (19, 25, 1);
INSERT INTO Evaluacion VALUES (20, 6, 15);
INSERT INTO Comentario VALUES (1, 'Facere cupiditate quisquam nostrum nemo.', 13);
INSERT INTO Comentario VALUES (2, 'Culpa repellendus nobis blanditiis enim a.', 11);
INSERT INTO Comentario VALUES (3, 'Totam laudantium sapiente placeat temporibus hic excepturi.', 2);
INSERT INTO Comentario VALUES (4, 'Dolorum aut saepe adipisci veniam odit doloremque temporibus.', 6);
INSERT INTO Comentario VALUES (5, 'Eaque vitae harum rerum.', 19);
INSERT INTO Comentario VALUES (6, 'Debitis exercitationem dolores labore optio.', 3);
INSERT INTO Comentario VALUES (7, 'Voluptate possimus id quam vitae ab.', 9);
INSERT INTO Comentario VALUES (8, 'Labore consectetur maxime debitis.', 16);
INSERT INTO Comentario VALUES (9, 'Libero modi architecto doloribus pariatur magnam tenetur possimus.', 6);
INSERT INTO Comentario VALUES (10, 'Corrupti expedita necessitatibus consequatur consectetur ut.', 10);
INSERT INTO Comentario VALUES (11, 'Dolorum sapiente quae doloribus nemo numquam.', 14);
INSERT INTO Comentario VALUES (12, 'Laborum a voluptates minima.', 10);
INSERT INTO Comentario VALUES (13, 'Labore est perspiciatis placeat ex.', 17);
INSERT INTO Comentario VALUES (14, 'Laboriosam illum nostrum in perspiciatis provident animi.', 8);
INSERT INTO Comentario VALUES (15, 'Rerum maxime exercitationem aliquid.', 17);
INSERT INTO Comentario VALUES (16, 'Perspiciatis ad beatae laborum adipisci enim.', 2);
INSERT INTO Comentario VALUES (17, 'Aut eligendi facere nostrum pariatur possimus voluptate.', 14);
INSERT INTO Comentario VALUES (18, 'Consectetur enim dolore tenetur exercitationem.', 7);
INSERT INTO Comentario VALUES (19, 'Praesentium esse ipsam optio labore fuga fugiat nesciunt.', 15);
INSERT INTO Comentario VALUES (20, 'Dolore nesciunt nihil inventore quae omnis.', 13);
INSERT INTO Supervision VALUES (16, 17);
INSERT INTO Supervision VALUES (19, 1);
INSERT INTO Supervision VALUES (7, 18);
INSERT INTO Supervision VALUES (8, 6);
INSERT INTO Supervision VALUES (19, 2);
INSERT INTO Supervision VALUES (20, 10);
INSERT INTO Supervision VALUES (17, 20);
INSERT INTO Supervision VALUES (8, 5);
INSERT INTO Supervision VALUES (2, 18);
INSERT INTO Supervision VALUES (20, 3);
INSERT INTO Supervision VALUES (9, 1);
INSERT INTO Supervision VALUES (8, 17);
INSERT INTO Supervision VALUES (7, 14);
INSERT INTO Supervision VALUES (19, 20);
INSERT INTO Supervision VALUES (6, 19);
INSERT INTO Supervision VALUES (1, 8);
INSERT INTO Supervision VALUES (6, 14);
INSERT INTO Supervision VALUES (5, 16);
INSERT INTO Supervision VALUES (8, 13);
INSERT INTO Supervision VALUES (13, 15);
INSERT INTO Capacitacion VALUES (1, 'Curso Ipsam', '2022-10-15', 4);
INSERT INTO Capacitacion VALUES (2, 'Curso Facere', '2023-05-23', 5);
INSERT INTO Capacitacion VALUES (3, 'Curso Consequatur', '2024-10-16', 4);
INSERT INTO Capacitacion VALUES (4, 'Curso In', '2024-11-03', 3);
INSERT INTO Capacitacion VALUES (5, 'Curso Maxime', '2024-09-17', 4);
INSERT INTO Capacitacion VALUES (6, 'Curso Ex', '2021-08-29', 4);
INSERT INTO Capacitacion VALUES (7, 'Curso Repudiandae', '2023-03-30', 4);
INSERT INTO Capacitacion VALUES (8, 'Curso Necessitatibus', '2020-06-29', 2);
INSERT INTO Capacitacion VALUES (9, 'Curso Explicabo', '2023-07-10', 5);
INSERT INTO Capacitacion VALUES (10, 'Curso Repellendus', '2021-07-28', 1);
INSERT INTO Asistencia VALUES (2, 13);
INSERT INTO Asistencia VALUES (6, 16);
INSERT INTO Asistencia VALUES (6, 12);
INSERT INTO Asistencia VALUES (7, 8);
INSERT INTO Asistencia VALUES (6, 15);
INSERT INTO Asistencia VALUES (2, 2);
INSERT INTO Asistencia VALUES (7, 10);
INSERT INTO Asistencia VALUES (1, 11);
INSERT INTO Asistencia VALUES (6, 11);
INSERT INTO Asistencia VALUES (1, 7);
INSERT INTO Asistencia VALUES (5, 17);
INSERT INTO Asistencia VALUES (10, 11);
INSERT INTO Asistencia VALUES (7, 14);
INSERT INTO Asistencia VALUES (3, 20);
INSERT INTO Asistencia VALUES (6, 12);
INSERT INTO Asistencia VALUES (5, 15);
INSERT INTO Asistencia VALUES (3, 20);
INSERT INTO Asistencia VALUES (1, 3);
INSERT INTO Asistencia VALUES (3, 11);
INSERT INTO Asistencia VALUES (6, 9);
INSERT INTO Trabajadores VALUES (4, 7);
INSERT INTO Trabajadores VALUES (7, 3);
INSERT INTO Trabajadores VALUES (5, 8);
INSERT INTO Trabajadores VALUES (12, 9);
INSERT INTO Trabajadores VALUES (18, 1);
INSERT INTO Trabajadores VALUES (10, 5);
INSERT INTO Trabajadores VALUES (15, 10);
INSERT INTO Trabajadores VALUES (11, 9);
INSERT INTO Trabajadores VALUES (14, 7);
INSERT INTO Trabajadores VALUES (16, 4);
INSERT INTO Trabajadores VALUES (19, 10);
INSERT INTO Trabajadores VALUES (10, 9);
INSERT INTO Trabajadores VALUES (12, 4);
INSERT INTO Trabajadores VALUES (13, 6);
INSERT INTO Trabajadores VALUES (19, 5);
INSERT INTO Trabajadores VALUES (3, 9);
INSERT INTO Trabajadores VALUES (20, 8);
INSERT INTO Trabajadores VALUES (1, 6);
INSERT INTO Trabajadores VALUES (13, 1);
INSERT INTO Trabajadores VALUES (14, 8);
INSERT INTO Trabajadores VALUES (8, 9);
INSERT INTO Trabajadores VALUES (2, 7);
INSERT INTO Trabajadores VALUES (1, 10);
INSERT INTO Trabajadores VALUES (15, 3);
INSERT INTO Trabajadores VALUES (9, 1);
INSERT INTO TecnologiaXProyecto VALUES (4, 7);
INSERT INTO TecnologiaXProyecto VALUES (5, 7);
INSERT INTO TecnologiaXProyecto VALUES (5, 1);
INSERT INTO TecnologiaXProyecto VALUES (1, 3);
INSERT INTO TecnologiaXProyecto VALUES (5, 9);
INSERT INTO TecnologiaXProyecto VALUES (4, 10);
INSERT INTO TecnologiaXProyecto VALUES (1, 10);
INSERT INTO TecnologiaXProyecto VALUES (4, 8);
INSERT INTO TecnologiaXProyecto VALUES (1, 1);
INSERT INTO TecnologiaXProyecto VALUES (5, 2);
INSERT INTO TecnologiaXProyecto VALUES (2, 10);
INSERT INTO TecnologiaXProyecto VALUES (3, 4);
INSERT INTO TecnologiaXProyecto VALUES (2, 1);
INSERT INTO TecnologiaXProyecto VALUES (3, 7);
INSERT INTO TecnologiaXProyecto VALUES (2, 4);
INSERT INTO TecnologiaXProyecto VALUES (1, 8);
INSERT INTO TecnologiaXProyecto VALUES (4, 4);
INSERT INTO TecnologiaXProyecto VALUES (3, 6);
INSERT INTO TecnologiaXProyecto VALUES (3, 1);
INSERT INTO TecnologiaXProyecto VALUES (2, 5);
INSERT INTO TecnologiaXProyecto VALUES (3, 8);
INSERT INTO TecnologiaXProyecto VALUES (3, 9);
INSERT INTO TecnologiaXProyecto VALUES (4, 2);
INSERT INTO TecnologiaXProyecto VALUES (4, 9);