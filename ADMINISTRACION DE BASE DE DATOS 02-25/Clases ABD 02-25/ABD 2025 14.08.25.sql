-- ADMINISTRACION DE BASES DE DATOS 02/25
-- CLASE 02 14/08/2025

CREATE DATABASE db_hotel;
USE db_hotel;

-- Tabla hotel
CREATE TABLE hotel(
id_hotel INT PRIMARY KEY,
nombre VARCHAR(20) NOT NULL,
direccion VARCHAR(35) NOT NULL,
telefono VARCHAR(8) DEFAULT 'No tiene'
)

-- Tabla habitación
CREATE TABLE habitacion(
id_habitacion INT PRIMARY KEY IDENTITY,
numero VARCHAR(8),
precio DECIMAL(18,2),
id_hotel INT,
CONSTRAINT CK_precio CHECK (precio > 0),
CONSTRAINT FK_hab_hotel FOREIGN KEY (id_hotel) REFERENCES hotel(id_hotel) ON DELETE CASCADE
)

-- Tabla pais
CREATE TABLE pais (
id_pais INT PRIMARY KEY,
nombre VARCHAR(50) NOT NULL
);

-- Tabla proveedor
CREATE TABLE proveedor (
id_proveedor INT PRIMARY KEY,
nombre VARCHAR(50) NOT NULL,
telefono VARCHAR(15),
id_pais INT,
CONSTRAINT FK_proveedor_pais FOREIGN KEY (id_pais) REFERENCES pais(id_pais)
);

-- Tabla intermedia
CREATE TABLE proveedor_hotel (
id_proveedor INT,
id_hotel INT,
PRIMARY KEY (id_proveedor, id_hotel),
CONSTRAINT FK_prov_hotel_proveedor FOREIGN KEY (id_proveedor) REFERENCES proveedor(id_proveedor),
CONSTRAINT FK_prov_hotel_hotel FOREIGN KEY (id_hotel) REFERENCES hotel(id_hotel)
);

-- INSERTS 

INSERT INTO hotel (id_hotel,nombre,direccion)
VALUES
(1001, 'Barcelo', 'Zona Rosa 402'),
(1002, 'Hotel Central', 'Calle Buenaventura 123'),
(1003, 'Grand Palace', 'Avenida Principal 456'),
(1004, 'Vista Bella', 'Calle del Mar 789'),
(1005, 'Hotel Playa', 'Playa del Sol 101');

INSERT INTO habitacion(numero, precio, id_hotel)
VALUES
('101', 45.00, 1001),
('102', 120.00,1001),
('103', 47.00, 1001),
('201', 200.00,1002),
('202', 18.00, 1002),
('301', 100.00,1003),
('302', 35.00, 1003),
('401', 250.00,1004),
('402', 260.00,1004);

INSERT INTO pais (id_pais, nombre)
VALUES
(1, 'México'),
(2, 'España'),
(3, 'Estados Unidos'),
(4, 'El Salvador');

INSERT INTO proveedor (id_proveedor, nombre, telefono, id_pais)
VALUES
(1, 'Proveedor A', '5551234567', 1),
(2, 'Proveedor B', '123456789', 2),
(3, 'Proveedor C', '987654321', 3);

INSERT INTO proveedor_hotel (id_proveedor, id_hotel)
VALUES
(1, 1001),
(2, 1002),
(1, 1003),
(2, 1005),
(3, 1004);

-- Uso de like 

-- Seleccion de nombre de hotel que inicie con una letra 
SELECT id_hotel, nombre, direccion, telefono
FROM hotel
WHERE nombre LIKE 'b%'

-- Una busqueda de proveedor utilizando _%
-- _ busca algun proveedor que tenga una r dentro del nombre luego de 1 caracter 
SELECT id_proveedor, nombre, telefono
FROM proveedor
WHERE nombre LIKE '_r%' 

-- Busqueda de nombre de hotel utilizando _

-- Cuenta con al menos una letra a luego de al menos 2 caracteres 
SELECT * 
FROM hotel
WHERE nombre LIKE '__a%'
SELECT * FROM proveedor

-- Una busqueda de pais [e-m]% (rango o conjunto de valores)
SELECT * FROM pais
WHERE nombre LIKE '[e-m]%'


-- Actualizar el precio de una habitacion 
SELECT * FROM habitacion

UPDATE habitacion 
set precio = 100 
where id_habitacion = 1

-- Utilizando IN 
UPDATE habitacion 
set precio = 100 
where id_habitacion IN (1,3,5) and precio <= 50;

SELECT * FROM habitacion;

