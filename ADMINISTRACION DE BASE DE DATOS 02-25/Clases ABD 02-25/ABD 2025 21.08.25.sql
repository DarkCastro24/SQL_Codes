
-- Clase 21/08/2025

CREATE OR ALTER FUNCTION dbo.VerificarHotel 
(
	@id_hotel INT
)
RETURNS VARCHAR(100) 
AS
BEGIN 
	DECLARE @nombre_hotel VARCHAR (20);
	DECLARE @mensaje VARCHAR (100);
	
	SELECT @nombre_hotel = nombre
	FROM hotel WHERE id_hotel = @id_hotel 

	IF (@nombre_hotel IS NOT NULL)
    BEGIN
        SET @mensaje = 'El nombre del hotel ' + @nombre_hotel;
    END
	ELSE 
	BEGIN 
		SET @mensaje = 'No existe un hotel con el id ' + CAST(@id_hotel AS VARCHAR(4));
	END

    RETURN @mensaje; 
END 

-- Existe
SELECT dbo.VerificarHotel(1) as nombre_hotel  
-- No existe 
SELECT dbo.VerificarHotel(1001) as nombre_hotel 

-- Verificar si un hotel tiene telefono registrado
CREATE OR ALTER FUNCTION dbo.si 
(
	@id_hotel INT
)
RETURNS VARCHAR(100) 
AS
BEGIN 
	DECLARE @telefono_hotel VARCHAR (20);
	
	SELECT @telefono_hotel = telefono
	FROM hotel WHERE id_hotel = @id_hotel 

	IF (@telefono_hotel = 'No tiene')
    BEGIN
        RETURN 'El hotel no tiene telefonos registrados';
    END
		RETURN 'El hotel si tiene un telefono registrado: ' + @telefono_hotel;
END 

-- Ningun hotel tiene telefonos registrados 
SELECT dbo.si(1001)

-- Para pruebas
UPDATE HOTEL set telefono = 'No tiene' where id_hotel = 1001
UPDATE HOTEL set telefono = '2257-7777' where id_hotel = 1001

-- Verificar el precio maximo de la habitaciones de un hotel y si es mayor a 200 descontarle el 10%
CREATE OR ALTER FUNCTION dbo.max_habitacion 
(
	@nombre_hotel VARCHAR(30)
)
RETURNS MONEY  
AS
BEGIN 
	DECLARE @precio_max MONEY;
	
	SELECT @precio_max = MAX(precio)  
	FROM habitacion ha
	INNER JOIN hotel h ON h.id_hotel = ha.id_hotel
	WHERE h.nombre = @nombre_hotel

	IF (@precio_max > 200)
    BEGIN
        RETURN @precio_max * 0.90;
    END
		RETURN @precio_max;
END

-- Hotel sin descuento 
SELECT dbo.max_habitacion('Barcelo')

-- Hotel con descuento 
SELECT dbo.max_habitacion('Vista Bella')

SELECT * 
FROM hotel
INNER JOIN habitacion ha ON ha.id_hotel = hotel.id_hotel

