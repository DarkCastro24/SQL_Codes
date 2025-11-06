/*
LABORATORIO 5 - COPIAS DE SEGURIDAD EN SQL SERVER
BASE DE DATOS: PUBS
FECHA DE CREACION: 04/11/2025

Este laboratorio contiene TRES CLAVES DE EJERCICIOS PRACTICOS que abordan
los diferentes tipos de restauracion disponibles en SQL Server. Cada clave se 
enfoca en un conjunto distinto de tablas del esquema PUBS.

ACLARACION IMPORTANTE: CADA ESTUDIANTE DESARROLLARA SU SOLUCION A SU MANERA 
ESTO SE DISEÑO CON EL OBJETIVO QUE CADA ARCHIVO QUE SUBAN SEA DIFERENTE Y EVITAR 
LA COPIA/PLAGIO ESA ES LA RAZON POR LA QUE UNICAMENTE SE DAN LAS INDICACIONES Y EL 
PATRON QUE DEBEN SEGUIR PERO NO LAS SENTENCIAS EXACTAS QUE VAN A OCUPAR.

Cada ejercicio contempla los tres tipos de restauracion:
1) Restauracion Completa (FULL)
2) Restauracion Diferencial (DIFFERENTIAL)
3) Restauracion Punto en Tiempo (LOG)

PRERREQUISITOS:
- Base de datos PUBS instalada y funcional.
- Carpeta para guardar backups existente.
- Permisos administrativos para ejecutar BACKUP y RESTORE.

IMPORTANTE:
- Los escenarios de perdida de datos deben simularse mediante UPDATE o DELETE.
- Los comandos deben reflejar cambios evidentes en las tablas afectadas.
- Al inicio de tu entregable indica tu nombre completo y numero de carnet.

ENTREGABLES:
1) Documento Word o PDF con capturas de todo el proceso.
2) Script .sql con todos los comandos desarrollados.
*/

USE master;
GO

/* CLAVE 1: Restauracion con tablas AUTHORS y TITLES */

/*
Diseñe y ejecute una estrategia de recuperacion completa para las tablas AUTHORS y TITLES.
Simule distintos escenarios de perdida de datos y recupere la informacion aplicando, en orden,
una restauracion FULL, una restauracion DIFFERENTIAL y una restauracion mediante LOG (PITR).
*/

-- CONFIGURACION INICIAL 
ALTER DATABASE pubs SET RECOVERY FULL;
GO

-- BACKUP FULL INICIAL
BACKUP DATABASE pubs 
TO DISK = 'C:\backups\pubs_CLAVE1_FULL.bak'
WITH INIT, COMPRESSION, STATS = 5;
GO

-- ESCENARIO 1: RESTAURACION FULL (simular daño)
USE pubs;

UPDATE authors SET au_lname = 'CORRUPTO', contract = 0;
UPDATE titles SET price = 0, royalty = 0;
DELETE FROM titleauthor WHERE au_id IN (SELECT TOP 5 au_id FROM authors);

-- Verificacion del daño
SELECT COUNT(*) AS autores_corruptos FROM authors WHERE au_lname = 'CORRUPTO';
SELECT COUNT(*) AS titulos_cero FROM titles WHERE price = 0;

-- Restauracion FULL
USE master;

ALTER DATABASE pubs SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
RESTORE DATABASE pubs FROM DISK = 'C:\backups\pubs_CLAVE1_FULL.bak'
WITH REPLACE, RECOVERY, STATS = 5;

ALTER DATABASE pubs SET MULTI_USER;

GO

-- Verificacion post-FULL
USE pubs;

SELECT COUNT(*) AS autores_recuperados FROM authors WHERE au_lname != 'CORRUPTO';
SELECT COUNT(*) AS titulos_recuperados FROM titles WHERE price > 0;
SELECT COUNT(*) AS relaciones_recuperadas FROM titleauthor;

GO

-- PREPARACION PARA DIFFERENTIAL Y LOG 
INSERT INTO authors (au_id, au_lname, au_fname, phone, contract)
VALUES ('111-11-1111', 'Gonzalez', 'Ana', '555-1111', 1),
       ('222-22-2222', 'Martinez', 'Luis', '555-2222', 1);

