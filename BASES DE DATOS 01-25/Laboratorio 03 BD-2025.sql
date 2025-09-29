/*
*   Solucion laboratorio 03
*   Autor: Diego Castro 00117322
*/

CREATE DATABASE laboratorio_3;
USE laboratorio_3;

-- PRIMERO CREAMOS LAS TABLAS CATALOGO (SIN LLAVE FORANEA)
CREATE TABLE Tecnologia (
 id INT NOT NULL,
 nombre VARCHAR(100) NOT NULL,
 version VARCHAR(50),
 PRIMARY KEY (id)
);

CREATE TABLE Area (
 id INT NOT NULL,
 nombre VARCHAR(100) NOT NULL,
 precio MONEY NOT NULL,
 PRIMARY KEY (id)
);

CREATE TABLE Rubro (
 id INT NOT NULL,
 nombre VARCHAR(100) NOT NULL,
 PRIMARY KEY (id)
);

CREATE TABLE Departamento (
 id INT NOT NULL,
 nombre VARCHAR(100) NOT NULL,
 PRIMARY KEY (id)
);

CREATE TABLE Puesto (
 id INT NOT NULL,
 nombre VARCHAR(100) NOT NULL,
 PRIMARY KEY (id)
);

CREATE TABLE Categoria (
 id INT NOT NULL,
 nombre VARCHAR(100) NOT NULL,
 id_area INT NOT NULL,
 PRIMARY KEY (id),
 FOREIGN KEY (id_area) REFERENCES Area(id)
);

-- TABLAS PRINCIPALES Y RELACIONES 
CREATE TABLE Cliente (
 id INT NOT NULL,
 nombre VARCHAR(150) NOT NULL,
 email VARCHAR(150) NOT NULL,
 id_rubro INT NOT NULL,
 PRIMARY KEY (id),
 FOREIGN KEY (id_rubro) REFERENCES Rubro(id)
);

CREATE TABLE Empleado (
 id INT NOT NULL,
 nombre VARCHAR(100) NOT NULL,
 apellido VARCHAR(100) NOT NULL,
 email VARCHAR(150) NOT NULL,
 fecha_contratacion DATE NOT NULL,
 id_puesto INT NOT NULL,
 id_departamento INT NOT NULL,
 PRIMARY KEY (id),
 FOREIGN KEY (id_puesto) REFERENCES Puesto(id),
 FOREIGN KEY (id_departamento) REFERENCES Departamento(id)
);

CREATE TABLE Proyecto (
 id INT NOT NULL,
 titulo VARCHAR(200) NOT NULL,
 id_categoria INT NOT NULL,
 id_cliente INT NOT NULL,
 id_lider INT NOT NULL,
 PRIMARY KEY (id),
 FOREIGN KEY (id_categoria) REFERENCES Categoria(id),
 FOREIGN KEY (id_cliente) REFERENCES Cliente(id),
 FOREIGN KEY (id_lider) REFERENCES Empleado(id)
);

CREATE TABLE Capacitacion (
 id INT NOT NULL,
 tema VARCHAR(200) NOT NULL,
 fecha DATE NOT NULL,
 duracion INT NOT NULL,
 PRIMARY KEY (id)
);

CREATE TABLE Supervision (
 id_empleado INT NOT NULL,
 id_mentor INT NOT NULL,
 PRIMARY KEY (id_empleado, id_mentor),
 FOREIGN KEY (id_empleado) REFERENCES Empleado(id),
 FOREIGN KEY (id_mentor) REFERENCES Empleado(id)
);

CREATE TABLE Evaluacion (
 id INT NOT NULL,
 puntaje INT NOT NULL,
 id_empleado INT NOT NULL,
 PRIMARY KEY (id),
 FOREIGN KEY (id_empleado) REFERENCES Empleado(id)
);

CREATE TABLE Comentario (
 id INT NOT NULL,
 descripcion VARCHAR(200) NOT NULL,
 id_evaluacion INT NOT NULL,
 PRIMARY KEY (id),
 FOREIGN KEY (id_evaluacion) REFERENCES Evaluacion(id)
);

-- POR ULTIMO CREAMOS LAS TABLAS N:N
CREATE TABLE TecnologiaXProyecto (
 id_tecnologia INT NOT NULL,
 id_proyecto INT NOT NULL,
 PRIMARY KEY (id_tecnologia, id_proyecto),
 FOREIGN KEY (id_tecnologia) REFERENCES Tecnologia(id),
 FOREIGN KEY (id_proyecto) REFERENCES Proyecto(id)
);

