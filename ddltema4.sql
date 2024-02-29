CREATE OR REPLACE VIEW VISTA AS;

CREATE OR REPLACE VIEW JEFES AS
    SELECT E.*, O.CIUDAD
    FROM EMPLEADO E, OFICINA O
    WHERE E.CODIGO_EMPLEADO IN (SELECT E.CODIGO_JEFE FROM EMPLEADO E)
        AND O.CODIGO_OFICINA = E.CODIGO_OFICINA;


SELECT E.NOMBRE FROM EMPLEADO E WHERE e.codigo_jefe ;

SELECT E.CODIGO_EMPLEADO FROM EMPLEADO E;

SELECT * FROM JEFES;

--this is wrong need help

SELECT DISTINCT E.NOMBRE, E.APELLIDO1, E.APELLIDO2, O.CIUDAD, 
        J.NOMBRE AS NOMBRE_JEFE, J.APELLIDO1 AS APELLIDO_JEFE, 
        J.APELLIDO2 AS APELLIDO2_JEFE, J.CIUDAD AS CIUDAD_JEFE
    FROM EMPLEADO E, OFICINA O, JEFES J
    WHERE O.CODIGO_OFICINA = E.CODIGO_OFICINA 
    AND J.CODIGO_OFICINA = O.CODIGO_OFICINA
    AND E.CODIGO_JEFE = J.CODIGO_JEFE;
    
    
    
--pl sql 

set serveroutput on;
BEGIN
    NULL;
END;
/

--2

BEGIN 
DBMS_OUTPUT.PUT_LINE('hola mundo');
END;
/

--3

BEGIN
    UPDATE EMPLE
        SET EMPLE.SALARIO = EMPLE.SALARIO*1.1
    WHERE EMPLE.COMISION > (EMPLE.SALARIO*5/100);
END;
/

SELECT SALARIO FROM EMPLE
    WHERE EMPLE.COMISION > (EMPLE.SALARIO*5/100);

--REVERT 
BEGIN
    UPDATE EMPLE
        SET EMPLE.SALARIO = EMPLE.SALARIO/1.1
    WHERE EMPLE.COMISION > (EMPLE.SALARIO*5/100);
END;
/

--4

SET SERVEROUTPUT ON;
DECLARE
V_APE EMPLE.APELLIDO%TYPE;
V_SALARIO EMPLE.SALARIO%TYPE;
BEGIN
    SELECT APELLIDO, SALARIO INTO V_APE, V_SALARIO   
    FROM EMPLE 
    WHERE DEPT_NO IS NULL;    
    DBMS_OUTPUT.PUT_LINE('El empleado ' || V_APE || ' tiene un salario de ' || V_SALARIO);
    END;
/

SELECT APELLIDO, SALARIO FROM EMPLE WHERE DEPT_NO IS NULL;

--5

DECLARE
V_PROD_7 PRODUCTO.CODIGO_PRODUCTO%TYPE;
BEGIN
    SELECT PRECIO_UNI INTO V_PROD_7
        FROM PRODUCTOS
        WHERE COD_PRODUCTO = 7;
        DBMS_OUTPUT.PUT_LINE(V_PROD_7);
END;
/

SELECT PRECIO_UNI FROM PRODUCTOS WHERE COD_PRODUCTO=7;

--6
/*Muestra por pantalla cuantos clientes realizaron una compra el día ‘22/09/1997’. Debe aparecer el
mensaje:
“____ clientes compraron el día ‘22/09/1997’ 
*/

SELECT COUNT(1) FROM VENTASCP WHERE FECHA = '22/09/1997';

DECLARE V_CANTIDAD_VENTAS_220997 NUMBER(3);
BEGIN
    SELECT COUNT(1) INTO V_CANTIDAD_VENTAS_220997
        FROM VENTASCP
        WHERE FECHA = '22/09/1997';
        DBMS_OUTPUT.PUT_LINE(V_CANTIDAD_VENTAS_220997 || ' CLIENTES COMPRARON EL DÍA 22/09/1997');
END;
/