INSERT INTO titles (title_id, title, type, pub_id, price, pubdate)
VALUES ('CL1001', 'Guia Avanzada SQL', 'business', '1389', 45.99, GETDATE());

INSERT INTO titleauthor (au_id, title_id, au_ord, royaltyper)
VALUES ('111-11-1111', 'CL1001', 1, 60),
       ('222-22-2222', 'CL1001', 2, 40);

-- BACKUP DIFFERENTIAL
USE master;

BACKUP DATABASE pubs 
TO DISK = 'C:\backups\pubs_CLAVE1_DIFF.bak'
WITH DIFFERENTIAL, COMPRESSION, STATS = 5;

GO

-- Cambios para LOG
USE pubs;

UPDATE authors SET contract = 1 WHERE state = 'CA' AND contract = 0;
INSERT INTO authors (au_id, au_lname, au_fname, phone, contract)
VALUES ('333-33-3333', 'Ramirez', 'Carlos', '555-3333', 1);
UPDATE titles SET price = price * 1.1 WHERE type = 'popular_comp';

-- BACKUP LOG
USE master;

BACKUP LOG pubs 
TO DISK = 'C:\backups\pubs_CLAVE1_LOG.trn'
WITH INIT, COMPRESSION, STATS = 5;
GO

-- ESCENARIO 2: RESTAURACION DIFFERENTIAL (simular perdida de lo recien agregado)
USE pubs;

DELETE FROM titleauthor WHERE title_id = 'CL1001';
DELETE FROM titles WHERE title_id = 'CL1001';
DELETE FROM authors WHERE au_id IN ('111-11-1111', '222-22-2222');

-- Restauraci�n DIFFERENTIAL
USE master;

ALTER DATABASE pubs SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
RESTORE DATABASE pubs FROM DISK = 'C:\backups\pubs_CLAVE1_FULL.bak'
WITH NORECOVERY, REPLACE, STATS = 5;

RESTORE DATABASE pubs FROM DISK = 'C:\backups\pubs_CLAVE1_DIFF.bak'
WITH RECOVERY, STATS = 5;

ALTER DATABASE pubs SET MULTI_USER;
GO

-- Verificacion post-DIFFERENTIAL
USE pubs;

SELECT * FROM authors WHERE au_id IN ('111-11-1111', '222-22-2222');
SELECT * FROM titles WHERE title_id = 'CL1001';
SELECT * FROM titleauthor WHERE title_id = 'CL1001';
GO

-- ESCENARIO 3: RESTAURACION LOG (PITR)
USE pubs;

DELETE FROM authors WHERE au_id = '333-33-3333';
UPDATE authors SET contract = 0 WHERE state = 'CA';

-- Restauracion LOG
USE master;

ALTER DATABASE pubs SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
RESTORE DATABASE pubs FROM DISK = 'C:\backups\pubs_CLAVE1_FULL.bak'
WITH NORECOVERY, REPLACE, STATS = 5;

RESTORE DATABASE pubs FROM DISK = 'C:\backups\pubs_CLAVE1_DIFF.bak'
WITH NORECOVERY, STATS = 5;

RESTORE LOG pubs FROM DISK = 'C:\backups\pubs_CLAVE1_LOG.trn'
WITH RECOVERY, STATS = 5;

ALTER DATABASE pubs SET MULTI_USER;
GO

-- Verificacion post-LOG
USE pubs;

SELECT * FROM authors WHERE au_id = '333-33-3333';
SELECT COUNT(*) AS contratos_CA FROM authors WHERE state = 'CA' AND contract = 1;
SELECT title_id, price FROM titles WHERE type = 'popular_comp' AND price > 20;
GO

/* CLAVE 2: Restauracion con tablas SALES y STORES */

/*
Implemente un plan integral de recuperacion para las tablas SALES y STORES.
Genere evidencia de perdida de informacion (ventas y tiendas) y restaurela aplicando
los tres tipos de restauracion: FULL, DIFFERENTIAL y LOG.
*/

-- CONFIGURACION INICIAL
USE master;

