-- REVISION EJERCICIOS A-1 SECCION 01
-- REVISADO POR: DIEGO EDUARDO CASTRO 00117322

-- DE LEON FLORES MARIA FERNANDA (EJERCICIO COMPLETO)
CREATE OR REPLACE PROCEDURE Nuevo_Vehiculo (
    v_id IN INT,
    modelo_id IN INT, 
    cliente_id IN INT,
    tipo_id IN INT,
    n_color IN INT,
    n_annio IN CHAR,
    n_comentario IN VARCHAR
)
IS 
    modelo_v INT;
    cliente_v INT;
    tipo_v INT;
    
BEGIN
    -- Ver si modelo existe
    SELECT COUNT(*)
    INTO modelo_v
    FROM MODELO
    WHERE id = modelo_id;

    -- Excepción
    IF modelo_v = 0 THEN
        DBMS_OUTPUT.PUT_LINE('ERROR: El Id de modelo no es válido');
        RETURN;
    END IF;

    -- Ver si cliente existe
    SELECT COUNT(*)
    INTO cliente_v
    FROM CLIENTE
    WHERE id = cliente_id;

    -- Excepción
    IF cliente_v = 0 THEN
        DBMS_OUTPUT.PUT_LINE('ERROR: El Id de cliente no es válido');
        RETURN;
    END IF;

    -- Ver si el tipo de vehículo existe
    SELECT COUNT(*)
    INTO tipo_v
    FROM TIPO_VEHICULO
    WHERE id = tipo_id;

    -- Excepción
    IF tipo_v = 0 THEN
        DBMS_OUTPUT.PUT_LINE('ERROR: El Id de tipo no es válido');
        RETURN;
    END IF;

    INSERT INTO VEHICULO (id, id_modelo, id_cliente, id_tipo, color, annio, comentarios)
    VALUES (v_id, modelo_id, cliente_id, tipo_id, n_color, n_annio, n_comentario);   
END;

-- Ejecución
-- IMPORTANTE: al ejecutar se muestra un lenguaje de error, pero si se inserta el nuevo registro en la tabla
BEGIN
	Nuevo_Vehiculo (55, 19, 20, 3, 7, 2020, 'null'); --Datos de prueba
END;

-- Comprobar la insercion de los nuevos registros
SELECT * FROM VEHICULO WHERE ID = 55;

DELETE FROM VEHICULO WHERE ID = 55;

-- HERNANDEZ PEREZ DAYALIN MARIANA (EJERCICIO INCOMPLETO)

/*
    LOS CASOS DE VALIDACIONES FUNCIONAN PERFECTAMENTE PERO AL REALIZAR LA INSERSION LA CONSOLA RETORNA EL SIGUIENTE 
    ERROR LO QUE INDICA QUE EL ID DEL VEHICULO NUNCA SE ASIGNA ORA-01400: no se puede realizar una inserción NULL en ("SYSTEM"."VEHICULO"."ID")
    EL REGISTRO NO SE INGRESA EN LA TABLA VEHICULOS 
*/

CREATE OR REPLACE TYPE vehiculo_nuevo AS OBJECT (
    id INT,
    id_modelo INT,
    id_cliente INT,
    id_tipo INT,
    color INT,
    annio CHAR (4),
    comentarios VARCHAR(128)
);

CREATE OR REPLACE TYPE vehiculo_nuevo_agregado AS TABLE OF vehiculo_nuevo;
DROP TYPE vehiculo_nuevo;

CREATE OR REPLACE PROCEDURE agregar_vehiculo (
    p_id_modelo IN INT,
    p_id_cliente IN INT,
    p_id_tipo IN INT,
    p_color IN INT,
    p_annio IN CHAR,
    p_comentarios IN VARCHAR2
) AS
    modelo_no_existe EXCEPTION;
    cliente_no_existe EXCEPTION;
    tipo_no_existe EXCEPTION;
    v_count INT;
    v_id INT;
