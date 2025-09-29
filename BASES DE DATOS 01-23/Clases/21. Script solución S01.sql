--****************************************************
-- Bases de datos: Triggers
-- Autor: Erick Varela
-- Correspondencia: evarela@uca.edu.sv
-- Version: 1.0
--****************************************************

-- Sintaxis básica de un trigger
/*
	CREATE OR ALTER TRIGGER trigger_name
	ON TABLA
	[BEFORE|AFTER] [INSERT|DELETE|UPDATE]
	AS BEGIN
		-- Cuerpo del trigger
	END;
*/

/*
 0. Ejecutando trigger básico
*/
CREATE OR ALTER TRIGGER t_hotel
ON HOTEL
AFTER INSERT
AS BEGIN
	PRINT 'Se insertado un nuevo registro en la tabla hotel';
END;
SELECT * FROM HOTEL;
INSERT INTO HOTEL VALUES (16, 'hotel', 'direccion', '+5037777777',1,1,3);
DELETE FROM HOTEL WHERE id = 16;

/* 1. Crear un trigger que permita verificar que cada vez
que se incluya una reserva, se evalue el estado VIP
del cliente que ha reservado. Puede suceder alguno de los
siguientes casos:
	- Clientes regulares:
		- Que el cliente mantega el estado de cliente regular
		- Que el cliente obtenga el estado VIP
	- Clientes VIP:
		- Que el cliente mantenga su estado VIP
		- Que el cliente pierda su estado VIP

Utilizar como base la siguiente consulta:
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
-- Validando la situación con el cliente 5
SELECT * FROM CLIENTE WHERE id = 5;
SELECT * FROM RESERVA;
INSERT INTO RESERVA VALUES (201, CONVERT(DATETIME, '05-05-2023 15:00:00',103),
				CONVERT(DATETIME,'06-05-2023 12:00:00' ,103),1,5, 13);
-- ¿el cliente 5 perdio su estado VIP?
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
-- El cliente 5 pierde su estado VIP pero al verificar la informacion en la tabla cliente
SELECT * FROM CLIENTE WHERE id = 5;

-- Creando trigger que vuelva automática la actualizacion del estado VIP de los clientes
-- Paso 1: creando funcion para calcular si un cliente es VIP de forma dinamica
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
WHERE CLIENTE_TOTAL_RESERVA.id = 3
GROUP BY CLIENTE_TOTAL_RESERVA.id, CLIENTE_TOTAL_RESERVA.nombre
HAVING AVG(CLIENTE_TOTAL_RESERVA.Reserva) >= 550.00
ORDER BY CLIENTE_TOTAL_RESERVA.id ASC;


CREATE OR ALTER FUNCTION is_vip(@id_cliente INT)
RETURNS BIT
AS BEGIN
	DECLARE @vip BIT;
	SELECT @vip = CASE 
		WHEN EXISTS(
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
			WHERE CLIENTE_TOTAL_RESERVA.id = @id_cliente
			GROUP BY CLIENTE_TOTAL_RESERVA.id, CLIENTE_TOTAL_RESERVA.nombre
			HAVING AVG(CLIENTE_TOTAL_RESERVA.Reserva) >= 550.00
		) THEN
			1
		ELSE
			0
		END;
	RETURN @vip;
END;

SELECT dbo.is_vip(3);

-- Paso 2: construyendo el trigger

CREATE OR ALTER TRIGGER check_vip
	ON RESERVA
	AFTER INSERT
	AS BEGIN
		DECLARE @is_vip BIT;
		DECLARE @id_cliente INT;

		SELECT @id_cliente = id_cliente_reserva FROM inserted;
		
		SET @is_vip = dbo.is_vip(@id_cliente);

		IF @is_vip = 1
		BEGIN
			UPDATE CLIENTE SET vip = 1 WHERE id = @id_cliente;
		END
		ELSE
		BEGIN
			UPDATE CLIENTE SET vip = 0 WHERE id = @id_cliente;
		END;
	END;

CREATE OR ALTER TRIGGER check_vip_del
	ON RESERVA
	AFTER DELETE
	AS BEGIN
		DECLARE @is_vip BIT;
		DECLARE @id_cliente INT;

		SELECT @id_cliente = id_cliente_reserva FROM deleted;
		
		SET @is_vip = dbo.is_vip(@id_cliente);

		IF @is_vip = 1
		BEGIN
			UPDATE CLIENTE SET vip = 1 WHERE id = @id_cliente;
		END
		ELSE
		BEGIN
			UPDATE CLIENTE SET vip = 0 WHERE id = @id_cliente;
		END;
	END;
-- Realizando pruebas
DELETE FROM RESERVA WHERE id > 200;

INSERT INTO RESERVA VALUES (201, CONVERT(DATETIME, '05-05-2023 15:00:00',103),
				CONVERT(DATETIME,'06-05-2023 12:00:00' ,103),1,5, 13);
SELECT * FROM CLIENTE;

DELETE FROM RESERVA WHERE id > 200;

DROP TRIGGER check_vip_del;
DROP TRIGGER check_vip;

-- 2.	Crear un procedimiento almacenado que permita registrar nuevas reservas
--		Como argumentos se reciben: el la fecha de checkin y checkout, el id del cliente
--		y el id de la habitacion.
--		NOTA: Validar que la nueva reserva no se solape con otras reservas

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



SELECT * FROM RESERVA WHERE id_habitacion = 24;
EXEC BOOKING 201,'19-05-2023 15:00:00','22-05-2023 12:00:00',1,5,24;

-- Verificando si la reserva 201 se esta traslapando con otra reserva de la base de datos
DECLARE @checkin DATETIME;
DECLARE @checkout DATETIME;
SELECT @checkin = checkin, @checkout = checkout FROM RESERVA WHERE id = 69;
SELECT COUNT(*) FROM RESERVA
WHERE 
((@checkin < checkin AND (@checkout BETWEEN checkin AND checkout)) OR
((@checkin BETWEEN checkin AND checkout) AND @checkout > checkout) OR
(@checkin >= checkin AND @checkout <= checkout) OR
(@checkin <= checkin AND @checkout >= checkout)) AND id_habitacion = 24;

CREATE OR ALTER TRIGGER check_booking
	ON RESERVA
	AFTER INSERT
	AS BEGIN
		DECLARE @result INT;
		DECLARE @checkin DATETIME;
		DECLARE @checkout DATETIME;
		DECLARE @id_hab INT;
		SELECT @checkin = checkin, @checkout = checkout, @id_hab = id_habitacion FROM inserted;
		
		SELECT @result = COUNT(*) FROM RESERVA
		WHERE 
		((@checkin < checkin AND (@checkout BETWEEN checkin AND checkout)) OR
		((@checkin BETWEEN checkin AND checkout) AND @checkout > checkout) OR
		(@checkin >= checkin AND @checkout <= checkout) OR
		(@checkin <= checkin AND @checkout >= checkout)) AND id_habitacion = 24;

		IF @result > 1 
		BEGIN
			RAISERROR ('La reserva no es válida, revise las fechas de reserva',11,1);
			ROLLBACK TRANSACTION;
		END 
	END;

DELETE FROM RESERVA WHERE id > 200;
EXEC BOOKING 201,'19-05-2023 15:00:00','22-05-2023 12:00:00',1,5,24;
SELECT * FROM RESERVA;

SELECT * FROM RESERVA WHERE id_habitacion = 23;
EXEC BOOKING 201,'19-05-2023 15:00:00','22-05-2023 12:00:00',1,5,23;

-- Ejecutando procedimiento almacenado
SELECT * FROM CLIENTE;

-- 1.2.	Crear una tabla llamada "REGISTRO_PUNTOS_S#", el objetivo de esta tabla será funcionar
--		como registro de los intercambios de puntos de cliente frecuente que realizan los
--		clientes. La tabla debe almacenar: la fecha y hora de la transaccion, el id y nombre del
--		usuario involucrado, la cantidad de puntos antes y despues de la transacción y una 
--		descriptión breve del proceso realizado.

DROP TABLE REGISTRO_PUNTOS;
CREATE TABLE REGISTRO_PUNTOS(
	id INT PRIMARY KEY IDENTITY,
	fecha DATETIME,
	id_cliente INT,
	nombre_cliente VARCHAR(50),
	puntos_ini INT,
	puntos_fin INT,
	descripcion VARCHAR(100)
);

CREATE OR ALTER PROCEDURE TRANSFERIR_PUNTOS
    @id_emisor INT,
    @id_receptor INT,
    @puntos INT
AS BEGIN
    -- Validando si los puntos del cliente emisor son suficiente para realizar la transfencia
    DECLARE @puntos_cliente_emisor INT;
    SELECT @puntos_cliente_emisor = puntos FROM CLIENTE WHERE id = @id_emisor;
    IF @puntos_cliente_emisor < @puntos 
        BEGIN
            PRINT 'ERROR: El cliente no tiene suficientes puntos para ser transferidos :(';
        END
    ELSE   
        BEGIN
            BEGIN TRY 
                BEGIN TRANSACTION TRANSFERENCIA_DE_PUNTOS
                -- Restando puntos al emisor
                UPDATE CLIENTE SET puntos = puntos - @puntos 
                    WHERE id = @id_emisor;
                -- Sumando puntos al receptor
                UPDATE CLIENTE SET puntos = puntos + @puntos 
                    WHERE id = @id_receptor;
                COMMIT TRANSACTION TRANSFERENCIA_DE_PUNTOS
            END TRY
            BEGIN CATCH
                DECLARE @ERROR_MESSAGE VARCHAR(100);
                SELECT @ERROR_MESSAGE = ERROR_MESSAGE();
                PRINT 'ERROR OCURRIDO: '+ @ERROR_MESSAGE;
                ROLLBACK TRANSACTION TRANSFERENCIA_DE_PUNTOS
            END CATCH; 
        END; 
END;


CREATE OR ALTER TRIGGER CHECK_POINTS
ON CLIENTE
AFTER UPDATE
AS BEGIN
	-- Seccion de declaracion de variables
	DECLARE @fecha DATETIME;
	DECLARE @id_cliente INT;
	DECLARE @nombre_cliente VARCHAR(50);
	DECLARE @puntos_ini INT;
	DECLARE @puntos_fin INT;
	DECLARE @descripcion VARCHAR (100);
	-- Sección de procesamiento de datos
	-- obteniendo fecha
	SELECT @fecha = GETDATE();
	SELECT @id_cliente = id, @nombre_cliente = nombre, @puntos_fin = puntos 
			FROM INSERTED;
	SELECT @puntos_ini = puntos FROM DELETED;
	
	
	
	IF @puntos_ini > @puntos_fin 
		SET @descripcion = 'Cliente ha gastado o regalado puntos';
	ELSE
		SET @descripcion = 'Cliente ha recibido puntos';



	INSERT INTO REGISTRO_PUNTOS (fecha, id_cliente, nombre_cliente, puntos_ini, puntos_fin, descripcion)
		VALUES(@fecha, @id_cliente, @nombre_cliente, @puntos_ini, @puntos_fin, @descripcion);
END;

-- Verificando datos
SELECT * FROM CLIENTE WHERE id = 1 OR id = 2;
EXEC TRANSFERIR_PUNTOS 1, 2, 1000;
-- Verificando contenido de la tabla REGISTRO_PUNTOS
SELECT * FROM REGISTRO_PUNTOS;


