-- TAREA A.1 
/*  
Crear un procedimiento almacenado que se encargue de agregar nuevos vehículos. El
procedimiento almacenado recibirá como parámetros de entrada todos los datos necesarios para
ingresar un nuevo vehículo. Se deberá validar que el id de modelo, el id de tipo de vehículo y el id
del cliente sean identificadores que existen en la base de datos. En caso de que un identificador no
exista se deberá lanzar una excepción personalizada.    
*/

CREATE OR REPLACE PROCEDURE nuevo_vehiculo(
    v_id IN INT,
    v_id_modelo IN INT,
    v_id_cliente IN INT,
    v_id_tipo IN INT,
    v_color IN INT,
    v_annio IN CHAR,
    v_comentarios IN VARCHAR2
) AS
    -- Variable auxiliar para realizar las validaciones 
    v_contador INT;
    -- Creamos las excepciones personalizadas 
    modelo_excepcion EXCEPTION;
    cliente_excepcion EXCEPTION;
    tipo_excepcion EXCEPTION;
BEGIN
    -- Validamos que el modelo ingresado exista
    SELECT COUNT(*) INTO v_contador
    FROM MODELO
    WHERE id = v_id_modelo;
    
    IF v_contador = 0 THEN
        RAISE modelo_excepcion;
    END IF;
    
    -- Validamos que el cliente ingresado exista
    SELECT COUNT(*) INTO v_contador
    FROM CLIENTE
    WHERE id = v_id_cliente;
    
    IF v_contador = 0 THEN
        RAISE cliente_excepcion;
    END IF;
    
    -- Validamos que el tipo de vehiculo exista 
    SELECT COUNT(*) INTO v_contador
    FROM TIPO_VEHICULO
    WHERE id = v_id_tipo;
    
    IF v_contador = 0 THEN
        RAISE tipo_excepcion;
    END IF;
    
    -- Si pasamos todas las validaciones ingresamos el nuevo registro utilizando los parametros 
    INSERT INTO VEHICULO (id, id_modelo, id_cliente, id_tipo, color, annio, comentarios)
    VALUES (v_id, v_id_modelo, v_id_cliente, v_id_tipo, v_color, v_annio, v_comentarios);
    
-- Manejo de excepciones personalizadas
EXCEPTION
    WHEN modelo_excepcion THEN
        RAISE_APPLICATION_ERROR(-20001, 'El modelo ingresado no existe.');
    WHEN cliente_excepcion THEN
        RAISE_APPLICATION_ERROR(-20002, 'El cliente ingresado no existe.');
    WHEN tipo_excepcion THEN
        RAISE_APPLICATION_ERROR(-20003, 'El tipo de vehículo ingresado no existe.');
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20004, 'Ocurrio un error al agregar el vehiculo: ' || SQLERRM);
END nuevo_vehiculo;


-- PROBANDO EXCEPCIONES (APLICANDO VALIDACION ID DE MODELO NO EXISTE)
BEGIN
    nuevo_vehiculo(51,33,5,2,1,'2024','Vehículo nuevo, sin daños');
END;

-- PROBANDO EXCEPCIONES (APLICANDO VALIDACION ID DE CLIENTE NO EXISTE)
BEGIN
    nuevo_vehiculo(51,3,55,2,1,'2024','Vehículo nuevo, sin daños');
END;

-- PROBANDO EXCEPCIONES (APLICANDO VALIDACION ID DE TIPO DE VEHICULO NO EXISTE)
BEGIN
    nuevo_vehiculo(51,3,5,200,1,'2024','Vehículo nuevo, sin daños');
END;

-- PROBANDO PROCESO ALMACENADO (FUNCIONA INSERCION)
BEGIN
    nuevo_vehiculo(54,3,5,2,1,'2014','Aire helando rico');
END;

-- VERIFICAMOS EL VEHICULO SE INGRESO 
SELECT * FROM VEHICULO WHERE ID = 54;

-- TAREA A.2
/*  
Crear un procedimiento almacenado que reciba como parámetro de entrada el id de un
empleado. El procedimiento almacenado deberá retornar la cantidad de reservas en las que el
empleado ha sido asignado responsable. Considerar todos los datos disponibles en el banco de
datos.  
*/