--7
/*
Crea un bloque anónimo que muestre cuantos productos hay de la línea ‘PB’ y sume el precio unitario
de todos los productos de la línea ‘PB’.
“Hay _____ productos de la línea PB. El precio total es de _____ €”
*/

DECLARE V_CANTIDADPB NUMBER(3);
V_PRECIOTOTALPB NUMBER(10);
BEGIN
    SELECT COUNT(1), SUM(PRECIO_UNI) INTO V_CANTIDADPB, V_PRECIOTOTALPB
    FROM PRODUCTOS
    WHERE LINEA_PRODUCTO = 'PB'
    GROUP BY (LINEA_PRODUCTO);
    DBMS_OUTPUT.PUT_LINE('HAY ' || V_CANTIDADPB || ' PRODUCTOS DE LA LINEA PB. EL PRECIO TOTAL ES DE ' || V_PRECIOTOTALPB || '€');
    END;
    /

--8
/*
Crea un bloque anónimo que inserte un nuevo empleado en la tabla emple. El código de empleado
será el máximo código de empleado más 1, la fecha de alta será la fecha del sistema el salario será
igual al máximo mas 10.000 y la comisión igual a la máxima mas 5.000. El resto de campos los puedes
completar como quieras.
Comprueba luego el resultado.
*/

DECLARE V_MAXCODE EMPLE.EMP_NO%TYPE;
V_MAXSALARIO EMPLE.SALARIO%TYPE;
V_MAXCOMISION EMPLE.COMISION%TYPE;
BEGIN
    SELECT MAX(EMP_NO) + 1, MAX(SALARIO) + 10000, MAX(COMISION) + 5000 INTO V_MAXCODE, V_MAXSALARIO, V_MAXCOMISION
    FROM EMPLE;
    DBMS_OUTPUT.PUT_LINE(V_MAXCODE);
    INSERT INTO EMPLE VALUES (V_MAXCODE, 'APELLIDO', 'OFICIO', 7369, SYSDATE, V_MAXSALARIO, V_MAXCOMISION, 20);
    END;
    /
    
    
    SELECT *
    FROM EMPLE;
    END;
    
--9
/*
Añade un nuevo campo a la tabla clientes llamado ZONA de tipo varchar2(10).
Crea un bloque anónimo que actualice la tabla clientes asignando zona CENTRO los clientes cuyo
domicilio sea Madrid y Norte al resto. Muestra por pantalla el importe total vendido a los clientes de
la zona centro. Debe aparecer el mensaje:
“Se ha facturado un total de _____ € a los clientes de la zona CENTRO.”
*/


ALTER TABLE CLIENTES ADD ZONA VARCHAR2(10);
ALTER TABLE CLIENTES DROP COLUMN ZONA;

DECLARE
V_VAR_TOTAL NUMBER(10);
BEGIN
UPDATE CLIENTES
    SET ZONA = DECODE(DOMICILIO, 'MADRID', 'CENTRO', 'NORTE');
    
SELECT SUM(P.PRECIO_UNI * V.UNIDADES) INTO V_VAR_TOTAL
    FROM PRODUCTOS P, VENTASCP V, CLIENTES C
    WHERE C.NIF = V.NIF AND V.COD_PRODUCTO = P.COD_PRODUCTO
    AND C.ZONA = 'CENTRO';
    DBMS_OUTPUT.PUT_LINE('Se ha facturado un total de '||V_VAR_TOTAL|| '€ a los clientes de la zona CENTRO' );
END;
/


/*10
Crea un bloque anónimo que inserte un nuevo registro en la tabla productos y en la tabla ventascp.
Datos para realizar la inserción:
• Descripción del producto: Intel 8088
• Linea_producto: Proces
Muestra por pantalla el nombre del cliente que ha realizado la compra del nuevo producto, la
descripción del producto y cuantas unidades ha comprado.
“El cliente _____ ha comprado ______ unidades del producto _____
*/

