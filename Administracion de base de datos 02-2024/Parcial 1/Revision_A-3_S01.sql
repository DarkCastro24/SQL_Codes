-- REVISION EJERCICIOS A-3 SECCION 01
-- REVISADO POR: DIEGO EDUARDO CASTRO 00117322

-- AGUILAR GARCIA GABRIEL EDUARDO (EJERCICIO CORRECTO)
SELECT * FROM RESERVA WHERE id = 3;
SELECT extract(day from (fecha_reservada - fecha_transaccion)) as diferencia FROM RESERVA where id = 3;

CREATE OR REPLACE FUNCTION reservas_express 
	(Id_reserva INT)
RETURN VARCHAR2 
AS
    diferencia INT;
BEGIN
	SELECT extract(day from (fecha_reservada - fecha_transaccion)) 
    INTO diferencia
    FROM RESERVA where id = Id_reserva;
    
    IF diferencia = 1 THEN
        RETURN 'TRUE';
    ELSE
        RETURN 'FALSE';
    END IF;
END;

SELECT reservas_express(2) Reserva_express FROM DUAL; 
-- AGREGO PARA PROBAR EL OTRO CASO Castro
SELECT reservas_express(68) Reserva_express FROM DUAL; 

-- CACERES CAMPOS JAVIER ALEJANDRO (EJERCICIO CORRECTO)
CREATE OR REPLACE FUNCTION es_express(id_reserva NUMBER) 
RETURN BOOLEAN 
IS
    v_transaction_date DATE;
    v_reserved_date DATE;
    v_days_diff NUMBER;
    is_express BOOLEAN := FALSE;
BEGIN
    SELECT fecha_transaccion, fecha_reservada
    INTO  v_transaction_date, v_reserved_date
    FROM RESERVA
    WHERE id = id_reserva;
    v_days_diff := v_reserved_date - v_transaction_date;
    IF v_days_diff >= 1 THEN
        is_express := TRUE;
    END IF;
    RETURN is_express;
END;

SELECT es_express(1) AS EXPRESS; // Retorna 1 (TRUE) puesto que cumple la condicion
SELECT es_express(68) AS EXPRESS;

-- ECHEVERRIA CUELLAR STEPHANIE ARACELY (EJERCICIO CORRECTO)
CREATE OR REPLACE FUNCTION reserva_express(p_id_reserva IN NUMBER) 
RETURN BOOLEAN IS
    v_fecha_transaccion DATE;
    v_fecha_reservada DATE;
BEGIN
    SELECT TRUNC(fecha_transaccion), TRUNC(fecha_reservada)
    INTO v_fecha_transaccion, v_fecha_reservada
    FROM reserva
    WHERE id = p_id_reserva;

    IF v_fecha_reservada - v_fecha_transaccion = 1 THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20001, 'La reserva no existe');
END;

-- AGREGO ESTO PARA PROBAR LA FUNCION Castro 
SELECT reserva_express(1) AS EXPRESS;
SELECT reserva_express(68) AS EXPRESS;


-- ESPINOZA DE LEON CHRISTIAN GABRIEL (EJERCICIO CORRECTO)
SELECT EXTRACT (DAY FROM fecha_reservada)- EXTRACT (DAY FROM fecha_transaccion)
        FROM Reserva

CREATE OR REPLACE FUNCTION reserva_express
        (reserva_id INT)
    RETURN INT
    AS
        res_express INT;
        dif INT;
    BEGIN
        SELECT EXTRACT (DAY FROM fecha_reservada)- EXTRACT (DAY FROM fecha_transaccion)
        INTO dif FROM Reserva WHERE id = reserva_id;
        IF dif = 1 OR dif = -1
        THEN res_express := 1;
        RETURN res_express;
        ELSE
        res_express := 0;
        RETURN res_express;
        END IF;
END;
        
SELECT id, reserva_express(id) express FROM Reserva;

/*IMPORTANTE
1 significa TRUE y 0 es FALSO
BOOLEAN dio problemas*/

-- GARCIA ALFARO DIEGO BENJAMIN (EJERCICIO CORRECTO)
create or replace function reservaExpress (idReserva number)
return boolean
is
    new_date_transaccion date;
    new_date_reserva date;
