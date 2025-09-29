--****************************************************
-- Bases de datos: Transacciones y cursores
-- Autor: Erick Varela
-- Correspondencia: evarela@uca.edu.sv
-- Version: 1.0
--****************************************************

-- Sintaxis básica
/*
	CREATE OR ALTER PROCEDURE <nombre_del_procedimiento>
		param1 tipo_de_dato,
		param2 tipo_de_dato,
		param3 tipo_de_dato,
		...
	AS BEGIN

	END;
*/


-- IMPORTANTE:
-- Para poder realizar algunos ejercicion de esta clase es necesario actualizar la base 
-- de datos HotelManagementDB, por lo que se debe:
--		* Agregar la columna "puntos" de tipo INT a la tabla CLIENTE.
--		* Actualizar la columna recien creada con algunos datos.
ALTER TABLE CLIENTE ADD puntos INT;
SELECT * FROM CLIENTE;

UPDATE CLIENTE SET puntos = 2310 WHERE id=1;
UPDATE CLIENTE SET puntos = 4744 WHERE id=2;
UPDATE CLIENTE SET puntos = 3626 WHERE id=3;
UPDATE CLIENTE SET puntos = 2387 WHERE id=4;
UPDATE CLIENTE SET puntos = 1233 WHERE id=5;
UPDATE CLIENTE SET puntos = 4028 WHERE id=6;
UPDATE CLIENTE SET puntos = 3089 WHERE id=7;
UPDATE CLIENTE SET puntos = 4061 WHERE id=8;
UPDATE CLIENTE SET puntos = 4051 WHERE id=9;
UPDATE CLIENTE SET puntos = 1065 WHERE id=10;
UPDATE CLIENTE SET puntos = 1759 WHERE id=11;
UPDATE CLIENTE SET puntos = 2240 WHERE id=12;
UPDATE CLIENTE SET puntos = 4889 WHERE id=13;
UPDATE CLIENTE SET puntos = 2233 WHERE id=14;
UPDATE CLIENTE SET puntos = 2021 WHERE id=15;
UPDATE CLIENTE SET puntos = 2431 WHERE id=16;
UPDATE CLIENTE SET puntos = 2751 WHERE id=17;
UPDATE CLIENTE SET puntos = 2156 WHERE id=18;
UPDATE CLIENTE SET puntos = 4470 WHERE id=19;
UPDATE CLIENTE SET puntos = 1986 WHERE id=20;
UPDATE CLIENTE SET puntos = 3619 WHERE id=21;
UPDATE CLIENTE SET puntos = 3754 WHERE id=22;
UPDATE CLIENTE SET puntos = 3745 WHERE id=23;
UPDATE CLIENTE SET puntos = 4781 WHERE id=24;
UPDATE CLIENTE SET puntos = 3036 WHERE id=25;
UPDATE CLIENTE SET puntos = 4239 WHERE id=26;
UPDATE CLIENTE SET puntos = 3178 WHERE id=27;
UPDATE CLIENTE SET puntos = 3948 WHERE id=28;
UPDATE CLIENTE SET puntos = 1563 WHERE id=29;
UPDATE CLIENTE SET puntos = 4366 WHERE id=30;
UPDATE CLIENTE SET puntos = 3624 WHERE id=31;
UPDATE CLIENTE SET puntos = 3667 WHERE id=32;
UPDATE CLIENTE SET puntos = 4372 WHERE id=33;
UPDATE CLIENTE SET puntos = 3307 WHERE id=34;
UPDATE CLIENTE SET puntos = 4883 WHERE id=35;
UPDATE CLIENTE SET puntos = 2307 WHERE id=36;
UPDATE CLIENTE SET puntos = 4106 WHERE id=37;
UPDATE CLIENTE SET puntos = 3898 WHERE id=38;
UPDATE CLIENTE SET puntos = 4610 WHERE id=39;
UPDATE CLIENTE SET puntos = 3126 WHERE id=40;
UPDATE CLIENTE SET puntos = 2439 WHERE id=41;
UPDATE CLIENTE SET puntos = 1882 WHERE id=42;
UPDATE CLIENTE SET puntos = 2043 WHERE id=43;
UPDATE CLIENTE SET puntos = 3143 WHERE id=44;
UPDATE CLIENTE SET puntos = 1274 WHERE id=45;
UPDATE CLIENTE SET puntos = 4369 WHERE id=46;
UPDATE CLIENTE SET puntos = 2939 WHERE id=47;
UPDATE CLIENTE SET puntos = 4112 WHERE id=48;
UPDATE CLIENTE SET puntos = 3697 WHERE id=49;
UPDATE CLIENTE SET puntos = 2300 WHERE id=50;

SELECT * FROM CLIENTE;

--*****************************************************

-- 1.0 	Crear un procedimiento almacenado que permita registrar nuevas reservas
--		Como argumentos se reciben: el la fecha de checkin y checkout, 
--		el id de metodo de pago, 
--		el id del cliente y el id de la habitacion.
-- DROP PROCEDURE BOOKING;
CREATE OR ALTER PROCEDURE BOOKING
	@id_reserva INT,
	@checkin VARCHAR(32),
	@checkout VARCHAR(32),
	@id_metodo_pago INT,
	@id_cliente INT,
	@id_habitacion INT
AS BEGIN
	BEGIN TRY
		DECLARE @checkin_dt DATETIME;
		DECLARE @checkout_dt DATETIME;
		SELECT @checkin_dt = CONVERT(DATETIME,@checkin,103);
		SELECT @checkout_dt = CONVERT(DATETIME,@checkout,103);
		INSERT INTO RESERVA (id, checkin, checkout, id_metodo_pago, 
								id_cliente_reserva, id_habitacion)
			VALUES(@id_reserva,@checkin_dt, @checkout_dt,
								@id_metodo_pago,@id_cliente,@id_habitacion);
	END TRY
	BEGIN CATCH
		DECLARE @error VARCHAR(128);
		SELECT @error = ERROR_MESSAGE ( );
		PRINT @error;
	END CATCH
END;




SELECT * FROM RESERVA ORDER BY id DESC;
DELETE FROM RESERVA WHERE id > 200;

EXEC BOOKING 201, '13-06-2023 15:00:00', '14-06-2023 12:00:00', 1, 2, 24;

SP_HELPTEXT BOOKING;

-- Ejecutando procedimiento almacenado
-- DELETE FROM RESERVA WHERE id = 201 OR id = 202;
DELETE FROM RESERVA WHERE id > 200;


-- Procedimientos almacenados con tratamiento de tablas.
-- 1.2. Crear un procedimiento almacenado que reciba como parametros dos enteros
--		El objetivo es mostrar la ganancia de cada hotel y la suma total de la ganancia
--		Parametro 1: numero entero entre 1 y 12 que representa un mes
--		Parametro 2: numero entero que representa un año.

-- Obteniendo el total de cada reserva a partir de las funciones creadas en la clase 19
SELECT id, checkin, checkout, dbo.ST_HABITACION(id) + dbo.ST_SERVICIO(id) 'TOTAL'
FROM RESERVA


-- Complementando la consulta anterior
SELECT HO.id, HO.nombre, R.id, R.checkin, R.checkout, 
		dbo.ST_HABITACION(R.id) + dbo.ST_SERVICIO(R.id) 'TOTAL'
FROM RESERVA R
		INNER JOIN HABITACION H
			ON H.id = R.id_habitacion
		INNER JOIN HOTEL HO 
			ON HO.id = H.id_hotel
ORDER BY HO.id ASC;

-- Agregando filtros y sumando la ganancia
SELECT HO.id, HO.nombre,
		SUM(dbo.ST_HABITACION(R.id) + dbo.ST_SERVICIO(R.id)) 'TOTAL'
FROM RESERVA R
		INNER JOIN HABITACION H
			ON H.id = R.id_habitacion
		INNER JOIN HOTEL HO 
			ON HO.id = H.id_hotel
WHERE MONTH(R.checkin) = 5
		AND YEAR(R.checkin) = 2023
GROUP BY HO.id, HO.nombre
ORDER BY HO.id ASC;

-- Creando el procedimiento almacenado
CREATE OR ALTER PROCEDURE hoteles_ganancias 
	@MM INT,
	@YY INT
AS BEGIN
	DECLARE @id INT, @nombre VARCHAR(64), @total VARCHAR(16);
	DECLARE @ganancia MONEY = 0;
	DECLARE hotel_ganancia CURSOR FOR
		SELECT HO.id, HO.nombre,
				SUM(dbo.ST_HABITACION(R.id) + dbo.ST_SERVICIO(R.id)) 'TOTAL'
		FROM RESERVA R
				INNER JOIN HABITACION H
					ON H.id = R.id_habitacion
				INNER JOIN HOTEL HO 
					ON HO.id = H.id_hotel
		WHERE MONTH(R.checkin) = @MM
				AND YEAR(R.checkin) = @YY
		GROUP BY HO.id, HO.nombre
		ORDER BY HO.id ASC;

	OPEN hotel_ganancia;

	FETCH NEXT FROM hotel_ganancia INTO @id, @nombre, @total;

	WHILE @@FETCH_STATUS = 0 
	BEGIN
		PRINT 'hotel: '+@nombre+', ganancia del mes: $'+@total;
		SET @ganancia += CAST(@total AS money); --@ganancia = @ganancia + @total;
		FETCH NEXT FROM hotel_ganancia INTO @id, @nombre, @total;
	END;

	PRINT '----------------------------';
	PRINT 'GANANCIA TOTAL: $'+ CAST(@ganancia as VARCHAR(16));

	CLOSE hotel_ganancia;
	DEALLOCATE hotel_ganancia;
END;

EXEC hoteles_ganancias 5, 2023;
--*****************************************************
--	TRANSACCIONES

-- 2.0	Crear un procedimiento almacenado que permita transferir puntos de cliente frecuente entre
--		2 usuarios. Como parametros se deberan recibir el id del usuario emisor, el id del usuario
--		receptor, y la cantidad de puntos a transferir.
--		NOTA: En la primera version de este ejercicio provocar un error de semantica y observar el resultado

ALTER PROCEDURE TRANSFERIR_PUNTOS
	@id_emisor INT,
	@id_receptor INT,
	@puntos INT
AS BEGIN 
	-- Validando si el usuario tiene suficientes puntos
	DECLARE @puntos_emisor INT;
	SELECT @puntos_emisor = puntos 
	FROM CLIENTE WHERE id = @id_emisor;
	
	IF @puntos_emisor <= @puntos 
		PRINT 'ERROR: El usuario emisor no tiene suficientes puntos.';
	ELSE 
	BEGIN
		BEGIN TRY 
	
			BEGIN TRANSACTION TRANSFERIR_PUNTOS;

			-- Restando puntos al emisor
			UPDATE CLIENTE 
				SET puntos = puntos - @puntos
			WHERE id = @id_emisor;

			RAISERROR('Error provocado a proposito',11,1);
		
			-- Sumando puntos al receptor
			UPDATE CLIENTE 
				SET puntos = puntos + @puntos
			WHERE id = @id_receptor;

			COMMIT TRANSACTION TRANSFERIR_PUNTOS;
		END TRY  
		BEGIN CATCH 
			DECLARE @ERROR_MESSAGE VARCHAR(100);
			SELECT @ERROR_MESSAGE=ERROR_MESSAGE();
			PRINT 'ERROR: ' + @ERROR_MESSAGE;
			ROLLBACK TRANSACTION TRANSFERIR_PUNTOS;
		END CATCH  
	END;
END;


SELECT * FROM CLIENTE WHERE id = 1 OR id = 2;
EXEC TRANSFERIR_PUNTOS 1, 2, 1000;
SELECT * FROM CLIENTE WHERE id = 1 OR id = 2;

EXEC TRANSFERIR_PUNTOS 2, 1, 1000;

SELECT * FROM CLIENTE WHERE id = 1 OR id = 2;