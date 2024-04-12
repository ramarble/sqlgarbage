set serveroutput on;
--ejercicio 1 Crea un bloque anónimo para visualizar el apellido de los empleados del departamento 20.
DECLARE
    v_ape   VARCHAR2(50);

    CURSOR cape IS
    SELECT
        apellido
    FROM
        emple
    WHERE
        dept_no=20;

BEGIN
    OPEN cape;
    LOOP
        FETCH cape INTO v_ape;
        EXIT WHEN cape%notfound;
        dbms_output.put_line(v_ape);
    END LOOP;
    CLOSE cape;
END;
/

--Visualizar los apellidos de los empleados de un departamento indicado por parámetro, creando
--un procedimiento que utiliza cursor y bucle WHILE. Si el apellido es nulo indicar 'Apellido Nulo'.


create or replace procedure procej2(v_input varchar2) as 
    v_ape VARCHAR2(50);
    CURSOR cloop IS
    SELECT APELLIDO FROM EMPLE WHERE DEPT_NO = V_INPUT;
    
BEGIN
    OPEN CLOOP;
    FETCH CLOOP INTO V_APE;
    WHILE CLOOP%FOUND LOOP
        DBMS_OUTPUT.PUT_LINE(V_APE);
        FETCH CLOOP INTO V_APE;
    END LOOP;
    CLOSE CLOOP;
    
EXCEPTION WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('OOPS');
END;
/

execute procej2('20');

-- Ejercicio anterior con for
--NOTE: THIS SUCKS

create or replace procedure procej3(v_input varchar2) as
    v_ape varchar2(50);
    cursor CLOOP2 is
    select apellido from emple where dept_no = v_input;
    
begin
    FOR REG IN CLOOP2 LOOP
    DBMS_OUTPUT.PUT_LINE(REG.APELLIDO);
    END LOOP;
    END;
    /
    
CLOSE CLOOP2;
EXECUTE PROCEJ3('20');


--Crea un bloque anónimo para visualizar el apellido, el oficio y la comisión de los empleados cuya
--comisión supera 50000 utilizando FOR..LOOP.

DECLARE
    CURSOR cloop3 IS
    SELECT
        apellido,
        oficio,
        comision
    FROM
        emple
    WHERE
        comision > 50000;

BEGIN
    FOR reg IN cloop3 LOOP
        dbms_output.put_line(reg.comision);
    END LOOP;
END;
/
        
        
--Crea un procedimiento que muestre el número de cada departamento y el número de
--empleados que tiene. Mostrar también los departamentos que no tienen empleados.

set serveroutput on;    
DECLARE
    V_COUNT NUMBER;
    V_DEPT NUMBER;
    CURSOR CUR5 IS
    SELECT
        depart.dept_no, count(emp_no)
    FROM
        emple, depart
    where depart.dept_no = emple.dept_no(+)
    GROUP BY
        depart.dept_no;

BEGIN
OPEN CUR5;
FETCH CUR5 INTO V_COUNT, V_DEPT;
DBMS_OUTPUT.PUT_LINE('DEPT_NO  ' || 'COUNT IN DEPT');
WHILE CUR5%FOUND LOOP
    DBMS_OUTPUT.PUT_LINE(V_DEPT || '            ' || V_COUNT );
    FETCH CUR5 INTO V_COUNT, V_DEPT;
    END LOOP;
CLOSE CUR5;
END;
/
    
    
--Escribir un bloque PL/SQL que visualice el apellido y la fecha de alta de 
--todos los empleados de la empresa ordenados por fecha 
--de alta ascendente, mediante una estructura cursor FOR..LOOP.

CREATE OR REPLACE PROCEDURE LOOPEMPLE06 AS
    CURSOR CUR06 IS
        SELECT FECHA_ALT, APELLIDO 
            FROM EMPLE
            ORDER BY FECHA_ALT;

BEGIN
    FOR a in cur06 LOOP
        DBMS_OUTPUT.PUT_LINE(a.apellido || ' ' || a.fecha_alt);
    END LOOP;

END;
/

set serveroutput on;
execute loopemple06;




CREATE OR REPLACE PROCEDURE TEST0113 AS
CURSOR C1 IS
SELECT DEPT_NO FROM EMPLE;
CURSOR C2(DEP EMPLE.DEPT_NO%TYPE) IS 
SELECT APELLIDO FROM EMPLE WHERE DEPT_NO = DEP;
BEGIN

