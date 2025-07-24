-- Crear un tablespace propio para el usuario
CREATE TABLESPACE userp1_tbs
    DATAFILE 'userp1_tbs.dbf'
    SIZE 100M
    AUTOEXTEND ON NEXT 10M MAXSIZE 500M;

-- Modificar la sesión para crear el usuario
alter session set "_ORACLE_SCRIPT"=true;  

-- Crear el usuario y asignarle el tablespace
CREATE USER userp1
    IDENTIFIED BY root
    DEFAULT TABLESPACE userp1_tbs
    QUOTA UNLIMITED ON userp1_tbs;

-- Otorgar privilegios al usuario
GRANT CONNECT, RESOURCE TO userp1;

-- Otorgar privilegios adicionales para la creación de objetos
GRANT CREATE SESSION TO userp1;
GRANT CREATE TABLE TO userp1;
GRANT CREATE SEQUENCE TO userp1;
GRANT CREATE VIEW TO userp1;
GRANT CREATE TRIGGER TO userp1;
GRANT CREATE PROCEDURE TO userp1;

-- Otorgar privilegios para crear claves primarias y foráneas
GRANT CREATE ANY INDEX TO userp1;