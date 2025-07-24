--****************************************************
-- Bases de datos: 13 Consulta de datos básica
-- Autor: Erick Varela
-- Correspondencia: evarela@uca.edu.sv
-- Version: 2.0
--****************************************************

--**********************************************************************
-- 1.0 Condiciones lógicas
SELECT * FROM RESERVA;

-- 1.1 Mostrar todas las reservas con id mayor a 90
SELECT * FROM RESERVA WHERE id > 90;

-- 1.2 Mostrar todas las reservas con id menor o igual a 10
SELECT * FROM RESERVA WHERE id <= 10;

-- 1.3 Mostrar todas las reservas con id entre 25 y 40
SELECT * FROM RESERVA WHERE id >= 25 AND id <= 40;

-- 1.3.1 Instrucción BETWEEN: Mostrar todas las reservas con id entre 25 y 40
SELECT * FROM RESERVA WHERE id BETWEEN 25 AND 40;

-- 1.3.1 Verificar el efecto en la consulta de NOT BETWEEN
SELECT * FROM RESERVA WHERE id NOT BETWEEN 25 AND 40;

-- 1.4 Instrucción  OR: 
-- Mostrar las reservas con id menores a 10 y mayores a 90
SELECT * FROM RESERVA WHERE id < 10 OR id > 90;

-- 1.4 Instrucción  OR: 
-- Mostrar las reservas con id menores a 10, mayores a 90 y menores a 100
SELECT * FROM RESERVA WHERE (id < 10 OR id > 90) AND id < 100;




-- 1.5 Mostrar las reservas que realizadas en mayo
SELECT * FROM RESERVA WHERE MONTH(checkin) = 5;

SELECT * FROM RESERVA 
WHERE checkin 
	BETWEEN CONVERT (DATE,'01-05-2023',103) AND CONVERT (DATE,'31-05-2023',103);

SELECT * FROM RESERVA 
WHERE checkin >= CONVERT (DATE,'01-05-2023',103) AND checkin <= CONVERT (DATE,'31-05-2023',103);

-- 1.6 Mostrar las reservas que sean mayores a 3 días
SELECT *, DATEDIFF(DAY, checkin, checkout) FROM RESERVA
WHERE DATEDIFF(DAY, checkin, checkout) > 3;


-- 1.7 Mostrar los correos de clientes que finalicen en .edu
SELECT * FROM CORREO_CLIENTE WHERE correo LIKE '%.edu';

-- 1.7.1 Mostrar los correos de clientes que utilizan outlook
SELECT * FROM CORREO_CLIENTE WHERE correo LIKE '%@outlook%';

-- 1.7.2 Mostrar los correos de clientes que NO utilizan outlook
SELECT * FROM CORREO_CLIENTE WHERE correo NOT LIKE '%@outlook%';


-- 1.7.3  Mostrar los correos de clientes que contengan 
--			un punto en su nombre de usuario
SELECT * FROM CORREO_CLIENTE WHERE correo LIKE '%.%@%';

--**********************************************************************
-- 2.0 Agrupando tablas 
-- 2.1 Mostrar cada el id, nombre de cada hotel, su teléfono 
--		y a que categoría pertenece:
SELECT * FROM HOTEL;
SELECT * FROM CATEGORIA_HOTEL;

SELECT HOTEL.id, HOTEL.nombre, HOTEL.telefono, CATEGORIA_HOTEL.categoria
FROM HOTEL, CATEGORIA_HOTEL
WHERE CATEGORIA_HOTEL.id = HOTEL.id_categoria_hotel;


-- 2.2 Mostrar cada el id y nombre de cada hotel 
--		y el nombre de la categoría a la que pertenece:
SELECT HOTEL.id, HOTEL.nombre, CATEGORIA_HOTEL.categoria
FROM HOTEL, CATEGORIA_HOTEL
WHERE CATEGORIA_HOTEL.id = HOTEL.id_categoria_hotel

-- 2.2.1 Uso de alias
SELECT H.id 'id hotel', H.nombre 'nombre de hotel', C.categoria
FROM HOTEL H, CATEGORIA_HOTEL C
WHERE C.id = H.id_categoria_hotel

-- 2.3.1 Mostrar toda la información de cada cliente, 
--		incluyendo el pais al cual pertenece y el tipo de cliente que es:
SELECT * FROM CLIENTE;
SELECT * FROM PAIS;
SELECT * FROM CATEGORIA_CLIENTE;

SELECT C.id, C.nombre, C.documento, C.id_pais, C.categoria_cliente, P.id, P.pais, CC.id, CC.categoria
FROM CLIENTE C, PAIS P, CATEGORIA_CLIENTE CC
WHERE P.id = C.id_pais AND CC.id = C.categoria_cliente

SELECT C.id, C.nombre, C.documento,P.pais, CC.categoria
FROM CLIENTE C, PAIS P, CATEGORIA_CLIENTE CC
WHERE P.id = C.id_pais AND CC.id = C.categoria_cliente
	