begin
    select to_date(cast(fecha_transaccion as date), 'DD-MM-YY'), to_date(cast(fecha_reservada as date), 'DD-MM-YY')
    into new_date_transaccion, new_date_reserva
    from reserva where id = idReserva;
    
    if extract(day from to_date(new_date_reserva) - 1) = extract(day from to_date(new_date_transaccion)) then
                return true;
            end if;
            
    return false;
end;

select reservaExpress(1);
-- AGREGO PARA PROBAR EL OTRO CASO: Castro 
select reservaExpress(68);

-- GONZALEZ CARDOZA JORGE EDUARDO (EJERCICIO INCOMPLETO)
CREATE OR REPLACE FUNCTION is_express(ID_R IN INTEGER)
RETURN BOOLEAN
IS DIFERENCIA INTEGER;
BEGIN
    SELECT EXTRACT(DAY FROM DIFER) INTO DIFERENCIA FROM (SELECT (FECHA_RESERVADA - FECHA_TRANSACCION) DIFER FROM RESERVA WHERE ID = ID_R);
    IF DIFERENCIA = 1 THEN
        RETURN TRUE;
    END IF;
    RETURN FALSE;
END;

-- AGREGO PARA PROBAR FUNCIONAMIENTO: Castro
SELECT is_express(1) AS EXPRESS; -- Reserva 1 es EXPRESS
SELECT is_express(68) AS EXPRESS; -- Reserva 68 es EXPRESS

-- NO IDENTIFICA CORRECTAMENTE LOS CASOS DE RESERVA EXPRESS
SELECT id, is_express(id) express FROM Reserva;

-- HERNANDEZ MILAN JOSE LUIS (EJERCICIO CORRECTO)
CREATE OR REPLACE FUNCTION es_reserva_express(
    p_id_reserva IN NUMBER
) RETURN BOOLEAN IS
    v_fecha_transaccion DATE;
    v_fecha_reservada DATE;
BEGIN
    SELECT fecha_transaccion, fecha_reservada
    INTO v_fecha_transaccion, v_fecha_reservada
    FROM reserva
    WHERE id = p_id_reserva;

    IF TRUNC(v_fecha_reservada) - TRUNC(v_fecha_transaccion) = 1 THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN FALSE;
END es_reserva_express;


/*
Prueba en caso 1, donde la fecha de transaccion es 27/04/24 06:32:37.000000000 PM y la fecha de reserva es
28/04/24 08:00:00.000000000 AM teniendo un dia de diferencia
*/
SELECT es_reserva_express(236) FROM DUAL;

/*
Prueba en caso de FALSE, donde la fecha de transaccion es 27/04/24 10:49:15.000000000 AM y la fecha de reserva es
29/04/24 08:00:00.000000000 AM, teniendo mas de un dia de diferencia
*/
SELECT es_reserva_express(231) FROM DUAL;

-- HERRERA TAMAYO FERNANDO YAEL (EJERCICIO CORRECTO)
CREATE OR REPLACE FUNCTION reserva_express (n1 INT)
RETURN BOOLEAN
IS
    diferencia_dias INT;
BEGIN
    SELECT TRUNC(fecha_reservada) - TRUNC(fecha_transaccion)
    INTO diferencia_dias
    FROM RESERVA
    WHERE id = n1;
    
    IF diferencia_dias = 1 THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END;

SELECT reserva_express (68) FROM DUAL;
--ejemplo con id 1 y 2

-- AGREGO PRUEBA PARA EL OTRO CASO Castro
SELECT reserva_express (1) FROM DUAL;

-- DIEGO ALEJANDRO IRAHETA MONTERROSA (EJERCICIO CORRECTO)
CREATE OR REPLACE FUNCTION tareaA3(id_solicitado int)
RETURN BOOLEAN
AS
confirmacion BOOLEAN;
dia_transaccion int;
dia_reserva int;
BEGIN
    SELECT EXTRACT(DAY FROM R.fecha_transaccion) INTO dia_transaccion FROM RESERVA R WHERE R.ID = id_solicitado;
    SELECT EXTRACT(DAY FROM R.fecha_reservada) INTO dia_reserva FROM RESERVA R WHERE R.ID = id_solicitado;
    IF dia_reserva - dia_transaccion = 1 THEN
        confirmacion := TRUE;
    ELSE
        confirmacion:= FALSE;
    END IF;
    RETURN confirmacion;
END;

SELECT * FROM RESERVA;

SELECT tareaA3(196) confirmacion from dual;
SELECT tareaA3(194) confirmacion from dual;

