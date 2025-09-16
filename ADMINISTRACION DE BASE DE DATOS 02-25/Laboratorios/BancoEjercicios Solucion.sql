USE ABD_Laboratorio1; 
GO

-- Ejercicio 1: Subconsulta aplicada en un WHERE
-- Mostrar la lista de pasajeros que tienen mas puntos de viajero frecuente que el promedio de puntos de todos los pasajeros.
-- Subconsulta del promedio de puntos de todos los pasajeros

SELECT AVG(puntos_viajero_frecuente) 
FROM PASAJERO

-- Consulta utilizando la subconsulta
SELECT id, nombre, identificacion, email
FROM PASAJERO
WHERE puntos_viajero_frecuente > (SELECT AVG(puntos_viajero_frecuente) FROM PASAJERO);

-- Ejercicio 2: Funcion Tabla 
-- Crear funcion tabla para obtener el top 5 de clientes que mas ingresos han generado

CREATE OR ALTER FUNCTION dbo.top_5_clientes()
RETURNS TABLE
AS
RETURN (
    SELECT TOP 5 
        p.nombre AS cliente,
        SUM(r.costo) + ISNULL(SUM(s.precio * e.cantidad), 0) AS ingresos_totales
    FROM PASAJERO p
    INNER JOIN RESERVA r ON p.id = r.id_pasajero
    LEFT JOIN EXTRA e ON r.id = e.id_reserva
    LEFT JOIN SERVICIO s ON e.id_servicio = s.id
    GROUP BY p.nombre
);

-- Consulta para obtener el top 5 de clientes con mas ingresos
SELECT cliente, ingresos_totales
FROM dbo.top_5_clientes()
ORDER BY ingresos_totales DESC;

-- Ejercicio 3: Subconsulta con funcion de agregacion
-- Mostrar toda la informacion de los trenes cuya capacidad sea mayor a 150 pasajeros ordenados de forma descendente.
-- DESAFIO!!! Obtener el valor numerico de la capacidad con una subconsulta.

-- Solucion 1 
SELECT 
    SUBSTRING(T.capacidad, 1, 3) AS capacidad
FROM TREN T
WHERE T.id = 1;

-- Solucion 2
SELECT 
    LEFT(T.capacidad, 3) AS capacidad
FROM TREN T
WHERE T.id = 1;

-- Consulta completa
SELECT id, serie, capacidad
FROM TREN T 
WHERE (SELECT SUBSTRING(capacidad, 1, 3) FROM TREN WHERE id = T.id) > 150
ORDER BY capacidad DESC

-- Ejercicio 4: Funcion escalar en una consulta
-- Crea una funcion escalar que calcule el costo total de una reserva, sumando el costo base del viaje, los servicios y los extras de la misma.
-- Posteriormente mostrar la informacion de la reserva con el nombre del cliente y cuyo costo total sea mayor a $450

CREATE OR ALTER FUNCTION dbo.calcular_total_reserva (@id_reserva INT)
RETURNS MONEY
AS
BEGIN
    DECLARE @costo_total MONEY;
    
	SELECT @costo_total = V.costo_base + ISNULL(SUM(S.precio * E.cantidad), 0)
    FROM RESERVA R
    INNER JOIN VIAJE V ON R.id_viaje = V.id
    LEFT JOIN EXTRA E ON R.id = E.id_reserva
    LEFT JOIN SERVICIO S ON E.id_servicio = S.id
    WHERE R.id = @id_reserva
    GROUP BY V.costo_base;

    RETURN @costo_total;
END;

-- Consulta completa ocupando funcion escalar
SELECT r.id, r.costo, r.fecha_reserva, p.nombre, dbo.calcular_total_reserva(r.id) as total_reserva 
FROM RESERVA r
INNER JOIN PASAJERO p ON p.id = r.id_pasajero
GROUP BY r.id, r.costo, r.fecha_reserva, p.nombre
HAVING dbo.calcular_total_reserva(r.id) > 450

-- Ejercicio 5:
-- Crea una funcion escalar que calcule un descuento para el pasajero en base al numero de reservas que haya realizado. 
-- Si el pasajero ha realizado mas de 3 reservas, se le aplica un 5% de descuento en el costo total de sus reservas. 
-- Mostrar la informacion del pasajero, el costo original, y el costo con descuento ordenado de forma descendente.

CREATE OR ALTER FUNCTION dbo.calcular_descuento (@id_pasajero INT)
RETURNS MONEY
AS
BEGIN
    DECLARE @descuento MONEY = 0;
    DECLARE @num_reservas INT;
    SELECT @num_reservas = COUNT(*) FROM RESERVA WHERE id_pasajero = @id_pasajero;

    IF @num_reservas > 3
    BEGIN
        SET @descuento = 0.05;
    END

    RETURN @descuento;
END;

-- Consulta que muestra la informacion del pasajero, el costo original y el costo con descuento
SELECT p.nombre, r.costo AS costo_original, 
    (r.costo - (r.costo * dbo.calcular_descuento(r.id_pasajero))) AS costo_con_descuento
FROM RESERVA r
INNER JOIN PASAJERO p ON r.id_pasajero = p.id
ORDER BY costo_original DESC