DECLARE
V_CLIENTE_REALIZA_COMPRA CLIENTES.NOMBRE%TYPE;
V_NUM_STOCK_COMPRADO ventascp.unidades%TYPE;
V_NOMBRE_PRODUCTO PRODUCTOS.DESCRIPCION%TYPE;
BEGIN

INSERT INTO PRODUCTOS VALUES (
    (SELECT COUNT(1)+1 FROM PRODUCTOS), 
    'INTEL 8088',
    'PROCES',
    10,
    3);    
    
INSERT INTO VENTASCP VALUES (
    '333C',
    (SELECT COD_PRODUCTO FROM PRODUCTOS WHERE DESCRIPCION = 'INTEL 8088'),
    SYSDATE,
    1);
    
SELECT C.NOMBRE, P.DESCRIPCION, V.UNIDADES INTO V_CLIENTE_REALIZA_COMPRA, V_NOMBRE_PRODUCTO, V_NUM_STOCK_COMPRADO
    FROM CLIENTES C, VENTASCP V, PRODUCTOS P 
    WHERE C.NIF = V.NIF AND P.COD_PRODUCTO = V.COD_PRODUCTO
    AND P.DESCRIPCION = 'INTEL 8088';
DBMS_OUTPUT.PUT_LINE('El cliente ' || V_CLIENTE_REALIZA_COMPRA || 
                    ' Ha comprado '|| V_NUM_STOCK_COMPRADO || 
                    ' unidades del producto ' ||V_NOMBRE_PRODUCTO);

--RETURN TO DEFAULT
DELETE FROM PRODUCTOS WHERE DESCRIPCION = 'INTEL 8088';
END;
/

/*
--ej2 parte 2
Crea un bloque anónimo que pida un rango de salarios (mínimo y máximo). Muestra el número de
empleados que ganen un salario en ese rango. Si no hay ningún empleado en ese rango muestra el
mensaje 'Ningún empleado encontrado.'. Implementa el control de excepciones
*/

DECLARE
V_MIN NUMBER(3);
V_MAX NUMBER(30);
V_COUNT_SALARIO NUMBER(3);
BEGIN
V_MIN := &INPUTMINRANGE;
V_MAX := &INPUTMAXRANGE;
SELECT COUNT(1) INTO V_COUNT_SALARIO
    FROM EMPLE
    WHERE SALARIO BETWEEN V_MIN AND V_MAX;

IF V_COUNT_SALARIO < 1 THEN
DBMS_OUTPUT.PUT_LINE('Ningún empleado encontrado'); 
ELSE DBMS_OUTPUT.PUT_LINE(V_COUNT_SALARIO || ' empleados encontrados que cobran entre ' || V_MIN || ' y ' || V_MAX);
END IF;
EXCEPTION
--THIS NEVER TRIGGERS HLP
WHEN others THEN     
RAISE_APPLICATION_ERROR(-20001, 'ERROR DE ENTRADA DE DATOS');
END;
/

SELECT COUNT(1)
    FROM EMPLE
    WHERE SALARIO BETWEEN 'A' AND 'B';
    
/*3 Crea un boque anónimo que pida un EMP_NO, APELLIDO, SALARIO, DEPT_NO para insertarlo en la
tabla emple. Si el salario es mayor de 100.000 sumarle 300 si no aumentarlo el 20%. Implementa el
control de excepciones
*/

DECLARE 
V_EMP_NO EMPLE.EMP_NO%TYPE := &NEW_EMP_NO;
V_APELLIDO EMPLE.APELLIDO%TYPE := '&NEW_APELLIDO';
V_SALARIO EMPLE.SALARIO%TYPE := &NEW_SALARIO;
V_DEPT_NO EMPLE.DEPT_NO%TYPE := &NEW_DEPT_NO;
BEGIN
IF V_SALARIO > 100000 THEN 
    V_SALARIO := V_SALARIO + 300;
ELSE 
    V_SALARIO := V_SALARIO + V_SALARIO *0.2; 
END IF;
    DBMS_OUTPUT.PUT_LINE(V_SALARIO);
    