BEGIN
    SELECT COUNT(*) INTO v_count
    FROM modelo
    WHERE id = p_id_modelo;
    IF v_count = 0 THEN
        RAISE modelo_no_existe;
    END IF;

    SELECT COUNT(*) INTO v_count
    FROM cliente
    WHERE id = p_id_cliente;
    IF v_count = 0 THEN
        RAISE cliente_no_existe;
    END IF;

    SELECT COUNT(*) INTO v_count
    FROM tipo_vehiculo
    WHERE id = p_id_tipo;
    IF v_count = 0 THEN
        RAISE tipo_no_existe;
    END IF;

    INSERT INTO vehiculo (id_modelo, id_cliente, id_tipo, color, annio, comentarios)
    VALUES (p_id_modelo, p_id_cliente, p_id_tipo, p_color, p_annio, p_comentarios)
    RETURNING id INTO v_id;

    DBMS_OUTPUT.PUT_LINE('Vehículo agregado con ID: ' || v_id);

EXCEPTION
    WHEN modelo_no_existe THEN
        RAISE_APPLICATION_ERROR(-20001, 'El ID del modelo no existe.');
    WHEN cliente_no_existe THEN
        RAISE_APPLICATION_ERROR(-20002, 'El ID del cliente no existe.');
    WHEN tipo_no_existe THEN
        RAISE_APPLICATION_ERROR(-20003, 'El ID del tipo de vehículo no existe.');
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20004, 'Ocurrió un error inesperado al agregar el vehículo. ' ||
                                        'Código de error: ' || SQLCODE || ' - ' || SQLERRM);
END;

-- PROBANDO TODAS LAS VALIDACIONES 
BEGIN
    -- Caso 1: El ID de modelo no existe
    BEGIN
        agregar_vehiculo(9999, 13, 3, 1, '2024', 'Caso de prueba: Modelo no existe');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Caso 1 - Error: ' || SQLERRM);
    END;

    -- Caso 2: El ID de cliente no existe
    BEGIN
        agregar_vehiculo(10, 9999, 2, 1, '2024', 'Caso de prueba: Cliente no existe');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Caso 2 - Error: ' || SQLERRM);
    END;

    -- Caso 3: El ID de tipo de vehículo no existe
    BEGIN
        agregar_vehiculo(10, 10, 9999, 1, '2024', 'Caso de prueba: Tipo de vehículo no existe');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Caso 3 - Error: ' || SQLERRM);
    END; 
END;

-- PROBANDO LA INSERCION 
BEGIN
    agregar_vehiculo(5, 6, 25, 2, '2024', 'Caso de prueba');
EXCEPTION
    WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Caso 4 - Error: ' || SQLERRM);
END;

-- CONSULTANDO SI APARECE EL NUEVO REGISTRO (NO APARECE EL NUEVO REGISTRO)
SELECT * FROM VEHICULO;

-- IRAHETA MENJIVAR DANILO ISAAC (EJERCICIO COMPLETO)

--También se incluira un ID automatico a la consulta, para que no existan futuros conflictos
--Es decir, el usuario no tendra que ingresar el ID del vehículo, unicamente el resto de datos
CREATE OR REPLACE PROCEDURE VEHICULO_UPDATE
    (p_id_modelo IN INT,
     p_id_cliente IN INT,
     p_id_tipo IN INT,
     p_color IN INT,
     p_annio IN CHAR,
     p_comentarios IN VARCHAR
    )
AS
    existe_id_modelo INT;
    existe_id_cliente INT;
    existe_id_tipo INT;
    total_id INT;
    new_id INT;
BEGIN
    SELECT COUNT(*) INTO existe_id_modelo
    FROM MODELO m
    WHERE m.id = p_id_modelo;
    
    IF existe_id_modelo = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'El id de modelo no existe');
    END IF;

    SELECT COUNT(*) INTO existe_id_cliente
    FROM CLIENTE c
    WHERE c.id = p_id_cliente;
    
    IF existe_id_cliente = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'El id de cliente no existe');
    END IF;

    SELECT COUNT(*) INTO existe_id_tipo
    FROM TIPO_VEHICULO tv
    WHERE tv.id = p_id_tipo;
    
    IF existe_id_tipo = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'El id de tipo de vehiculo no existe');
    END IF;
    
    
    SELECT COUNT(*) INTO total_id
    FROM VEHICULO;
    
    new_id := total_id + 1;
    
    INSERT INTO VEHICULO (id, id_modelo, id_cliente, id_tipo, color, annio, comentarios)
    VALUES (new_id, p_id_modelo, p_id_cliente, p_id_tipo, p_color, p_annio, p_comentarios);
