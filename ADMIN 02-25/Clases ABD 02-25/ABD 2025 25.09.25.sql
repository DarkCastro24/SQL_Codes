-- Administracion de bases de datos				Fecha: 25/09/2025

-- Autenticaciones: Windows y Autenticacion Mixta (SQL)

-- Se puede habilitar la autenticacion mixta 

-- Nos conectamos al SQL Server y seleccionamos el servidor 
-- Nos vamos a propiedades y seleccionamos el apartado de seguridad 
-- Marcamos donde dice Autenticacion de Windows y SQL Server 
-- Ahora a reiniciar el servidor con click derecho y restart sobre el servidor (primer elemento en el menu de la izquierda)


/*	LOGIN: ES LA CREDENCIAL DE ACCESO AL SERVIDOR */
-- Contiene el nombre de usuario y modo de autenticacion
-- UN LOGIN DA ACCESO AL SERVIDOR 
-- SE PUEDE CREAR DESDE CUALQUIER BASE DE DATOS 
-- SE GUARDA EN LA BASE DE DATOS MASTER 

/*
	CREATE LOGIN appUser ​
	WITH PASSWORD = 'AppUser2025!', ​
	CHECK_POLICY = ON, ​
	CHECK_EXPIRATION = ON;
*/

-- USUARIO: IDENTIDAD DENTRO DE BASE DE DATOS ESPECIFICA 

-- TODO USUARIO ESTA VINCULADO A UN LOGIN EXCEPTO LOS USUARIOS CONTENIDOS QUE SOLO EXISTEN DENTRO DE LA BASE

/*
	USE VENTAS;
	CREATE USER appUserDB FOR 
	LOGIN appUser;
*/

USE laboratorio05;

-- Creando login
CREATE LOGIN appUser ​
	WITH PASSWORD = 'AppUser2025!', ​
	CHECK_POLICY = ON, ​
	CHECK_EXPIRATION = ON;

-- Creando usuario 
CREATE USER appUserDB FOR 
	LOGIN appUser;

-- Iniciar sesion en SQL Server con las credenciales (DESCONECTAR DEL SERVIDOR) 
-- User: appUser ​
-- Password: AppUser2025!

-- USUARIOS CONTENIDOS 

-- COMANDO: CREATE USER <nombre_usuario> WITH PASSWORD = '<contrseña>'

-- Ventajas: Portatil ya que se mueve dentro de la  base 
-- No se tienen que crear los logins para restaurar la base de datos.

-- HABILITAR LA AUTENTICACION AUTOCONTENIDA EN EL SERVIDOR 
EXEC sp_configure 'contained database authentication', 1;
RECONFIGURE;

-- Corroboramos si se habilito porque config_level tiene el valor de 1 
EXEC sp_configure 'contained database authentication'
ALTER DATABASE laboratorio05 ​
SET CONTAINMENT = PARTIAL;​

ALTER DATABASE laboratorio05 SET CONTAINMENT = PARTIAL;

-- Al conectarnos a una base de datos autocontenida solo sale esta base de datos 
-- Crear un usuario autocontenido e iniciar sesion con el 
CREATE USER appUserDB2
WITH PASSWORD = 'AppUser2025!';
GO

-- Agregar el rol minimo para que sirva 
ALTER ROLE db_datareader ADD MEMBER appUserDB2;
GO

-- Credenciales 
-- Usuario: appUserDB2
-- Clave: AppUser2025!
-- En las opciones de SQL Server seleccionar la pestaña configuracion de conexion 
-- y donde dice base de datos quitar la master y poner el nombre de la base a la que 
-- pertenece ese usuario en este caso "laboratorio05"

/* Continuando con la clase */

-- Habilitar la autenticación autocontenida en el servidor
EXEC sp_configure 'contained database authentication', 1;
RECONFIGURE;
GO

-- Crear bases de datos 
CREATE DATABASE C00117322Normal;
CREATE DATABASE C00117322Contained CONTAINMENT = PARTIAL;
GO

-- Crear login y usuario en la base de datos normal
CREATE LOGIN normalUser00117322 
WITH PASSWORD = 'Normal123!',
     CHECK_POLICY = ON,
     CHECK_EXPIRATION = ON;
GO

USE C00117322Normal;
GO
CREATE USER normalUserDB00117322 FOR LOGIN normalUser00117322;
GO

-- Asignar un rol al usuario
ALTER ROLE db_datareader ADD MEMBER normalUserDB00117322;
GO

-- Visualizar usuarios en la base
SELECT name, type_desc 
FROM sys.database_principals 
WHERE type IN ('S','U');
GO

-- Visualizar roles en la base
SELECT name, type_desc 
FROM sys.database_principals 
WHERE type = 'R';
GO

-- Crear usuario AUTOCONTENIDO en la base contenida
USE C00117322Contained;
GO
CREATE USER containedUser00117322 
WITH PASSWORD = 'Contained123!';
GO

-- Asignar un rol al usuario autocontenido
ALTER ROLE db_datareader ADD MEMBER containedUser00117322;
GO

-- Visualizar usuarios en la base contenida
SELECT name, type_desc 
FROM sys.database_principals 
WHERE type IN ('S','U');
GO

-- CREAMOS UNA TABLA LE INSERTAMOS 5 REGISTROS Y LE HACEMOS BACKUP 
CREATE TABLE Clientes (
    Id INT PRIMARY KEY,
    Nombre VARCHAR(50),
    Ciudad VARCHAR(50)
);

INSERT INTO Clientes VALUES
(1, 'Ana', 'San Salvador'),
(2, 'Luis', 'Santa Ana'),
(3, 'María', 'San Miguel'),
(4, 'Carlos', 'Sonsonate'),
(5, 'Elena', 'La Libertad');

-- Backup a la base de datos
BACKUP DATABASE C00117322Contained 
TO DISK = 'C:\backups\C00117322Contained.bak'
WITH INIT, COMPRESSION, STATS = 5;
GO


RESTORE DATABASE C00117322Normal
FROM DISK = 'C:\backups\C00117322Normal.bak'
WITH REPLACE;
GO

RESTORE DATABASE C00117322Contained 
FROM DISK = 'C:\backups\C00117322Contained .bak'
WITH REPLACE;
GO


