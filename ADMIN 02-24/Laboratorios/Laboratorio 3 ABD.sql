-- LABORATORIO 03 ADMINISTRACION DE ALMACENAMIENTO Y USUARIOS
-- AUTOR: DIEGO EDUARDO CASTRO QUINTANILLA 00117322
-- FECHA: 26/09/2024

/*
    IMPORTANTE!!! Antes de comenzar a ejecutar los comandos debemos crear una carpeta para guardar los tablespace 
    en el directorio del disco C: ese mismo nombre es el que debemos colocar en las rutas que coloquemos 
    durante el desarrollo de la practica.
*/

ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE;

/*  Ejercicio 1: Crear un tablespace auto expandible llamado TB__LB3 (sustituir “” por su número de carnet).
    Asignar un datafile de 8 megabytes y que será guardado en el disco C.
    El tamaño máximo será de 36 Megabytes con extensiones de 2 Megabytes.
*/

CREATE SMALLFILE TABLESPACE TB00117322LB3
DATAFILE 'C:/lab03/datafile_tb1.dbf' SIZE 8M
AUTOEXTEND ON NEXT 2M MAXSIZE 36M;

-- En caso de querer eliminar el tablespace 
DROP TABLESPACE TB00117322LB3 INCLUDING CONTENTS AND DATAFILES;

/* Ejercicio 2: Añadir un nuevo datafile al tablespace creado en el ejercicio 1.
   El tamaño será 10 Megabytes y será almacenado en el disco C.
*/

ALTER TABLESPACE TB00117322LB3
ADD DATAFILE 'C:/lab03/datafile_tb2.dbf' SIZE 10M AUTOEXTEND OFF;

-- En caso de querer eliminar el tablasepace ejecutar 
ALTER TABLESPACE TB00117322LB3
DROP DATAFILE 'C:/lab03/datafile_tb2.dbf';

/* Ejercicio 3: Redimensionar el segundo datafile creado a 8 Megabytes. */
ALTER DATABASE DATAFILE 'C:/lab03/datafile_tb2.dbf' RESIZE 8M;

/* Ejercicio 4: Crear un usuario “user_” (sustituir con su carnet) la contraseña será “contrasena”.
   Asignar como tablespace por defecto el creado en el ejercicio 1, y como tablespace temporal “TEMP”.
   Definir una cuota de 4MB de uso de espacio en el tablespace por defecto. 
*/ 

CREATE USER user_00117322
IDENTIFIED BY contrasena
DEFAULT TABLESPACE TB00117322LB3
TEMPORARY TABLESPACE TEMP
QUOTA 4M ON TB00117322LB3;

/* Ejercicio 5: Crear Rol “hacker” y asignar los siguientes privilegios:
   Poder conectarse a la base de datos (CONNECT).
   Poder crear recursos (RESOURCE).
   Crear Rol “developer” y asignar los siguientes privilegios:
    
   Poder conectarse a la base de datos (CONNECT).
   Permitir agregar nuevas filas de datos (INSERT ON).
   Asignar el rol hacker al usuario creado en el ejercicio 4.
*/ 

CREATE ROLE Hacker;
GRANT CONNECT to Hacker;
GRANT RESOURCE to Hacker;
CREATE ROLE developer;
GRANT CONNECT to developer;
GRANT INSERT ON dual to developer;
GRANT Hacker TO user_00117322;

/* Ejercicio 6: Crear el perfil FCLD_ABD con los siguientes parámetros:

Máximo número de intentos de login: 3.
Tiempo de vida de la contraseña: 20.
Tiempo de inactividad: 30.
Número máximo de reutilización de una contraseña: 5.
Tiempo de gracia de una contraseña: 5.
Asignar el perfil al usuario creado en el ejercicio 4. 
*/

CREATE PROFILE FCLD_ABD LIMIT 
FAILED_LOGIN_ATTEMPTS 3
PASSWORD_LIFE_TIME 20
INACTIVE_ACCOUNT_TIME 30
PASSWORD_REUSE_MAX 5 
PASSWORD_GRACE_TIME 5;

ALTER USER user_00117322
PROFILE FCLD_ABD;


-- COMPROBANDO TODOS LOS EJERCICIOS 
SELECT * FROM DBA_TABLESPACES;
SELECT * FROM DBA_DATA_FILES;
SELECT * FROM dba_roles;
SELECT * FROM dba_users;
SELECT * FROM dba_profiles;

-- COMANDOS PARA ELIMINAR LOS OBJETOS CREADOS

-- Eliminar el usuario creado
DROP USER user_00117322 CASCADE;

-- Eliminar el rol Hacker
DROP ROLE Hacker;

-- Eliminar el rol developer
DROP ROLE developer;

-- Cambiar el perfil del usuario a DEFAULT antes de eliminar el perfil personalizado
ALTER USER user_00117322 PROFILE DEFAULT;

-- Eliminar el perfil FCLD_ABD
DROP PROFILE FCLD_ABD CASCADE;