FOR I IN C1 LOOP
    FOR J IN C2(I.DEPT_NO) LOOP
    DBMS_OUTPUT.PUT_LINE(J.APELLIDO);
    END LOOP;
END LOOP;    
END;
/

EXECUTE TEST0113;

-- EJERCICIO ANTERIOR PERO CON WHILE

CREATE OR REPLACE PROCEDURE LOOPEMPLE07 AS
    VFEC EMPLE.FECHA_ALT%TYPE;
    VAPE EMPLE.APELLIDO%TYPE;
    CURSOR CUR07 IS
        SELECT FECHA_ALT, APELLIDO 
            FROM EMPLE
            ORDER BY FECHA_ALT;

BEGIN

OPEN CUR07;
FETCH CUR07 INTO VFEC, VAPE;
WHILE CUR07%FOUND LOOP
    DBMS_OUTPUT.PUT_LINE(VFEC ||' ' ||VAPE);
    FETCH CUR07 INTO VFEC, VAPE;
END LOOP;
END;
/
execute loopemple07;

--08 Crea un procedimiento que liste los empleados (emp_no, apellido)
--que tienen un apellido de un número de letras (longitud del apellido)
--que coincida con el número que el usuario inserta por parámetro. 
-- Si no hay ningún apellido con esa longitud mostrar un mensaje 
--'No hay apellidos conesa longitud'

--NO ME GUSTA ESTA SOLUCION
CREATE OR REPLACE PROCEDURE PROC08(APELEN NUMBER) AS
VBOOL BOOLEAN := FALSE;
CURSOR CUR0801(APELEN NUMBER) IS
    SELECT APELLIDO FROM EMPLE WHERE LENGTH(APELLIDO) = APELEN;
BEGIN

FOR a in CUR0801(APELEN) loop
VBOOL := TRUE;
DBMS_OUTPUT.PUT_LINE(A.APELLIDO);
END LOOP;

IF NOT VBOOL THEN
DBMS_OUTPUT.PUT_LINE('NO HAY APELLIDOS CON ESA LONGITUD');
END IF;

END;
/

EXECUTE PROC08(10);

--TAMPOCO ME GUSTA ESTA SOLUCIÓN 
CREATE OR REPLACE PROCEDURE PROC0802(APELEN NUMBER) AS
VAPE EMPLE.APELLIDO%TYPE;
CURSOR CUR0802(APELEN NUMBER) IS
    SELECT APELLIDO FROM EMPLE WHERE LENGTH(APELLIDO) = APELEN;
BEGIN

OPEN CUR0802(APELEN);
FETCH CUR0802 INTO VAPE;
IF CUR0802%NOTFOUND THEN
DBMS_OUTPUT.PUT_LINE('NOT FOUND');
END IF;

WHILE CUR0802%FOUND LOOP 
DBMS_OUTPUT.PUT_LINE(VAPE);
FETCH CUR0802 INTO VAPE;
END LOOP;
CLOSE CUR0802;
END;
/

EXECUTE PROC0802(9);

--Crea un procedimiento con un parámetro n que indica el número de departamento. 
--Se deben mostrar los apellidos de los empleados de los departamentos n hasta el n+4.
--Para cada departamento mostrar la lista de sus apellidos correspondientes. 
--Si el departamento no tiene empleados solo hay que mostrar el número de departamento. 
--Pista: utilizar variables de acoplamiento o cursores con parámetros


--that's it?
CREATE OR REPLACE PROCEDURE PROC0901(n number) AS
CURSOR CUR0901(N NUMBER) IS
SELECT APELLIDO, DEPT_NO FROM EMPLE WHERE DEPT_NO BETWEEN N AND N+20;
BEGIN

FOR I IN CUR0901(N) LOOP
DBMS_OUTPUT.PUT_LINE(I.DEPT_NO || ' ' ||I.APELLIDO);
END LOOP;

END;
/


EXECUTE PROC0901(10);

--10 Crea un bloque anónimo que devuelva el apellido y número de los 5
--empleados cuya comisión más salario sea menor. 
--Obviar la problemática de si el salario o la comisión son NULL
SET SERVEROUTPUT ON;
DECLARE
EMPLEADO EMPLE.APELLIDO%TYPE;
NUMERO EMPLE.EMP_NO%TYPE;
CURSOR CUR1001 IS 
    SELECT APELLIDO, EMP_NO FROM EMPLE ORDER BY SALARIO+COMISION ASC;
