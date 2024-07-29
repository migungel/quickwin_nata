-- SELECT * FROM OPERATION_TYPES ot 
-- INSERT INTO OPERATION_TYPES VALUES ('activeChangeAccount', 'activeChangeAccount', SYSTIMESTAMP, )

-- REVISAR SI YA ESTA CREADO
DECLARE
  fecha_actual DATE;
  fecha_futura DATE;
  numero_de_anios NUMBER := 70; -- Puedes ajustar este valor según tus necesidades
BEGIN
  fecha_actual := SYSDATE;
  fecha_futura := ADD_MONTHS(fecha_actual, numero_de_anios * 12);

 	INSERT INTO OPERATION_TYPES(OPERATION_TYPE_ID,OPERATION_NAME, VALID_FROM,  VALID_UNTIL,STATUS ) 
  VALUES ('activeChangeAccount', 'activeChangeAccount', fecha_actual, fecha_futura, 'A');
 
  DBMS_OUTPUT.PUT_LINE('Fecha Actual: ' || fecha_actual);
  DBMS_OUTPUT.PUT_LINE('Fecha Futura (' || numero_de_anios || ' años después): ' || fecha_futura);
END;