-- BETWEEN Y OPERADORES DE COMPARACION
-- Habitaciones que van de 100 a 200 con BETWEEN 
SELECT * FROM habitacion
WHERE precio BETWEEN 100 and 200

-- CONSULTAS JOINS INNER, LEFT
SELECT pro.nombre 'nombre de provedor', p.nombre as 'nombre de pais'
FROM proveedor pro 
INNER JOIN pais p ON p.id_pais = pro.id_pais

-- Obtener los proveedores asociados 
-- a un hotel especifico 

SELECT * FROM proveedor
SELECT * FROM proveedor_hotel

SELECT pro.nombre as nombre_proveedor, h.nombre as nombre_hotel 
FROM proveedor pro
INNER JOIN proveedor_hotel ph ON ph.id_proveedor = pro.id_proveedor
INNER JOIN hotel h ON ph.id_hotel = h.id_hotel 

-- Obtener todos los nombres de hoteles y si tienen habitaciones entonces mostrar sus datos 

SELECT h.nombre as nombre_hotel, ha.numero as numero_habitacion, ha.precio as precio_habitacion 
FROM habitacion ha
LEFT JOIN hotel h ON ha.id_hotel = h.id_hotel

SELECT h.nombre AS nombre_hotel, ha.numero AS numero_habitacion, ha.precio AS precio_habitacion 
FROM hotel h
LEFT JOIN habitacion ha ON h.id_hotel = ha.id_hotel

-- ABD																		CLASE 19/08/2025

-- Obtener el total de habitaciones 

SELECT COUNT(id_habitacion) as cantidad_habitaciones FROM habitacion;

SELECT * FROM habitacion;

-- Encontrar el promedio de precios de las habitaciones agrupadas por id_hotel 

SELECT h.id_hotel, ho.nombre, AVG(h.precio) as promedio
FROM habitacion h
INNER JOIN hotel ho ON h.id_hotel = ho.id_hotel
GROUP BY ho.nombre,h.id_hotel
ORDER BY promedio ASC

-- USO DE JOIN, HAVING 
-- Mostrar el precio promedio de las habitaciones por hotel pero solo para los que tengan precio mayor a 100
-- HAVING hace lo mismo que WHERE solo que se ocupa para funciones de agregacion

SELECT h.id_hotel, ho.nombre, AVG(h.precio) as promedio
FROM habitacion h
INNER JOIN hotel ho ON h.id_hotel = ho.id_hotel
GROUP BY ho.nombre,h.id_hotel
HAVING AVG(h.precio) > 100
ORDER BY promedio ASC

-- USO DE TOP 1 
-- Mostrar el nombre del hotel y el precio de la habitacion mas cara ordenado de mayor a menor por precio

-- La mas cara por cada hotel
SELECT h.id_hotel, ho.nombre, max(h.precio) as habitacion_mas_cara
FROM habitacion h
INNER JOIN hotel ho ON ho.id_hotel = h.id_hotel
GROUP BY h.id_hotel, ho.nombre
ORDER BY habitacion_mas_cara DESC 

-- La mas cara de todos los hoteles 
SELECT TOP 1 h.id_hotel, ho.nombre, max(h.precio) as habitacion_mas_cara
FROM habitacion h
INNER JOIN hotel ho ON ho.id_hotel = h.id_hotel
GROUP BY h.id_hotel, ho.nombre
ORDER BY habitacion_mas_cara DESC 

-- SUBCONSULTAS

-- Subconsulta escalar: un solo resultado 
-- Subconsulta multiples filas: varios registros que cumplen con la condicion
-- Subconsulta de tabla o correlacionada

/*
	SELECT campo1, campo2
	FROM tabla
	WHERE (
		SELECT campo3
		FROM tabla2 
		WHERE campo4 = 'x'
	)
*/

-- Mostrar los hoteles que tienen al menos una habitacion cuyo precio es superior a 200 

-- Subconsulta para obtener los ID de los hoteles que cumplen 
SELECT id_hotel 
FROM habitacion
GROUP BY id_hotel 
HAVING max(precio) > 200

-- Consulta para mostrar todos los datos del hotel filtrado con subconsulta

-- Utilizando IN 
SELECT * FROM hotel
WHERE id_hotel IN (SELECT id_hotel 
FROM habitacion
GROUP BY id_hotel 
HAVING max(precio) > 200)

-- Utilizando EXISTS 
SELECT *
FROM hotel h
WHERE EXISTS 
(
    SELECT ha.id_hotel
    FROM habitacion ha
    WHERE ha.id_hotel = h.id_hotel
    AND ha.precio > 200
)