-- Ejercicio 6: Subconsulta como tabla 
-- Mostrar el nombre del pasajero y el costo total de sus reservas, detallando cada uno de los subtotales, unicamente mostrar las reservas donde el costo total sea mayor a 500.
SELECT nombre_pasajero, costo_base, total_servicios, total_extras, costo_total
FROM (
    SELECT P.nombre AS nombre_pasajero,
	V.costo_base AS costo_base ,
	ISNULL(SUM(S.precio), 0) AS total_servicios,
	ISNULL(SUM(E.cantidad), 0) AS total_extras,
	(V.costo_base + ISNULL(SUM(S.precio * E.cantidad), 0)) AS costo_total
    FROM PASAJERO P
    INNER JOIN RESERVA R ON P.id = R.id_pasajero
    INNER JOIN VIAJE V ON R.id_viaje = V.id
    LEFT JOIN EXTRA E ON R.id = E.id_reserva
    LEFT JOIN SERVICIO S ON E.id_servicio = S.id
    GROUP BY P.nombre, V.costo_base
) AS subconsulta 
WHERE costo_total > 500;

-- Ejercicio 7: Proceso almacenado y estructuras de control de flujo
-- Crear un proceso almacenado que solicite el id de un pasajero posteriormente debe verificar si ha realizado 
-- mas de 5 reservas. En caso que si le suma 10 a su puntuacion de viajero frecuente y si no muestra un mensaje indicando que no cuenta con suficientes reservas.

CREATE OR ALTER PROCEDURE sp_Bonificacion_Pasajeros
    @id_pasajero INT
AS
BEGIN
    DECLARE @num_reservas INT;
    SELECT @num_reservas = COUNT(*) FROM RESERVA WHERE id_pasajero = @id_pasajero;

    IF @num_reservas > 5
    BEGIN
        UPDATE PASAJERO
        SET puntos_viajero_frecuente = puntos_viajero_frecuente + 10
        WHERE id = @id_pasajero;
    END
    ELSE
    BEGIN
        PRINT 'El pasajero no cuenta con suficientes reservas.';
    END
END

EXEC sp_Bonificacion_Pasajeros 1;

-- Puntos originales 197
SELECT id, nombre, identificacion, email, puntos_viajero_frecuente FROM PASAJERO WHERE id = 1

-- Ejercicio 8: Funcion Escalar con funcion de fecha
-- Crea una funcion escalar que calcule la edad numerica de un pasajero basada en su fecha de nacimiento.
-- Posteriormente ocupar la funcion para mostrar la informacion del pasajero incluyendo su edad ordenados de mayor a menor.

CREATE OR ALTER FUNCTION dbo.calcular_edad (@fecha_nacimiento DATE)
RETURNS INT
AS
BEGIN
    RETURN DATEDIFF(YEAR, @fecha_nacimiento, GETDATE());
END;

-- Probando la funcion escalar en la consulta
SELECT id, nombre, identificacion, email, puntos_viajero_frecuente,
	dbo.calcular_edad(fecha_nacimiento) as edad
FROM PASAJERO
ORDER BY dbo.calcular_edad(fecha_nacimiento) DESC

-- Ejercicio 9: Procedimiento Almacenado para crear una reserva
-- Crear un procedimiento almacenado para registrar una nueva reserva para un pasajero, dado el id_pasajero, id_viaje, costo, fecha de reserva y id_clase.
CREATE OR ALTER PROCEDURE registrar_reserva
    @id_pasajero INT,
    @id_viaje INT,
    @id_clase INT,
    @costo DECIMAL(18, 2),
    @fecha_reserva DATE
AS
BEGIN
	DECLARE @id_reserva INT;

	SELECT @id_reserva = MAX(id)+1
    FROM RESERVA R

    INSERT INTO RESERVA (id, id_pasajero, id_viaje, id_clase, costo, fecha_reserva)
    VALUES (@id_reserva,@id_pasajero, @id_viaje, @id_clase, @costo, @fecha_reserva);
END;

-- Ejecucion de proceso almacenado
EXEC registrar_reserva 1,1,1,50,'2025-08-20'

-- Comprobar si se agrego la reserva
SELECT * FROM RESERVA ORDER BY id DESC

-- Ejercicio 10: Funcion tabla como una subconsulta
-- Crea una funcion tabla que muestre todos los trenes con un costo base mayor a 30 ordenados de mayor a menor.

CREATE OR ALTER FUNCTION dbo.trenes_costo()
RETURNS TABLE
AS
RETURN (
    SELECT T.id, T.serie, T.capacidad, V.costo_base
    FROM TREN T
    JOIN VIAJE V ON T.id = V.id_tren
    WHERE V.costo_base > 30
);

-- Implementando la funcion como subconsulta
SELECT id, serie, capacidad, costo_base
FROM dbo.trenes_costo()
ORDER BY costo_base DESC

-- Ejercicio 11: Procedimiento almacenado y estructuras de control de flujo 
-- Crear un procedimiento que reciba el id de un pasajero y calcule el costo promedio de sus reservas.

CREATE OR ALTER PROCEDURE sp_calcular_promedio_reservas
    @id_pasajero INT
AS
BEGIN
    DECLARE @promedio_costo MONEY;
	DECLARE @nombre_pasajero VARCHAR(30);

	SELECT @promedio_costo = AVG(r.costo), @nombre_pasajero = p.nombre  
	FROM PASAJERO p 
	INNER JOIN RESERVA r ON r.id_pasajero = p.id
	GROUP BY p.nombre

    IF @promedio_costo IS NULL
    BEGIN
        PRINT 'El pasajero no tiene reservas realizadas.';
    END
    ELSE
    BEGIN
        PRINT 'El costo promedio de las reservas del pasajero ' + @nombre_pasajero + ' es: $' + CAST(@promedio_costo AS VARCHAR(30));
    END
END;

-- Ejemplo de ejecucion
EXEC sp_calcular_promedio_reservas 1;
