/*
LABORATORIO 5 - COPIAS DE SEGURIDAD EN SQL SERVER
BASE DE DATOS: PUBS
FECHA DE CREACIÓN: 04/11/2025

Este laboratorio contiene TRES CLAVES DE EJERCICIOS PRÁCTICOS que abordan
los diferentes tipos de restauración disponibles en SQL Server. Cada clave se 
enfoca en un conjunto distinto de tablas del esquema PUBS.

Cada ejercicio contempla los tres tipos de restauración:
1) Restauración Completa (FULL)
2) Restauración Diferencial (DIFFERENTIAL)
3) Restauración Punto en Tiempo (LOG)

PRERREQUISITOS:
- Base de datos PUBS instalada y funcional.
- Carpeta C:\backups\ existente.
- Permisos administrativos para ejecutar BACKUP y RESTORE.

IMPORTANTE:
- Los escenarios de pérdida de datos deben simularse mediante UPDATE o DELETE.
- Los comandos deben reflejar cambios evidentes en las tablas afectadas.
- Al inicio de tu entregable indica tu nombre completo y número de carnet.

ENTREGABLES:
1) Documento Word o PDF con capturas de todo el proceso.
2) Script .sql con todos los comandos ejecutados.
*/

USE master;
GO

/* ============================================================================ */
/* CLAVE 1: Restauración con tablas AUTHORS y TITLES */
/* ============================================================================ */

/*
ENUNCIADO CLAVE 1 (mejorado):
Diseñe y ejecute una estrategia de recuperación completa para las tablas AUTHORS y TITLES.
Simule distintos escenarios de pérdida de datos y recupere la información aplicando, en orden,
una restauración FULL, una restauración DIFFERENTIAL y una restauración mediante LOG (PITR).
*/

-- CONFIGURACIÓN INICIAL 
ALTER DATABASE pubs SET RECOVERY FULL;
GO

-- BACKUP FULL INICIAL
BACKUP DATABASE pubs 
TO DISK = 'C:\backups\pubs_CLAVE1_FULL.bak'
WITH INIT, COMPRESSION, STATS = 5;
GO

-- ESCENARIO 1: RESTAURACIÓN FULL (simular daño)
USE pubs;
UPDATE authors SET au_lname = 'CORRUPTO', contract = 0;
UPDATE titles SET price = 0, royalty = 0;
DELETE FROM titleauthor WHERE au_id IN (SELECT TOP 5 au_id FROM authors);

-- Verificación del daño
SELECT COUNT(*) AS autores_corruptos FROM authors WHERE au_lname = 'CORRUPTO';
SELECT COUNT(*) AS titulos_cero FROM titles WHERE price = 0;

-- Restauración FULL
USE master;
ALTER DATABASE pubs SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
RESTORE DATABASE pubs FROM DISK = 'C:\backups\pubs_CLAVE1_FULL.bak'
WITH REPLACE, RECOVERY, STATS = 5;
ALTER DATABASE pubs SET MULTI_USER;
GO

-- Verificación post-FULL
USE pubs;
SELECT COUNT(*) AS autores_recuperados FROM authors WHERE au_lname != 'CORRUPTO';
SELECT COUNT(*) AS titulos_recuperados FROM titles WHERE price > 0;
SELECT COUNT(*) AS relaciones_recuperadas FROM titleauthor;
GO

-- PREPARACIÓN PARA DIFFERENTIAL Y LOG (nuevos cambios)
INSERT INTO authors (au_id, au_lname, au_fname, phone, contract)
VALUES ('111-11-1111', 'Gonzalez', 'Ana', '555-1111', 1),
       ('222-22-2222', 'Martinez', 'Luis', '555-2222', 1);

INSERT INTO titles (title_id, title, type, pub_id, price, pubdate)
VALUES ('CLV1001', 'Guía Avanzada SQL', 'business', '1389', 45.99, GETDATE());

INSERT INTO titleauthor (au_id, title_id, au_ord, royaltyper)
VALUES ('111-11-1111', 'CLV1001', 1, 60),
       ('222-22-2222', 'CLV1001', 2, 40);

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

