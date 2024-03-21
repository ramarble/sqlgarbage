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
    