--****************************************************
-- Bases de datos: Introduccion a T-SQL
-- Autor: Erick Varela
-- Correspondencia: evarela@uca.edu.sv
-- Version: 1.0
--****************************************************

-- *****************************************************
-- 1.	T-SQL
-- *****************************************************
--1.0	declarando variables T-SQL

-- Imprimiendo variables.

-- Concatenando cadenas de texto:

-- 1.1	Concantenando numeros

-- Condicion básica

-- Condicion que utiliza consultas como argumento

-- bucles


-- Integrando T-SQL con SQL
-- 1.2  Mostrar las habitaciones que hayan sido reservadas durante al menos 10 dias 
--		durante junio de 2023.
-- Consulta original:
/*SELECT H.id 'id habitacion', H.numero, SUM(DATEDIFF (DAY, R.checkin, R.checkout)) 'dias en reserva'
FROM RESERVA R, HABITACION H
WHERE R.id_habitacion = H.id
	AND MONTH(R.checkin) = 6
GROUP BY H.id, H.numero
HAVING SUM(DATEDIFF (DAY, R.checkin, R.checkout)) >= 10
ORDER BY H.id ASC;*/



-- 2.0	¿cuantos clientes hay por cada pais?
-- Consulta original:
/*SELECT p.pais, COUNT(c.nombre) as 'cantidad de clientes'
FROM pais p LEFT JOIN cliente c
ON p.id = c.id_pais
GROUP BY  p.pais
ORDER BY COUNT(c.nombre) DESC;*/

--Utilizando CASE para dar formato a la salida de una consulta.


-- 3.0	Eliminando sub-consultas al utilizar T-SQL
-- 3.1	¿Cual es el porcentaje de clientes que vienen de cada pais?
-- partiendo de esta subconsulta:
/*
SELECT P.id, P.pais, CONCAT((CAST(COUNT(C.nombre) AS FLOAT)/(SELECT COUNT(*) FROM CLIENTE))*100,'%') 'cantidad de clientes'
FROM PAIS P 
	LEFT JOIN CLIENTE C
ON P.id = C.id_pais
GROUP BY P.id, P.pais
ORDER BY COUNT(C.nombre) DESC;*/


-- 3.2  Mostrar la lista de clientes 'VIP'
-- partiendo de esta subconsulta:
/*
SELECT CLIENTE_TOTAL_RESERVA.id, CLIENTE_TOTAL_RESERVA.nombre, ROUND(AVG(CLIENTE_TOTAL_RESERVA.Reserva),2) 'promedio'
FROM (
	SELECT C.id, C.nombre, 
			H.precio * DATEDIFF (DAY,R.checkin,R.checkout) + 
			ISNULL(SUM(S.precio),0)*DATEDIFF (DAY,R.checkin,R.checkout) 'Reserva'
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
) CLIENTE_TOTAL_RESERVA
GROUP BY CLIENTE_TOTAL_RESERVA.id, CLIENTE_TOTAL_RESERVA.nombre
HAVING AVG(CLIENTE_TOTAL_RESERVA.Reserva) >= 550.00
ORDER BY CLIENTE_TOTAL_RESERVA.id ASC;
*/
