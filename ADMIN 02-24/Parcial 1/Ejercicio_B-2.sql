/* 
   EJERCICIO B-2 Crear una función que reciba como parámetros dos fechas, la función retornará la lista 
   de servicios extra ordenados por popularidad para las fechas ingresadas. Para calcular este 
   indicador, el índice de popularidad de los servicios estará basado en el porcentaje de adquisición de los servicios extra en cada reserva. 
*/

CREATE OR REPLACE TYPE popularidad_obj IS OBJECT (
    servicio VARCHAR2(30),
    total_adquisiciones NUMBER,
    popularidad NUMBER
);

CREATE OR REPLACE TYPE popularidad_tb IS TABLE OF popularidad_obj;

CREATE OR REPLACE FUNCTION extras_populares(
    p_fecha_inicio TIMESTAMP,
    p_fecha_fin TIMESTAMP
) RETURN popularidad_tb PIPELINED IS
BEGIN
    FOR rec IN (
        SELECT s.servicio , COUNT(e.id_servicio) AS total_adquisiciones, ROUND((COUNT(e.id_servicio) * 100 / (SELECT COUNT(*) FROM EXTRA)), 2) AS popularidad
        FROM EXTRA e
        JOIN SERVICIO s ON s.id = e.id_servicio
        JOIN RESERVA r ON r.id = e.id_reserva
        WHERE r.fecha_reservada BETWEEN p_fecha_inicio AND p_fecha_fin
        GROUP BY s.servicio
        ORDER BY popularidad DESC, total_adquisiciones DESC
    ) LOOP
        PIPE ROW (popularidad_obj(rec.servicio, rec.total_adquisiciones, rec.popularidad));
    END LOOP;
    
    RETURN;
END;

-- Probando la funcion
SELECT * FROM TABLE(extras_populares(TO_TIMESTAMP('2023-01-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS'),TO_TIMESTAMP('2024-12-31 23:59:59', 'YYYY-MM-DD HH24:MI:SS')));

