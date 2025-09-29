-- PROCEDIMIENTO ALMACENADO CON CONSULTA
CREATE OR ALTER PROCEDURE FacturasPorCliente
    @ClienteID INT
AS
BEGIN
    SELECT FacturaID, FechaFactura, Monto
    FROM Factura
    WHERE ClienteID = @ClienteID
    ORDER BY FechaFactura DESC;
END;

-- Uso:
EXEC FacturasPorCliente 7;
GO;

-- PROCEDIMIENTO ALMACENADO PARA INSERTAR DATOS 
CREATE OR ALTER PROCEDURE AgregarCliente
    @Nombre NVARCHAR(50),
    @Apellido NVARCHAR(50),
    @Email NVARCHAR(100),
    @Telefono NVARCHAR(20)
AS
BEGIN
    DECLARE @ID INT = (SELECT ISNULL(MAX(ClienteID), 0) + 1 FROM Cliente);
    INSERT INTO Cliente (ClienteID, Nombre, Apellido, Email, Telefono)
    VALUES (@ID, @Nombre, @Apellido, @Email, @Telefono);
END;

EXEC AgregarCliente 'Diego', 'Castro', 'diego_castro@gmail.com', '77012345';

-- Comprobar que se inserto el cliente 
SELECT * FROM Cliente;
DELETE FROM Cliente where ClienteID = 151;
GO;

-- PROCEDIMIENTO ALMACENADO CON CURSOR
CREATE OR ALTER PROCEDURE ImprimrProductosCategoria
    @CategoriaID INT
AS
BEGIN
    SET ANSI_WARNINGS OFF;

    DECLARE @contador INT;
    DECLARE @ProductoID INT; 
	DECLARE @Nombre NVARCHAR(100);
    DECLARE @Precio DECIMAL(10,2);
    DECLARE @total DECIMAL(12,2) = 0;

    DECLARE cursor_productos CURSOR FOR
        SELECT ProductoID, Nombre, PrecioUnitario
        FROM Producto
        WHERE CategoriaID = @CategoriaID
        ORDER BY ProductoID ASC;

    SELECT @contador = COUNT(*)
    FROM Producto
    WHERE CategoriaID = @CategoriaID;

    IF @contador = 0
    BEGIN
        PRINT 'No hay productos para la categoría ' + CAST(@CategoriaID AS VARCHAR(10));
        RETURN;
    END

    OPEN cursor_productos;

    WHILE @contador > 0
    BEGIN
        FETCH NEXT FROM cursor_productos INTO @ProductoID, @Nombre, @Precio;
        PRINT('Producto ID: ' + CAST(@ProductoID AS VARCHAR(10)) + ' - Nombre: ' + @Nombre + ' -> Precio: $' + CAST(@Precio AS VARCHAR(12)));
        SET @total = @total + @Precio;
        SET @contador = @contador - 1;
    END

    PRINT('------------------------');
    PRINT('TOTAL SUMA PRECIOS: $' + CAST(@total AS VARCHAR(12)));

    CLOSE cursor_productos;
    DEALLOCATE cursor_productos;
END;

-- Ejemplo de ejecución:
EXEC ImprimrProductosCategoria 2;
GO;

-- FUNCIONES 
CREATE OR ALTER FUNCTION dbo.CalcularIVA(@Precio MONEY)
RETURNS MONEY
AS
BEGIN
    RETURN ROUND(@Precio * 1.13, 2);
END;

-- Ejemplo de ejecucion de consulta con funcion CalcularIVA
SELECT Nombre, PrecioUnitario, dbo.CalcularIVA(PrecioUnitario) AS 'Precio+Iva'
FROM Producto;
GO;

CREATE OR ALTER FUNCTION dbo.NombreCategoria (@CategoriaID INT)
RETURNS NVARCHAR(50)
AS
BEGIN
    DECLARE @Nombre NVARCHAR(50);
    SELECT @Nombre = Nombre
    FROM   Categoria
    WHERE  CategoriaID = @CategoriaID;
    RETURN ISNULL(@Nombre, 'Categoría no encontrada');
END;

select dbo.NombreCategoria(2) as 'Nombre Categoria';
GO;

-- 2- Ejemplo de funcion tabla 
CREATE OR ALTER FUNCTION dbo.ProductosPorCategoria(@CategoriaID INT)
RETURNS TABLE
AS
RETURN
(
    SELECT ProductoID, Nombre, PrecioUnitario
    FROM Producto
    WHERE CategoriaID = @CategoriaID
);

-- Ejemplo de ejecucion 
SELECT * FROM dbo.ProductosPorCategoria(2);

SELECT Nombre, PrecioUnitario 
FROM dbo.ProductosPorCategoria(2);