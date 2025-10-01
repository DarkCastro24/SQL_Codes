/*	Privilegios y gestion de roles 
	Fecha: 30/09/2025
*/

-- Login: permiso para acceder al servidor 
-- Usuario: permiso para acceder a una base de datos

-- Asignar roles y gestionar permisos

-- Los privilegios determinan lo que puede hacer un usuario con los objetos de la BD 
-- Los roles agrupan los privilegios y despues a los usuarios se les asigna un rol.

-- Tenemos 3 tipos de privilegios: sobre servidor, bases de datos y sobre objetos.

-- Los de servidor: ALTER ANY LOGIN, CREATE DATABASE, VIEW ANY DATABASE, CONTROL SERVER
-- Da administracion total sobre el servidor

-- A nivel de bases de datos: CONTROL DATABASE, ALTER DATABASE, ALTER ANY USER Y BACKUP DATABASE
-- Se aplican a una base de datos en particular 

-- A nivel de objeto: CREATE TABLE, ALTER VIEW, ALTER PROCEDURE, DROP TABLE, DROP TRIGGER, SELECT 
-- Permite control sobre los objetos dentro de la base de datos.

-- GRANT: Comando para otorgar privilegios 
-- REVOKE: Quita los privilegios dados a traves de GRANT
-- DENY: Niega los privilegios 

-- Otorga un privilegio:
GRANT SELECT, UPDATE ON dbo.Clientes TO Usuario1;

-- Quita el privilegio otorgado 
-- (pero si lo recibe por otro rol, lo conserva):
REVOKE UPDATE ON dbo.Clientes FROM Usuario1;

-- Niega un privilegio de forma explícita,
-- incluso si el usuario lo tiene a través de un rol:
DENY DELETE ON dbo.Clientes TO Usuario1;

-- ROLES PREDEFINIDOS 

-- db_owner dueño de la base de datos tiene control total sobre la base de datos 
-- db_securityadmin​ administrar los roles ademas de dar y quitar permisos en la base de datos
-- db_backupoperator realizar las copias de seguridad de la base 
-- db_datareader encargado de generar reporte de BI
-- db_datawriter INSERT, UPDATE y DELETE en todas las tablas y vistas

-- ROLES PERSONALIZADOS (SON LOS QUE HACEMOS NOSOTROS MANUALMENTE)
-- Solo existe en la base de datos donde estas cuando lo creas 

-------------------------------------------------------
-- CREAR ROL PERSONALIZADO
-------------------------------------------------------
CREATE ROLE rol_reportes;

-- Otorgar permisos al rol
GRANT SELECT ON dbo.Ventas TO rol_reportes;
GRANT EXECUTE ON dbo.spGenerarInforme TO rol_reportes;

-- Asignar usuario al rol
ALTER ROLE rol_reportes ADD MEMBER usuarioBD;

-- !!! NECESITO HACER UN RESTORE CON UN BACKUP DE BASE DE DATOS 
RESTORE DATABASE GameWorld
FROM DISK = 'C:\backups\GameWorld.bak'
WITH REPLACE;  

-- SI FALLA ES PORQUE HAY QUE ACTIVAR LAS BASES DE DATOS AUTOCONTENIDAS
-- EJECUTAR EL COMANDO Y LUEGO VOLVER A INTENTAR
EXEC sp_configure 'contained database authentication', 1;
RECONFIGURE;
    
-------------------------------------------------------
-- ROLES PREDEFINIDOS
-------------------------------------------------------
-- Crear login en el servidor
CREATE LOGIN user_reportes WITH PASSWORD = 'Reporte123$';

-- Crear usuario en la base de datos actual
USE GameWorld;
CREATE USER user_reportes FOR LOGIN user_reportes;

-- Agregar usuario al rol db_datareader
ALTER ROLE db_datareader ADD MEMBER user_reportes;


-------------------------------------------------------
-- PRUEBA DE CONTEXTO CON USUARIO user_reportes
-------------------------------------------------------
-- Cambiar contexto al usuario
EXECUTE AS USER = 'user_reportes';

-- Consulta permitida
SELECT TOP (5) * FROM dbo.Clientes;

-- Operación NO permitida (INSERT)
INSERT INTO dbo.Clientes (IdCliente, Nombre, Ciudad)
VALUES (6, 'Juan Morales', 'San Salvador');

-- Regresar al contexto original
REVERT;

-- CONSULTAR CON QUE USUARIO ESTAMOS CONECTADOS 
SELECT CURRENT_USER;

-------------------------------------------------------
-- ROLES PERSONALIZADOS
-------------------------------------------------------
-- Crear rol y asignar permisos
CREATE ROLE rol_operaciones;
GRANT INSERT, UPDATE ON dbo.Ventas TO rol_operaciones;

-- Crear login en el servidor
CREATE LOGIN user_operador WITH PASSWORD = 'Operador123$';

-- Crear usuario en la base de datos actual
CREATE USER user_operador FOR LOGIN user_operador;

-- Agregar usuario al rol personalizado
ALTER ROLE rol_operaciones ADD MEMBER user_operador;


-------------------------------------------------------
-- PRUEBA DE CONTEXTO CON USUARIO user_operador
-------------------------------------------------------
-- Cambiar contexto al usuario
EXECUTE AS USER = 'user_operador';

-- Consultas permitidas
INSERT INTO dbo.Ventas (idCliente, Fecha, Estado, Total)
VALUES (2, '2025-09-26', 'Finalizada', 50.00);

UPDATE dbo.Ventas
SET Total = 65.50
WHERE IdVenta = 1; -- Si incluimos la sentencia falla porque implicitamente hace un SELECT 

-- Consulta NO permitida (DELETE)
DELETE FROM dbo.Ventas WHERE IdVenta = 6;

-- Regresar al contexto original
REVERT;