ALTER DATABASE pubs SET RECOVERY FULL;
GO

-- BACKUP FULL INICIAL
BACKUP DATABASE pubs 
TO DISK = 'C:\backups\pubs_CLAVE2_FULL.bak'
WITH INIT, COMPRESSION, STATS = 5;
GO

-- ESCENARIO 1: RESTAURACION FULL (simular dano)
USE pubs;

UPDATE stores SET stor_name = 'TIENDA CORRUPTA';
DELETE FROM sales WHERE qty > 20;
UPDATE sales SET payterms = 'CORRUPTO' WHERE ord_num LIKE 'P%';

-- Verificacion del dano
SELECT COUNT(*) AS tiendas_corruptas FROM stores WHERE stor_name = 'TIENDA CORRUPTA';
SELECT COUNT(*) AS ventas_corruptas FROM sales WHERE payterms = 'CORRUPTO';
SELECT COUNT(*) AS ventas_grandes_borradas FROM sales WHERE qty > 20; -- 0 tras el DELETE

-- Restauracion FULL
USE master;

ALTER DATABASE pubs SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
RESTORE DATABASE pubs FROM DISK = 'C:\backups\pubs_CLAVE2_FULL.bak'
WITH REPLACE, RECOVERY, STATS = 5;

ALTER DATABASE pubs SET MULTI_USER;
GO

-- Verificacion post-FULL
USE pubs;

SELECT COUNT(*) AS tiendas_recuperadas FROM stores WHERE stor_name != 'TIENDA CORRUPTA';
SELECT COUNT(*) AS ventas_sanas FROM sales WHERE payterms != 'CORRUPTO';
GO

-- PREPARACION PARA DIFFERENTIAL Y LOG
USE pubs;

INSERT INTO stores (stor_id, stor_name, stor_address, city, state, zip)
VALUES ('9000', 'Tienda Test 1', '123 Calle Principal', 'San Francisco', 'CA', '94101'),
       ('9001', 'Tienda Test 2', '456 Avenida Central', 'Berkeley', 'CA', '94704');

INSERT INTO sales (stor_id, ord_num, ord_date, qty, payterms, title_id)
VALUES (9000, '10001', GETDATE(), 50, 'Net 30', 'BU1032'),
       (9001, '10002', GETDATE(), 25, 'Net 60', 'PS2091');

-- BACKUP DIFFERENTIAL
USE master;

BACKUP DATABASE pubs 
TO DISK = 'C:\backups\pubs_CLAVE2_DIFF.bak'
WITH DIFFERENTIAL, COMPRESSION, STATS = 5;
GO

-- Cambios para LOG
USE pubs;

UPDATE sales SET qty = qty * 2 WHERE stor_id IN ('6380', '7066');
INSERT INTO sales (stor_id, ord_num, ord_date, qty, payterms, title_id)
VALUES ('7131', 'LOGORDER1', GETDATE(), 15, 'Net 30', 'PC1035');
UPDATE stores SET stor_address = 'Direccion Actualizada' WHERE stor_id = '7131';

-- BACKUP LOG
USE master;

BACKUP LOG pubs 
TO DISK = 'C:\backups\pubs_CLAVE2_LOG.trn'
WITH INIT, COMPRESSION, STATS = 5;
GO

-- ESCENARIO 2: RESTAURACION DIFFERENTIAL (simular perdida de lo recien agregado)
USE pubs;

DELETE FROM sales WHERE ord_num IN ('10001', '10002');
DELETE FROM stores WHERE stor_id IN ('9000', '9001');

-- Restauracion DIFFERENTIAL
USE master;

ALTER DATABASE pubs SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
RESTORE DATABASE pubs FROM DISK = 'C:\backups\pubs_CLAVE2_FULL.bak'
WITH NORECOVERY, REPLACE, STATS = 5;

RESTORE DATABASE pubs FROM DISK = 'C:\backups\pubs_CLAVE2_DIFF.bak'
WITH RECOVERY, STATS = 5;

ALTER DATABASE pubs SET MULTI_USER;
GO

-- Verificacion post-DIFFERENTIAL
USE pubs;