BEGIN

OPEN CUR1001;
FOR I IN 1..5 LOOP
FETCH CUR1001 INTO EMPLEADO, NUMERO;
DBMS_OUTPUT.PUT_LINE(EMPLEADO || ' ' || NUMERO);
END LOOP;
CLOSE CUR1001;
END;
/

--11 Realiza una función que muestre los apellidos de los empleados con salario 
--entre un salario mínimo y un salario máximo (ambos incluidos) 
--indicado por parámetro. La función debe retornar el número de empleados y sus apellidos
--que se encuentran en esa banda salarial (importante la función no muestra 
--por pantalla cuantos empleados hay en la banda salarial, sólo retorna ese valor).
--Implementa un ejemplo para probar la función. 
--Cuando la función de una excepción debe que retornar el valor -1



CREATE OR REPLACE FUNCTION FUNC1101(MINN NUMBER, MAXN NUMBER)
RETURN number as cantidadEmpleados number;
VAPE EMPLE.APELLIDO%TYPE;
CURSOR CUR1101(MINM NUMBER, MAXN NUMBER) 
    IS SELECT APELLIDO 
    FROM EMPLE 
    WHERE SALARIO BETWEEN MINM AND MAXN;
BEGIN

OPEN CUR1101(MINN, MAXN);
FETCH CUR1101 INTO VAPE;
WHILE CUR1101%FOUND LOOP
DBMS_OUTPUT.PUT_LINE(VAPE);
FETCH CUR1101 INTO VAPE;
END LOOP;
cantidadEmpleados := CUR1101%ROWCOUNT;
CLOSE CUR1101;
return cantidadEmpleados;
EXCEPTION when others then
return -1;
END;
/


execute dbms_output.put_line(func1101(1000,200000));

execute dbms_output.put_line(func1101(-1000,-10000));

--01 Dada la tabla libros2 crear un bloque anónimo que 
--muestre el código de libro, el título y el autor
--de los 3 libros con más unidades (en caso de igualdad 
--de unidades se toma como criterio de ordenación la 
--ordenación por defecto de Oracle)

DECLARE
CURSOR PARTE201 IS SELECT COD_LIBRO, TITULO, AUTOR FROM LIBROS2 ORDER BY UNIDADES; 
VCONT NUMBER(1);
BEGIN
VCONT := 0;
FOR I IN PARTE201 LOOP
VCONT := VCONT+1;
DBMS_OUTPUT.PUT_LINE(I.COD_LIBRO ||' ' || I.TITULO || ' ' ||I.AUTOR);
EXIT WHEN VCONT = 3;
END LOOP;
END;
/

--02 Codificar un bloque anónimo de PL/SQL que muestre el apellido, 
--el número de departamento y la localidad de los empleados que 
--ganen más de 1000€ y su comisión no sea nula. Los empleados
--que no tengan departamento deben aparecer. Los departamentos sin empleados no deben
--aparecer. Cuando un empleado no tenga departamento debe aparecer 
--“Sin dept” y cuando no tenga localidad “Sin loc”. 
--Los salarios NULL, NO se tomarán como 0. Cuando no haya ningún
--empleado que cumpla la condición no mostrar nada


--THIS WORK

DECLARE
VAPE EMPLE.APELLIDO%TYPE;
VDEPT VARCHAR2(10);
VLOC DEPART.LOC%TYPE;
VSALARIO EMPLE.SALARIO%TYPE;
VCOM EMPLE.COMISION%TYPE;
CURSOR P2CUR02 IS 
    SELECT E.APELLIDO, TO_CHAR(DECODE(D.DEPT_NO, 0, 'SIN DEPT', D.DEPT_NO)), D.LOC, E.SALARIO, E.COMISION
    FROM EMPLE E, DEPART D
    WHERE (SALARIO/12) > 1000
    AND COMISION IS NOT NULL
    AND D.DEPT_NO = E.DEPT_NO(+);
BEGIN

OPEN P2CUR02;
FETCH P2CUR02 INTO VAPE, VDEPT, VLOC, VSALARIO, VCOM;
WHILE P2CUR02%FOUND LOOP
DBMS_OUTPUT.PUT_LINE(VAPE || ' '|| VDEPT || ' ' ||  VLOC || ' ' ||VSALARIO ||' ' || VCOM);
FETCH P2CUR02 INTO VAPE, VDEPT, VLOC, VSALARIO, VCOM;
END LOOP;
CLOSE P2CUR02;
END;
/

