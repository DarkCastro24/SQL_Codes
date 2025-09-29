-- EJERCICIOS PROPUESTOS 1, 2, 3 Y 4 PARA PRIMER PARCIAL ABD 02/24 
-- AUTOR: Diego Eduardo Castro 00117322
-- USUARIO DE ORACLE UTILIZADO: SYSTEM -- IMPORTANTE SYS PUEDE DAR PROBLEMAS AL CREAR TRIGGERS
-- LAS TABLAS E INSERSION DE REGISTROS DEBEN REALIZARSE CON UNA CONEXION DE SYSTEM PARA EL EJERCICIO 4

-- EJERCICIO 1 

/* Crear una función que reciba como parámetro el id de una factura la función retornará el subtotal 
   calculado a partir de los platillos consumidos en el servicio */
CREATE OR REPLACE FUNCTION calcular_subtotal_plato(p_id_factura NUMBER) 
RETURN NUMBER IS
    subtotal_plato NUMBER;
BEGIN
    -- Calculamos el subtotal de platos para una factura específica
    SELECT NVL(SUM(P.precio), 0) -- NVL retorna el segundo parametro en caso del primero ser NULL
    INTO subtotal_plato
    FROM FACTURA F
    LEFT JOIN DETALLE_PLATO DP ON DP.ID_FACTURA = F.ID
    LEFT JOIN PLATO P ON P.ID = DP.ID_PLATO
    WHERE F.ID = p_id_factura
    GROUP BY F.ID;
    
    RETURN subtotal_plato; 
END;

-- PROBANDO FUNCIONAMIENTO 
SELECT calcular_subtotal_plato(1) FROM dual;  
SELECT calcular_subtotal_plato(2) FROM dual;  
SELECT calcular_subtotal_plato(3) FROM dual;

/* Crear una función que reciba como parámetro el id de una factura la función retornará el subtotal 
   calculado a partir de los postres consumidos en el servicio. */
CREATE OR REPLACE FUNCTION calcular_subtotal_postre(p_id_factura NUMBER) 
RETURN NUMBER IS
    subtotal_postre NUMBER;
BEGIN
    SELECT NVL(SUM(P.precio),0) -- NVL retorna el segundo parametro en caso del primero ser NULL
    INTO subtotal_postre
    FROM FACTURA F
    LEFT JOIN DETALLE_POSTRE DP ON DP.ID_FACTURA = F.ID
    LEFT JOIN POSTRE P ON P.ID = DP.ID_POSTRE
    WHERE F.ID = p_id_factura
    GROUP BY F.ID;
    
    RETURN subtotal_postre; 
END;

-- PROBANDO FUNCIONAMIENTO
SELECT calcular_subtotal_postre(4) FROM dual;  
SELECT calcular_subtotal_postre(5) FROM dual;  
SELECT calcular_subtotal_postre(6) FROM dual;  

-- EJERCICIO 2

/* Crear una función que reciba como parámetros valores que representan dos fechas, el tipo de dato 
   debe ser DATE. La función retornará la lista de facturas registradas en la base de datos en el rango 
   de fechas definidos como parámetros. El resultado debe incluir el subtotal de platos, el subtotal de 
   postres y el total (suma del subtotal de platos + subtotal de postres).  */
   
CREATE OR REPLACE TYPE INFORMACION_FACTURA AS OBJECT (
    id NUMBER,
    fecha DATE,
    id_cliente NUMBER,
    id_restaurante NUMBER,
    subtotal_plato NUMBER,
    subtotal_postre NUMBER,
    total NUMBER
);

-- Creamos el tipo de tabla para contener multiples facturas
CREATE OR REPLACE TYPE INFORMACION_FACTURA_TABLA AS TABLE OF INFORMACION_FACTURA;

CREATE OR REPLACE FUNCTION obtener_facturas_con_subtotales(
    fecha_inicio DATE,
    fecha_fin DATE
) 
RETURN INFORMACION_FACTURA_TABLA AS -- La funcion retornara una tabla
    facturas INFORMACION_FACTURA_TABLA;
