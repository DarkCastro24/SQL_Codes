--****************************************************
-- Bases de datos: Introduccion a T-SQL
-- Autor: Erick Varela
-- Correspondencia: evarela@uca.edu.sv
-- Version: 1.0
--****************************************************

-- *****************************************************
-- 1.	Transact-SQL
-- *****************************************************
--1.0	declarando variables T-SQL
DECLARE @variable VARCHAR(50);
SET @variable = 'Bases de datos';
-- Imprimiendo variables.
PRINT @variable;

-- Concatenando cadenas de texto:
PRINT CONCAT(@variable,' 2023');
PRINT @variable + ' 2023';
--PRINT @variable + ' ' + 2023; --falla
PRINT @variable + ' ' + CONVERT(CHAR(4),2023);

-- Actualizando variable
SET @variable = @variable + ' 2023';
PRINT @variable;
PRINT CONCAT(@variable,' 2023');

-- Condicion básica
DECLARE @numero INT;
SET @numero = 16;
IF (@numero%2=0)
	PRINT 'El numero es par';
ELSE
	PRINT 'El numero es impar';

DECLARE @numero INT;
SET @numero = 16;
IF (@numero%2=0)
BEGIN
	PRINT 'El numero es par';
	PRINT 'El numero es par';
END
ELSE
BEGIN
	PRINT 'El numero es impar';
END;

-- Condicion que utiliza consultas como argumento
;
IF ((SELECT COUNT(id) FROM CLIENTE) >= 40)
	PRINT 'En la base de datos existen  mas de 40 cliente';

DECLARE @cantidad_clientes INT;
SELECT  @cantidad_clientes = COUNT(id) FROM CLIENTE;

IF (@cantidad_clientes >= 40)
	PRINT 'En la base de datos existen  mas de 40 cliente';

-- bucles
DECLARE @contador INT;
SET @contador = 5;

WHILE @contador >= 0
BEGIN
	PRINT @contador;
	SET @contador = @contador - 1;
END;

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

DECLARE @mes INT, @dias_objetivo INT;
SET @mes = 6;
SET @dias_objetivo = 10;

SELECT H.id 'id habitacion', H.numero, SUM(DATEDIFF (DAY, R.checkin, R.checkout)) 'dias en reserva'
FROM RESERVA R, HABITACION H
WHERE R.id_habitacion = H.id
	AND MONTH(R.checkin) = @mes
GROUP BY H.id, H.numero
HAVING SUM(DATEDIFF (DAY, R.checkin, R.checkout)) >= @dias_objetivo
ORDER BY H.id ASC;

-- 2.0	¿cuantos clientes hay por cada pais?
-- Consulta original:
/*SELECT p.pais, COUNT(c.nombre) as 'cantidad de clientes'
FROM pais p LEFT JOIN cliente c
ON p.id = c.id_pais
GROUP BY  p.pais
ORDER BY COUNT(c.nombre) DESC;*/

--Utilizando CASE para dar formato a la salida de una consulta.
SELECT p.pais, COUNT(c.nombre) as 'cantidad de clientes',
		CASE COUNT(c.nombre)
			WHEN 0 THEN 
				'Ningún cliente'
			WHEN 1 THEN 
				'1 Cliente'
			ELSE 
				CONCAT(COUNT(c.nombre), ' Clientes')
		END 'cantidad de clientes'
FROM pais p LEFT JOIN cliente c
ON p.id = c.id_pais
GROUP BY  p.pais
ORDER BY COUNT(c.nombre) DESC;

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

DECLARE @cantidad_clientes INT;
SELECT @cantidad_clientes = COUNT(*) FROM CLIENTE;

SELECT P.id, P.pais, CONCAT((CAST(COUNT(C.nombre) AS FLOAT)/@cantidad_clientes)*100,'%') 'cantidad de clientes'
FROM PAIS P 
	LEFT JOIN CLIENTE C
ON P.id = C.id_pais
GROUP BY P.id, P.pais
ORDER BY COUNT(C.nombre) DESC;


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


DECLARE @cliente_reserva TABLE(
	id INT,
	nombre VARCHAR(50),
	total_reserva MONEY
);
DECLARE @meta_vip MONEY;
SET @meta_vip = 550.0;

INSERT INTO @cliente_reserva (id, nombre, total_reserva)
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
				H.precio * DATEDIFF (DAY,R.checkin,R.checkout);

SELECT id, nombre, AVG(total_reserva)
FROM @cliente_reserva
GROUP BY id, nombre
HAVING AVG(total_reserva) >= @meta_vip
ORDER BY id ASC;