-- Administración de bases de datos                             Fecha: 23/10/2025  
-- Tema: Esquemas y Seguridad

/*
    Un esquema es un contenedor lógico de objetos de base de datos:
    tablas, vistas, procedimientos, funciones, etc.
    Permite organizar y aislar los objetos según módulos, áreas o propietarios.

    Ejemplo de estructura:

        Base de Datos: BD_Empresa
            ├── Esquema: ventas
            │     ├── Tabla: pedidos
            │     └── Vista: v_pedidosMes
            ├── Esquema: rrhh
            │     ├── Tabla: empleados
            │     └── Procedimiento: sp_sueldo
            └── Esquema: contabilidad
                  ├── Tabla: nota_credito
                  └── Función: get_morosos
*/

-- CASO 1  
-- Creación de un esquema
CREATE DATABASE EmpresaDB;
GO
USE EmpresaDB;
GO

CREATE SCHEMA Ventas AUTHORIZATION usuarioVentas;
GO

-- Consultar propiedades
CREATE TABLE Ventas.Pedidos (
    IdPedido INT PRIMARY KEY,
    Fecha DATE,
    Monto DECIMAL(10,2)
);
GO

-- Cambiar un objeto de esquema
ALTER SCHEMA RRHH TRANSFER dbo.Empleados;
GO

-- Eliminar esquema
DROP SCHEMA Ventas;
GO

/*
    Ventajas de usar esquemas:
    - Aislar módulos o departamentos.
    - Facilitar la seguridad por roles.
    - Evitar conflictos de nombres.
    - Permitir administración modular.
*/

-- CASO 2  
-- Consultar todos los esquemas y sus propietarios
SELECT name AS Esquema,
       USER_NAME(principal_id) AS Propietario
FROM sys.schemas;
GO

-- Verificar los objetos que contiene cada esquema
SELECT s.name AS Esquema,
       o.name AS Objeto,
       o.type_desc AS Tipo
FROM sys.objects o
JOIN sys.schemas s ON o.schema_id = s.schema_id
ORDER BY s.name;
GO

/*
    Seguridad asociada a los esquemas:
    Los privilegios pueden asignarse a nivel de esquema, 
    simplificando la administración. Si se revocan privilegios del esquema, 
    los objetos dentro de él también quedan restringidos.
*/

-- Asignar permisos a un rol sobre un esquema
GRANT SELECT, INSERT, UPDATE, DELETE
ON SCHEMA :: Ventas
TO rol_lectura;
GO

/*
    Propiedades de los esquemas:
    - Cada esquema tiene un propietario (usuario o rol).
    - Los objetos creados dentro heredan la propiedad del esquema.
*/

USE EmpresaDB;
GO

-- Crear usuario y rol
CREATE USER usuarioVentas FOR LOGIN loginVentas;
CREATE ROLE rolComercial;
GO

-- Crear esquema Ventas con propietario usuarioVentas
CREATE SCHEMA Ventas AUTHORIZATION usuarioVentas;
GO

-- Crear esquema Comercial con propietario rolComercial
CREATE SCHEMA Comercial AUTHORIZATION rolComercial;
GO

-- Crear objetos de ejemplo en el esquema Ventas
CREATE TABLE Ventas.Pedidos (
    IdPedido INT PRIMARY KEY,
    Fecha DATE,
    Monto DECIMAL(10,2)
);
GO

CREATE TABLE Ventas.Clientes (
    IdCliente INT PRIMARY KEY,
    Nombre NVARCHAR(100)
);
GO

-- Verificar los objetos que contiene cada esquema
SELECT s.name AS Esquema,
       o.name AS Objeto,
       o.type_desc AS Tipo
FROM sys.objects o
JOIN sys.schemas s ON o.schema_id = s.schema_id
ORDER BY s.name;
GO

-- Eliminar esquema Ventas (si está vacío)
DROP SCHEMA Ventas;
GO

-- Transferir objetos entre esquemas
ALTER SCHEMA Comercial TRANSFER Ventas.Pedidos;
ALTER SCHEMA Comercial TRANSFER Ventas.Clientes;
GO

-- Verificar si el esquema Ventas está vacío
SELECT COUNT(*) AS ObjetosEnVentas
FROM sys.objects o
JOIN sys.schemas s ON o.schema_id = s.schema_id
WHERE s.name = 'Ventas';
GO

-- Eliminar el esquema Ventas
DROP SCHEMA Ventas;
GO

-- Reasignar propiedad de un esquema
ALTER AUTHORIZATION ON SCHEMA::Comercial TO dbo;
GO

-- Verificar cambio de propietario
SELECT name AS Esquema,
       USER_NAME(principal_id) AS Propietario
FROM sys.schemas
WHERE name = 'Comercial';
GO

/*
    Caso de estudio:
    El DBA de la base de datos PUBS desea reorganizar los objetos
    para separar las tablas relacionadas con autores y títulos 
    en un nuevo esquema llamado Editorial.

    Además, quiere reasignar la propiedad del esquema dbo
    a un rol de base de datos llamado rol_editorial.
*/

-- Crear rol y usuario que administrará los esquemas
CREATE ROLE rol_editorial;
CREATE USER usuarioEditorial FOR LOGIN loginEditorial;
GO

-- Crear el nuevo esquema Editorial
CREATE SCHEMA Editorial AUTHORIZATION rol_editorial;
GO

-- Transferir los objetos al nuevo esquema
ALTER SCHEMA Editorial TRANSFER dbo.authors;
ALTER SCHEMA Editorial TRANSFER dbo.titles;
ALTER SCHEMA Editorial TRANSFER dbo.publishers;
ALTER SCHEMA Editorial TRANSFER dbo.titleauthor;
GO

/*
Discusión:
Al transferir un objeto de un esquema a otro:
    - Los índices, llaves foráneas y relaciones se conservan.
    - Los permisos deben verificarse, ya que pueden depender del propietario.
*/

-- Buenas prácticas:
/*
    Nombrar esquemas según función o área del negocio.
    Centralizar seguridad por roles y esquemas, no por objeto.
    Evitar usar el esquema dbo para todo.
    Documentar los esquemas creados y sus relaciones.
*/

-- Conclusión:
/*
    El uso de esquemas es una práctica fundamental en la administración moderna
    de bases de datos, ya que:
    - Introduce modularidad y claridad estructural.
    - Simplifica la seguridad y delegación de permisos.
    - Mejora la portabilidad y mantenimiento de los sistemas.
*/
