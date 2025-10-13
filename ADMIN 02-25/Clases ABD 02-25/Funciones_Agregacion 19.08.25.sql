CREATE DATABASE db_animal;
 
USE db_animal;
 
CREATE TABLE pais(
        codigo INT IDENTITY(1,1) PRIMARY KEY,
        nombre VARCHAR(20),
        idioma VARCHAR(20),
        moneda VARCHAR(10)
);
 
CREATE TABLE animal (
        id INT IDENTITY(1,1) PRIMARY KEY,
        nombre VARCHAR(50),
        habita VARCHAR(20),
        edad_vida_media INT,
        dieta VARCHAR(20),
        codigo INT CONSTRAINT FK_AnimalPais FOREIGN KEY REFERENCES pais(codigo)
);
 
INSERT INTO Pais (nombre, idioma ,moneda) VALUES ('China','Mandarin', 'Yuan');  
INSERT INTO Pais (nombre, idioma, moneda) VALUES ('Estados Unidos','Ingles' ,'Dolar');
INSERT INTO Pais (nombre, idioma, moneda) VALUES ('Brasil','Portugues', 'Real');
INSERT INTO Pais (nombre, idioma, moneda) VALUES ('El Salvador','Espanol', 'Dolar');
INSERT INTO Pais (nombre, idioma, moneda) VALUES ('Mexico','Espanol', 'Peso');
INSERT INTO Pais (nombre, idioma, moneda) VALUES ('Colombia','Espanol', 'Peso');
INSERT INTO Pais (nombre, idioma, moneda) VALUES ('Francia','Frances', 'Euro');
INSERT INTO Pais (nombre, idioma, moneda) VALUES ('Peru','Espanol', 'Sol');  
INSERT INTO Pais (nombre, idioma, moneda) VALUES ('Rusia','Ruso' ,'Rublo');
INSERT INTO Pais (nombre, idioma, moneda) VALUES ('Finlandia', 'finlandes','Euro');
 
 
 
INSERT INTO Animal (nombre, habita, edad_vida_media, dieta, codigo) VALUES ('Chacal dorado', 'jungla', 38, 'omnivoro', 1);
INSERT INTO Animal (nombre, habita, edad_vida_media, dieta, codigo) VALUES ('Dragon komodo', 'desierto', 4, 'herbivoro',1);
INSERT INTO Animal (nombre, habita, edad_vida_media, dieta, codigo) VALUES ('Elefante africano', 'desierto', 72, 'herbivoro', 1);
INSERT INTO Animal (nombre, habita, edad_vida_media, dieta, codigo) VALUES ('Bienteveo comun', 'jungla', 47, 'omnivoro', 1);
INSERT INTO Animal (nombre, habita, edad_vida_media, dieta, codigo) VALUES ('Pavo real indio', 'sabana', 29, 'carnivoro', 1);
INSERT INTO Animal (nombre, habita, edad_vida_media, dieta, codigo) VALUES ('Cangrejo', 'sabana', 12, 'herbivoro',1);
INSERT INTO Animal (nombre, habita, edad_vida_media, dieta, codigo) VALUES ('Gacela', 'jungla', 39, 'herbivoro', 2);
INSERT INTO Animal (nombre, habita, edad_vida_media, dieta, codigo) VALUES ('Potoro', 'sabana', 62, 'omnivoro', 2);
INSERT INTO Animal (nombre, habita, edad_vida_media, dieta, codigo) VALUES ('Crinifer concolor', 'desierto', 96, 'carnivoro', 2);
INSERT INTO Animal (nombre, habita, edad_vida_media, dieta, codigo) VALUES ('Halcon ferruginoso', 'sabana', 40, 'carnivoro', 2);
INSERT INTO Animal (nombre, habita, edad_vida_media, dieta, codigo) VALUES ('Piquero de cara azul', 'jungla', 45, 'omnivoro', 2);
INSERT INTO Animal (nombre, habita, edad_vida_media, dieta, codigo) VALUES ('Lugano', 'jungla', 85, 'omnivoro', 3);
INSERT INTO Animal (nombre, habita, edad_vida_media, dieta, codigo) VALUES ('Estornino pinto', 'sabana', 73, 'herbivoro', 3);
INSERT INTO Animal (nombre, habita, edad_vida_media, dieta, codigo) VALUES ('Aguila leonada', 'jungla', 74, 'herbivoro', 3);
INSERT INTO Animal (nombre, habita, edad_vida_media, dieta, codigo) VALUES ('Ardilla Richardson', 'desierto', 32, 'herbivoro',4);
INSERT INTO Animal (nombre, habita, edad_vida_media, dieta, codigo) VALUES ('Guacamaya alas verdes', 'sabana', 9, 'herbivoro', 6);
INSERT INTO Animal (nombre, habita, edad_vida_media, dieta, codigo) VALUES ('Dendrocitta vagabunda', 'sabana', 92, 'omnivoro', 6);
INSERT INTO Animal (nombre, habita, edad_vida_media, dieta, codigo) VALUES ('Coralillo', 'jungla', 81, 'carnivoro', 6);
INSERT INTO Animal (nombre, habita, edad_vida_media, dieta,codigo) VALUES  ('Armadillo de nueve bandas', 'sabana', 55, 'omnivoro', 7);
INSERT INTO Animal (nombre, habita, edad_vida_media, dieta, codigo) VALUES ('Grulla corona negra', 'sabana', 18, 'omnivoro', 8);
INSERT INTO Animal (nombre, habita, edad_vida_media, dieta, codigo) VALUES ('Tockus leucomelas', 'sabana', 68, 'omnivoro', 9);
INSERT INTO Animal (nombre, habita, edad_vida_media, dieta, codigo) VALUES ('Lagarto de lengua azul', 'desierto', 63, 'herbivoro', 9);
INSERT INTO Animal (nombre, habita, edad_vida_media, dieta, codigo) VALUES ('Tinamou elegante crestado', 'jungla', 84, 'herbivoro', 9);
INSERT INTO Animal (nombre, habita, edad_vida_media, dieta, codigo) VALUES ('Monstruo gila', 'sabana', 1, 'carnivoro', 9);
INSERT INTO Animal (nombre, habita, edad_vida_media, dieta, codigo) VALUES ('Dragon     con volantes', 'desierto', 56, 'herbivoro', 9);
INSERT INTO Animal (nombre, habita, edad_vida_media, dieta, codigo) VALUES ('Jirafa', 'desierto', 27, 'herbivoro', NULL);
INSERT INTO Animal (nombre, habita, edad_vida_media, dieta, codigo) VALUES ('Oso pardo', 'jungla', 30, 'carnivoro', NULL);
INSERT INTO Animal (nombre, habita, edad_vida_media, dieta, codigo) VALUES ('Gallina', 'sabana', 10, 'herbivoro', NULL);
INSERT INTO Animal (nombre, habita, edad_vida_media, dieta, codigo) VALUES ('Ballena', 'Oceano', 27, 'carnivoro', NULL);

