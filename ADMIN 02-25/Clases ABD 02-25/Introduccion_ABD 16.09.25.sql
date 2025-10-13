-- Primera clase ABD del ing James								Fecha: 16/09/2025

/*
master:
Es la base de datos mas importante de SQL Server, ya que contiene toda la informaci�n a nivel de sistema como configuraciones del servidor, detalles de inicio de sesi�n, rutas de archivos f�sicos y referencias a todas las dem�s bases de datos. Si esta base se da�a, 
el motor de SQL Server no podra arrancar correctamente.

model:
Sirve como plantilla para la creacion de nuevas bases de datos; 
todas las bases que se creen despues de instalar SQL Server tomar�n su configuraci�n base desde model, incluyendo opciones como collation, tama�o inicial, y configuraciones de recuperaci�n. No tiene efecto retroactivo sobre bases ya existentes.

msdb:
Almacena informacion relacionada con las tareas automatizadas del servidor, como trabajos programados, 
planes de mantenimiento, alertas, operadores y el historial de respaldos y restauraciones. 
Es fundamental para el funcionamiento del SQL Server Agent y otras operaciones administrativas.

tempdb:
Es una base de datos temporal que se reinicia cada vez que se reinicia el servidor; 
se utiliza para almacenar objetos temporales como tablas temporales, variables tipo tabla, cursores, y 
datos intermedios generados en operaciones de ordenamiento, agrupamiento o joins complejos. Su rendimiento es clave porque es ampliamente utilizada por SQL Server internamente.
*/

-- Consulta para obtener todas las bases de datos del SQL Server 
SELECT name, database_id, state_desc, recovery_model_desc 
FROM sys.databases
WHERE database_id <= 4
ORDER BY database_id

-- Acceso a la tabla temporal
SELECT TOP 20 OBJECT_NAME(object_id), *
FROM tempdb.sys.objects
ORDER BY create_date DESC;

-- Listar bases de datos del sistema y su estado
SELECT name, state_desc, recovery_model_desc
FROM sys.databases
WHERE database_id <= 4;

-- Crear y comprobar una base de datos
CREATE DATABASE LabIntroDBA;
GO

SELECT name, recovery_model_desc, collation_name
FROM sys.databases
WHERE name = 'LabIntroDBA';
GO

DROP DATABASE LabIntroDBA;
