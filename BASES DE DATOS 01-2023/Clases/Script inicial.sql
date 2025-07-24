--****************************************************
-- Bases de datos: Introducción a SQL
-- Autor: Erick Varela
-- Correspondencia: evarela@uca.edu.sv
-- Version: 1.0
--****************************************************


-- 1.0 RESTRICCIONES.
-- 1.1 Creando tabla HOTEL con columnas NULL (por defecto)/NOT NULL (Insertar hoteles 1,2 y 3)

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

-- 1.2.2 Modificando tabla para poder configurar la llave primaria


-- 1.2.3 Insertando información

-- eliminando tabla:

-- 2.2.3 Definir llave primaria al final de la definición de la tabla (Insertar hoteles 1,2 y 3)

-- eliminando tabla:

-- 2.2.4 Defiendo la llave primaria cuando se crea la tabla


-- eliminando tabla:


-- 3.0 Columnas UNIQUE: definiendo la columna telefono como campo unico.
	
-- 3.1 Insertando datos 

	

-- 3.2 Borrar la tabla HOTEL

	
-- 4.0 Columnas Default: definiendo la columna dirección con un valor por defecto.


-- 4.1 Insertando datos 


-- 4.2 Borrar la tabla HOTEL


-- 5.0 Restricción CHECK
-- 5.1 Crear las tablas HOTEL y HABITACION con las siguientes restricciones:
-- Campo telefono de HOTEL debe tener el formato:
-- 		Debe incluir el identificador de país +503
-- 		El formato oficial de un telefono inicia con los digitos 2,6 y 7.
-- 		El número de telefono actual tiene 8 digitos de longitud.
-- Campo numero de HABITACION debe tener el formato:
-- 		numero mayor que 0

	
-- 5.2 Borrar datos de las tablas HOTEL y HABITACION
