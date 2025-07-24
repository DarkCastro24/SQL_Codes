--****************************************************
-- Bases de datos: 14 Joins
-- Autor: Erick Varela
-- Correspondencia: evarela@uca.edu.sv
-- Version: 2.0
--****************************************************


-- *****************************************************
-- 1.	ORDER BY
-- *****************************************************
-- 1.0 Mostar los datos de la tabla reserva e identificar como estan 
-- ordenados los datos
-- ¿Se utiliza siempre el mismo criterio?
SELECT *
FROM RESERVA;

-- 1.2	Mostrar los datos de la tabla reserva. 
--		Ordenar los datos a partir del id de cliente en 
--		orden descendente
SELECT *
FROM RESERVA R
ORDER BY R.id_cliente_reserva ASC;

SELECT *
FROM RESERVA R
ORDER BY R.id_cliente_reserva DESC;

-- 1.3	Mostrar los datos de la tabla reserva. Incluir el nombre del cliente, 
--		el hotel y el numero de habitacion reservada.
--		Ordenar la tabla con respecto al nombre del cliente en forma ascendente.
SELECT R.id, R.checkin, R.checkout, C.nombre 'cliente', 
			HO.nombre 'hotel', H.numero
FROM CLIENTE C, RESERVA R, HABITACION H, HOTEL HO
WHERE C.id = R.id_cliente_reserva
		AND H.id = R.id_habitacion
		AND HO.id = H.id_hotel
ORDER BY C.nombre ASC;




-- 1.4	 Observar que cada cliente ha realizado 0, 1 o varias reservas, ordenar la lista segun
--		 el nombre del cliente en orden descendente y por cada cliente ordenar sus RESERVAS
--		 de forma cronologica.
SELECT R.id, R.checkin, R.checkout, C.nombre 'cliente', 
			HO.nombre 'hotel', H.numero
FROM CLIENTE C, RESERVA R, HABITACION H, HOTEL HO
WHERE C.id = R.id_cliente_reserva
		AND H.id = R.id_habitacion
		AND HO.id = H.id_hotel
ORDER BY C.nombre DESC, R.checkin ASC;


-- 1.4.2 Mostrar los datos de la tabla reserva. Incluir el nombre del cliente, 
--		 el hotel y el nomero de habitacion reservada.
--		 Ordenar la tabla con respecto al nombre del cliente en forma ascendente.
--		 Como segundo y tercer criterio de orden utilizar el hotel y el numero de habitacion
SELECT R.id, R.checkin, R.checkout, C.nombre 'cliente', 
			HO.nombre 'hotel', H.numero
FROM CLIENTE C, RESERVA R, HABITACION H, HOTEL HO
WHERE C.id = R.id_cliente_reserva
		AND H.id = R.id_habitacion
		AND HO.id = H.id_hotel
ORDER BY C.nombre DESC, R.checkin ASC, H.numero ASC;


-- *****************************************************
-- 2.0	GROUP BY
-- *****************************************************
-- 2.1	¿Cuantos clientes hay por cada pais? 
--		Ordenar la lista en orden descendente
-- Paso 1: creando vista
SELECT C.nombre, P.id, P.pais
FROM CLIENTE C, PAIS P
WHERE P.id = C.id_pais
ORDER BY P.pais DESC;

-- Paso 2: aplicando función de agregación COUNT
SELECT COUNT(C.nombre), P.pais
FROM CLIENTE C, PAIS P
WHERE P.id = C.id_pais
GROUP BY P.pais
ORDER BY P.pais DESC;

-- 2.1.1 ¿Cuantos clientes hay por cada pais? 
--		Ordenar la lista en orden descendente
--		 Incluir el id y nombre de cada pais.
SELECT P.id, P.pais, COUNT(C.nombre) 'cantidad de clientes'
FROM CLIENTE C, PAIS P
WHERE P.id = C.id_pais
GROUP BY P.id, P.pais
ORDER BY P.pais DESC;

-- 2.2	¿Cuantos clientes hay por cada pais? 
--		Ordenar la lista en orden descendente
--		Incluir en el resultado los paises sin ningún cliente
SELECT P.id, P.pais, COUNT(C.nombre) 'cantidad de clientes'
FROM PAIS P
	LEFT JOIN CLIENTE C
		ON P.id = C.id_pais
GROUP BY P.id, P.pais
ORDER BY COUNT(C.nombre) ASC;

-- 2.3  ¿Cuantas RESERVAs se han realizado en cada hotel?
--		Ordenar el resultado con respecto al id de cada hotel de 
--		forma ascendente
-- Paso 1: creando consulta
SElECT HO.id, HO.nombre, R.id
FROM HOTEL HO, HABITACION H, RESERVA R
WHERE HO.id = H.id_hotel
		AND H.id = R.id_habitacion
ORDER BY HO.id ASC;

-- Paso 2: aplicando funcion de agregación COUNT
SELECT HO.id, HO.nombre, COUNT(R.id) 'cantidad reservas'
FROM HOTEL HO, HABITACION H, RESERVA R
WHERE HO.id = H.id_hotel
		AND H.id = R.id_habitacion
GROUP BY HO.id, HO.nombre
ORDER BY HO.id ASC;


-- 2.4 ¿Cual es la habitacion mas barata y mas cara de cada hotel?
SELECT COUNT(*) 
FROM HABITACION;

SELECT HO.id, HO.nombre, MIN(H.precio)
FROM HOTEL HO, HABITACION H
WHERE HO.id = H.id_hotel
GROUP BY HO.id, HO.nombre;

SELECT HO.id, HO.nombre, MAX(H.precio)
FROM HOTEL HO, HABITACION H
WHERE HO.id = H.id_hotel
GROUP BY HO.id, HO.nombre;