SELECT * FROM stores WHERE stor_id IN ('9000', '9001');
SELECT * FROM sales WHERE ord_num IN ('10001', '10002');
GO

-- ESCENARIO 3: RESTAURACION LOG (PITR)
USE pubs;

DELETE FROM sales WHERE ord_num = '10001';
UPDATE sales SET qty = 1 WHERE stor_id IN ('9000', '9001');
UPDATE stores SET stor_address = 'DIRECCION ERRONEA' WHERE stor_id = '9000';

-- Restauracion LOG
USE master;

ALTER DATABASE pubs SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
RESTORE DATABASE pubs FROM DISK = 'C:\backups\pubs_CLAVE2_FULL.bak'
WITH NORECOVERY, REPLACE, STATS = 5;

RESTORE DATABASE pubs FROM DISK = 'C:\backups\pubs_CLAVE2_DIFF.bak'
WITH NORECOVERY, STATS = 5;

RESTORE LOG pubs FROM DISK = 'C:\backups\pubs_CLAVE2_LOG.trn'
WITH RECOVERY, STATS = 5;

ALTER DATABASE pubs SET MULTI_USER;
GO

-- Verificacion post-LOG
USE pubs;

SELECT * FROM sales WHERE ord_num = '6871';
SELECT stor_id, qty FROM sales WHERE stor_id IN ('6380', '7066') AND qty > 10;
SELECT stor_id, stor_address FROM stores WHERE stor_id = '7131' AND stor_address = 'Direccion Actualizada';

GO

/* CLAVE 3: Restauracion con tablas PUBLISHERS y ROYSCHED */

/*
Elabore una estrategia de recuperacion para las tablas PUBLISHERS y ROYSCHED.
Simule incidentes de modificacion y eliminacion, y restablezca la informacion
aplicando los tres tipos de restauracion: FULL, DIFFERENTIAL y LOG.
*/

-- CONFIGURACION INICIAL
USE master;
ALTER DATABASE pubs SET RECOVERY FULL;
GO

-- BACKUP FULL INICIAL
BACKUP DATABASE pubs 
TO DISK = 'C:\backups\pubs_CLAVE3_FULL.bak'
WITH INIT, COMPRESSION, STATS = 5;
GO

-- ESCENARIO 1: RESTAURACION FULL (simular dano)
USE pubs;

UPDATE publishers SET pub_name = 'EDITORIAL CORRUPTA';
DELETE FROM roysched WHERE royalty > 15;
UPDATE roysched SET royalty = 0 WHERE lorange = 0;

-- Verificacion del dano
SELECT COUNT(*) AS editoriales_corruptas FROM publishers WHERE pub_name = 'EDITORIAL CORRUPTA';
SELECT COUNT(*) AS royalty_cero FROM roysched WHERE royalty = 0;

-- Restauracion FULL
USE master;

ALTER DATABASE pubs SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
RESTORE DATABASE pubs FROM DISK = 'C:\backups\pubs_CLAVE3_FULL.bak'
WITH REPLACE, RECOVERY, STATS = 5;

ALTER DATABASE pubs SET MULTI_USER;
GO

-- Verificacion post-FULL
USE pubs;

SELECT COUNT(*) AS editoriales_recuperadas FROM publishers WHERE pub_name != 'EDITORIAL CORRUPTA';
SELECT COUNT(*) AS royalty_alto FROM roysched WHERE royalty > 15;
GO

-- PREPARACION PARA DIFFERENTIAL Y LOG
USE pubs;

INSERT INTO publishers (pub_id, pub_name, city, state, country)
VALUES ('9902', 'Nueva Editorial Tech', 'San Jose', 'CA', 'USA'),
       ('9903', 'Libros Modernos SA',   'Austin',   'TX', 'USA');

INSERT INTO roysched (title_id, lorange, hirange, royalty)
VALUES ('BU1032', 50001, 75000, 20),   -- alta banda para BU1032
       ('PS2091', 30001, 50000, 18);   -- alta banda para PS2091

-- BACKUP DIFFERENTIAL
USE master;