CREATE OR REPLACE PROCEDURE cantidad_reservas_empleado(
    v_id_empleado IN INT,
    v_reservas_asignadas OUT INT
) AS
BEGIN
    -- Obtenemos la cantidad de reservas de las que el empleado es responsable
    SELECT NVL(COUNT(*), 0)
    INTO v_reservas_asignadas
    FROM RESERVA
    WHERE id_empleado_responsable = v_id_empleado;

    -- Imprimimos el id del empleado y la cantidad de reservas que tiene asignadas
    DBMS_OUTPUT.PUT_LINE('El empleado con el id ' || v_id_empleado || ' cuenta con ' || v_reservas_asignadas || ' reservas asignadas.');
END cantidad_reservas_empleado;

-- PROBANDO FUNCIONAMIENTO 
DECLARE
    v_reservas_asignadas INT;
BEGIN
    cantidad_reservas_empleado(10, v_reservas_asignadas); 
END;

-- TAREA A.3 
/*
Crear una función que reciba como parámetro de entrada el id de una reserva. La
función deberá calcular si se trata de una reserva express. Para definir si una reserva es express,
debe existir una diferencia de 1 día entre la columna ‘fecha_transaccion’ y la columna
‘fecha_reservada’. La función deberá retornar un valor booleano TRUE en caso de que la reserva
sea express. En caso contrario la función retornará el valor FALSE.
*/

CREATE OR REPLACE FUNCTION reserva_express(
    v_id_reserva IN INT
) RETURN BOOLEAN IS
    -- Variables para almacenar las fechas y los dias de diferencia
    v_fecha_transaccion DATE;
    v_fecha_reservada DATE;
    v_dias_diferencia INT;
BEGIN
    -- Obtenemos las fechas de la reserva con id ingresado como parametro 
    SELECT fecha_transaccion, fecha_reservada
    INTO v_fecha_transaccion, v_fecha_reservada
    FROM RESERVA
    WHERE id = v_id_reserva;
    
    -- Calculamos la diferencia en dias entre fecha transaccion y fecha reservada
    v_dias_diferencia := v_fecha_reservada - v_fecha_transaccion;

    -- Si la diferencia es de un dia es reserva express y retornamos TRUE sino FALSE
    IF v_dias_diferencia = 1 THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END reserva_express;