INSERT INTO EMPLE (EMP_NO, APELLIDO, SALARIO, DEPT_NO)
        VALUES (V_EMP_NO, V_APELLIDO, V_SALARIO, V_DEPT_NO);
END;
/

/*ej4 Crea un bloque anónimo PL/SQL que pida un numero entero. Este número indica una opción: 1 que
borra todos los empleados del departamento 10 y 2 que borra todos los empleados del departamento
20. Si el usuario inserta otro número mostrar el mensaje 'No has escogido una opción válida.'
Implementa el control de excepciones
*/

DECLARE 
V_INPUT_INT NUMBER(3) := &INPUT_INT;
BEGIN
CASE v_input_int
    WHEN 1 THEN DBMS_OUTPUT.PUT_LINE('DELETE FROM EMPLE WHERE DEPT_NO = 10(not actually doing it lol)');
    WHEN 2 THEN DBMS_OUTPUT.PUT_LINE('DELETE FROM EMPLE WHERE DEPT_NO = 20(not actually doing it lol');
    else DBMS_OUTPUT.PUT_LINE('NO HAS ELEGIDO UNA OPCIÓN VÁLIDA');
    end case;
end;
/

/*ej5 Crea un bloque anónimo que pida por pantalla un número de dept_no y nos devuelva cuántos
empleados hay en el departamento y la media del salario. Si no hay empleados en el departamento o
el departamento no existe mostrar el mensaje el 'Departamento no existe o vacío'*/

DECLARE
V_DEPT_NO EMPLE.DEPT_NO%TYPE := &INPUT_DEPT_NO;
V_COUNT_FROM_SELECT NUMBER(3);
V_MEDIA NUMBER;
BEGIN
SELECT COUNT(1), AVG(SALARIO) INTO V_COUNT_FROM_SELECT, V_MEDIA
FROM EMPLE WHERE DEPT_NO = V_DEPT_NO;
IF V_COUNT_FROM_SELECT = 0 THEN
DBMS_OUTPUT.PUT_LINE('NO EXISTE ESE DEPARTAMENTO O ESTÁ VACÍO');
ELSE
DBMS_OUTPUT.PUT_LINE('HAY ' ||V_COUNT_FROM_SELECT|| ' EMPLEADOS EN EL DEPARTAMENTO ' ||V_DEPT_NO || ' Y SU MEDIA DE SALARIO ES ' ||V_MEDIA);
END IF;
END;
/

/*EJ6 Crea un bloque anónimo para borrar un empleado pidiendo por pantalla el número de empleado. Si
el empledo no existe mostrar el mensaje 'Empleado no encontrado' y si existe mostrar 'Se ha
eliminado el empleado con código ____'. Gestionar las excepciones pertinentes*/

DECLARE
V_EMPLEADO emple.emp_no%TYPE := &INPUT_EMP_NO_A_MATAR;
V_RETURNED EMPLE.EMP_NO%TYPE;
BEGIN

SELECT EMP_NO INTO V_RETURNED
FROM EMPLE WHERE EMP_NO = V_EMPLEADO;

IF V_RETURNED != 0 THEN
DBMS_OUTPUT.PUT_LINE('EMPLEADO NÚMERO '||V_RETURNED|| ' HA LLEGADO TU FINAL');
DELETE FROM EMPLE WHERE EMP_NO = V_RETURNED;
end if;

exception 
when others then
dbms_output.put_line('No existe ese empleado');
end;
/

/* EJ 7 Crear una tabla copiaAlum con la estructura de la tabla alumnos. Crea un bloque anónimo que copie
en esa tabla los alumnos de la tabla Alumnos que vivan en ‘Madrid’.
Mostrar al usuario el número de filas insertadas en la ejecución del bloque anónimo. 
Gestionar las excepciones pertinentes
(DUP_VAL_ON_INDEX es la excepción que se genera cuando se viola la clave primaria */

CREATE TABLE copiaAlum as (select * from alumnos);
declare
v_dni alumnos.dni%type;
v_apenom alumnos.apenom%type;
v_direc alumnos.direc%type;
v_pobla alumnos.pobla%type;
v_telef alumnos.telef%type;
v_count number;
begin