BEGIN
    -- SELECT para recolectar los datos en la tabla de facturas creada anteriormente
    SELECT INFORMACION_FACTURA(
               F.ID,
               F.fecha,
               F.id_cliente,
               F.id_restaurante,
               calcular_subtotal_plato(F.ID),
               calcular_subtotal_postre(F.ID), 
               calcular_subtotal_plato(F.ID) + calcular_subtotal_postre(F.ID)
           )
    BULK COLLECT INTO facturas 
    FROM FACTURA F
    WHERE F.fecha BETWEEN fecha_inicio AND fecha_fin  -- Filtrado por el rango de fechas
    ORDER BY F.ID;

    -- Retornamos la tabla con el resultado
    RETURN facturas;
END;

-- Probando la funcion que retorna la tabla con la conversion explicita de fechas
SELECT * FROM TABLE(obtener_facturas_con_subtotales(TO_DATE('01/01/2022', 'DD/MM/YYYY'), TO_DATE('30/01/2022', 'DD/MM/YYYY')));

-- EJERCICIO 3 

/* Crear un procedimiento almacenado que reciba como parámetros el id de un restaurante (INT), y dos fechas (VARCHAR2). 
   El procedimiento deberá hacer uso de la función creada en el ejercicio 2 para poder obtener las ganancias de un 
   restaurante específico en un rango de fechas, luego, se deberá recorrer el resultado de la consulta con un cursor para 
   imprimir su contenido en consola. El procedimiento deberá hacer uso correcto de cursores y bloques TRY/CATCH para realizar el procesamiento de datos.
*/

CREATE OR REPLACE PROCEDURE obtener_ganancias_restaurante(
    p_id_restaurante INT,
    p_fecha_inicio VARCHAR2,
    p_fecha_fin VARCHAR2
) 
IS
    -- Creamos el cursor y le asignamos la consulta que va a contener 
    CURSOR facturas_cursor IS
        SELECT F.ID, F.fecha, calcular_subtotal_plato(F.ID) + calcular_subtotal_postre(F.ID) AS total
        FROM FACTURA F
        WHERE 
            F.id_restaurante = p_id_restaurante
            AND F.fecha BETWEEN TO_DATE(p_fecha_inicio, 'DD/MM/YYYY') AND TO_DATE(p_fecha_fin, 'DD/MM/YYYY')
        ORDER BY F.ID; 
    -- Variables a utilizar al recorrer el cursor
    v_id_factura NUMBER;
    v_fecha DATE;
    v_total NUMBER;
    num_rows NUMBER;
BEGIN
    -- Abrimos el cursor y contamos cuantas facturas hay contiene (es el numero de filas)
    OPEN facturas_cursor;
    SELECT COUNT(*) INTO num_rows FROM (SELECT * FROM FACTURA F WHERE F.id_restaurante = p_id_restaurante 
    AND F.fecha BETWEEN TO_DATE(p_fecha_inicio, 'DD/MM/YYYY') AND TO_DATE(p_fecha_fin, 'DD/MM/YYYY'));
    
    -- Imprimimos el encabezado del resultado en consola
    DBMS_OUTPUT.PUT_LINE('Las facturas registradas del restaurante "mauris" son: ');
    DBMS_OUTPUT.PUT_LINE('--------------------------------------------------');
    
    -- Recorremos el cursor con LOOP
    LOOP
        -- Asignamos cada columna del cursor dentro de las variables creadas anteriormente 
        FETCH facturas_cursor INTO v_id_factura, v_fecha, v_total;
        EXIT WHEN facturas_cursor%NOTFOUND;

        -- Imprimir el contenido en la consola DBMS
        DBMS_OUTPUT.PUT_LINE('id factura: ' || v_id_factura || ', fecha: ' || v_fecha || ', TOTAL: $' || v_total);
    END LOOP;
    
    -- Mostramos el numero de facturas procesadas
    DBMS_OUTPUT.PUT_LINE('--------------------------------------------------');
    DBMS_OUTPUT.PUT_LINE('Total de facturas procesadas: ' || num_rows);

    -- Cerramos el cursor
    CLOSE facturas_cursor;
