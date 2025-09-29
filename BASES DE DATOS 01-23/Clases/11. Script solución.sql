--****************************************************
-- Bases de datos: Introducción a SQL
-- Autor: Erick Varela
-- Correspondencia: evarela@uca.edu.sv
-- Version: 1.0
--****************************************************


-- 1.0 RESTRICCIONES.
-- 1.1 Creando tabla HOTEL con columnas NULL (por defecto)/NOT NULL (Insertar hoteles 1,2 y 3)
CREATE TABLE hotel(
	id INT NULL,
	nombre VARCHAR (32) NOT NULL,
	dirección VARCHAR(32) NULL,
	telefono CHAR(12) NULL
);


-- 1.1.1 Insertar la lista de hoteles y verificar el resultado
INSERT INTO HOTEL (id, nombre, direccion, telefono)
	VALUES (1, 'Real Intercontinental', 'San Salvador', '+50324234992');
INSERT INTO HOTEL (id, nombre, direccion, telefono)
	VALUES (2, 'Crowne Plaza', NULL,'+50325008446');
INSERT INTO HOTEL (nombre, telefono)
	VALUES ('Quality Hotel Real Aeropuerto', '+50325008446');
	
-- Borrando el contenido de la tabla


-- 1.2 Creando llave primaria
-- 1.2.1 A través del comando ALTER
ALTER TABLE hotel ADD CONSTRAINT pk_hotel PRIMARY KEY (id); --falla porque la columna acepta nulos
-- 1.2.2 Modificando tabla para poder configurar la llave primaria
ALTER TABLE hotel ALTER COLUMN id INT NOT NULL;
ALTER TABLE hotel ADD CONSTRAINT pk_hotel PRIMARY KEY (id); 

-- eliminando tabla:
DROP TABLE hotel;
-- 2.2.3 Definir llave primaria al final de la definición de la tabla (Insertar hoteles 1,2 y 3)
CREATE TABLE hotel(
	id INT PRIMARY KEY,
	nombre VARCHAR (32) NOT NULL,
	dirección VARCHAR(32) NULL,
	telefono CHAR(12) NULL
);

-- eliminando tabla:
DROP TABLE hotel;
-- 2.2.4 Defiendo la llave primaria cuando se crea la tabla
CREATE TABLE hotel(
	id INT NOT NULL,
	nombre VARCHAR (32) NOT NULL,
	dirección VARCHAR(32) NULL,
	telefono CHAR(12) NULL,
	 CONSTRAINT pk_hotel PRIMARY KEY (id)
);

DROP TABLE hotel;


-- 2.2.5 autogenerando la llave primaria (PK)
CREATE TABLE hotel(
	id INT PRIMARY KEY IDENTITY,
	nombre VARCHAR (32) NOT NULL,
	direccion VARCHAR(32) NULL,
	telefono CHAR(12) NULL
);
-- Insertando datos
INSERT INTO HOTEL (id, nombre, direccion, telefono)
	VALUES (1, 'Real Intercontinental', 'San Salvador', '+50324234992'); -- falla, porque el campo pk se esta definiciendo de forma explicita
INSERT INTO HOTEL (nombre, direccion, telefono)
	VALUES ('Real Intercontinental', 'San Salvador', '+50324234992');
SELECT * FROM hotel;
INSERT INTO HOTEL (nombre, direccion, telefono)
	VALUES ('Crowne Plaza', NULL,'+50325008446');
INSERT INTO HOTEL (nombre, telefono)
	VALUES ('Quality Hotel Real Aeropuerto', '+50325008446');
SELECT * FROM hotel;

DROP TABLE hotel;

-- 3.0 Columnas UNIQUE: definiendo la columna telefono como campo unico.
CREATE TABLE hotel(
	id INT PRIMARY KEY IDENTITY,
	nombre VARCHAR (32) NOT NULL,
	direccion VARCHAR(32) NULL,
	telefono CHAR(12) NULL UNIQUE
);

-- 3.1 Insertando datos 
INSERT INTO HOTEL (nombre, direccion, telefono)
	VALUES ('Real Intercontinental', 'San Salvador', '+50324234992');
INSERT INTO HOTEL (nombre, direccion, telefono)
	VALUES ('Crowne Plaza', NULL,'+50325008446');
INSERT INTO HOTEL (nombre, telefono)
	VALUES ('Quality Hotel Real Aeropuerto', '+50325008447');
SELECT * FROM hotel;

-- 3.2 Borrar la tabla HOTEL
DROP TABLE hotel;
	
-- 4.0 Columnas Default: definiendo la columna dirección con un valor por defecto.
CREATE TABLE hotel(
	id INT PRIMARY KEY IDENTITY,
	nombre VARCHAR (32) NOT NULL,
	direccion VARCHAR(32) NULL DEFAULT 'No disponible',
	telefono CHAR(12) NULL UNIQUE
);


-- 4.1 Insertando datos 
INSERT INTO HOTEL (nombre, direccion, telefono)
	VALUES ('Real Intercontinental', 'San Salvador', '+50324234992');
INSERT INTO HOTEL (nombre, direccion, telefono)
	VALUES ('Crowne Plaza', NULL,'+50325008446');
INSERT INTO HOTEL (nombre, telefono)
	VALUES ('Quality Hotel Real Aeropuerto', '+50325008447');
INSERT INTO HOTEL (nombre, telefono)
	VALUES ('Hotel el hotel','+50325008448');

SELECT * FROM hotel;
-- 4.2 Borrar la tabla HOTEL
DROP TABLE hotel;


-- 5.0 Restricción CHECK
-- 5.1 Crear las tablas HOTEL y HABITACION con las siguientes restricciones:
-- Campo telefono de HOTEL debe tener el formato:
-- 		Debe incluir el identificador de país +503
-- 		El formato oficial de un telefono inicia con los digitos 2,6 y 7.
-- 		El número de telefono actual tiene 8 digitos de longitud.
-- Campo numero de HABITACION debe tener el formato:
-- 		numero mayor que 0
CREATE TABLE hotel(
	id INT PRIMARY KEY IDENTITY,
	nombre VARCHAR (32) NOT NULL,
	direccion VARCHAR(32) NULL DEFAULT 'No disponible',
	telefono CHAR(12) NULL UNIQUE CHECK (telefono LIKE '+503[2|6|7][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
);

INSERT INTO HOTEL (nombre, direccion, telefono)
	VALUES ('Real Intercontinental', 'San Salvador', '+50324234992');
INSERT INTO HOTEL (nombre, direccion, telefono)
	VALUES ('Crowne Plaza', NULL,'+50325008446');
INSERT INTO HOTEL (nombre, telefono)
	VALUES ('Quality Hotel Real Aeropuerto', '+50325008447');
INSERT INTO HOTEL (nombre, telefono)
	VALUES ('Hotel el hotel','+50375008441');

DROP TABLE habitacion;
CREATE TABLE habitacion(
	id INT PRIMARY KEY IDENTITY,
	numero_habitacion INT CHECK (numero_habitacion > 0),
	precio MONEY,
	id_hotel INT
)
-- 5.2 Borrar datos de las tablas HOTEL y HABITACION