select count(1) into v_count
    from alumnos 
    where pobla = 'Madrid';

insert into copiaalum (select dni, apenom, direc, pobla, telef
                            from alumnos 
                            
                            where pobla = 'Madrid');
DBMS_OUTPUT.PUT_LINE(v_count || ' alumnos introducidos');
end;
/

/*ej 8
Crea un bloque anónimo que inserte un empleado en la tabla EMPLE. Su número será superior más
uno de los existentes y la fecha de incorporación a la empresa será la actual. El departamento será el
departamento con una media del salario más alta, si son varios departamentos mostrar un mensaje
indicándolo. El resto de los campos será NULL
*/

declare
v_max_media_dept number(10);
v_max_emp number(5);
v_count number(2);
v_avg number(10);
begin

select max(emp_no) into v_max_emp
from emple;

select max(avg(salario)) into v_max_media_dept
    from emple
    group by dept_no;

select count(avg(salario)) into v_count
    from emple
    group by dept_no
    having avg(salario) = v_max_media_dept;

if v_count > 1 then
dbms_output.put_line('Hay ' || v_count || ' departamentos con la media máxima de salario ');
end if;

insert into emple 
    (emp_no, fecha_alt, salario, dept_no) values 
    (v_max_emp + 1, sysdate, v_max_media_dept, 50);
end;
/

begin
for each in emple begin
dbms_output.put_line(rowee || 'boomboomboom');
end;
/

/* 9-Crea un bloque anónimo que pida un numero de departamento 
y un numero de empleado. Si el departamento no existe, lo crea. 
Si el empleado no existe se inserta con el número de empleado, el
dept y el salario (media salario departamento), 
si la media del salario es nula, se inserta el salario 0
*/

DECLARE
V_INPUT_DEPTNO EMPLE.DEPT_NO%TYPE := &DEPT_NO;
V_COUNT_DEPTNO NUMBER(10);
V_INPUT_EMPNO EMPLE.EMP_NO%TYPE := &EMP_NO;
V_COUNT_EMPNO NUMBER(10);
V_AVG_SALARIO_DEPT NUMBER(10);
BEGIN

SELECT COUNT(D.DEPT_NO) INTO V_COUNT_DEPTNO
FROM DEPART D
WHERE DEPT_NO = V_INPUT_DEPTNO;

SELECT AVG(SALARIO) INTO V_AVG_SALARIO_DEPT
FROM EMPLE
WHERE DEPT_NO = V_INPUT_DEPTNO;

IF V_AVG_SALARIO_DEPT IS NULL THEN
V_AVG_SALARIO_DEPT := 0;
END IF;

IF V_COUNT_DEPTNO = 0 THEN
INSERT INTO DEPART (DEPT_NO) VALUES (V_INPUT_DEPTNO);
DBMS_OUTPUT.PUT_LINE('NUEVO DEPARTAMENTO CREADO CON VALOR ' || V_INPUT_DEPTNO);
END IF;

SELECT COUNT(EMP_NO) INTO V_COUNT_EMPNO
FROM EMPLE
WHERE EMP_NO = V_INPUT_EMPNO;

IF V_COUNT_EMPNO = 0 THEN
DBMS_OUTPUT.PUT_LINE('AÑADIENDO EMPLEADO CON VALORES ' ||
            ' EMP_NO: ' || V_INPUT_EMPNO || ' ALTA: ' || SYSDATE|| 
            ' SALARIO ' || V_AVG_SALARIO_DEPT || ' DEPARTAMENTO ' ||  V_INPUT_DEPTNO);
INSERT INTO EMPLE (EMP_NO, FECHA_ALT, SALARIO, DEPT_NO)
    VALUES(V_INPUT_EMPNO, SYSDATE, V_AVG_SALARIO_DEPT, V_INPUT_DEPTNO);
ELSE
DBMS_OUTPUT.PUT_LINE('EMPLE FOUND');
END IF;

exception
when no_data_found then
dbms_output.put_line('NO DATA FOUND NERD');
END;
/