-- Bloque de excepciones TRY CATCH
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
        ROLLBACK; -- Revertimos los cambios en caso que se ejecute la excepcion 
END;

-- Probamos el funcionamiento del proceso almacenado
BEGIN
    obtener_ganancias_restaurante(1, '01/01/2022', '30/06/2022');
END;

-- EJERCICIO 4 
CREATE OR REPLACE TRIGGER CHECK_ESTACION_PLATO
BEFORE INSERT ON DETALLE_PLATO
FOR EACH ROW
DECLARE
    v_estacion_factura VARCHAR2(25);
    v_estacion_plato VARCHAR2(25);
    v_fecha_factura DATE;
BEGIN
    -- Obtener la fecha de la factura que se quiere ingresar con la tabla NEW
    SELECT F.fecha INTO v_fecha_factura 
    FROM FACTURA F 
    WHERE F.ID = :NEW.ID_FACTURA;

    -- Determinamos la estacion de la factura basada en el rango de fechas del enunciado (solo hay registros del año 2022)
    IF v_fecha_factura BETWEEN TO_DATE('21/03/2022', 'DD/MM/YYYY') AND TO_DATE('21/06/2022', 'DD/MM/YYYY') THEN
        v_estacion_factura := 'primavera';
    ELSIF v_fecha_factura BETWEEN TO_DATE('22/06/2022', 'DD/MM/YYYY') AND TO_DATE('23/09/2022', 'DD/MM/YYYY') THEN
        v_estacion_factura := 'verano';
    ELSIF v_fecha_factura BETWEEN TO_DATE('24/09/2022', 'DD/MM/YYYY') AND TO_DATE('21/12/2022', 'DD/MM/YYYY') THEN
        v_estacion_factura := 'otoño';
    ELSE
        v_estacion_factura := 'invierno';
    END IF;

    -- Obtenemos la estacion del plato a traves de su menu 
    SELECT M.estacion INTO v_estacion_plato 
    FROM PLATO P
    JOIN MENU M ON P.ID_MENU = M.ID
    WHERE P.ID = :NEW.ID_PLATO;

    -- Comparamos que las estaciones de la factura y la del plato no sean diferentes (si es el caso mostramos mensaje de validacion)
    IF v_estacion_factura != v_estacion_plato THEN
        RAISE_APPLICATION_ERROR(-20001, 'ERROR: La estación del plato y la temporada de la factura no coinciden...');
    END IF;
END;


/* PROBANDO EL FUNCIONAMIENTO DEL TRIGGER CON NUEVAS INSERCIONES */

-- Creando una factura y plato de VERANO
INSERT INTO FACTURA (id, fecha, id_cliente, id_restaurante)
VALUES (31, TO_DATE('30/06/2022', 'DD/MM/YYYY'), 1, 1);

-- Insertando un plato de VERANO en la factura de verano
INSERT INTO DETALLE_PLATO (id_factura, id_plato)
VALUES (31, 12);  -- Funciona porque el plato 12 pertenece al menu de verano y la fecha de la factura tambien

-- Creando una factura de verano pero con plato de primavera
INSERT INTO FACTURA (id, fecha, id_cliente, id_restaurante)
VALUES (32, TO_DATE('30/06/2022', 'DD/MM/YYYY'), 1, 1);

INSERT INTO DETALLE_PLATO (id_factura, id_plato)
VALUES (32, 1);  -- Falla porque el plato 1 es de primavera y la fecha de la factura es de verano.

-- Borrando los registros agregados para probar el trigger
DELETE FROM DETALLE_PLATO WHERE ID_FACTURA = 31;
DELETE FROM DETALLE_PLATO WHERE ID_FACTURA = 32;
DELETE FROM FACTURA WHERE ID = 31;
DELETE FROM FACTURA WHERE ID = 32;













