--**************************************************************************
-- Bases de datos: instrucciones HAVING e INTO
-- Autor: Erick Varela
-- Correspondencia: evarela@uca.edu.sv
-- Version: 2.0
--**************************************************************************

--**************************************************************************
-- 1.	instruccion HAVING
--**************************************************************************
-- 1.1  Mostrar las habitaciones que hayan sido reservadas durante 
--		al menos 10 dias durante junio de 2023.

SELECT H.id, H.numero,
		SUM(DATEDIFF(DAY,R.checkin,R.checkout)) 'dias por reserva'
FROM HABITACION H, RESERVA R
WHERE H.id = R.id_habitacion
		AND MONTH(R.checkin) = 6
		AND YEAR (R.checkin) = 2023
GROUP BY H.id, H.numero
HAVING SUM(DATEDIFF(DAY,R.checkin,R.checkout)) >= 10
ORDER BY H.id ASC;



-- 1.2  Mostrar la lista de clientes 'VIP'
--		Un cliente adquiere el estado VIP si tiene al menos 
--		una estancia con valor igual o mayor a $999.99
-- Partiendo de la consulta que construimos en la clase 15:
/*
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
*/


SELECT C.id, C.nombre, 
		H.precio * DATEDIFF (DAY,R.checkin,R.checkout) + 
		ISNULL(SUM(S.precio),0)*DATEDIFF (DAY,R.checkin,R.checkout) 'TOTAL'
FROM HABITACION H
	INNER JOIN RESERVA R
		ON H.id = R.id_habitacion
	INNER JOIN CLIENTE C
		ON C.id = R.id_cliente_reserva
	LEFT JOIN EXTRA X 
		ON R.id = X.id_reserva
	LEFT JOIN SERVICIO S
		ON S.id = X.id_servicio
GROUP BY R.id, R.checkin, R.checkout, H.precio, C.id, C.nombre, 
		DATEDIFF (DAY,R.checkin,R.checkout),
			H.precio * DATEDIFF (DAY,R.checkin,R.checkout)
HAVING H.precio * DATEDIFF (DAY,R.checkin,R.checkout) + 
					ISNULL(SUM(S.precio),0)*DATEDIFF (DAY,R.checkin,R.checkout) > 999.99;


-- 1.3	Mostrar la categoria de habitacion de cada hotel que haya obtenido 
--		una ganancia mayor a $2000, 
--		tomar en cuenta solo el "subtotal habitacion" para realizar esta calculo
SELECT HO.id, HO.nombre 'hotel', TH.tipo, 
		SUM(DATEDIFF(DAY,R.checkin,R.checkout) * H.precio) 'subtotal habitacion'
FROM HOTEL HO, HABITACION H, TIPO_HABITACION TH, RESERVA R
WHERE HO.id = H.id_hotel
		AND TH.id = H.id_tipo_habitacion
		AND H.id = R.id_habitacion
GROUP BY HO.id, HO.nombre, TH.tipo
HAVING SUM(DATEDIFF(DAY,R.checkin,R.checkout) * H.precio)  > 2000
ORDER BY HO.id ASC;



-- *****************************************************
-- 2.	instruccion INTO
-- *****************************************************
-- 2.1	A partir del ejercicio extra visto en la clase 15, 
--		almacenar el resultado en una nueva tabla con la 
--		instrucción INTO

SELECT R.id, R.checkin, R.checkout, H.precio,
		DATEDIFF (DAY,R.checkin,R.checkout) 'dias reservados',
			H.precio * DATEDIFF (DAY,R.checkin,R.checkout) 'subtotal habitacion',
				ISNULL(SUM(S.precio),0)*DATEDIFF (DAY,R.checkin,R.checkout) 'subtotal servicio',
					H.precio * DATEDIFF (DAY,R.checkin,R.checkout) + 
					ISNULL(SUM(S.precio),0)*DATEDIFF (DAY,R.checkin,R.checkout) 'TOTAL'
INTO MAYOJUNIO23
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


SELECT * FROM GANANCIAS;



-- 2.2	Volver a ejecutar la consulta anterior y verificar el resultado.
-- 2.3	visualizar el diagrama relacional generado por SQL Server 