-- MEJIA MARROQUIN DIEGO ENRIQUE (EJERCICIO INCOMPLETO)
CREATE OR REPLACE FUNCTION es_reserva_express(p_id_reserva IN INT)
RETURN BOOLEAN
IS
    v_fecha_transaccion TIMESTAMP;
    v_fecha_reservada TIMESTAMP;
    v_diferencia INTERVAL DAY TO SECOND;
BEGIN

    SELECT fecha_transaccion, fecha_reservada
    INTO v_fecha_transaccion, v_fecha_reservada
    FROM RESERVA
    WHERE id = p_id_reserva;

    v_diferencia := v_fecha_reservada - v_fecha_transaccion;

    IF v_diferencia = INTERVAL '1' DAY THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
   
        RETURN FALSE;
    WHEN OTHERS THEN
    
        RETURN FALSE;
END;

-- PROBADNO SI FUNCIONA (TODOS LOS RESULTADOS SON 0)
SELECT id, es_reserva_express(id) express FROM Reserva;

-- MORALES PINEDA ALEXANDER EFRAIN (EJERCICIO CORRECTO)
CREATE OR REPLACE FUNCTION reservaExpress(idReserva INT)
RETURN BOOLEAN
AS 
    isReservaExpress BOOLEAN := FALSE;
    daysDiff INT;
BEGIN
    SELECT EXTRACT(DAY FROM CAST(FECHA_RESERVADA AS DATE)) - EXTRACT(DAY FROM CAST(FECHA_TRANSACCION AS DATE)) INTO daysDiff FROM RESERVA WHERE ID = idReserva;
    IF daysDiff = 1 THEN
        isReservaExpress := TRUE;
    ELSE 
        isReservaExpress := FALSE;
    END IF;
    RETURN isReservaExpress;
END;

-- Probar función
SELECT RESERVAEXPRESS(385) FROM DUAL;
-- PROBANDO EL OTRO CASO: Castro
SELECT RESERVAEXPRESS(68) FROM DUAL;


-- PARADA MIRA CRISTIAN FERNANDO (EJERCICIO CORRECTO)
CREATE OR REPLACE FUNCTION get_reservation_type (reserva_id INT)
    RETURN BOOLEAN
IS 
    reserva_express BOOLEAN;
    fecha_t DATE;
    fecha_r DATE;
    diferencia_dia INT;
BEGIN

    SELECT fecha_transaccion,fecha_reservada 
    INTO fecha_t, fecha_r
    FROM RESERVA 
    WHERE id = reserva_id;
    
    SELECT fecha_r - fecha_t into diferencia_dia from dual;

    IF (diferencia_dia != 1) THEN
        reserva_express := FALSE;
    ELSE 
        reserva_express := TRUE;
    END IF;
    
    RETURN reserva_express;
END;
--Prueba aqui
SELECT * FROM RESERVA where id = 399 or id = 2;

SELECT get_reservation_type(1);
SELECT get_reservation_type(68);

-- MARCELO RIVERA SOTO (EJERCICIO CORRECTO)
CREATE OR REPLACE FUNCTION es_reserva_express(p_id_reserva RESERVA.id%TYPE)
RETURN BOOLEAN
IS
    v_diferencia_dias NUMBER;
BEGIN
    SELECT TRUNC(RS.FECHA_RESERVADA) - TRUNC(RS.FECHA_TRANSACCION)
    INTO v_diferencia_dias
    FROM RESERVA RS
    WHERE id = p_id_reserva;

    IF v_diferencia_dias = 1 THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('La reserva no existe.');
        RETURN FALSE;
END es_reserva_express;

SELECT * FROM RESERVA RS WHERE ES_RESERVA_EXPRESS(RS.ID);

-- AGREGO PARA PROBAR LOS DOS CASOS: Castro
SELECT es_reserva_express(1);
SELECT es_reserva_express(68);

-- RODRIGUEZ CRUZ CRISTIAN MAURICIO (EJERCICIO CORRECTO)
CREATE OR REPLACE FUNCTION F_es_reserva_express(p_id_reserva NUMBER)
RETURN BOOLEAN
IS
    v_fecha_transaccion RESERVA.fecha_transaccion%TYPE;
    v_fecha_reservada RESERVA.fecha_reservada%TYPE;
    v_diferencia_dias NUMBER;
