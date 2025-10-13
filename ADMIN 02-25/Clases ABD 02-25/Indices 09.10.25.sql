CREATE DATABASE indicesLab;
GO
USE indicesLab;
GO

-- TABLA DE EJEMPLO
CREATE TABLE dbo.Clientes
(
  IdCliente       INT IDENTITY(1,1),
  Nombre          NVARCHAR(50),
  Apellido        NVARCHAR(50),
  Email           NVARCHAR(100),
  Ciudad          NVARCHAR(50),
  Estado          NVARCHAR(20),
  FechaRegistro   DATE,
  CONSTRAINT PK_Clientes PRIMARY KEY NONCLUSTERED (IdCliente)
);
GO

-- CREAR ÍNDICE CLUSTERED
CREATE CLUSTERED INDEX IX_Clientes_Apellido
ON dbo.Clientes (Apellido);
GO

-- INSERTAR DATOS DE PRUEBA
INSERT INTO dbo.Clientes (Nombre, Apellido, Email, Ciudad, Estado, FechaRegistro)
VALUES 
('Ana','Pérez','ana.perez@ejemplo.com','San Salvador','Activo','2011-01-10'),
('Luis','Ramírez','luis.ramirez@ejemplo.com','Santa Ana','Activo','2011-03-22'),
('Carla','López','carla.lopez@ejemplo.com','San Miguel','Inactivo','2012-02-14'),
('Diego','Quintanilla','diego.q@ejemplo.com','Sonsonate','Activo','2012-03-01');
GO

-- MEDIR RENDIMIENTO ANTES DEL ÍNDICE EN FechaRegistro
SET STATISTICS TIME ON;
SELECT *
FROM dbo.Clientes
WHERE FechaRegistro BETWEEN '2011-01-01' AND '2012-03-31';
GO

-- CREAR ÍNDICE NONCLUSTERED EN FechaRegistro
CREATE INDEX IX_Clientes_Fecha
ON dbo.Clientes (FechaRegistro);
GO

-- Repetir la misma consulta para comparar tiempos
SELECT *
FROM dbo.Clientes
WHERE FechaRegistro BETWEEN '2011-01-01' AND '2012-03-31';
GO

-- OTROS ÍNDICES ÚTILES

-- ÍNDICE UNIQUE
CREATE UNIQUE INDEX IX_Cliente_Email
ON dbo.Clientes (Email);
GO

-- ÍNDICE COMPUESTO
CREATE INDEX IX_Cliente_Ciudad_Estado
ON dbo.Clientes (Ciudad, Estado);
GO

-- ÍNDICE FILTRADO
CREATE INDEX IX_Cliente_Activo
ON dbo.Clientes (Estado)
WHERE Estado = 'Activo';
GO

-- CONSULTAS DE APOYO Y DIAGNÓSTICO

-- Ver índices de una tabla
EXEC sp_helpindex 'dbo.Clientes';
GO

-- Ver índices faltantes (sugerencias del optimizador)
SELECT * FROM sys.dm_db_missing_index_details;
GO

---------------------------------------------------------------
-- 9) MEDIR FRAGMENTACIÓN DE ÍNDICES
---------------------------------------------------------------
SELECT
  OBJECT_NAME(ips.object_id) AS Tabla,
  i.name                     AS Indice,
  ips.index_type_desc        AS Tipo,
  ips.avg_fragmentation_in_percent AS Fragmentacion
FROM sys.dm_db_index_physical_stats (DB_ID(), NULL, NULL, NULL, 'LIMITED') AS ips
JOIN sys.indexes AS i
  ON ips.object_id = i.object_id
 AND ips.index_id  = i.index_id
WHERE ips.database_id = DB_ID();
GO

---------------------------------------------------------------
-- 10) MANTENIMIENTO DE ÍNDICES
---------------------------------------------------------------

-- Reorganizar (fragmentación menor a 30%)
ALTER INDEX IX_Clientes_Apellido ON dbo.Clientes REORGANIZE;
GO

-- Reconstruir (fragmentación mayor a 30%)
ALTER INDEX IX_Clientes_Apellido ON dbo.Clientes REBUILD;
GO

---------------------------------------------------------------
-- 11) LIMPIEZA OPCIONAL
---------------------------------------------------------------
--DROP INDEX IX_Cliente_Ciudad_Estado ON dbo.Clientes;
--DROP INDEX IX_Cliente_Activo ON dbo.Clientes;
--DROP DATABASE indicesLab;
--GO
