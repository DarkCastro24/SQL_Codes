--****************************************************
-- Bases de datos: Funciones y procedimientos almacenados
-- Autor: Erick Varela
-- Correspondencia: evarela@uca.edu.sv
-- Version: 1.0
--****************************************************

-- *****************************************************
-- 1.	Funciones
-- *****************************************************
-- 1.1	Crear una funcion que tome como parametro el id de un cliente
--		y retorne el nombre del pais del que procede dicho cliente.

-- 1.1.1	Ejecutando la funcion.

-- 1.1.2	Ejecutando la funcion en una consulta.





-- 1.2	Crear una funcion que calcule el sub total de los servicios extras adquiridos en una reserva.
--		Si la reserva no tiene servicios extras, la funcion retorna 0.0
-- Consulta
/*
SELECT * 
FROM RESERVA R
    LEFT JOIN EXTRA X 
        ON R.id = x.id_reserva
    LEFT JOIN SERVICIO S
        ON S.id = x.id_servicio
    WHERE R.id = 2;
*/



-- 1.3 	Crear una funcion que calcula el sub total de la habitacion utilizada en cada reserva
-- Consulta
/*
SELECT R.id, R.checkin, R.checkout, H.id, H.precio, DATEDIFF(DAY, R.checkin, R.checkout)
FROM RESERVA R 
    INNER JOIN HABITACION H 
        ON H.id = R.id_habitacion;
*/



-- 2.1.1	Calcular el total de cada reserva 
-- consulta realizada en la clase 15:
/*
SELECT R.id, R.checkin, R.checkout, HO.nombre 'Hotel', H.numero 'Habitacion', (H.precio*DATEDIFF(DAY,R.checkin, R.checkout)) 'subtotal reserva',
		ISNULL(SUM(S.precio),0) 'subtotal servicios', ((H.precio*DATEDIFF(DAY,R.checkin, R.checkout))+ISNULL(SUM(S.precio),0)) 'TOTAL'
FROM RESERVA R
	INNER JOIN HABITACION H
		ON H.id = R.id_habitacion
	INNER JOIN HOTEL HO 
		ON HO.id = H.id_hotel
	LEFT JOIN EXTRA X
		ON R.id = X.id_reserva
	LEFT JOIN SERVICIO S 
		ON S.id = X.id_servicio
GROUP BY R.id, R.checkin, R.checkout, HO.nombre, H.numero, H.precio;
*/
-- consulta utilizando funciones.


-- 1.3	Crear una funcion que calcule el total de una reserva
--		La funcion recibira como parametro el id de una reserva.


-- 1.4	Crear la funcion llamada, RESERVA_DETALLE. Debe mostrar el subtotal
--		obtenido de la multiplicaci�n del precio de la habitaci�n y el numero de dias reservados (A).
--		mostrar el total de la suma de los servicios extra incluidos (B).
--		y el total resultante de toda la reserva (A+B).