CREATE TABLE Asignacion (
 id_proyecto INT NOT NULL,
 id_empleado INT NOT NULL,
 PRIMARY KEY (id_proyecto, id_empleado),
 FOREIGN KEY (id_proyecto) REFERENCES Proyecto(id),
 FOREIGN KEY (id_empleado) REFERENCES Empleado(id)
);

CREATE TABLE Asistencia (
 id INT NOT NULL,
 id_capacitacion INT NOT NULL,
 id_empleado INT NOT NULL,
 PRIMARY KEY (id),
 FOREIGN KEY (id_capacitacion) REFERENCES Capacitacion(id),
 FOREIGN KEY (id_empleado) REFERENCES Empleado(id)
);

-- INSERCION DE DATOS 

-- PRIMERO HAY QUE INGRESAR LOS DATOS EN LAS TABLAS CATALOGO 
INSERT INTO Tecnologia (id, nombre, version) VALUES
(1, 'Java', '17'),
(2, 'Python', '3.11'),
(3, 'JavaScript', 'ES6'),
(4, 'SQL Server', '2019'),
(5, 'Spring Boot', '3.0');

INSERT INTO Area (id, nombre, precio) VALUES
(1, 'Tecnolog as de la Informaci n', 5000),
(2, 'Marketing Digital', 4000),
(3, 'Recursos Humanos', 3000);

INSERT INTO Rubro (id, nombre) VALUES
(1, 'Servicios Tecnol gicos'),
(2, 'Educaci n'),
(3, 'Salud');

INSERT INTO Departamento (id, nombre) VALUES
(1, 'Desarrollo de Software'),
(2, 'Ventas'),
(3, 'Administraci n');

-- Insertando datos en Puesto
INSERT INTO Puesto (id, nombre) VALUES
(1, 'Desarrollador Full Stack'),
(2, 'Analista de Datos'),
(3, 'Project Manager');

INSERT INTO Categoria (id, nombre, id_area) VALUES
(1, 'Desarrollo Web', 1),
(2, 'An lisis de Datos', 1),
(3, 'Gesti n de Proyectos', 1);

-- INGRESANDO DATOS EN TABLAS PRINCIPALES 
INSERT INTO Cliente (id, nombre, email, id_rubro) VALUES
(1, 'Carlos Mart nez', 'carlos.martinez@email.com', 1),
(2, 'Ana Rodr guez', 'ana.rodriguez@email.com', 1),
(3, 'Luis P rez', 'luis.perez@email.com', 1),
(4, 'Mar a Gonz lez', 'maria.gonzalez@email.com', 1),
(5, 'Jorge Hern ndez', 'jorge.hernandez@email.com', 1);

INSERT INTO Empleado (id, nombre, apellido, email, fecha_contratacion, id_puesto, id_departamento) VALUES
(1, 'David', 'Lopez', 'david.lopez@email.com', '2023-01-15', 1, 1),
(2, 'Sof a', 'Ram rez', 'sofia.ramirez@email.com', '2022-05-22', 1, 1),
(3, 'Mateo', 'Torres', 'mateo.torres@email.com', '2021-09-10', 1, 1),
(4, 'Isabella', 'Castro', 'isabella.castro@email.com', '2020-11-05', 1, 1),
(5, 'Sebasti n', 'Flores', 'sebastian.flores@email.com', '2023-03-18', 1, 1);

INSERT INTO Proyecto (id, titulo, id_categoria, id_cliente, id_lider) VALUES
(1, 'Sistema de Gesti n de Inventario', 1, 1, 1),
(2, 'Desarrollo de App M vil', 1, 2, 2),
(3, 'Implementaci n de ERP', 1, 3, 3),
(4, 'P gina Web Corporativa', 1, 4, 4),
(5, 'Automatizaci n de Procesos', 1, 5, 5);

-- CORROBORANDO LA INSERCION DE DATOS 

-- SELECT PARA LOS CATALOGOS
SELECT * FROM Tecnologia;
SELECT * FROM Area;
SELECT * FROM Rubro;
SELECT * FROM Departamento;
SELECT * FROM Puesto;
SELECT * FROM Categoria;

-- SELECT PARA LAS TABLAS PRINCIPALES 
SELECT * FROM Cliente;
SELECT * FROM Empleado;
SELECT * FROM Proyecto;
