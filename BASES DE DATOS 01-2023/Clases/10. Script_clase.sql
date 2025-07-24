use clase10_s01;

-- Soy un comentario :D 

/*
Comentario
de 
bloque
*/

-- Creando tablas
CREATE TABLE hotel(
	id INT NULL, 
	nombre VARCHAR(32) NOT NULL, 
	direccion VARCHAR(64) NULL,
	telefono CHAR(12) NULL
);

-- Eliminando tabla
DROP TABLE hotel;

CREATE TABLE habitacion(
	id INT,
	numero INT,
	precio MONEY,
	id_hotel INT
);

-- Crear tablas hotel y habitacion

-- 2. Consultado tablas
-- Instruccion DML SELECT: permite consultar tablas
-- Seleccionando todas las columnas de la tabla hotel:
SELECT id, nombre, direccion, telefono
FROM hotel;

-- Opcionalmente
SELECT *
FROM hotel;

-- Seleccionando columnas especificas
SELECT id, nombre
FROM hotel;

-- El orden de las columnas no importa
SELECT nombre, telefono, id, direccion
FROM hotel;

-- 3. Insertando datos
-- Instruccion DML INSERT: permite insertar datos en una tabla
	/*
	Id: 1
	Hotel: Real Intercontinental San Salvador
	Dirección: 4945 Purus. St.
	Telefono: +50324234992
	*/
	
	/*
	Id: 2
	Hotel: Crowne Plaza
	Dirección: ---
	Telefono: +50325008446
	*/
	
	/*
	Id: ---
	Hotel: Quality Hotel Real Aeropuerto
	Dirección: ---
	Telefono: +50325008446
	*/

INSERT INTO hotel (id, nombre, direccion, telefono)
VALUES (1, 'Real Intercontinental','4945 Purus. St.','+50324234992');
INSERT INTO hotel (id, nombre, direccion, telefono)
VALUES (2, 'Crowne Plaza',NULL,'+50325008446');
INSERT INTO hotel (nombre, telefono)
VALUES ('Quality Hotel','+50325008446');
-- Seleccionando la tabla hotel
SELECT id, nombre, direccion, telefono
FROM hotel;

INSERT INTO hotel (id, nombre, direccion, telefono)
VALUES (1, 'Real Intercontinental','San Salvador','+50324234992');


-- 4. Creación de llaves primarias (PK)
-- Borrando los datos de la tabla. La mejor práctica es crear las llaves primarias en el momento de creacion de la tabla
DROP TABLE hotel; -- esta instrucción borra la tabla
-- Instrucción DML DELETE: borra todos o algunos datos de una tabla
DELETE FROM hotel;
SELECT * FROM HOTEL;

-- Definiendo la llave primera
-- 4.1 Como instrucción independiente (se debe modificar la tabla)
-- Instrucción DDL ALTER: modifica un objeto de la base de datos
ALTER TABLE hotel ADD CONSTRAINT pk_hotel PRIMARY KEY (id);
-- la instruccion anterior falla porque la columna id de hotel permite nulos, es necesario cambiar esta caracteristica
ALTER TABLE hotel ALTER COLUMN id INT NOT NULL;
-- Creando la llave primaria
ALTER TABLE hotel ADD CONSTRAINT pk_hotel PRIMARY KEY (id);

-- Insertando datos:
INSERT INTO hotel (id, nombre, direccion, telefono)
VALUES (1, 'Real Intercontinental','4945 Purus. St.','+50324234992');
INSERT INTO hotel (id, nombre, direccion, telefono)
VALUES (2, 'Crowne Plaza',NULL,'+50325008446');
INSERT INTO hotel (nombre, telefono)
VALUES ('Quality Hotel','+50325008446'); --falla: porque la pk es NULL
INSERT INTO hotel (id, nombre, direccion, telefono)
VALUES (1, 'Real Intercontinental','San Salvador','+50324234992'); -- falla: porque la pk se repite

DROP TABLE HOTEL;
-- 4.2 Al definir la columna cuando se crea la tabla
CREATE TABLE hotel(
	id INT PRIMARY KEY, 
	nombre VARCHAR(32) NOT NULL, 
	direccion VARCHAR(64) NULL,
	telefono CHAR(12) NULL
);
DROP TABLE HOTEL;
-- 4.3 Al final de la tabla cuando se crea la tabla
CREATE TABLE hotel(
	id INT NOT NULL, 
	nombre VARCHAR(32) NOT NULL, 
	direccion VARCHAR(64) NULL,
	telefono CHAR(12) NULL,
	CONSTRAINT pk_hotel PRIMARY KEY (id)
);