-- ESCENARIO 2: RESTAURACIÓN DIFFERENTIAL (simular pérdida de lo recién agregado)
USE pubs;
DELETE FROM titleauthor WHERE title_id = 'CLV1001';
DELETE FROM titles WHERE title_id = 'CLV1001';
DELETE FROM authors WHERE au_id IN ('111-11-1111', '222-22-2222');

-- Restauración DIFFERENTIAL
USE master;
ALTER DATABASE pubs SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
RESTORE DATABASE pubs FROM DISK = 'C:\backups\pubs_CLAVE1_FULL.bak'
WITH NORECOVERY, REPLACE, STATS = 5;
RESTORE DATABASE pubs FROM DISK = 'C:\backups\pubs_CLAVE1_DIFF.bak'
WITH RECOVERY, STATS = 5;
ALTER DATABASE pubs SET MULTI_USER;
GO

-- Verificación post-DIFFERENTIAL
USE pubs;
SELECT * FROM authors WHERE au_id IN ('111-11-1111', '222-22-2222');
SELECT * FROM titles WHERE title_id = 'CLV1001';
SELECT * FROM titleauthor WHERE title_id = 'CLV1001';
GO

-- ESCENARIO 3: RESTAURACIÓN LOG (PITR)
USE pubs;
DELETE FROM authors WHERE au_id = '333-33-3333';
UPDATE authors SET contract = 0 WHERE state = 'CA';

-- Restauración LOG
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

-- Verificación post-LOG
USE pubs;
SELECT * FROM authors WHERE au_id = '333-33-3333';
SELECT COUNT(*) AS contratos_CA FROM authors WHERE state = 'CA' AND contract = 1;
SELECT title_id, price FROM titles WHERE type = 'popular_comp' AND price > 20;
GO


/* ============================================================================ */
/* CLAVE 2: Restauración con tablas SALES y STORES */
/* ============================================================================ */

/*
ENUNCIADO CLAVE 2 (mejorado):
Implemente un plan integral de recuperación para las tablas SALES y STORES.
Genere evidencia de pérdida de información (ventas y tiendas) y restáurela aplicando
los tres tipos de restauración: FULL, DIFFERENTIAL y LOG.
*/

-- CONFIGURACIÓN INICIAL
USE master;
ALTER DATABASE pubs SET RECOVERY FULL;
GO

-- BACKUP FULL INICIAL
BACKUP DATABASE pubs 
TO DISK = 'C:\backups\pubs_CLAVE2_FULL.bak'
WITH INIT, COMPRESSION, STATS = 5;
GO

-- ESCENARIO 1: RESTAURACIÓN FULL (simular daño)
USE pubs;
UPDATE stores SET stor_name = 'TIENDA CORRUPTA';
DELETE FROM sales WHERE qty > 20;
UPDATE sales SET payterms = 'CORRUPTO' WHERE ord_num LIKE 'P%';

-- Verificación del daño
SELECT COUNT(*) AS tiendas_corruptas FROM stores WHERE stor_name = 'TIENDA CORRUPTA';
SELECT COUNT(*) AS ventas_corruptas FROM sales WHERE payterms = 'CORRUPTO';
SELECT COUNT(*) AS ventas_grandes_borradas FROM sales WHERE qty > 20; -- debería ser 0 tras el DELETE

-- Restauración FULL
USE master;
ALTER DATABASE pubs SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
RESTORE DATABASE pubs FROM DISK = 'C:\backups\pubs_CLAVE2_FULL.bak'
WITH REPLACE, RECOVERY, STATS = 5;
ALTER DATABASE pubs SET MULTI_USER;
GO

-- Verificación post-FULL
USE pubs;
SELECT COUNT(*) AS tiendas_recuperadas FROM stores WHERE stor_name != 'TIENDA CORRUPTA';
SELECT COUNT(*) AS ventas_sanas FROM sales WHERE payterms != 'CORRUPTO';
GO

-- PREPARACIÓN PARA DIFFERENTIAL Y LOG
USE pubs;
INSERT INTO stores (stor_id, stor_name, stor_address, city, state, zip)
VALUES ('TEST1', 'Tienda Test 1', '123 Calle Principal', 'San Francisco', 'CA', '94101'),
       ('TEST2', 'Tienda Test 2', '456 Avenida Central', 'Berkeley', 'CA', '94704');