BEGIN
    SELECT fecha_transaccion, fecha_reservada
    INTO v_fecha_transaccion, v_fecha_reservada
    FROM RESERVA
    WHERE id = p_id_reserva;
    
    v_diferencia_dias := TRUNC(v_fecha_reservada) - TRUNC(v_fecha_transaccion);
    
    IF v_diferencia_dias = 1 THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;

END;

select F_es_reserva_express(2) as express;
-- PROBANDO EL OTRO ESCENARIO Castro
select F_es_reserva_express(1) as express;

-- SANCHEZ LEONARD GERMAN ABRAHAM (EJERCICIO CORRECTO)
CREATE OR REPLACE TYPE tipo_reserva_rapida AS OBJECT (
    id_reserva INT,
    es_rapida INT  -- Usamos INT para representar TRUE (1) o FALSE (0)
);

-- Crear el tipo de tabla para almacenar los objetos de tipo_reserva_rapida
CREATE OR REPLACE TYPE tabla_reserva_rapida AS TABLE OF tipo_reserva_rapida;

-- Crear la función para verificar si una reserva específica es express
CREATE OR REPLACE FUNCTION verificar_reserva_rapida_por_id(p_id_reserva IN INT)
RETURN tabla_reserva_rapida PIPELINED
IS
    v_id_reserva RESERVA.id%TYPE;
    v_fecha_transaccion RESERVA.fecha_transaccion%TYPE;
    v_fecha_reservada RESERVA.fecha_reservada%TYPE;
BEGIN
    -- Obtenemos la reserva específica
    SELECT id, fecha_transaccion, fecha_reservada
    INTO v_id_reserva, v_fecha_transaccion, v_fecha_reservada
    FROM RESERVA
    WHERE id = p_id_reserva;

    
    IF TRUNC(v_fecha_reservada) - TRUNC(v_fecha_transaccion) = 1 THEN
        
        PIPE ROW (tipo_reserva_rapida(v_id_reserva, 1));
    ELSE
        -- Si no es express, retornamos 0
        PIPE ROW (tipo_reserva_rapida(v_id_reserva, 0));
    END IF;
    
EXCEPTION
    
    WHEN NO_DATA_FOUND THEN
        
        PIPE ROW (tipo_reserva_rapida(p_id_reserva, 0));
END;

SELECT * FROM TABLE(verificar_reserva_rapida_por_id(222));
-- PROBANDO EL OTRO CASO Castro
SELECT * FROM TABLE(verificar_reserva_rapida_por_id(1));

-- TOVAR JOVEL CESAR ISAAC (EJERCICIO INCOMPLETO)
CREATE OR REPLACE FUNCTION f_reserva (id_reserva INT)
RETURN BOOLEAN
IS
    fecha_transaccion TIMESTAMP;
    fecha_reservada TIMESTAMP;
BEGIN
    SELECT fecha_transaccion, fecha_reservada
    INTO fecha_transaccion, fecha_reservada
    FROM reserva
    WHERE id_reserva = reserva.id;
    IF (fecha_reservada - fecha_transaccion = 1) THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END;

-- PRUEBO EL FUNCIONAMIENTO DE AMBOS CASOS Castro (Ambos casos retornan 0)
select f_reserva(1) as express;
select f_reserva(68) as express;

-- MOSTRANDO TODOS LOS RETORNOS QUE REALIZA LA FUNCION (Todos son 0)
SELECT id, f_reserva(id) express FROM Reserva;


-- VIDES ZAVALA PABLO ENRIQUE (EJERCICIO CORRECTO)
CREATE OR REPLACE FUNCTION checkReservaExpress
    (
        id_reserva NUMBER
    )
RETURN BOOLEAN IS
   fechaTransc TIMESTAMP;
    fechaReserva TIMESTAMP;
    diferencia NUMBER;
BEGIN
    SELECT R.FECHA_TRANSACCION, R.FECHA_RESERVADA
    INTO fechaTransc, fechaReserva FROM RESERVA R WHERE R.ID = id_reserva;
    SELECT EXTRACT(DAY FROM (fechaReserva-fechaTransc)) INTO diferencia FROM dual;
    IF diferencia = 1 THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END;

SELECT * FROM RESERVA;

SELECT checkReservaExpress(376) FROM dual;
-- Probando el otro caso
SELECT checkReservaExpress(1) FROM dual;