END;

SELECT *FROM VEHICULO;

EXEC VEHICULO_UPDATE(1,1,1,11,2021, 'hola')

SELECT *FROM VEHICULO;

-- MELGAR FLORES JUAN JOSE (REALIZO OTRO EJERCICIO)
--GRUPO A
--Ejercicio A.2

--Crear un procedimiento almacenado que reciba como parámetro de entrada el id de un
--empleado. El procedimiento almacenado deberá retornar la cantidad de reservas en las que el
--empleado ha sido asignado responsable. Considerar todos los datos disponibles en el banco de
--datos.

--VER LA TABLA RESERVA
SELECT * FROM RESERVA;

--CONSULTA
SELECT COUNT(*)
FROM RESERVA R
WHERE R.ID_EMPLEADO_RESPONSABLE = 5;

--FUNCTION
CREATE OR REPLACE FUNCTION COUNT_RESERVAS (
    ID_EMPLEADO NUMBER
) 
RETURN NUMBER
AS
    CANTIDAD_RESERVAS NUMBER;
BEGIN

    SELECT COUNT(*)
    INTO CANTIDAD_RESERVAS
    FROM RESERVA R
    WHERE R.ID_EMPLEADO_RESPONSABLE = ID_EMPLEADO;
    
    RETURN CANTIDAD_RESERVAS;
END;

SELECT COUNT_RESERVAS (5) FROM DUAL;

-- PANAMEÑO REYES JEFRY GILBERTO (EJERCICIO CORRECTO / SE DETECTO CHATGTP)
/*
    Tarea A.1. Crear un procedimiento almacenado que se encargue de agregar nuevos vehículos. El
    procedimiento almacenado recibirá como parámetros de entrada todos los datos necesarios para
    ingresar un nuevo vehículo. Se deberá validar que el id de modelo, el id de tipo de vehículo y el id
    del cliente sean identificadores que existen en la base de datos. En caso de que un identificador no
    exista se deberá lanzar una excepción personalizada.
*/

select * from vehiculo
select count(id) from modelo where id = 1;
select count(id) from tipo_vehiculo where id = 1;

create or replace procedure insertVehicle(idVehicle int, idModel int, idType int, idClient int, colorVehicle int, yearVehicle char, comments varchar2)
is 
    noModel exception;
    noType exception;
    noClient exception;
    noPrimaryKey exception;
    countModel int;
    countType int;
    countClient int;
begin
    select count(id) into countModel from modelo where id = idModel;
    select count(id) into countType from tipo_vehiculo where id = idType;
    select count(id) into countClient from cliente where id = idClient;


    -- Verificar condiciones
    IF countModel < 1 THEN
        RAISE noModel;
    ELSIF countType < 1 THEN
        RAISE noType;
    ELSIF countClient < 1 THEN
        RAISE noClient;
    END IF;
    
    insert into vehiculo values (idVehicle, idModel, idClient, idType, colorVehicle, yearVehicle, comments);
    
    exception
        when noModel then
            raise_application_error(-20001, 'ERROR: El modelo con el id ' || idModel || ' no existe...');
        when noType then
            raise_application_error(-20001, 'ERROR: El tipo de vehiculo con el id '|| idType || ' no existe...');
        when noClient then
            raise_application_error(-20001, 'ERROR: El cliente con el id '||idClient|| ' no existe...');
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error inesperado: ' || SQLERRM);
            RAISE;
end;


exec insertVehicle(60,5,1,2,8,2024,'Escape necesita reparación.');
INSERT INTO VEHICULO (id, id_modelo, id_cliente, id_tipo, color, annio, comentarios) VALUES  (3,5,23,2,8,2024,'Escape necesita reparación.');

SELECT * FROM VEHICULO