INSERT INTO sales (stor_id, ord_num, ord_date, qty, payterms, title_id)
VALUES ('TEST1', 'TESTORDER1', GETDATE(), 50, 'Net 30', 'BU1032'),
       ('TEST2', 'TESTORDER2', GETDATE(), 25, 'Net 60', 'PS2091');

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
UPDATE stores SET stor_address = 'Dirección Actualizada' WHERE stor_id = '7131';

-- BACKUP LOG
USE master;
BACKUP LOG pubs 
TO DISK = 'C:\backups\pubs_CLAVE2_LOG.trn'
WITH INIT, COMPRESSION, STATS = 5;
GO

-- ESCENARIO 2: RESTAURACIÓN DIFFERENTIAL (simular pérdida de lo recién agregado)
USE pubs;
DELETE FROM sales WHERE ord_num IN ('TESTORDER1', 'TESTORDER2');
DELETE FROM stores WHERE stor_id IN ('TEST1', 'TEST2');

-- Restauración DIFFERENTIAL
USE master;
ALTER DATABASE pubs SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
RESTORE DATABASE pubs FROM DISK = 'C:\backups\pubs_CLAVE2_FULL.bak'
WITH NORECOVERY, REPLACE, STATS = 5;
RESTORE DATABASE pubs FROM DISK = 'C:\backups\pubs_CLAVE2_DIFF.bak'
WITH RECOVERY, STATS = 5;
ALTER DATABASE pubs SET MULTI_USER;
GO

-- Verificación post-DIFFERENTIAL
USE pubs;
SELECT * FROM stores WHERE stor_id IN ('TEST1', 'TEST2');
SELECT * FROM sales WHERE ord_num IN ('TESTORDER1', 'TESTORDER2');
GO

-- ESCENARIO 3: RESTAURACIÓN LOG (PITR)
USE pubs;
DELETE FROM sales WHERE ord_num = 'LOGORDER1';
UPDATE sales SET qty = 1 WHERE stor_id IN ('6380', '7066');
UPDATE stores SET stor_address = 'DIRECCIÓN ERRÓNEA' WHERE stor_id = '7131';

-- Restauración LOG
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

-- Verificación post-LOG
USE pubs;
SELECT * FROM sales WHERE ord_num = 'LOGORDER1';
SELECT stor_id, qty FROM sales WHERE stor_id IN ('6380', '7066') AND qty > 10;
SELECT stor_id, stor_address FROM stores WHERE stor_id = '7131' AND stor_address = 'Dirección Actualizada';
GO


/* ============================================================================ */
/* CLAVE 3: Restauración con tablas PUBLISHERS y ROYSCHED */
/* ============================================================================ */

/*
ENUNCIADO CLAVE 3 (mejorado):
Elabore una estrategia de recuperación para las tablas PUBLISHERS y ROYSCHED.
Simule incidentes de modificación y eliminación, y restablezca la información
aplicando los tres tipos de restauración: FULL, DIFFERENTIAL y LOG.
*/

-- CONFIGURACIÓN INICIAL
USE master;
ALTER DATABASE pubs SET RECOVERY FULL;
GO

-- BACKUP FULL INICIAL
BACKUP DATABASE pubs 
TO DISK = 'C:\backups\pubs_CLAVE3_FULL.bak'
WITH INIT, COMPRESSION, STATS = 5;
GO

-- ESCENARIO 1: RESTAURACIÓN FULL (simular daño)
USE pubs;
UPDATE publishers SET pub_name = 'EDITORIAL CORRUPTA';
DELETE FROM roysched WHERE royalty > 15;
UPDATE roysched SET royalty = 0 WHERE lorange = 0;

-- Verificación del daño
SELECT COUNT(*) AS editoriales_corruptas FROM publishers WHERE pub_name = 'EDITORIAL CORRUPTA';
SELECT COUNT(*) AS royalty_cero FROM roysched WHERE royalty = 0;

