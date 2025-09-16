-- Creando el objeto
CREATE OR REPLACE TYPE type_sales_row AS OBJECT(
    idempleado INT,
    nombre VARCHAR2(40),
    direccion VARCHAR2(100),
    iddepartamento INT
);

-- Creando una colección para contener los objetos de tipo fila
CREATE OR REPLACE TYPE type_sales_collection AS TABLE OF type_sales_row;

-- Ejercicio 2 Mostrar excepcion cuando no hayan personas con ese
CREATE OR REPLACE FUNCTION ejercicio2 (id_departamento in int)
RETURN type_sales_collection PIPELINED
AS
    CURSOR cursor_departamento IS
    SELECT idempleado,nombre,direccion,iddepartamento FROM EMPLEADO WHERE IDDEPARTAMENTO = id_departamento;
    fila cursor_departamento%rowtype;
    
    num_empleados NUMBER;
    DEPARTAMENTO_INVALIDO EXCEPTION;
    
BEGIN 
-- Obtenemos el numero de personas por departamento
SELECT COUNT(*) INTO num_empleados FROM EMPLEADO WHERE IDDEPARTAMENTO = id_departamento;
-- Verificar si hay 0 con un if y lanzaar la execpcion
IF num_empleados = 0 THEN
    RAISE DEPARTAMENTO_INVALIDO;
END IF;

    OPEN cursor_departamento;
    LOOP
        FETCH cursor_departamento INTO fila;
        EXIT WHEN cursor_departamento%NOTFOUND;
        PIPE ROW (type_sales_row(fila.idempleado, fila.nombre, fila.direccion, fila.iddepartamento));
    END LOOP;
    CLOSE cursor_departamento;

END;

SELECT * FROM TABLE(ejercicio2(4));

DROP TYPE type_departamento_row
DROP TYPE empleado_departamento_collection

-- Ejercicio 3 
CREATE OR REPLACE PROCEDURE ejercicio3 (id_compania IN NUMBER)
IS
    CURSOR compania_cursor is
    SELECT  v.codvideojuego, v.titulo,v.fechalanzamiento, v.precio, v.idcondicion,c.idcompania,c.nombre,c.fechadefundacion
    FROM VIDEOJUEGO v  
    INNER JOIN VIDEOJUEGOXCOMPANIA vc ON vc.codvideojuego = v.codvideojuego
    INNER JOIN COMPANIA c ON c.idcompania = vc.idcompania
    WHERE c.idcompania = id_compania;
    
    row_cursor_compania compania_cursor%ROWTYPE;
    
    json_array_videojuego json_array_t;
    json_compania_object json_object_t;
    json_videojuego_object json_object_t;
BEGIN

    -- Inicializamos los objetos de json 
    json_array_videojuego := new json_array_t();
    json_compania_object := new json_object_t();
    json_videojuego_object := new json_object_t();
    
    OPEN compania_cursor;
    
    LOOP
    FETCH compania_cursor INTO row_cursor_compania;
    
    EXIT WHEN compania_cursor%NOTFOUND;
    
    -- Agregamos primero la info del juego al object object.put('campo', row.campo)
    json_videojuego_object.put('codvideojuego', row_cursor_compania.codvideojuego);
    json_videojuego_object.put('titulo', row_cursor_compania.titulo);
    json_videojuego_object.put('fechalanzamiento', row_cursor_compania.fechalanzamiento);
    json_videojuego_object.put('precio', row_cursor_compania.precio);
    json_videojuego_object.put('idcondicion', row_cursor_compania.idcondicion);
    
    -- Ocupamos el .append al arreglo JSON array.apped(json_object)
    json_array_videojuego.append(json_videojuego_object);
    
    -- Agregamos la info de la compania al objecto compania 
    json_compania_object.put('idcompania',row_cursor_compania.idcompania);
    json_compania_object.put('nombre',row_cursor_compania.nombre);
    json_compania_object.put('fechadefundacion',row_cursor_compania.fechadefundacion);
    
    END LOOP;
    
    CLOSE compania_cursor;
    
    -- Object compania.put 'coleccion' ,array
    json_compania_object.put('coleccion',json_array_videojuego);
    
    -- Imprimimos el json
    dbms_output.put_line (json_compania_object.to_string); 
END;

SET SERVEROUTPUT ON;

EXEC ejercicio3(3);