-- RAMIREZ BARRERA WALTER ALEXANDER (EJERCICIO CORRECTO)
CREATE OR REPLACE PROCEDURE INSERT_VEHICLE
    (id IN INT,
    id_modelo IN INT,
    id_cliente IN INT,
    id_tipo IN INT,
    color IN INT,
    annio IN CHAR,
    comentarios IN VARCHAR2)
IS 
    totalModels int;
    totalTypes int;
    totalClient int;
BEGIN
    SELECT COUNT(*) INTO totalModels FROM modelo;
    if id_modelo > totalModels then
        RAISE_APPLICATION_ERROR(-20001, 'ERROR: Modelo no existe en la base de datos.');
    end if;
    
    SELECT COUNT(*) INTO totalTypes FROM tipo_vehiculo;
    if id_tipo > totalTypes then
        RAISE_APPLICATION_ERROR(-20002, 'ERROR: Tipo no existe en la base de datos');
    end if;
    
    SELECT COUNT(*) INTO totalClient FROM tipo_vehiculo;
    if id_cliente > totalClient then
        RAISE_APPLICATION_ERROR(-20003, 'ERROR: Cliente no existe en la base de datos');
    end if;
    
    INSERT INTO VEHICULO (id, id_modelo, id_cliente, id_tipo, color, annio, comentarios)
    VALUES (
        id,
        id_modelo,
        id_cliente,
        id_tipo,
        color,
        annio,
        comentarios
    );
END;

BEGIN
    INSERT_VEHICLE(
        id => 62,        
        id_modelo => 1,          
        id_cliente => 1,           
        id_tipo => 2,            
        color => 1,               
        annio => 2024,          
        comentarios => 'Nuevo vehículo'
    );
END;

SELECT * FROM VEHICULO WHERE id = 62;

-- ROMERO DELGADO JUAN CARLOS (EJERCICIO CORRECTO)
--Crear un procedimiento almacenado que se encargue de agregar nuevos vehículos. El
--procedimiento almacenado recibirá como parámetros de entrada todos los datos necesarios para
--ingresar un nuevo vehículo. Se deberá validar que el id de modelo, el id de tipo de vehículo y el id
--del cliente sean identificadores que existen en la base de datos. En caso de que un identificador no
--exista se deberá lanzar una excepción personalizada.

select * from vehiculo where id = 56;

CREATE OR REPLACE PROCEDURE AgregarVehiculo(
    id IN NUMBER,
    idModelo IN NUMBER, -- Validar
    idCliente IN NUMBER, -- Validar
    idTipo IN NUMBER,  -- Validar
    color IN NUMBER,
    annio IN CHAR, -- CHAR(4) en la tabla
    comentarios IN VARCHAR2
) AS
    v_dummy NUMBER;
BEGIN
    -- Verificar si el modelo existe
    BEGIN
        SELECT 1 INTO v_dummy FROM MODELO WHERE ID = idModelo;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('El modelo con ID ' || idModelo || ' no existe.');
            RAISE_APPLICATION_ERROR(-20001, 'ID de modelo no válido.');
    END;

    -- Verificar si el cliente existe
    BEGIN
        SELECT 1 INTO v_dummy FROM CLIENTE WHERE ID = idCliente;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('El cliente con ID ' || idCliente || ' no existe.');
            RAISE_APPLICATION_ERROR(-20002, 'ID de cliente no válido.');
    END;

    -- Verificar si el tipo de vehículo existe
    BEGIN
        SELECT 1 INTO v_dummy FROM TIPO_VEHICULO WHERE ID = idTipo;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('El tipo de vehículo con ID ' || idTipo || ' no existe.');
            RAISE_APPLICATION_ERROR(-20003, 'ID de tipo de vehículo no válido.');
    END;

    -- Si todas las validaciones son exitosas, insertar el vehículo
    INSERT INTO VEHICULO (ID, ID_MODELO, ID_CLIENTE, ID_TIPO, COLOR, ANNIO, COMENTARIOS)
    VALUES (id, idModelo, idCliente, idTipo, color, annio, comentarios);
    
    -- Confirmar la transacción
    COMMIT;

EXCEPTION
    WHEN OTHERS THEN
        -- Manejar cualquier otro error
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Se ha producido un error: ' || SQLERRM);
        RAISE;
END AgregarVehiculo;