/*
Crea un bloque anónimo que solicite una fecha y nos
indique si el día cae en fin de semana o no.
*/
-- CODE GOLF SQL LET'S GOOOOOOOOOOOOOOOOO
DECLARE
I VARCHAR2(10) := TO_NUMBER(TO_CHAR(TO_DATE('&D'), 'D'));
O VARCHAR2(30) := 'ES FIN DE SEMANA';
BEGIN
IF I <= 5 THEN
O := 'NO ' || O;
END IF;
DBMS_OUTPUT.PUT_LINE(O);
END;
/

/*
Crea un bloque anónimo que solicite una fecha y nos muestre que día de la semana es.
*/

DECLARE
VINPUT VARCHAR2(10) := TO_CHAR(TO_DATE('&D'), 'Day');
BEGIN
DBMS_OUTPUT.PUT_LINE(VINPUT);
END;
/

/*
Crea un bloque anónimo convierta una temperatura a escala Fahrenheit a Celsius y viceversa. El
programa solicitará introducir una temperatura y una escala.
Conversión Celsius a Fahrenheit: ((9*temperatura)/5)+32
Conversión de Fahrenheit a Celsius: ((temperatura-32)*5)/9
*/

DECLARE
VINPUT_VALUE NUMBER := &INPUT_TEMPERATURA;
VOUTPUT_VALUE NUMBER;
VINPUT_C_OR_F VARCHAR2(10) := UPPER(SUBSTR('&FAHRENHEIT_OR_CELSIUS', 1,1));
VOPTION1 VARCHAR2(12) := 'FAHRENHEIT';
VOPTION2 VARCHAR2(12) := 'CELSIUS';
BEGIN

IF VINPUT_C_OR_F = 'C' THEN
VOPTION1 := 'CELSIUS';
VOPTION2 := 'FAHRENHEIT';
VOUTPUT_VALUE := (9*VINPUT_VALUE)/5+32;
ELSIF VINPUT_C_OR_F = 'F' THEN
VOUTPUT_VALUE := ((VINPUT_VALUE-32)*5)/9;
END IF;
DBMS_OUTPUT.PUT_LINE(VINPUT_VALUE || ' ' || VOPTION1 ||' ES IGUAL A ' || VOUTPUT_VALUE || ' ' || VOPTION2);
END;
/


/* 
EJERCICIOS PL SQL I I I  
*/

/*
Dados dos números enteros introducidos por el usuario, uno menor que otro, realizar un
programa que muestre los números enteros entre los dos números (SIN incluir los mismos)
*/

DECLARE
VINPUT1 NUMBER := &INPUT1;
VINPUT2 NUMBER := &INPUT2;
VBUFFER NUMBER;
BEGIN
IF VINPUT2 < VINPUT1 THEN
VBUFFER := VINPUT1;
VINPUT1 := VINPUT2;
VINPUT2 := VBUFFER;
END IF;
DBMS_OUTPUT.PUT_LINE('THE VALUES BETWEEN ' || VINPUT1 || ' AND ' || VINPUT2 || ' ARE');
FOR I IN VINPUT1+1..VINPUT2-1 LOOP
DBMS_OUTPUT.PUT(I ||' ');
END LOOP;
DBMS_OUTPUT.NEW_LINE;
END;
/

/*
Dado un número entero pedido al usuario determinar si el mismo es par o impar y mostrarlo
por pantalla. La función MOD(NUMBER M, NUMBER N) devuelve el resto de una división.
*/

DECLARE
    VINPUT1 NUMBER := &INPUT1;
    VOUTPUT VARCHAR2(12) := 'PAR';
BEGIN
IF MOD(VINPUT1, 2) = 1 THEN
    VOUTPUT := 'IM' || VOUTPUT;
END IF;
DBMS_OUTPUT.PUT_LINE(VINPUT1 || ' ES UN NÚMERO ' || VOUTPUT);
END;
/

/*
Dados dos números enteros introducidos por el usuario, uno menor que otro, realizar un
programa que muestre los números PARES enteros entre los dos números (INCLUIR los mismos)
*/