-- Restauración FULL
USE master;
ALTER DATABASE pubs SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
RESTORE DATABASE pubs FROM DISK = 'C:\backups\pubs_CLAVE3_FULL.bak'
WITH REPLACE, RECOVERY, STATS = 5;
ALTER DATABASE pubs SET MULTI_USER;
GO

-- Verificación post-FULL
USE pubs;
SELECT COUNT(*) AS editoriales_recuperadas FROM publishers WHERE pub_name != 'EDITORIAL CORRUPTA';
SELECT COUNT(*) AS royalty_alto FROM roysched WHERE royalty > 15;
GO

-- PREPARACIÓN PARA DIFFERENTIAL Y LOG
USE pubs;
INSERT INTO publishers (pub_id, pub_name, city, state, country)
VALUES ('9900', 'Nueva Editorial Tech', 'San Jose', 'CA', 'USA'),
       ('9901', 'Libros Modernos SA', 'Austin', 'TX', 'USA');

INSERT INTO roysched (title_id, lorange, hirange, royalty)
VALUES ('BU1032', 50001, 75000, 20),
       ('PS2091', 30001, 50000, 18);

-- BACKUP DIFFERENTIAL
USE master;
BACKUP DATABASE pubs 
TO DISK = 'C:\backups\pubs_CLAVE3_DIFF.bak'
WITH DIFFERENTIAL, COMPRESSION, STATS = 5;
GO

-- Cambios para LOG
USE pubs;
UPDATE publishers SET city = 'CIUDAD ACTUALIZADA' WHERE pub_id IN ('0877', '1389');
INSERT INTO roysched (title_id, lorange, hirange, royalty)
VALUES ('PC1035', 10001, 20000, 16);
UPDATE roysched SET royalty = royalty + 2 WHERE title_id = 'PS2106';

-- BACKUP LOG
USE master;
BACKUP LOG pubs 
TO DISK = 'C:\backups\pubs_CLAVE3_LOG.trn'
WITH INIT, COMPRESSION, STATS = 5;
GO

-- ESCENARIO 2: RESTAURACIÓN DIFFERENTIAL (simular pérdida de lo recién agregado)
USE pubs;
DELETE FROM publishers WHERE pub_id IN ('9900', '9901');
DELETE FROM roysched WHERE title_id IN ('BU1032', 'PS2091') AND royalty IN (20, 18);

-- Restauración DIFFERENTIAL
USE master;
ALTER DATABASE pubs SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
RESTORE DATABASE pubs FROM DISK = 'C:\backups\pubs_CLAVE3_FULL.bak'
WITH NORECOVERY, REPLACE, STATS = 5;
RESTORE DATABASE pubs FROM DISK = 'C:\backups\pubs_CLAVE3_DIFF.bak'
WITH RECOVERY, STATS = 5;
ALTER DATABASE pubs SET MULTI_USER;
GO

-- Verificación post-DIFFERENTIAL
USE pubs;
SELECT * FROM publishers WHERE pub_id IN ('9900', '9901');
SELECT * FROM roysched WHERE title_id IN ('BU1032', 'PS2091') AND royalty IN (20, 18);
GO

-- ESCENARIO 3: RESTAURACIÓN LOG (PITR)
USE pubs;
DELETE FROM roysched WHERE title_id = 'PC1035' AND royalty = 16;
UPDATE publishers SET city = 'CIUDAD ERRÓNEA' WHERE pub_id IN ('0877', '1389');
UPDATE roysched SET royalty = 10 WHERE title_id = 'PS2106';

-- Restauración LOG
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

-- Verificación post-LOG
USE pubs;
SELECT * FROM roysched WHERE title_id = 'PC1035' AND royalty = 16;
SELECT pub_id, city FROM publishers WHERE pub_id IN ('0877', '1389') AND city = 'CIUDAD ACTUALIZADA';
SELECT title_id, royalty FROM roysched WHERE title_id = 'PS2106' AND royalty > 10;
GO


/* Script opcional de limpieza (descomentar si se desea)
-- EXEC xp_cmdshell 'DEL "C:\backups\pubs_CLAVE*.bak"';
-- EXEC xp_cmdshell 'DEL "C:\backups\pubs_CLAVE*.trn"';
*/
