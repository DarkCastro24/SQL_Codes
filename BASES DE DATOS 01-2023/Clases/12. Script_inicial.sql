--****************************************************
-- Bases de datos: Introducción a SQL
-- Autor: Erick Varela
-- Correspondencia: evarela@uca.edu.sv
-- Version: 1.0
-- Tema: Restricción de llave foránea
--****************************************************

-- Ejercicio 1
-- 1.0 Crear tablas HOTEL y HABITACION, luego definir la llave foránea que relaciona a ambas tablas
CREATE TABLE HOTEL (
	id INT PRIMARY KEY IDENTITY,
	nombre VARCHAR(50) NOT NULL,
	direccion VARCHAR(100) NULL DEFAULT 'Dirección no definida',
	telefono CHAR(12) NOT NULL UNIQUE CHECK (telefono LIKE '+503[2|6|7][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
);

CREATE TABLE HABITACION(
	id INT PRIMARY KEY,
	numero INT NOT NULL CHECK (numero > 0),
	precio MONEY NOT NULL,
	id_hotel INT NOT NULL
);
GO

-- 1.0.1 Creando llave foránea


-- 1.1 Insertar una habitación en la tabla HABITACION y observar el resultado:

-- Esta instrucción falla, razón: 
-- El campo id_hotel no puede ser NULL; pero el valor no puede contener un valor que no existe en la tabla Hotel

-- 1.2 Insertar datos en la tabla HOTEL, luego intentar insertar en la tabla HABITACION
INSERT INTO HOTEL (nombre, direccion, telefono)
	VALUES ('Real Intercontinental', 'San Salvador', '+50324234992');
INSERT INTO HOTEL (nombre, telefono)
	VALUES ('Crowne Plaza', '+50325008446');
INSERT INTO HOTEL (nombre, telefono)
	VALUES ('Quality Hotel Real Aeropuerto', '+50375008447'); 
SELECT * FROM HOTEL;

-- 1.2.2 Insertando datos en habitación
INSERT INTO HABITACION(id, numero, precio, id_hotel) 
	VALUES (1, 101, 130.99, 1); 
INSERT INTO HABITACION(id, numero, precio, id_hotel) 
	VALUES (2, 102, 159.00, 1); 
INSERT INTO HABITACION(id, numero, precio, id_hotel) 
	VALUES (3, 102, 99.99, 3); 

-- 1.3 Eliminar el hotel con id = 2, luego, eliminar el hotel con id = 3


-- 1.3.1 Eliminar las habitación con id_hotel = 3;


-- 1.3.2 Eliminar el hotel con id = 3;


-- 1.3.3 Eliminando tablas HOTEL y HABITACION
-- NOTA: ¡Ahora el orden de eliminación de las tablas importa!


-- 1.4 Crear las tablas HOTEL y HABITACION, y definir la llave foránea incluyendo la acción referencial conveniente
CREATE TABLE HOTEL (
	id INT PRIMARY KEY IDENTITY,
	nombre VARCHAR(50) NOT NULL,
	direccion VARCHAR(100) NULL DEFAULT 'Dirección no definida',
	telefono CHAR(12) NOT NULL UNIQUE CHECK (telefono LIKE '+503[2|6|7][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
);

CREATE TABLE HABITACION(
	id INT PRIMARY KEY,
	numero INT NOT NULL CHECK (numero > 0),
	precio MONEY NOT NULL,
	id_hotel INT NOT NULL
);
GO

-- 1.4.1 Creando llave foránea

-- 1.4.2 Insertar datos en la tabla HOTEL y HABITACION
INSERT INTO HOTEL (nombre, direccion, telefono)
	VALUES ('Real Intercontinental', 'San Salvador', '+50324234992');
INSERT INTO HOTEL (nombre, telefono)
	VALUES ('Crowne Plaza', '+50325008446');
INSERT INTO HOTEL (nombre, telefono)
	VALUES ('Quality Hotel Real Aeropuerto', '+50375008447'); 
SELECT * FROM HOTEL;

INSERT INTO HABITACION(id, numero, precio, id_hotel) 
	VALUES (1, 101, 130.99, 1); 
INSERT INTO HABITACION(id, numero, precio, id_hotel) 
	VALUES (2, 102, 159.00, 1); 
INSERT INTO HABITACION(id, numero, precio, id_hotel) 
	VALUES (3, 102, 99.99, 3); 

SELECT * FROM HOTEL;
SELECT * FROM HABITACION;

-- 1.4.3 Eliminar el hotel con id = 1 y observar el resultado en las tablas HOTEL Y HABITACION


-- 1.4.4 Eliminar la tabla HOTEL y observa el resultado

-- NOTA: la accion referencial solo aplica para la eliminación y actualización de datos no de tablas
-- Para poder eliminar la tabla hotel, es necesario:
-- Opción 1: Eliminar la llave foránea
-- Opción 2: Eliminar la tabla HABITACION

ALTER TABLE HABITACION DROP CONSTRAINT fk_hotel_habitacion;
DROP TABLE HOTEL;
DROP TABLE HABITACION;

-- Ejercicio 2:
