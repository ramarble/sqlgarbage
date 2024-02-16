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
/*Muestra por pantalla cuantos clientes realizaron una compra el d�a �22/09/1997�. Debe aparecer el
mensaje:
�____ clientes compraron el d�a �22/09/1997� 
*/

SELECT COUNT(1) FROM VENTASCP WHERE FECHA = '22/09/1997';

DECLARE V_CANTIDAD_VENTAS_220997 NUMBER(3);
BEGIN
    SELECT COUNT(1) INTO V_CANTIDAD_VENTAS_220997
        FROM VENTASCP
        WHERE FECHA = '22/09/1997';
        DBMS_OUTPUT.PUT_LINE(V_CANTIDAD_VENTAS_220997 || ' CLIENTES COMPRARON EL D�A 22/09/1997');
END;
/


--7
/*
Crea un bloque an�nimo que muestre cuantos productos hay de la l�nea �PB� y sume el precio unitario
de todos los productos de la l�nea �PB�.
�Hay _____ productos de la l�nea PB. El precio total es de _____ ��
*/

DECLARE V_CANTIDADPB NUMBER(3);
V_PRECIOTOTALPB NUMBER(10);
BEGIN
    SELECT COUNT(1), SUM(PRECIO_UNI) INTO V_CANTIDADPB, V_PRECIOTOTALPB
    FROM PRODUCTOS
    WHERE LINEA_PRODUCTO = 'PB'
    GROUP BY (LINEA_PRODUCTO);
    DBMS_OUTPUT.PUT_LINE('HAY ' || V_CANTIDADPB || ' PRODUCTOS DE LA LINEA PB. EL PRECIO TOTAL ES DE ' || V_PRECIOTOTALPB || '�');
    END;
    /

--8
/*
Crea un bloque an�nimo que inserte un nuevo empleado en la tabla emple. El c�digo de empleado
ser� el m�ximo c�digo de empleado m�s 1, la fecha de alta ser� la fecha del sistema el salario ser�
igual al m�ximo mas 10.000 y la comisi�n igual a la m�xima mas 5.000. El resto de campos los puedes
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
A�ade un nuevo campo a la tabla clientes llamado ZONA de tipo varchar2(10).
Crea un bloque an�nimo que actualice la tabla clientes asignando zona CENTRO los clientes cuyo
domicilio sea Madrid y Norte al resto. Muestra por pantalla el importe total vendido a los clientes de
la zona centro. Debe aparecer el mensaje:
�Se ha facturado un total de _____ � a los clientes de la zona CENTRO.�
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
    DBMS_OUTPUT.PUT_LINE('Se ha facturado un total de '||V_VAR_TOTAL|| '� a los clientes de la zona CENTRO' );
END;
/


/*10
Crea un bloque an�nimo que inserte un nuevo registro en la tabla productos y en la tabla ventascp.
Datos para realizar la inserci�n:
� Descripci�n del producto: Intel 8088
� Linea_producto: Proces
Muestra por pantalla el nombre del cliente que ha realizado la compra del nuevo producto, la
descripci�n del producto y cuantas unidades ha comprado.
�El cliente _____ ha comprado ______ unidades del producto _____
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
Crea un bloque an�nimo que pida un rango de salarios (m�nimo y m�ximo). Muestra el n�mero de
empleados que ganen un salario en ese rango. Si no hay ning�n empleado en ese rango muestra el
mensaje 'Ning�n empleado encontrado.'. Implementa el control de excepciones
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
DBMS_OUTPUT.PUT_LINE('Ning�n empleado encontrado'); 
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
    
/*3 Crea un boque an�nimo que pida un EMP_NO, APELLIDO, SALARIO, DEPT_NO para insertarlo en la
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

/*ej4 Crea un bloque an�nimo PL/SQL que pida un numero entero. Este n�mero indica una opci�n: 1 que
borra todos los empleados del departamento 10 y 2 que borra todos los empleados del departamento
20. Si el usuario inserta otro n�mero mostrar el mensaje 'No has escogido una opci�n v�lida.'
Implementa el control de excepciones
*/

