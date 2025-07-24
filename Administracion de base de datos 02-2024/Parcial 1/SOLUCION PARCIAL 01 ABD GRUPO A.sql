-- SOLUCION PARCIAL 01 ABD GRUPO A
-- SECCION 01   FECHA: 17/09/2024
-- AUTOR: DIEGO EDUARDO CASTRO 00117322

/*  
    TAREA A.1 Crear un procedimiento almacenado que se encargue de agregar nuevos vehículos. El
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


/*  
    TAREA A.2 Crear un procedimiento almacenado que reciba como parámetro de entrada el id de un
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


/*
     TAREA A.3 Crear una función que reciba como parámetro de entrada el id de una reserva. La
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


/*
     Tarea A.4 Crear un procedimiento almacenado que se encargue de ingresar nuevas reservas. El
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








