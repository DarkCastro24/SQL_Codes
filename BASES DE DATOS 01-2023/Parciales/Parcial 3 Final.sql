/*
*	PARCIAL FINAL DE BASES DE DATOS CICLO 1/2023
*	ESTUDIANTE: DIEGO EDUARDO CASTRO QUINTANILLA 00117322
*	DOCENTE: ERICK VARELA
*/

CREATE DATABASE parcial3;
USE parcial3;

/*****			EJERCICIO 1			 *****/

CREATE OR ALTER FUNCTION subtotalCompra(@id_compra INT)
RETURNS MONEY
AS
BEGIN
	DECLARE @totalCompra MONEY;
	SELECT @totalCompra = SUM(TF.precio)
	FROM COMPRA C, ENTRADA E, FUNCION F, TIPO_FUNCION TF 
	WHERE C.id = E.id_compra AND F.id = E.id_funcion AND TF.id = F.id_tipo
	AND C.id = @id_compra
	GROUP BY C.id,C.fecha, C.descuento
	ORDER BY C.id ASC
	RETURN @totalCompra;
END;

-- Probando la funcion
SELECT dbo.subtotalCompra(15) 'Subtotal compra';

/*****			EJERCICIO 2			 *****/

-- Procedimiento almacenado
CREATE OR ALTER PROCEDURE imprimirFactura
@fecha VARCHAR(10)
as 
BEGIN 
	DECLARE @fecha_date DATE;
	SET @fecha_date = CONVERT(DATE, @fecha ,103);
	DECLARE @id_compra INT, @fecha_compra DATE, @encargado VARCHAR(32),@descuento MONEY, @subTotal MONEY; 
	DECLARE CURSOR_EJ4 CURSOR STATIC FOR 
	SELECT C.id 'id_compra', C.fecha 'fecha_compra', E.nombre 'nombre_empleado', C.descuento, isnull(dbo.subtotalCompra(C.id),0) 'subtotal_factura'
		FROM COMPRA C
			INNER JOIN EMPLEADO E
				ON E.id = C.id_empleado
		WHERE CAST(C.fecha AS DATE) = CONVERT(DATE, @fecha_date ,103);
	BEGIN TRY
			BEGIN TRANSACTION imprimirCompras
				OPEN CURSOR_EJ4;
				FETCH NEXT FROM CURSOR_EJ4  INTO @id_compra, @fecha_compra, @encargado, @descuento, @subTotal
				WHILE @@FETCH_STATUS = 0
				BEGIN
					SET @subTotal = @subTotal - @descuento;
					PRINT 'id compra: ' + CAST(@id_compra AS VARCHAR(4)) + ', fecha: ' + CAST(@fecha_compra AS VARCHAR(24)) + ', responsable: ' +CAST(@encargado AS VARCHAR(32)) + ' , subtotal función: ' + CAST(@subTotal AS VARCHAR(15)) ; 
					FETCH NEXT FROM CURSOR_EJ4 INTO @id_compra, @fecha_compra, @encargado, @descuento, @subTotal;
				END;
				CLOSE CURSOR_EJ4;
				DEALLOCATE CURSOR_EJ4;
			COMMIT TRANSACTION imprimirCompras
		END TRY
		BEGIN CATCH
			DECLARE @error_mensaje VARCHAR(100);
			SELECT @error_mensaje = ERROR_MESSAGE();
			PRINT @error_mensaje;
		END CATCH
END;

-- Probando el proceso almacenado
EXEC imprimirFactura '01/06/2023'


/*****			EJERCICIO 3			 *****/

-- TRIGGER: Verificar que la estacion del plato y la factura coincidan.
CREATE OR ALTER TRIGGER validarAsiento
ON ENTRADA
AFTER INSERT
AS BEGIN 
	DECLARE @id_asiento INT, @id_funcion INT;
	DECLARE @validarAsiento INT;
	SELECT @id_asiento = inserted.id_asiento FROM inserted;
	SELECT @id_funcion = inserted.id_funcion FROM inserted;
	SET @validarAsiento = (SELECT COUNT(e.id_asiento) FROM ENTRADA e WHERE id_funcion = @id_funcion and e.id_asiento = @id_asiento)	
	IF @validarAsiento != 1	
	BEGIN 
		RAISERROR ('ERROR: El asiento ya ha sido reservado por otra compra',11,1);
		ROLLBACK TRANSACTION;
	END
END;

INSERT INTO COMPRA VALUES (101, CONVERT(DATETIME, '04-06-2023 09:32:00.000', 103),0,10,3);

SELECT * FROM ENTRADA WHERE id_funcion = 2 ORDER BY id_asiento ASC

-- Este insert da error (ya esta reservado)
INSERT INTO ENTRADA VALUES (200,'AIUDA',2,5,101);

-- Este insert si se guarda (no esta reservado)
INSERT INTO ENTRADA VALUES (201,'AIUDA',2,6,101);

DELETE FROM ENTRADA WHERE id >= 200