DECLARE
    VINPUT1 NUMBER := &INPUT1;
    VINPUT2 NUMBER := &INPUT2; 
    VBUFFER NUMBER;
BEGIN

IF VINPUT2 < VINPUT1 THEN
    VBUFFER := VINPUT1;
    VINPUT1 := VINPUT2;
    VINPUT2 := VBUFFER;
END IF;
DBMS_OUTPUT.PUT_LINE('LOS NUMEROS PARES ENTRE ' ||VINPUT1 || ' Y ' || VINPUT2 || ' SON');

FOR I IN (VINPUT1/2)..(VINPUT2/2)-(MOD(VINPUT2,2)) LOOP
    DBMS_OUTPUT.PUT(I*2 || ', ');
END LOOP;

DBMS_OUTPUT.NEW_LINE;
END;
/

/*
pedir un numero al usuario y mostrar los n primeros pares empezando desde 0. Usa el bucle
FOR
*/
DECLARE
VINPUT1 NUMBER := &INPUT1;
lessthan0 exception;
BEGIN
IF VINPUT1 < 0 THEN
RAISE lessthan0;
END IF;
DBMS_OUTPUT.PUT_LINE('LOS NUMEROS PARES ENTRE 0 Y ' || VINPUT1 || ' SON');
FOR I IN 0..VINPUT1/2 - (MOD(VINPUT1,2)) LOOP
    DBMS_OUTPUT.PUT(I*2 || ', ');
    
END LOOP;
DBMS_OUTPUT.NEW_LINE;
EXCEPTION
WHEN lessthan0 THEN
    DBMS_OUTPUT.PUT_LINE('HAS ELEGIDO UN NÚMERO MENOR QUE 0');
END;
/


/*
Pedir dos números al usuario inicio y fin (fin es mayor o igual que inicio). Mostrar los múltiplos
de 3 desde fin a inicio ambos incluidos. Usa el bucle FOR.
*/

DECLARE
    VINPUT1 NUMBER := &INPUT1;
    VINPUT2 NUMBER := &INPUT2; 
    VBUFFER NUMBER;
BEGIN
IF VINPUT2 < VINPUT1 THEN
    VBUFFER := VINPUT1;
    VINPUT1 := VINPUT2;
    VINPUT2 := VBUFFER;
END IF;
DBMS_OUTPUT.PUT_LINE('LOS NUMEROS DIVISIBLES ENTRE 3 ENTRE ' ||VINPUT1 || ' Y ' || VINPUT2 || ' SON');

FOR I IN (VINPUT1/3)..(VINPUT2/3)-(MOD(VINPUT2,3)) LOOP
    DBMS_OUTPUT.PUT(I*3 || ', ');
END LOOP;

DBMS_OUTPUT.NEW_LINE;
END;
/

/*Obtener el número de veces que un número se puede dividir por 2 obteniendo un resto 0,
utilizando variable de sustitución para dar el valor del número.*/

DECLARE
VINPUT NUMBER := &INPUT1;
VCOUNTER NUMBER := 0;
BEGIN
WHILE ABS(VINPUT/2) >= 1 LOOP
    VCOUNTER := VCOUNTER+1;
    VINPUT := VINPUT/2;
END LOOP;
DBMS_OUTPUT.PUT_LINE(VCOUNTER);
END;
/


/*
Crea un procedimiento PL/SQL que visualice el precio de un producto cuyo código se pasa como
parámetro. Implementa el módulo de excepciones.
*/

CREATE OR REPLACE PROCEDURE verPrecioProd(prodCod in productos.cod_producto%type) as 
    vtest number; 
begin
select precio_uni into vtest
    from Productos
    where prodCod = cod_producto;
dbms_output.put_line(vtest);
exception
when no_data_found then
dbms_output.put_line('oopsie');
end verPrecioProd;
/


begin
verPrecioProd(2341);
end;
/