BACKUP DATABASE pubs 
TO DISK = 'C:\backups\pubs_CLAVE3_DIFF.bak'
WITH DIFFERENTIAL, COMPRESSION, STATS = 5;
GO

-- Cambios para LOG (se registraran en el backup de log)
USE pubs;

UPDATE publishers SET city = 'CIUDAD ACTUALIZADA' WHERE pub_id IN ('0877', '1389');
INSERT INTO roysched (title_id, lorange, hirange, royalty)
VALUES ('PC1035', 10001, 20000, 16);   -- nueva banda para PC1035 (solo en LOG)
UPDATE roysched SET royalty = royalty + 2 WHERE title_id = 'PS2106'; -- ajuste LOG

-- BACKUP LOG
USE master;

BACKUP LOG pubs 
TO DISK = 'C:\backups\pubs_CLAVE3_LOG.trn'
WITH INIT, COMPRESSION, STATS = 5;
GO

-- ESCENARIO 2: RESTAURACION DIFFERENTIAL (simular perdida de lo recien agregado al DIFF)
USE pubs;

-- Aqui eliminamos EXACTAMENTE lo que agregamos antes del DIFF:
DELETE FROM publishers WHERE pub_id IN ('9902', '9903');
DELETE FROM roysched WHERE (title_id = 'BU1032' AND royalty = 20)
                     OR  (title_id = 'PS2091' AND royalty = 18);

-- Restauracion DIFFERENTIAL
USE master;

ALTER DATABASE pubs SET SINGLE_USER WITH ROLLBACK IMMEDIATE;

RESTORE DATABASE pubs FROM DISK = 'C:\backups\pubs_CLAVE3_FULL.bak'
WITH NORECOVERY, REPLACE, STATS = 5;

RESTORE DATABASE pubs FROM DISK = 'C:\backups\pubs_CLAVE3_DIFF.bak'
WITH RECOVERY, STATS = 5;

ALTER DATABASE pubs SET MULTI_USER;
GO

-- Verificacion post-DIFFERENTIAL (coherente con lo insertado antes del DIFF)
USE pubs;

SELECT * FROM publishers WHERE pub_id IN ('9902', '9903');
SELECT * FROM roysched WHERE (title_id = 'BU1032' AND royalty = 20)
                      OR  (title_id = 'PS2091' AND royalty = 18);
GO

-- ESCENARIO 3: RESTAURACION LOG (PITR sobre cambios del LOG)
USE pubs;

-- Danamos SOLO lo que fue parte de los cambios de LOG:
DELETE FROM roysched WHERE title_id = 'PC1035' AND royalty = 16;  -- insertado en LOG
UPDATE publishers SET city = 'CIUDAD ERRONEA' WHERE pub_id IN ('0877', '1389'); -- sobreescribe lo actualizado en LOG
UPDATE roysched SET royalty = 10 WHERE title_id = 'PS2106';       -- pisa el +2 hecho en LOG

-- Restauracion LOG
USE master;

ALTER DATABASE pubs SET SINGLE_USER WITH ROLLBACK IMMEDIATE;

RESTORE DATABASE pubs FROM DISK = 'C:\backups\pubs_CLAVE3_FULL.bak'
WITH NORECOVERY, REPLACE, STATS = 5;

RESTORE DATABASE pubs FROM DISK = 'C:\backups\pubs_CLAVE3_DIFF.bak'
WITH NORECOVERY, STATS = 5;

RESTORE LOG pubs FROM DISK = 'C:\backups\pubs_CLAVE3_LOG.trn'
WITH RECOVERY, STATS = 5;

ALTER DATABASE pubs SET MULTI_USER;
GO

-- Verificacion post-LOG (debe reflejar el estado "bueno" del LOG)
USE pubs;

SELECT * 
FROM roysched 
WHERE title_id = 'PC1035' AND royalty = 16;

SELECT pub_id, city 
FROM publishers 
WHERE pub_id IN ('0877', '1389') AND city = 'CIUDAD ACTUALIZADA';

SELECT title_id, royalty 
FROM roysched 
WHERE title_id = 'PS2106' AND royalty > 10;  -- debe ser >10 tras el +2 del LOG
GO