-- PROBANDO LA FUNCION (RESERVA EXPRESS) FECHAS: 01/04/24 --> 02/04/24
BEGIN
    IF reserva_express(2) THEN
        DBMS_OUTPUT.PUT_LINE('La reserva es express.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('La reserva no es express.');
    END IF;
END;

-- PROBANDO LA FUNCION (RESERVA NO EXPRESS) FECHAS: 01/04/24 --> 08/04/24
BEGIN
    IF reserva_express(10) THEN
        DBMS_OUTPUT.PUT_LINE('La reserva es express.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('La reserva no es express.');
    END IF;
END;

-- Tarea A.4 
/*
Crear un procedimiento almacenado que se encargue de ingresar nuevas reservas. El
procedimiento deberá recibir todos los parámetros de entrada necesarios para ingresar una nueva
reserva con datos consistentes. El empleado responsable deberá ser asignado aleatoriamente. Como
aclaración, la columna “fecha transacción” indica la fecha y hora que el cliente realizó la reserva en
la aplicación móvil; la columna “fecha reservada” es la fecha y hora que el cliente desea recibir el
servicio; y la columna “fecha servicio aplicado” es la fecha y hora real en la que se atenderá la
reserva por lo que el procedimiento asignará siempre un valor nulo a este campo. Validar que la
“fecha reservada” no sea más antigua que la “fecha transacción”.
*/

CREATE OR REPLACE PROCEDURE insertar_reserva(
    v_id_reserva IN INT,           
    v_id_vehiculo IN INT,
    v_fecha_transaccion IN TIMESTAMP,
    v_fecha_reservada IN TIMESTAMP
) AS
    v_id_empleado_responsable INT;
    v_total_empleados INT;
    excepcion_fecha EXCEPTION;
BEGIN
    -- Validamos que la fecha reservada no sea mas antigua que la fecha de transaccion
    IF v_fecha_reservada < v_fecha_transaccion THEN
        RAISE excepcion_fecha;
    END IF;

    -- Obtener la cantidad total de empleados disponibles
    SELECT COUNT(*) INTO v_total_empleados
    FROM EMPLEADO;
    
    -- Obtenemos el id de un empleado aleatorio
    SELECT id INTO v_id_empleado_responsable
    FROM (SELECT id FROM EMPLEADO ORDER BY DBMS_RANDOM.VALUE) WHERE ROWNUM = 1;

    -- Ingresamos la nueva reserva con los parametros ingresados, con el id del empleado aleatorio como responsable y la fecha de servicio con un valor de NULL
    INSERT INTO RESERVA (id, id_vehiculo, id_empleado_responsable, fecha_transaccion, fecha_reservada, fecha_servicio_aplicado)
    VALUES (v_id_reserva, v_id_vehiculo, v_id_empleado_responsable, v_fecha_transaccion, v_fecha_reservada, NULL);

    -- Mostramos un mensaje de confirmacion en consola
    DBMS_OUTPUT.PUT_LINE('Se registro la nueva reserva con el id ' || v_id_reserva || ' , para el vehículo con id ' || v_id_vehiculo || ' y el empleado con id: ' || v_id_empleado_responsable || ' fue asignado como el responsable.');
    
EXCEPTION
    -- Manejo de la excepcion personalizada
    WHEN excepcion_fecha THEN
        RAISE_APPLICATION_ERROR(-20001, 'La fecha reservada no puede ser anterior a la fecha de transaccion.');
    
    -- Manejo de excepciones generales 
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20002, 'Ocurrio un error al ingresar la nueva reserva: ' || SQLERRM);
END insertar_reserva;


-- PROBANDO EL PROCESO ALMACENADO (PROBANDO EXCEPCION POR FECHA INVALIDA)
BEGIN
    insertar_reserva(800,22,SYSTIMESTAMP,SYSTIMESTAMP - INTERVAL '1' DAY);
END;

-- PROBANDO EL PROCESO ALMACENADO (SI FUNCIONA PORQUE LA FECHA ES CORRECTA)
BEGIN
    insertar_reserva(800,22,SYSTIMESTAMP,SYSTIMESTAMP + INTERVAL '2' DAY);
END;

-- COMPROBANDO QUE LA RESERVA FUE INGRESADA 
SELECT * FROM RESERVA WHERE id = 800;

-- BORRANDO LA RESERVA INGRESADA PREVIAMENTE 
DELETE FROM RESERVA WHERE id = 800;


-- Tarea B.1.
/*
Crear una función que reciba como parámetro de entrada dos fechas, la función 
retornará la lista de reservas disponibles en esas dos fechas, además, la función agregará una 
columna calculada que representa el total de ganancia por cada una de las reservas. Para calcular el 
total de una reserva se debe considerar el precio del servicio principal (lavado de automóvil) que 
depende del tipo de vehículo (este dato está disponible en la tabla TIPO_VEHICULO) y la suma de 
todos los servicios extra incluidos en la reserva respectiva. Se debe considerar que no todas las 
reservas incluyen servicios extra.
*/
CREATE OR REPLACE TYPE fila_reserva_ganancia AS OBJECT(
    id_reserva INT,
    fecha_reservada DATE,
    id_vehiculo INT,
    precio_lavado NUMBER(6, 2),
    total_servicios_extra NUMBER(6, 2),
    total_ganancia NUMBER(6, 2)
);

CREATE OR REPLACE TYPE tabla_reserva_ganancia AS TABLE OF fila_reserva_ganancia;

CREATE OR REPLACE FUNCTION reservas_con_ganancia
    (fecha_inicio DATE, fecha_fin DATE)
RETURN tabla_reserva_ganancia
AS
    reservas tabla_reserva_ganancia := tabla_reserva_ganancia();
BEGIN
    SELECT fila_reserva_ganancia(R.id, R.fecha_reservada, V.id, T.precio_lavado, NVL(SUM(S.precio), 0), (T.precio_lavado + NVL(SUM(S.precio), 0)))
    BULK COLLECT INTO reservas
    FROM RESERVA R
    INNER JOIN VEHICULO V ON R.id_vehiculo = V.id
    INNER JOIN TIPO_VEHICULO T ON V.id_tipo = T.id
    LEFT JOIN EXTRA E ON R.id = E.id_reserva
    LEFT JOIN SERVICIO S ON E.id_servicio = S.id
    WHERE TRUNC(R.fecha_reservada) BETWEEN fecha_inicio AND fecha_fin
    GROUP BY R.id, R.fecha_reservada, V.id, T.precio_lavado
    ORDER BY R.fecha_reservada;
    
    RETURN reservas;
END;

SELECT * FROM TABLE(reservas_con_ganancia(DATE '2024-04-01', DATE '2024-09-15')); -- 754 Resultados

SELECT COUNT(*) FROM RESERVA; -- 754 Resultados

---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------

-- Tarea B.2.
/*
Crear una función que reciba como parámetros dos fechas, la función retornará la lista 
de servicios extra ordenados por popularidad para las fechas ingresadas. Para calcular este 
indicador, el índice de popularidad de los servicios estará basado en el porcentaje de adquisición de 
los servicios extra en cada reserva.
*/
CREATE OR REPLACE PROCEDURE servicios_populares (
    fecha_inicio IN DATE,
    fecha_fin IN DATE
)
IS
    v_resultado SYS_REFCURSOR;
    v_servicio SERVICIO.servicio%TYPE;
    v_total NUMBER;
    v_porcentaje_popularidad NUMBER;
    x NUMBER := 0;
BEGIN
    OPEN v_resultado FOR
    SELECT s.servicio, COUNT(e.id_servicio) AS total, ROUND((COUNT(e.id_servicio) * 100) / (SELECT COUNT(*) FROM RESERVA r WHERE r.fecha_reservada BETWEEN fecha_inicio AND fecha_fin), 2) AS porcentaje_popularidad
    FROM EXTRA e
    JOIN SERVICIO s ON e.id_servicio = s.id
    JOIN RESERVA r ON e.id_reserva = r.id
    WHERE r.fecha_reservada BETWEEN fecha_inicio AND fecha_fin
    GROUP BY s.servicio
    ORDER BY porcentaje_popularidad DESC;
    
    LOOP
        FETCH v_resultado INTO v_servicio, v_total, v_porcentaje_popularidad;
        EXIT WHEN v_resultado%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Servicio: ' || v_servicio || ', Total: ' || v_total || ', Popularidad: ' || v_porcentaje_popularidad || '%');
        x := x + v_total;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('Total de servicios: ' || x);
    CLOSE v_resultado;
END;

SET SERVEROUTPUT ON;

BEGIN
    servicios_populares(DATE '2024-04-01', DATE '2024-09-15'); -- Suma de totales de servicios 951
END;

SELECT COUNT(*) FROM EXTRA; -- 951 Resulatdos


-- TAREA C.1.
/*
Luego de realizar un análisis del tiempo tomado en realizar las tareas, se llegó a la 
conclusión de que, para realizar un servicio eficiente, lo recomendable es que cada cliente pueda 
realizar un máximo de 5 ediciones de datos por cada vehículo de su propiedad, para ello, crear un 
Trigger que valide que solo existan 5 actualizaciones por vehículo al día. Si un cliente intenta 
exceder el límite establecido, el trigger deberá lanzar una excepción personalizada.
Para cumplir con el caso, este ejemplo utiliza una tabla auxiliar.
*/

CREATE TABLE registro_actualizacion_vehiculo (id_vehiculo INT, fecha DATE);

CREATE OR REPLACE TRIGGER check_carinfo_update
BEFORE UPDATE
ON VEHICULO
FOR EACH ROW
DECLARE
    id_v INT;
    cuenta_actualizaciones INT;
BEGIN 
    -- Obteniendo el id de vehículo que se intenta actualizar 
    id_v := :NEW.id;
    -- Contando la cantidad de actualizaciones del dia 
    SELECT COUNT(*) 
    INTO cuenta_actualizaciones
    FROM  registro_actualizacion_vehiculo 
    WHERE id_vehiculo = id_v
        AND TRUNC(fecha) = TRUNC(SYSDATE);
    -- Si la cuenta es menos a 5 se registra la actualización
    IF cuenta_actualizaciones < 5 THEN
        INSERT INTO registro_actualizacion_vehiculo 
        VALUES (id_v, SYSDATE);
        DBMS_OUTPUT.PUT_LINE('Update ok...');
    ELSE 
        RAISE_APPLICATION_ERROR(-20000, 'ERROR : Numero máximo de actualizaciones alcanzadas para este vehículo. ');
    END IF;
END;

SET SERVEROUTPUT ON;
-- Ejecutar la siguiente consulta 6 veces. Debe fallar en la sexta vez.
UPDATE VEHICULO SET COMENTARIOS = 'Ejemplo de trigger' WHERE id = 1;
SELECT * FROM VEHICULO;

DROP TRIGGER check_carinfo_update;
-- TAREA C.2.
/*
Crear un Trigger que valide que cada vez que se cree una nueva reserva y se asigne un 
empleado responsable de esa reserva, el empleado no tenga asignada una reserva en la fecha y hora 
en la que se intenta crear la nueva reserva. Si no se cumple la condición el trigger deberá lanzar una 
excepción personalizada
*/

CREATE OR REPLACE TRIGGER check_booking_employee
BEFORE INSERT
ON RESERVA
FOR EACH ROW
DECLARE
    id_emp INT;
    fecha_de_reserva TIMESTAMP;
    contador INT;
BEGIN 
    fecha_de_reserva := :NEW.fecha_reservada;
    id_emp := :NEW.id_empleado_responsable;
    
    contador := 0;
    
    SELECT COUNT(*) 
    INTO contador 
    FROM RESERVA 
    WHERE fecha_reservada = fecha_de_reserva 
        AND id_empleado_responsable = id_emp;
    
    IF contador != 0 THEN
        RAISE_APPLICATION_ERROR(-20000, 'ERROR : No se puede asignar el responsable a la reserva');
    END IF;
    
END;

SELECT * FROM RESERVA;

-- La siguiente reserva debe fallar (es la reserva 1 con id diferente pero tiene el mismo empleado y hora.
INSERT INTO RESERVA 
VALUES(1000,7,12,TO_TIMESTAMP('2024-04-01 02:35:59', 'YYYY-MM-DD HH24:MI:SS'),TO_TIMESTAMP('5-4-2024 14:30:00', 'DD-MM-YYYY HH24:MI:SS'),TO_TIMESTAMP('5/4/2024 14:38', 'DD-MM-YYYY HH24:MI:SS'));
-- Si a la reserva anterior se le cambia el empleado
INSERT INTO RESERVA 
VALUES(1000,7,10,TO_TIMESTAMP('2024-04-01 02:35:59', 'YYYY-MM-DD HH24:MI:SS'),TO_TIMESTAMP('5-4-2024 14:30:00', 'DD-MM-YYYY HH24:MI:SS'),TO_TIMESTAMP('5/4/2024 14:38', 'DD-MM-YYYY HH24:MI:SS'));


/*
-- TAREA C.3.
A la gerencia del negocio le interesa saber el índice de eficiencia de la gestión del 
tiempo que se tiene cuando se atienden las reservas, por lo tanto, se desea implementar un 
procedimiento almacenado que reciba como parámetros dos números enteros, el primer parámetro 
representa un mes y el segundo parámetro representa un año. El procedimiento almacenado debe 
calcular el promedio de tiempo de retraso (en minutos) que ha tenido cada empleado durante el mes 
ingresado como parámetro. Para poder realizar este cálculo, en la tabla RESERVA, se encuentra un 
campo “fecha reservada” que incluye la fecha y hora reservada para que un cliente reciba un 
servicio; la columna “fecha_servicio_aplicado” contiene la fecha y hora real en la que se atendió la 
reserva. Luego de realizar este cálculo, el procedimiento almacenado mostrará en consola el 
empleado con menos tiempo de retraso en los servicios ofrecidos.
*/
CREATE OR REPLACE PROCEDURE empleadomaseficiente (
    mm INT,
    yy INT
)  
IS
    menor_promedio FLOAT;
    empleado_id INT;
    empleado_nombre VARCHAR2(64);
BEGIN
    -- Ejecuta la consulta y obtiene el menor promedio de minutos junto con el id y el nombre del empleado
    SELECT promedio_minutos, id, nombre
    INTO menor_promedio, empleado_id, empleado_nombre
    FROM (
        SELECT R.id_empleado_responsable, E.id, E.nombre, 
               ROUND(AVG(EXTRACT(MINUTE FROM  ( R.fecha_servicio_aplicado - R.fecha_reservada))), 2)  AS promedio_minutos
        FROM RESERVA R
        INNER JOIN EMPLEADO E
            ON E.id = R.id_empleado_responsable
        WHERE EXTRACT(MONTH FROM R.fecha_reservada) = mm 
          AND EXTRACT(YEAR FROM R.fecha_reservada) = yy
        GROUP BY R.id_empleado_responsable, E.id, E.nombre
        ORDER BY promedio_minutos ASC
    )
    WHERE ROWNUM = 1; -- Selecciona solo el primer resultado (el menor)

    DBMS_OUTPUT.PUT_LINE('El menor promedio de minutos es: ' || menor_promedio || 'minutos');
    DBMS_OUTPUT.PUT_LINE('Empleado ID: ' || empleado_id);
    DBMS_OUTPUT.PUT_LINE('Empleado Nombre: ' || empleado_nombre);
END;

SET SERVEROUTPUT ON;

EXEC empleadomaseficiente(4, 2024);