/*
Crea un procedimiento que modifique el precio de un producto pasándole el código del
producto y el nuevo precio. El procedimiento comprobará que la variación de precio no supere
el 20% y que el producto existe. Si no existe indicarlo con un mensaje por pantalla. Se puede
usar la función ABS(number) que hace el valor absoluto de un número.
*/

CREATE OR REPLACE PROCEDURE modPrecioProducto
                    (codigoProd productos.cod_producto%type, nuevoPrecio productos.precio_uni%type) as
    vOutPrecioProd productos.precio_uni%type;
    vOutNombreProd productos.descripcion%type;
    price_var_too_large exception;
begin

select precio_uni, descripcion into vOutPrecioProd, vOutNombreProd
    from Productos
    where codigoProd = cod_producto;

if abs(vOutPrecioProd - nuevoPrecio) > vOutPrecioProd* 0.2 then
    raise price_var_too_large;
end if;

dbms_output.put_line('El producto ' || vOutNombreProd || ' se ha actualizado de precio ' ||
    vOutPrecioProd || ' > ' || nuevoPrecio);
update productos
    set precio_uni = nuevoPrecio
    where cod_producto = codigoProd;

exception
when no_data_found then
dbms_output.put_line('No se ha encontrado este producto');

when price_var_too_large then
dbms_output.put_line('Price variation too large');
end;
/

execute modprecioproducto(1,15000);

/*Crea un procedimiento que cambie el oficio de un empleado de la tabla emple por otro,
con los parámetros número de empleado y nuevo oficio. 
Visualizar por pantalla el número de empleado, el oficio anterior y el nuevo oficio. */

select oficio from emple;

create or replace procedure cambiarOficioEmple 
    (cod emple.emp_no%type, nuevoOficio emple.oficio%type) as

    vDenominadorEmple emple.apellido%type;
    vOficioEmple emple.oficio%type;
begin

select apellido, oficio into vDenominadorEmple, vOficioEmple
    from emple
    where emp_no = cod;
    
if (vDenominadorEmple is null) then
vDenominadorEmple := 'SIN_NOMBRE';
end if;
dbms_output.put_line
    (vDenominadorEmple || ' de código ' || cod || ' y oficio ' || vOficioEmple ||
    ' ahora trabaja como ' || nuevoOficio);
update emple 
    set oficio = nuevoOficio
    where emp_no = cod;

exception
when no_data_found then
dbms_output.put_line('No hay un empleado con ese código');
end;
/

execute cambiarOficioEmple(99, 'SECRETARIO');

/*
Crea un procedimiento que reciba el nuevo oficio para un empleado como parámetro. El
procedimiento debe cambiar ese nuevo oficio al empleado con número de empleado mayor. Si
no existen empleados indicarlo con un mensaje. Es obligatorio utilizar el procedimiento
cambiar_oficio del ejercicio anterior.
*/

create or replace procedure nuevoOficio
    (nuevoOficio emple.oficio%type) as

    vmax_emple emple.emp_no%type;
begin
    
SELECT MAX(emp_no) into vmax_emple FROM EMPLE;

cambiarOficioEmple(vmax_emple, nuevoOficio);

exception
when no_data_found then
dbms_output.put_line('no hay empleados en la tabla' );
end;
/

execute nuevoOficio('pepe');

/* 
Crea una función que devuelva el número de empleado de la tabla emple, pasando como
parámetro el apellido. Si el empleado no se encuentra o hay muchos empleados con ese apellido
indicarlo mediante los correspondientes mensajes y hacer que la función devuelva -1 si no
encuentra el empleado, -2 si hay varios empleados con el mismo apellido y -3 si se da cualquier
otra excepción
*/

create or replace function codForEmple
    (ape emple.apellido%type)
    return emple.emp_no%type as
        rCodEmple emple.emp_no%type;
    begin
        select emp_no into rCodEmple
        from Emple
        where apellido = ape;
    return rCodEmple;
    exception
    when no_data_found then
    return -1;
    when too_many_rows then
    return -2;
    when others then
    return -3;
    end codForEmple;
    /
    
update emple
set apellido = 'ARROYO' where emp_no = 99;

select codForEmple('ARROYO') from emple;