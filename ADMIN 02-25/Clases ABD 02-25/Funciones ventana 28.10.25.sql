/*
-- Clase ABD 28/10/2025
-- Tema: Windows Functions (Funciones Ventana)

	Descripción:
	Las funciones ventana permiten realizar cálculos sobre un conjunto 
	de filas relacionadas (una "ventana") sin agrupar los datos, 
	manteniendo el detalle de cada registro. 
	Sirven para obtener rankings, acumulados, promedios móviles y 
	comparaciones entre filas, entre otros análisis.

	Comandos y funciones más usados:
	 - OVER(): define la ventana sobre la cual se aplica el cálculo.
	 - PARTITION BY: divide los datos en grupos dentro de la ventana.
	 - ORDER BY: establece el orden para calcular los valores.
	 - ROW_NUMBER(): asigna un número consecutivo a cada fila.
	 - RANK(): genera un ranking con agregando en el contador el numero de empates (si hay 3 empates en el ranking 2 el siguiente no sera 3 si no 5).
	 - DENSE_RANK(): ranking manteniendo el correlativo (aunque hayan 3 empatados en la posicion 2 el siguiente sigue siendo 3)
	 - LAG() / LEAD(): acceden al valor anterior o siguiente.
	 - SUM() / AVG() OVER(): acumulados o promedios sin agrupar.

	Ejemplo de aplicación:
	Usadas para analizar ventas, generar rankings por editorial, 
	comparar trimestres o calcular ingresos acumulados sin perder 
	detalle de cada registro.
*/

USE pubs;

-- Agregación básica: libros vendidos
SELECT t.title_id, t.title,
    SUM(s.qty) AS copiasVendidas
FROM titles t
JOIN sales s ON t.title_id = s.title_id
GROUP BY t.title_id, t.title
ORDER BY copiasVendidas DESC;
GO

-- Total vendido y rankings (ROW_NUMBER, RANK, DENSE_RANK)
SELECT t.title_id, t.title,
    SUM(s.qty) AS copiasVendidas,
    SUM(s.qty * t.price) AS totalVendido,
    ROW_NUMBER() OVER (ORDER BY SUM(s.qty * t.price) DESC) AS ranking1,
    RANK() OVER (ORDER BY SUM(s.qty * t.price) DESC) AS ranking2,
    DENSE_RANK() OVER (ORDER BY SUM(s.qty * t.price) DESC) AS ranking3
FROM titles t
JOIN sales s ON t.title_id = s.title_id
GROUP BY t.title_id, t.title
ORDER BY totalVendido DESC;
GO

-- Ranking de ventas por editorial
SELECT p.pub_id, p.pub_name,
    SUM(s.qty) AS copiasVendidas
FROM publishers p
JOIN titles t ON p.pub_id = t.pub_id
JOIN sales s ON t.title_id = s.title_id
GROUP BY p.pub_id, p.pub_name
ORDER BY copiasVendidas;
GO

-- Con total vendido (Con ranking de las que mas vendieron)
SELECT p.pub_id, p.pub_name,
    SUM(s.qty) AS copiasVendidas,
	rank() over(order by SUM(s.qty * t.price) desc )as totalVendido
FROM publishers p
JOIN titles t ON p.pub_id = t.pub_id
JOIN sales s ON t.title_id = s.title_id
GROUP BY p.pub_id, p.pub_name
ORDER BY copiasVendidas;
GO

-- Ranking de libros por editorial
SELECT p.pub_name, t.title, SUM(s.qty) AS copiasVendidas,
    SUM(s.qty * t.price) AS totalVendido,
    RANK() OVER (PARTITION BY p.pub_name ORDER BY SUM(s.qty) DESC) AS ranking
FROM publishers p
JOIN titles t ON p.pub_id = t.pub_id
JOIN sales s ON t.title_id = s.title_id
GROUP BY p.pub_name, t.title
ORDER BY p.pub_name;
GO

-- Ingreso total por editorial
SELECT p.pub_name, t.title,
    SUM(s.qty * t.price) AS totalVendido,
    SUM(SUM(s.qty * t.price)) OVER (PARTITION BY p.pub_name) AS ingresoEditorial
FROM publishers p
JOIN titles t ON p.pub_id = t.pub_id
JOIN sales s ON t.title_id = s.title_id
GROUP BY p.pub_name, t.title
ORDER BY p.pub_name;
GO

-- Promedio de regalías por autor
SELECT a.au_id,a.au_fname, a.au_lname, AVG(t.royalty) AS promedioRegalia,
    DENSE_RANK() OVER (ORDER BY AVG(t.royalty) DESC) AS ranking
FROM authors a
JOIN titleauthor ta ON a.au_id = ta.au_id
JOIN titles t ON ta.title_id = t.title_id
GROUP BY a.au_id, a.au_fname, a.au_lname
ORDER BY ranking;
GO

-- Evolucion de ventas por trimestre
-- CTE
WITH ventas_trimestrales AS (
    SELECT 
        DATEPART(YEAR, s.ord_date) AS anio,
        DATEPART(QUARTER, s.ord_date) AS trimestre,
        SUM(s.qty * t.price) AS ingreso
    FROM titles t 
    JOIN sales s ON t.title_id = s.title_id
    GROUP BY 
        DATEPART(YEAR, s.ord_date),
        DATEPART(QUARTER, s.ord_date)
)
SELECT anio, trimestre, ingreso,
    SUM(ingreso) OVER (PARTITION BY anio ORDER BY trimestre) AS acumulado,
    LAG(ingreso) OVER (ORDER BY anio, trimestre) AS venta_anterior,
    ingreso - LAG(ingreso) OVER (ORDER BY anio, trimestre) AS diferencia
FROM ventas_trimestrales
ORDER BY anio, trimestre;
GO

-- Desempeño por tienda
SELECT st.stor_id, st.stor_name, COUNT(DISTINCT s.ord_num) AS numeroPedidos,
    SUM(s.qty) AS copias,
    SUM(s.qty * t.price) AS ventaTotal,
    RANK() OVER (ORDER BY SUM(s.qty * t.price) DESC) AS ranking
FROM stores st
JOIN sales s ON st.stor_id = s.stor_id
JOIN titles t ON s.title_id = t.title_id
GROUP BY st.stor_id, st.stor_name
ORDER BY ranking;
GO

-- Evolución de ventas por trimestre
WITH ventas_trimestrales AS (
    SELECT 
        DATEPART(YEAR, s.ord_date) AS anio,
        DATEPART(QUARTER, s.ord_date) AS trimestre,
        SUM(s.qty * t.price) AS ingreso
    FROM sales s
    JOIN titles t ON s.title_id = t.title_id
    GROUP BY DATEPART(YEAR, s.ord_date), DATEPART(QUARTER, s.ord_date)
)
SELECT 
    anio,
    trimestre,
    ingreso,
    SUM(ingreso) OVER (PARTITION BY anio ORDER BY trimestre) AS acumulado,
    LAG(ingreso) OVER (ORDER BY anio, trimestre) AS venta_t_anterior,
    ingreso - LAG(ingreso) OVER (ORDER BY anio, trimestre) AS diferencia
FROM ventas_trimestrales
ORDER BY anio, trimestre;
GO
