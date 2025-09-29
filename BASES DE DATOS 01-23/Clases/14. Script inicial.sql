--****************************************************
-- Bases de datos: 14 Joins
-- Autor: Erick Varela
-- Correspondencia: evarela@uca.edu.sv
-- Version: 2.0
--****************************************************

-- 1.0 Descubriendo la utilidad de cada JOIN
-- 1.1 Antes agregamos algunos datos para comprender el funcionamiento de la instrucción JOIN
ALTER TABLE CLIENTE ALTER COLUMN id_pais INT NULL;
INSERT INTO CLIENTE (id, nombre, documento, id_pais, categoria_cliente) VALUES (51,'Finley Armstrong','M26375757',NULL,5);
INSERT INTO CLIENTE (id, nombre, documento, id_pais, categoria_cliente) VALUES (52,'Naomi Lee','X14183183',NULL,1);

-- 1.2 INNER JOIN

-- 1.3 LEFT JOIN

-- 1.3.1 LEFT JOIN

-- 1.4 RIGHT JOIN

-- 1.4.1 RIGHT JOIN

-- 1.5 FULL JOIN

-- 1.5.1 FULL JOIN

-- 2.0 Utilizando JOINS para realizar consultas
-- 2.1 Mostrar el id, nombre, dirección de cada hotel y el titulo de la categoría a la que pertenece:


-- 2.2 Mostrar toda la información de cada cliente, la vista debe incluir
-- el nombre del pais al cual pertenece y el tipo de cliente que es.
-- Consulta convencional

-- 2.2 Mostrar toda la información de cada cliente, la vista debe incluir
-- el nombre del pais al cual pertenece y el tipo de cliente que es, filtrar a los clientes con categoria "viajero"


-- 2.3 ¿Existe algún cliente que no ha registrado ningún correo electrónico?, si es así, realizar una consulta
-- que identifique a este grupo de clientes

-- 2.5 Mostrar todas las reservas realizadas para la segunda semana de Mayo.
-- Incluir el nombre del cliente que ha realizado la reserva.


-- 2.6 Mostrar todas las reservas realizadas para la segunda semana de Mayo.
-- Incluir el nombre del cliente que ha realizado la reserva, el método de pago y que habitacion reservo.


-- 2.7 Mostrar todas las reservas realizadas para la segunda semana de Mayo.
-- Incluir el nombre del cliente que ha realizado la reserva, el método de pago y que habitacion reservo.
-- Mostrar ademas el tipo de habitacion reservada y en que hotel reservo.