DECLARE 
V_INPUT_INT NUMBER(3) := &INPUT_INT;
BEGIN
CASE v_input_int
    WHEN 1 THEN DBMS_OUTPUT.PUT_LINE('DELETE FROM EMPLE WHERE DEPT_NO = 10(not actually doing it lol)');
    WHEN 2 THEN DBMS_OUTPUT.PUT_LINE('DELETE FROM EMPLE WHERE DEPT_NO = 20(not actually doing it lol');
    else DBMS_OUTPUT.PUT_LINE('NO HAS ELEGIDO UNA OPCI�N V�LIDA');
    end case;
end;
/

/*ej5 Crea un bloque an�nimo que pida por pantalla un n�mero de dept_no y nos devuelva cu�ntos
empleados hay en el departamento y la media del salario. Si no hay empleados en el departamento o
el departamento no existe mostrar el mensaje el 'Departamento no existe o vac�o'*/

DECLARE
V_DEPT_NO EMPLE.DEPT_NO%TYPE := &INPUT_DEPT_NO;
V_COUNT_FROM_SELECT NUMBER(3);
V_MEDIA NUMBER;
BEGIN
SELECT COUNT(1), AVG(SALARIO) INTO V_COUNT_FROM_SELECT, V_MEDIA
FROM EMPLE WHERE DEPT_NO = V_DEPT_NO;
IF V_COUNT_FROM_SELECT = 0 THEN
DBMS_OUTPUT.PUT_LINE('NO EXISTE ESE DEPARTAMENTO O EST� VAC�O');
ELSE
DBMS_OUTPUT.PUT_LINE('HAY ' ||V_COUNT_FROM_SELECT|| ' EMPLEADOS EN EL DEPARTAMENTO ' ||V_DEPT_NO || ' Y SU MEDIA DE SALARIO ES ' ||V_MEDIA);
END IF;
END;
/

/*EJ6 Crea un bloque an�nimo para borrar un empleado pidiendo por pantalla el n�mero de empleado. Si
el empledo no existe mostrar el mensaje 'Empleado no encontrado' y si existe mostrar 'Se ha
eliminado el empleado con c�digo ____'. Gestionar las excepciones pertinentes*/

DECLARE
V_EMPLEADO emple.emp_no%TYPE := &INPUT_EMP_NO_A_MATAR;
V_RETURNED EMPLE.EMP_NO%TYPE;
BEGIN

SELECT EMP_NO INTO V_RETURNED
FROM EMPLE WHERE EMP_NO = V_EMPLEADO;

IF V_RETURNED != 0 THEN
DBMS_OUTPUT.PUT_LINE('EMPLEADO N�MERO '||V_RETURNED|| ' HA LLEGADO TU FINAL');
DELETE FROM EMPLE WHERE EMP_NO = V_RETURNED;
end if;

exception 
when others then
dbms_output.put_line('No existe ese empleado');
end;
/

/* EJ 7 Crear una tabla copiaAlum con la estructura de la tabla alumnos. Crea un bloque an�nimo que copie
en esa tabla los alumnos de la tabla Alumnos que vivan en �Madrid�.
Mostrar al usuario el n�mero de filas insertadas en la ejecuci�n del bloque an�nimo. 
Gestionar las excepciones pertinentes
(DUP_VAL_ON_INDEX es la excepci�n que se genera cuando se viola la clave primaria */

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
Crea un bloque an�nimo que inserte un empleado en la tabla EMPLE. Su n�mero ser� superior m�s
uno de los existentes y la fecha de incorporaci�n a la empresa ser� la actual. El departamento ser� el
departamento con una media del salario m�s alta, si son varios departamentos mostrar un mensaje
indic�ndolo. El resto de los campos ser� NULL
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
dbms_output.put_line('Hay ' || v_count || ' departamentos con la media m�xima de salario ');
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