-- Paises donde el idioma es español 
SELECT * FROM pais
WHERE idioma = 'Espanol'

-- Nombres de animales que inician de la a - c
SELECT * 
FROM animal
WHERE nombre LIKE '[a-c]%'

-- Nombre de los animales que son carnivoros y hervivoros 
SELECT nombre, dieta 
FROM animal 
WHERE dieta = 'carnivoro' OR dieta = 'herbivoro'

-- Seleccionar todos los registros de dietas de animales que inician que tengan un patron rn_
SELECT *
FROM animal
WHERE dieta LIKE '%rn_%';

-- Seleccionar los nombres de los animales y el nombre de pais
SELECT a.nombre AS animal, p.nombre AS pais
FROM animal AS a
LEFT JOIN pais AS p ON p.codigo = a.codigo;

-- seleccionar los nombre de los paises que no tienen asignado animales
SELECT p.nombre AS pais_sin_animales
FROM pais AS p
LEFT JOIN animal AS a ON a.codigo = p.codigo
WHERE a.id IS NULL;

-- cantidad de animales agrupados por codigo de pais
SELECT a.codigo AS codigo_pais, COUNT(*) AS cantidad_animales
FROM animal AS a
GROUP BY a.codigo
ORDER BY codigo_pais;

-- cantidad de animales agrupados por dieta y condicion ser herbivoro
SELECT dieta, COUNT(*) AS cantidad
FROM animal
WHERE dieta = 'herbivoro'
GROUP BY dieta;

-- Mostar la cantidad de animales agrupados por habita y condicion habita desierto
SELECT habita, COUNT(*) AS cantidad
FROM animal
WHERE habita = 'desierto'
GROUP BY habita;

-- mostrar nombre del pais y cantidad de animales agrupados por nombre de pais
SELECT p.nombre AS pais, COUNT(a.id) AS cantidad_animales
FROM pais AS p
LEFT JOIN animal AS a ON a.codigo = p.codigo
GROUP BY p.nombre;

-- mostrar el promedio de las edades de vida media de los animales agrupados por nombre de pais
SELECT p.nombre AS pais, AVG(a.edad_vida_media ) AS promedio_vida_media
FROM pais AS p
LEFT JOIN animal AS a ON a.codigo = p.codigo
GROUP BY p.nombre

-- Mostar la cantidad de animales agrupados por habita y que tienen una vida media menor a 10
SELECT habita, COUNT(*) AS cantidad
FROM animal
WHERE edad_vida_media < 10
GROUP BY habita

/*

*/