DELETE FROM EMPLE WHERE EMP_NO = 1337;
INSERT INTO EMPLE VALUES (1337, 'JUANFRA', NULL, NULL, NULL, 999990, 30000, 0); 

INSERT INTO DEPART VALUES(0, 'MISSINGNO', 'GLITCH CITY');


--03 Tabla fabricantes y artículos. Realizar un procedimiento 
-- que pida dos códigos de fabricantes uno inicial y otro final.
-- El procedimiento debe mostrar, para cada fabricante una 
--línea indicando “Artículos para el fabricante con código: XX” 
--(donde XX es el código de fabricante). A continuación de la línea de
--cada fabricante, con una línea por artículo, los datos de los artículos 
--(artículo, peso, categoría y nombre) para ese fabricante

CREATE OR REPLACE PROCEDURE proccur03(cod1 NUMBER, cod2 NUMBER) AS
CURSOR CUR0301(cod1 number, cod2 number) IS 
    SELECT COD_FABRICANTE
    FROM FABRICANTES A
    WHERE COD_FABRICANTE BETWEEN cod1 AND cod2
    ORDER BY COD_FABRICANTE;
CURSOR CUR0302(COD1 NUMBER) IS
    SELECT A.ARTICULO, A.PESO, A.CATEGORIA
        FROM ARTICULOS A
        WHERE COD_FABRICANTE = cod1;
BEGIN

FOR I IN CUR0301(COD1, COD2) LOOP
    DBMS_OUTPUT.PUT_LINE('ARTÍCULOS PARA EL FABRICANTE CON CÓDIGO: ' || I.COD_FABRICANTE);
    FOR J IN CUR0302(I.COD_FABRICANTE) LOOP
        DBMS_OUTPUT.PUT_LINE(I.COD_FABRICANTE||' ' ||J.ARTICULO || ' ' || J.PESO || ' ' || J.CATEGORIA);
    END LOOP;
END LOOP;
END;
/
SET SERVEROUTPUT ON;
EXECUTE PROCCUR03(10,20);


--04 Dados dos números de departamento pasados por parámetro, 
--realizar una función que muestre el apellido de 
--los empleados de ambos departamentos. Además, debe devolver el número de
--departamento del departamento más grande (aquel con más empleados). Si alguno de los
--departamentos no existe indicarlo. Realizar el ejercicio usando un único cursor

CREATE OR REPLACE FUNCTION P2_04(DEP1 NUMBER, DEP2 NUMBER) 
RETURN NUMBER AS biggestDept NUMBER;
VCOUNT NUMBER := 0;
VCOUNT2 NUMBER := 0;
CURSOR CUR2_04(DEP1 NUMBER, DEP2 NUMBER) IS
    SELECT APELLIDO, DEPT_NO FROM EMPLE WHERE DEPT_NO IN (DEP1, DEP2);
BEGIN

FOR I IN CUR2_04(DEP1, DEP2) LOOP
DBMS_OUTPUT.PUT_LINE(I.APELLIDO);
IF I.DEPT_NO = DEP1 THEN 
    VCOUNT := VCOUNT +1;
    ELSE VCOUNT := VCOUNT -1;
END IF;
END LOOP;
IF VCOUNT = 0 THEN
    RETURN 0;
END IF;

IF VCOUNT > 0 THEN
    RETURN DEP1;
END IF;
RETURN DEP2;

END;
/
set serveroutput on;
EXECUTE DBMS_OUTPUT.PUT_LINE(P2_04(30,20));


--05 Programar un bloque anónimo. Dada la tabla libros2 y prestamo mostrar
--para cada cod_libro y título las distintas fechas de préstamo 
--con el formato Dia**Mes**Año. Las fechas deben
--mostrarse en orden descendente. La salida debe ser de la forma: 
--Código 1234 Titulo BBDD

DECLARE
CURSOR cur0501 IS
    SELECT L2.TITULO, P.COD_LIBRO, P.FECHA_PRESTAMO 
        FROM PRESTAMO P, LIBROS2 L2
        WHERE P.COD_LIBRO = L2.COD_LIBRO
            ORDER BY FECHA_PRESTAMO DESC;
BEGIN
FOR I IN CUR0501 LOOP
DBMS_OUTPUT.PUT_LINE(I.TITULO ||' ' ||I.FECHA_PRESTAMO);
END LOOP;
END;
/