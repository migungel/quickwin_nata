DECLARE
  -- CONDITIONS
  -- USAR ID DE CONDICION QUE SE NECESITE
  ln_condition_id NUMBER := NULL;
  ln_operation_type_id1 VARCHAR2(200) := 'confirmOrder';
  ln_campaign_id NUMBER := 100129;
  -- USAR ID DE INVOCADOR QUE SE NECESITE
  ln_invoke_id NUMBER := 757;
  -- obligatorio definir
  ln_behaviour_oper_id NUMBER := 718;
  ln_behaviour_oper_stage_id NUMBER := 3196;

BEGIN
  -- insertar
  INSERT INTO behaviour_enrichment (
    BEHAVIOUR_ENRICHMENT_ID, 
    BEHAVIOUR_OPER_STAGE_ID, 
    CONDITION_ID, 
    INVOKE_ID, 
    ORDER_BY, 
    REQUIRED, 
    STATUS, 
    NOTIFICATION_GROUP_ID, 
    WHEN_RESP_NOT_SUCCESS, 
    CONDITION_GROUP_ID, 
    DEFINED_FUNCTION_CALL_ID, 
    EXECUTION_PRIORITY, 
    RETRIES, 
    APPLY_COMPENSATION, 
    INVOKE_ID_COMP_BACKWARD, 
    INVOKE_ID_COMP_FORWARD
  ) VALUES (
    (SELECT NVL(MAX(T.behaviour_enrichment_id), 0) + 1 
     FROM behaviour_enrichment T),
    ln_behaviour_oper_stage_id, 
    ln_condition_id, 
    ln_invoke_id, 
    (SELECT NVL(MAX(T.ORDER_BY), 0) + 10 
     FROM BEHAVIOUR_ENRICHMENT T 
     WHERE T.BEHAVIOUR_OPER_STAGE_ID = ln_behaviour_oper_stage_id), 
    'YES', 
    'A', 
    NULL, 
    '', 
    '', 
    NULL, 
    'CONDITION', 
    0, 
    'NO', 
    '', 
    ''
  );

  DBMS_OUTPUT.put_line('ln_behaviour_oper_stage_id number := ' || ln_behaviour_oper_stage_id || ';');
  DBMS_OUTPUT.put_line('---------------REFRESH--------------------------------------');
  DBMS_OUTPUT.put_line('http://192.168.37.146:8101/quickWin/clearCampaignById/' || ln_campaign_id);
  DBMS_OUTPUT.put_line('---------------SELECT--------------------------------------');
  DBMS_OUTPUT.put_line('SELECT * FROM behaviour_oper_stages T WHERE T.BEHAVIOUR_OPERATION_ID = ' || ln_behaviour_oper_id || ' ORDER BY t.order_by;');
  DBMS_OUTPUT.put_line('SELECT * FROM behaviour_enrichment T WHERE T.BEHAVIOUR_OPER_STAGE_ID = ' || ln_behaviour_oper_stage_id || ' ORDER BY t.order_by;');
  DBMS_OUTPUT.put_line('--------------UPDATE STATUS---------------------------------------');
  DBMS_OUTPUT.put_line('UPDATE behaviour_enrichment T SET status = ''I'' WHERE T.BEHAVIOUR_OPER_STAGE_ID = ' || ln_behaviour_oper_stage_id || ';');
  DBMS_OUTPUT.put_line('--------------DELETE---------------------------------------');
  DBMS_OUTPUT.put_line('DELETE behaviour_enrichment B WHERE B.BEHAVIOUR_OPER_STAGE_ID = ' || ln_behaviour_oper_stage_id || ';');
  DBMS_OUTPUT.put_line('---------------REQUEST----------------------------------------------');
  DBMS_OUTPUT.put_line('http://192.168.37.146:8101/quickWin/getActivateRequest');
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    DBMS_OUTPUT.put_line(SQLERRM);
END;