execute AgregarVehiculo(56, 4, 8, 2, 3,2020, NULL);

-- SEGURA REYMUNDO JONATAN ERNESTO (EJERCICIO CORRECTO)
/*
Tarea A.1. Crear un procedimiento almacenado que se encargue de agregar nuevos vehículos. El
procedimiento almacenado recibirá como parámetros de entrada todos los datos necesarios para
ingresar un nuevo vehículo. Se deberá validar que el id de modelo, el id de tipo de vehículo y el id
del cliente sean identificadores que existen en la base de datos. En caso de que un identificador no
exista se deberá lanzar una excepción personalizada.
*/

CREATE OR REPLACE PROCEDURE agregar_vehiculo (
    ag_id IN NUMBER,            
    ag_id_modelo IN NUMBER,   
    ag_id_cliente IN NUMBER,   
    ag_id_tipo IN NUMBER,      
    ag_color IN NUMBER,        
    ag_annio IN VARCHAR2,      
    ag_comentarios IN VARCHAR2  
) AS
    -- Excepciones personalizadas
    excep_modelo EXCEPTION;
    excep_tipo EXCEPTION;
    excep_cliente EXCEPTION;

    -- Variable auxiliar para validación
    var_aux NUMBER;

BEGIN
    -- Validación de modelo
    BEGIN
        SELECT 1 INTO var_aux FROM MODELO WHERE id = ag_id_modelo;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE excep_modelo;
    END;

    -- Validación de cliente
    BEGIN
        SELECT 1 INTO var_aux FROM CLIENTE WHERE id = ag_id_cliente;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE excep_cliente;
    END;

    -- Validación de tipo de vehículo
    BEGIN
        SELECT 1 INTO var_aux FROM TIPO_VEHICULO WHERE id = ag_id_tipo;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE excep_tipo;
    END;

    -- Inserto el vehiculo
    INSERT INTO VEHICULO (id, id_modelo, id_cliente, id_tipo, color, annio, comentarios)
    VALUES (ag_id, ag_id_modelo, ag_id_cliente, ag_id_tipo, ag_color, ag_annio, ag_comentarios);

    -- Mensaje de confirmación
    DBMS_OUTPUT.PUT_LINE('Vehículo insertado correctamente');
    
EXCEPTION
    WHEN excep_modelo THEN
        DBMS_OUTPUT.PUT_LINE('Error: El modelo con id ' || ag_id_modelo || ' no existe.');
    WHEN excep_cliente THEN
        DBMS_OUTPUT.PUT_LINE('Error: El cliente con id ' || ag_id_cliente || ' no existe.');
    WHEN excep_tipo THEN
        DBMS_OUTPUT.PUT_LINE('Error: El tipo de vehículo con id ' || ag_id_tipo || ' no existe.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error inesperado: ' || SQLERRM);
END agregar_vehiculo;

--Ejemplo donde da una exception
EXEC agregar_vehiculo(57, 5, 1, 1, 123, '2023', 'Vehiculo ferrari');

select * from VEHICULO where id = 57;

-- Rafaul Gutierrez del barrio 00073123 (Ejercicio correcto)
create or replace procedure pa_AgregarVehículo(
    idVehiculo in int,
    idModelo in int,
    idCliente in int,
    idTipo in int,
    color in int,
    annio in varchar2,
    comentarios in varchar2
)
is
    v_verificarIDmodelo number;
    v_verificarIDcliente number;
    v_verificarIDtipo number;
begin

    -- Verificación de existencia del ID del modelo
    select count(*)
    into v_verificarIDmodelo
    from modelo
    where id = idModelo;
    
    -- Verificación de existencia del ID del cliente
    select count(*)
    into v_verificarIDcliente
    from cliente
    where id = idCliente;
    
    -- Verificación de existencia del ID del tipo
    select count(*)
    into v_verificarIDtipo
    from tipo_vehiculo
    where id = idTipo;
    
    -- Verificación de que los IDs existen
    if v_verificarIDmodelo = 0 then
        raise_application_error(-20010, 'Error: El ID de modelo no existe.');
        
    elsif v_verificarIDcliente = 0 then
        raise_application_error(-20011, 'Error: El ID de cliente no existe.');

    elsif v_verificarIDtipo = 0 then
        raise_application_error(-20012, 'Error: El ID de tipo de vehículo no existe.');
        
    else 
        insert into vehiculo(id, id_modelo, id_cliente, id_tipo, color, annio, comentarios)
        values (idVehiculo, idModelo, idCliente, idTipo, color, annio, comentarios);
        commit;  
    end if;