SELECT HO.id, HO.nombre, 
		MIN(H.precio) 'habitacion económica', 
			MAX(H.precio) 'habitación premium'
FROM HOTEL HO, HABITACION H
WHERE HO.id = H.id_hotel
GROUP BY HO.id, HO.nombre;

--2.5	Mostrar el detalle de cada RESERVA con respecto a los precios.
--		incluir el precio de la habitacion y el total de los servicios
-- 		nota: se asume que el precio de la habitacion es por noche
-- Precio de reserva (precio habitacion * cantidad de dias reservados) +
--						(total de los servicios adquiridos * cantidad de días reservados)

-- Paso 1: relacionando tablas HABITACION y RESERVA
SELECT R.id, R.checkin, R.checkout, H.precio
FROM HABITACION H
	INNER JOIN RESERVA R
		ON H.id = R.id_habitacion

-- paso 2: calculando cantidad de dias reservados
SELECT R.id, R.checkin, R.checkout, H.precio,
		DATEDIFF (DAY,R.checkin,R.checkout) 'dias reservados'
FROM HABITACION H
	INNER JOIN RESERVA R
		ON H.id = R.id_habitacion;

-- Paso 3 calculando subtotal de habitacion:
SELECT R.id, R.checkin, R.checkout, H.precio,
		DATEDIFF (DAY,R.checkin,R.checkout) 'dias reservados',
			H.precio * DATEDIFF (DAY,R.checkin,R.checkout) 'subtotal habitacion'
FROM HABITACION H
	INNER JOIN RESERVA R
		ON H.id = R.id_habitacion;

-- Paso 4: relacionando tablas SERVICIO y EXTRA
SELECT R.id, R.checkin, R.checkout, H.precio,
		DATEDIFF (DAY,R.checkin,R.checkout) 'dias reservados',
			H.precio * DATEDIFF (DAY,R.checkin,R.checkout) 'subtotal habitacion'
FROM HABITACION H
	INNER JOIN RESERVA R
		ON H.id = R.id_habitacion
	LEFT JOIN EXTRA X 
		ON R.id = X.id_reserva
	LEFT JOIN SERVICIO S
		ON S.id = X.id_servicio;

-- Paso 5: Mostrando los servicios extras incluidos en cada reserva
SELECT R.id, R.checkin, R.checkout, H.precio,
		DATEDIFF (DAY,R.checkin,R.checkout) 'dias reservados',
			H.precio * DATEDIFF (DAY,R.checkin,R.checkout) 'subtotal habitacion',
				S.precio
FROM HABITACION H
	INNER JOIN RESERVA R
		ON H.id = R.id_habitacion
	LEFT JOIN EXTRA X 
		ON R.id = X.id_reserva
	LEFT JOIN SERVICIO S
		ON S.id = X.id_servicio;

-- Paso 6: calculando subtotal de servicios
SELECT R.id, R.checkin, R.checkout, H.precio,
		DATEDIFF (DAY,R.checkin,R.checkout) 'dias reservados',
			H.precio * DATEDIFF (DAY,R.checkin,R.checkout) 'subtotal habitacion',
				SUM(S.precio) 'subtotal servicio'
FROM HABITACION H
	INNER JOIN RESERVA R
		ON H.id = R.id_habitacion
	LEFT JOIN EXTRA X 
		ON R.id = X.id_reserva
	LEFT JOIN SERVICIO S
		ON S.id = X.id_servicio
GROUP BY R.id, R.checkin, R.checkout, H.precio,
		DATEDIFF (DAY,R.checkin,R.checkout),
			H.precio * DATEDIFF (DAY,R.checkin,R.checkout);

-- Paso 7: Realizando casting de los valores NULOS a 0.00 y multiplicando por la cantidad de 
--			dias reservados
SELECT R.id, R.checkin, R.checkout, H.precio,
		DATEDIFF (DAY,R.checkin,R.checkout) 'dias reservados',
			H.precio * DATEDIFF (DAY,R.checkin,R.checkout) 'subtotal habitacion',
				ISNULL(SUM(S.precio),0)*DATEDIFF (DAY,R.checkin,R.checkout) 'subtotal servicio'
FROM HABITACION H
	INNER JOIN RESERVA R
		ON H.id = R.id_habitacion
	LEFT JOIN EXTRA X 
		ON R.id = X.id_reserva
	LEFT JOIN SERVICIO S
		ON S.id = X.id_servicio
GROUP BY R.id, R.checkin, R.checkout, H.precio,
		DATEDIFF (DAY,R.checkin,R.checkout),
			H.precio * DATEDIFF (DAY,R.checkin,R.checkout);

-- Paso 8: calculando el total de la reserva
SELECT R.id, R.checkin, R.checkout, H.precio,
		DATEDIFF (DAY,R.checkin,R.checkout) 'dias reservados',
			H.precio * DATEDIFF (DAY,R.checkin,R.checkout) 'subtotal habitacion',
				ISNULL(SUM(S.precio),0)*DATEDIFF (DAY,R.checkin,R.checkout) 'subtotal servicio',
					H.precio * DATEDIFF (DAY,R.checkin,R.checkout) + 
					ISNULL(SUM(S.precio),0)*DATEDIFF (DAY,R.checkin,R.checkout) 'TOTAL'
FROM HABITACION H
	INNER JOIN RESERVA R
		ON H.id = R.id_habitacion
	LEFT JOIN EXTRA X 
		ON R.id = X.id_reserva
	LEFT JOIN SERVICIO S
		ON S.id = X.id_servicio
GROUP BY R.id, R.checkin, R.checkout, H.precio,
		DATEDIFF (DAY,R.checkin,R.checkout),
			H.precio * DATEDIFF (DAY,R.checkin,R.checkout);
		