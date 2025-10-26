-- Administracion de bases de datos						Fecha: 16/10/2025  
-- Secuencias y direccionamientos

-- No es parte del parcial pero si del proyecto de catedra 

/*
	Una secuencia es un objeto que genera numeros en serie deacuerdo a las reglas definidias
	Donde se pueden ocupar? En las facturas o documentos 
	NO ES IDENTITY a diferencia de eso la secuencia es independiente y se puede usar en multiples
	tablas o procedimientos
	Donde se puede aplicar? En una tabla de facturacion, se le asigna un numero de miembro?
*/

CREATE DATABASE secuencia;
USE secuencia;

-- CASO 1 
-- Crear una secuencia llamada factura 
CREATE SEQUENCE dbo.seq_factura​
    AS INT ​
    START WITH 1000​
    INCREMENT BY 1 ​
    NO CYCLE ​
    CACHE 50;​
GO

-- 2 Tabla que usa la secuencia en DEFAULT​ 
-- La PK se genera mediante la secuencia sql_factura 
CREATE TABLE dbo.Factura (​
	IdFactura INT NOT NULL ​
	CONSTRAINT DF_Factura_Id DEFAULT (NEXT VALUE FOR dbo.seq_factura),​ 
    Fecha DATE NOT NULL DEFAULT (CAST(GETDATE() AS DATE)),​
    ClienteId INT NOT NULL,​
    Total DECIMAL(12,2) NOT NULL,​
    CONSTRAINT PK_Factura PRIMARY KEY (IdFactura)​
);​
GO

-- 3) Insertar registros sin especificar IdFactura​
INSERT INTO dbo.Factura (ClienteId, Total) ​
VALUES (101, 250.75), (102, 99.99), (103, 1500.00);​
GO​​

-- 4) Consular la tabla​
SELECT * FROM dbo.Factura ORDER BY IdFactura;

-- CASO 2 
-- Crear secuencia​ para el cliente
CREATE SEQUENCE dbo.seq_cliente​
    AS INT​
    START WITH 1​
    INCREMENT BY 1​
    NO CYCLE​
    CACHE 100;​
GO

-- 2) Creación de tabla  Cliente​
CREATE TABLE dbo.Cliente (​
    IdCliente INT NOT NULL ​CONSTRAINT DF_Cliente_Id DEFAULT (NEXT VALUE FOR dbo.seq_cliente),​
    Nombre NVARCHAR(80) NOT NULL,​
    CodigoCliente AS ('CLI-' + RIGHT(REPLICATE('0',4) + CAST(IdCliente AS VARCHAR(10)), 4)) PERSISTED,​
    CONSTRAINT PK_Cliente PRIMARY KEY (IdCliente)​
);
GO

-- 3) Insertar registros de ejemplo​
INSERT INTO dbo.Cliente (Nombre) ​
VALUES (N'Ana Torres'), (N'Carlos Mejía'), (N'Laura Jiménez');​
GO​
​
-- 4) Verificar​
SELECT IdCliente, CodigoCliente, Nombre​
FROM dbo.Cliente​
ORDER BY IdCliente;

-- CASO 3 
-- Crear secuencia​
CREATE SEQUENCE dbo.seq_documento
    AS INT ​
    START WITH 1000​
    INCREMENT BY 1 ​
    NO CYCLE ​
    CACHE 50;​
GO

-- 2) Tablas que comparten el correlativo​
CREATE TABLE dbo.FacturaDoc (​
    IdDocumento INT NOT NULL ​
        CONSTRAINT DF_FacturaDoc_Id DEFAULT (NEXT VALUE FOR dbo.seq_documento),​
    Fecha DATE NOT NULL DEFAULT (CAST(GETDATE() AS DATE)),​
    ClienteId INT NOT NULL,​
    Total DECIMAL(12,2) NOT NULL,​
    CONSTRAINT PK_FacturaDoc PRIMARY KEY (IdDocumento)​
);

-- 2) Tablas que comparten el correlativo​
CREATE TABLE dbo.NotaCredito (​
    IdDocumento INT NOT NULL ​
        CONSTRAINT DF_NotaCredito_Id DEFAULT (NEXT VALUE FOR dbo.seq_documento),​
    Fecha DATE NOT NULL DEFAULT (CAST(GETDATE() AS DATE)),​
    FacturaOrigen INT, ​
    Motivo NVARCHAR(200) NOT NULL,​
    Monto DECIMAL(12,2) NOT NULL,​
    CONSTRAINT PK_NotaCredito PRIMARY KEY (IdDocumento)​
);

-- 3) Registros de ejemplo: primero facturas, luego nota de crédito​
INSERT INTO dbo.FacturaDoc (ClienteId, Total) ​VALUES (201, 120.00), (202, 450.00);​
INSERT INTO dbo.NotaCredito (FacturaOrigen, Motivo, Monto) VALUES (5000, N'Descuento aplicado', 20.00);​
INSERT INTO dbo.FacturaDoc (ClienteId, Total) ​VALUES (203, 999.99);​
GO

-- 4) Verificar correlativo único compartido​
SELECT 'Factura' AS Tipo, IdDocumento, Fecha, Total AS Monto, NULL AS Motivo​
FROM dbo.FacturaDoc​
UNION ALL​
SELECT 'NotaCredito', IdDocumento, Fecha, Monto, Motivo​
FROM dbo.NotaCredito​
ORDER BY IdDocumento;

-- DIMENSIONAR EL ESPACIO 

/*
	Consiste en calcular el tamaño que ocupan todos los elementos dentro de la base de datos 
	Se calcula con la siguiente formula 
	(Tamaño de fila + Overhead) * Filas estimadas * Factor de crecimiento 
	En el proyecto deben hacer esto por cada tabla
	Aca es donde importa el tamaño que ocupa cada tipo de dato
*/

/*
	CREATE TABLE Empleado (​

  IdEmpleado INT,                    -- 4 bytes​

  Nombre VARCHAR(50),      -- hasta 50 bytes + 2 bytes de longitud​

 Edad TINYINT,                          -- 1 byte​

 FechaIngreso DATE,              -- 3 bytes​

 Salario DECIMAL(10,2)        -- 5 bytes​

);​

​

Tamaño de fila promedio ≈ 4+52+1+3+5+2 = 67 bytes
*/