end;

BEGIN
    pa_AgregarVehículo(
        idVehiculo => 103, 
        idModelo => 1, 
        idCliente => 100, 
        idTipo => 999,
        color => 5, 
        annio => '2024', 
        comentarios => 'Vehículo de prueba'
    );
END;

-- David Sebastian Parrales Ponce 00543824 (Ejercicio correcto)

/*Crear un procedimiento almacenado que se encargue de agregar nuevos vehículos. El
procedimiento almacenado recibirá como parámetros de entrada todos los datos necesarios para
ingresar un nuevo vehículo. Se deberá validar que el id de modelo, el id de tipo de vehículo y el id
del cliente sean identificadores que existen en la base de datos. En caso de que un identificador no
exista se deberá lanzar una excepción personalizada.
*/

CREATE OR REPLACE PROCEDURE add_new_vehicle(
    v_id               IN NUMBER,
    v_id_modelo        IN NUMBER,
    v_id_cliente       IN NUMBER,
    v_tipo_vehiculo    IN NUMBER,
    v_color_carro      IN NUMBER,
    v_annio_carro      IN CHAR,
    v_comentarios_carro IN VARCHAR2
) 
IS
    
    ex_modelo_no_existe EXCEPTION;
    ex_tipo_no_existe EXCEPTION;
    ex_cliente_no_existe EXCEPTION;

    v_dummy NUMBER; 

BEGIN
   
    SELECT COUNT(*)
    INTO v_dummy
    FROM MODELO
    WHERE ID = v_id_modelo;

    IF v_dummy = 0 THEN
        RAISE ex_modelo_no_existe;
    END IF;

    
    SELECT COUNT(*)
    INTO v_dummy
    FROM TIPO_VEHICULO
    WHERE ID = v_tipo_vehiculo;

    IF v_dummy = 0 THEN
        RAISE ex_tipo_no_existe;
    END IF;

   
    SELECT COUNT(*)
    INTO v_dummy
    FROM CLIENTE
    WHERE ID = v_id_cliente;

    IF v_dummy = 0 THEN
        RAISE ex_cliente_no_existe;
    END IF;

    
    INSERT INTO VEHICULO (ID, ID_MODELO, ID_CLIENTE, ID_TIPO, COLOR, ANNIO, COMENTARIOS)
    VALUES (v_id, v_id_modelo, v_id_cliente, v_tipo_vehiculo, v_color_carro, v_annio_carro, v_comentarios_carro);

    DBMS_OUTPUT.PUT_LINE('Vehículo agregado correctamente.');

EXCEPTION
   
    WHEN ex_modelo_no_existe THEN
        DBMS_OUTPUT.PUT_LINE('Error: El ID del modelo no existe.');
    WHEN ex_tipo_no_existe THEN
        DBMS_OUTPUT.PUT_LINE('Error: El ID del tipo de vehículo no existe.');
    WHEN ex_cliente_no_existe THEN
        DBMS_OUTPUT.PUT_LINE('Error: El ID del cliente no existe.');
   
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error inesperado: ' || SQLERRM);
END add_new_vehicle;


DECLARE
    v_id NUMBER := 101; 
    v_id_modelo NUMBER := 1; 
    v_id_cliente NUMBER := 5; 
    v_tipo_vehiculo NUMBER := 3; 
    v_color_carro NUMBER := 12345; 
    v_annio_carro CHAR(4) := '2020';
    v_comentarios_carro VARCHAR2(128) := 'Carro en buen estado'; 
BEGIN
    add_new_vehicle(v_id, v_id_modelo, v_id_cliente, v_tipo_vehiculo, v_color_carro, v_annio_carro, v_comentarios_carro);

END;

SELECT * FROM VEHICULO WHERE ID = 101;



