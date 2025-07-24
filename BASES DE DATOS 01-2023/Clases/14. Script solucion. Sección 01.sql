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
SELECT *
FROM CLIENTE C INNER JOIN PAIS P
	ON P.id = C.id_pais;

SELECT * 
FROM CLIENTE C, PAIS P
WHERE P.id = C.id_pais;

-- 1.3 LEFT JOIN
-- Asumiendo tabla izquierda a CLIENTE y tabla derecha a PAIS
SELECT *
FROM CLIENTE C LEFT JOIN PAIS P
	ON P.id = C.id_pais;

-- 1.3.1 LEFT JOIN
SELECT *
FROM CLIENTE C LEFT JOIN PAIS P
	ON P.id = C.id_pais
WHERE P.id IS NULL;

-- 1.4 RIGHT JOIN
SELECT *
FROM CLIENTE C RIGHT JOIN PAIS P
	ON P.id = C.id_pais;
-- 1.4.1 RIGHT JOIN
SELECT *
FROM CLIENTE C RIGHT JOIN PAIS P
	ON P.id = C.id_pais
WHERE C.id IS NULL;

-- 1.5 FULL JOIN
SELECT *
FROM CLIENTE C FULL JOIN PAIS P
	ON P.id = C.id_pais;

-- 1.5.1 FULL JOIN
SELECT *
FROM CLIENTE C FULL JOIN PAIS P
	ON P.id = C.id_pais
WHERE C.id_pais IS NULL;

SELECT *
FROM CLIENTE C FULL JOIN PAIS P
	ON P.id = C.id_pais
WHERE C.id IS NULL OR P.id IS NULL;

-- 2.0 Utilizando JOINS para realizar consultas
-- 2.1 Mostrar el id, nombre, dirección de cada hotel 
--		y el titulo de la categoría a la que pertenece:
SELECT H.id, H.nombre, H.direccion, C.categoria
FROM HOTEL H INNER JOIN CATEGORIA_HOTEL C
	ON C.id = H.id_categoria_hotel;

-- 2.2 Mostrar toda la información de cada cliente, la vista debe incluir
-- el nombre del pais al cual pertenece y el tipo de cliente que es.
-- Consulta convencional
SELECT C.id, C.nombre, C.documento, P.pais, CC.categoria
FROM CLIENTE C, CATEGORIA_CLIENTE CC, PAIS P
WHERE CC.id = C.categoria_cliente AND C.id_pais = P.id;


-- Paso 1: unir a los conjuntos CLIENTE y CATEGORIA
SELECT C.id, C.nombre, C.documento, CC.categoria
FROM CLIENTE C INNER JOIN CATEGORIA_CLIENTE CC
	ON C.categoria_cliente = CC.id;

-- Paso 2; Unir el conjunto resultante de la consulta del paso 1, con 
--			el conjunto PAIS
SELECT C.id, C.nombre, C.documento, CC.categoria, P.pais
FROM CLIENTE C INNER JOIN CATEGORIA_CLIENTE CC
	ON C.categoria_cliente = CC.id
		INNER JOIN PAIS P
	ON P.id = C.id_pais;

-- 2.2 Mostrar toda la información de cada cliente, la vista debe incluir
--	el nombre del pais al cual pertenece y el tipo de cliente que es, 
--	filtrar a los clientes con categoria "viajero"
SELECT C.id, C.nombre, C.documento, CC.categoria, P.pais
FROM CLIENTE C INNER JOIN CATEGORIA_CLIENTE CC
	ON C.categoria_cliente = CC.id
		INNER JOIN PAIS P
	ON P.id = C.id_pais
WHERE CC.categoria = 'viajero';

-- 2.3 ¿Existe algún cliente que no ha registrado ningún correo 
--	electrónico?, si es así, realizar una consulta
-- que identifique a este grupo de clientes
SELECT *
FROM CLIENTE C LEFT JOIN CORREO_CLIENTE CC
	ON C.id = CC.id_cliente
WHERE CC.id_cliente IS NULL;

-- 2.5 Mostrar todas las reservas realizadas para la segunda semana de Mayo.
-- Incluir el nombre del cliente que ha realizado la reserva.
SELECT R.id, R.checkin, R.checkout, R.id_cliente_reserva, C.id, C.nombre
FROM RESERVA R INNER JOIN CLIENTE C 
	ON C.id = R.id_cliente_reserva
WHERE R.checkin BETWEEN CONVERT (date, '08-05-2023', 103)
							AND CONVERT (date, '14-05-2023', 103);


-- 2.6 Mostrar todas las reservas realizadas para la segunda semana de Mayo.
--	Incluir el nombre del cliente que ha realizado la reserva, 
--	el método de pago y que habitacion reservo.
SELECT R.id, R.checkin, R.checkout, R.id_cliente_reserva, C.id, C.nombre,
			M.metodo_pago
FROM RESERVA R INNER JOIN CLIENTE C 
	ON C.id = R.id_cliente_reserva
		INNER JOIN METODO_PAGO M
	ON M.id = R.id_metodo_pago
WHERE R.checkin BETWEEN CONVERT (date, '08-05-2023', 103)
							AND CONVERT (date, '14-05-2023', 103);

SELECT R.id, R.checkin, R.checkout, R.id_cliente_reserva, C.id, C.nombre,
			M.metodo_pago, H.numero 'habitacion reservada'
FROM RESERVA R INNER JOIN CLIENTE C 
	ON C.id = R.id_cliente_reserva
		INNER JOIN METODO_PAGO M
	ON M.id = R.id_metodo_pago
		INNER JOIN HABITACION H
	ON H.id = R.id_habitacion
WHERE R.checkin BETWEEN CONVERT (date, '08-05-2023', 103)
							AND CONVERT (date, '14-05-2023', 103);

-- 2.7 Mostrar todas las reservas realizadas para la segunda semana de Mayo.
-- Incluir el nombre del cliente que ha realizado la reserva, el método de pago y que habitacion reservo.
-- Mostrar ademas el tipo de habitacion reservada y en que hotel reservo.
SELECT R.id, R.checkin, R.checkout, R.id_cliente_reserva, C.id, C.nombre,
			M.metodo_pago, H.numero 'habitacion reservada',
				HO.nombre 'Hotel'
FROM RESERVA R INNER JOIN CLIENTE C 
	ON C.id = R.id_cliente_reserva
		INNER JOIN METODO_PAGO M
	ON M.id = R.id_metodo_pago
		INNER JOIN HABITACION H
	ON H.id = R.id_habitacion
		INNER JOIN HOTEL HO
	ON HO.id = H.id_hotel
WHERE R.checkin BETWEEN CONVERT (date, '08-05-2023', 103)
							AND CONVERT (date, '14-05-2023', 103);


SELECT R.id, R.checkin, R.checkout, R.id_cliente_reserva, C.id, C.nombre,
			M.metodo_pago, H.numero 'habitacion reservada', TH.tipo 'ti'
				HO.nombre 'Hotel'
FROM RESERVA R INNER JOIN CLIENTE C 
	ON C.id = R.id_cliente_reserva
		INNER JOIN METODO_PAGO M
	ON M.id = R.id_metodo_pago
		INNER JOIN HABITACION H
	ON H.id = R.id_habitacion
		INNER JOIN HOTEL HO
	ON HO.id = H.id_hotel
		INNER JOIN TIPO_HABITACION TH
	ON TH.id = H.id_tipo_habitacion
WHERE R.checkin BETWEEN CONVERT (date, '08-05-2023', 103)
							AND CONVERT (date, '14-05-2023', 103);