--****************************************************
-- Bases de datos: Transacciones y cursores
-- Autor: Erick Varela
-- Correspondencia: evarela@uca.edu.sv
-- Version: 1.0
--****************************************************

-- IMPORTANTE:
-- Para poder realizar algunos ejercicion de esta clase es necesario actualizar la base 
-- de datos HotelManagementDB, por lo que se debe:
--		* Agregar la columna "puntos" de tipo INT a la tabla CLIENTE.
--		* Actualizar la columna recien creada con algunos datos.
ALTER TABLE CLIENTE ADD puntos INT;
SELECT * FROM CLIENTE;

UPDATE CLIENTE SET puntos = 2310 WHERE id=1;
UPDATE CLIENTE SET puntos = 4744 WHERE id=2;
UPDATE CLIENTE SET puntos = 3626 WHERE id=3;
UPDATE CLIENTE SET puntos = 2387 WHERE id=4;
UPDATE CLIENTE SET puntos = 1233 WHERE id=5;
UPDATE CLIENTE SET puntos = 4028 WHERE id=6;
UPDATE CLIENTE SET puntos = 3089 WHERE id=7;
UPDATE CLIENTE SET puntos = 4061 WHERE id=8;
UPDATE CLIENTE SET puntos = 4051 WHERE id=9;
UPDATE CLIENTE SET puntos = 1065 WHERE id=10;
UPDATE CLIENTE SET puntos = 1759 WHERE id=11;
UPDATE CLIENTE SET puntos = 2240 WHERE id=12;
UPDATE CLIENTE SET puntos = 4889 WHERE id=13;
UPDATE CLIENTE SET puntos = 2233 WHERE id=14;
UPDATE CLIENTE SET puntos = 2021 WHERE id=15;
UPDATE CLIENTE SET puntos = 2431 WHERE id=16;
UPDATE CLIENTE SET puntos = 2751 WHERE id=17;
UPDATE CLIENTE SET puntos = 2156 WHERE id=18;
UPDATE CLIENTE SET puntos = 4470 WHERE id=19;
UPDATE CLIENTE SET puntos = 1986 WHERE id=20;
UPDATE CLIENTE SET puntos = 3619 WHERE id=21;
UPDATE CLIENTE SET puntos = 3754 WHERE id=22;
UPDATE CLIENTE SET puntos = 3745 WHERE id=23;
UPDATE CLIENTE SET puntos = 4781 WHERE id=24;
UPDATE CLIENTE SET puntos = 3036 WHERE id=25;
UPDATE CLIENTE SET puntos = 4239 WHERE id=26;
UPDATE CLIENTE SET puntos = 3178 WHERE id=27;
UPDATE CLIENTE SET puntos = 3948 WHERE id=28;
UPDATE CLIENTE SET puntos = 1563 WHERE id=29;
UPDATE CLIENTE SET puntos = 4366 WHERE id=30;
UPDATE CLIENTE SET puntos = 3624 WHERE id=31;
UPDATE CLIENTE SET puntos = 3667 WHERE id=32;
UPDATE CLIENTE SET puntos = 4372 WHERE id=33;
UPDATE CLIENTE SET puntos = 3307 WHERE id=34;
UPDATE CLIENTE SET puntos = 4883 WHERE id=35;
UPDATE CLIENTE SET puntos = 2307 WHERE id=36;
UPDATE CLIENTE SET puntos = 4106 WHERE id=37;
UPDATE CLIENTE SET puntos = 3898 WHERE id=38;
UPDATE CLIENTE SET puntos = 4610 WHERE id=39;
UPDATE CLIENTE SET puntos = 3126 WHERE id=40;
UPDATE CLIENTE SET puntos = 2439 WHERE id=41;
UPDATE CLIENTE SET puntos = 1882 WHERE id=42;
UPDATE CLIENTE SET puntos = 2043 WHERE id=43;
UPDATE CLIENTE SET puntos = 3143 WHERE id=44;
UPDATE CLIENTE SET puntos = 1274 WHERE id=45;
UPDATE CLIENTE SET puntos = 4369 WHERE id=46;
UPDATE CLIENTE SET puntos = 2939 WHERE id=47;
UPDATE CLIENTE SET puntos = 4112 WHERE id=48;
UPDATE CLIENTE SET puntos = 3697 WHERE id=49;
UPDATE CLIENTE SET puntos = 2300 WHERE id=50;

SELECT * FROM CLIENTE;

--*****************************************************

-- 1.0 	Crear un procedimiento almacenado que permita registrar nuevas reservas
--		Como argumentos se reciben: el la fecha de checkin y checkout, el id de metodo de pago, 
--		el id del cliente y el id de la habitacion.
-- DROP PROCEDURE BOOKING;


-- Ejecutando procedimiento almacenado
-- DELETE FROM RESERVA WHERE id = 201 OR id = 202;


-- Verificando datos:
-- Se observa alguna anomalia en los datos?




-- Procedimientos almacenados con tratamiento de tablas.
-- 1.2. Crear un procedimiento almacenado que reciba como parametros dos enteros
--		El objetivo es mostrar la ganancia de cada hotel y la suma total de la ganancia
--		Parametro 1: numero entero entre 1 y 12 que representa un mes
--		Parametro 2: numero entero que representa un año.



--*****************************************************
--	TRANSACCIONES

-- 2.0	Crear un procedimiento almacenado que permita transferir puntos de cliente frecuente entre
--		2 usuarios. Como parametros se deberan recibir el id del usuario emisor, el id del usuario
--		receptor, y la cantidad de puntos a transferir.
--		NOTA: En la primera version de este ejercicio provocar un error de semantica y observar el resultado


-- Ejecutando procedimiento almacenado (se espera un error)


-- Verificando datos


-- 2.1	Crear una version 2 del procedimiento almacenado anterior
--		Utilizar transacciones

