DECLARE
  ln_campaign_id number := 100129;
  ln_behaviour_oper_id number := 865;
  ln_behaviour_oper_stage_id number := 4068;
  lv_subscriber_property_id varchar(32767) := '';
  lv_condition_id number := 0;
  lv_domain_id number := 0;
  lv_domain_value_range_id number := 0;
  lv_condition_property_id number := 0;
  lv_identifier varchar(15) := '[22385] ';

BEGIN

  -- CONDITION
  SELECT nvl(max(c.condition_id), 0) + 1 
  INTO lv_condition_id 
  FROM CONDITION c;

  INSERT INTO CONDITION 
  (
    CONDITION_ID, 
    DESCRIPTION
  )
  VALUES 
  (
    lv_condition_id, 
    lv_identifier||'eSIM QR Code - Valida si el estado del ICCID se encuentra vacio.'
  );

  -- SUBSCRIBER_PROPERTIES 
  lv_subscriber_property_id := 'ESTADO';

  -- DOMAIN
  SELECT nvl(max(d.domain_id), 0) + 1 
  INTO lv_domain_id 
  FROM DOMAIN d;

  INSERT INTO DOMAIN 
  (
    DOMAIN_ID, 
    DESCRIPTION, 
    STATUS
  )
  VALUES 
  (
    lv_domain_id,
    lv_identifier||'eSIM QR Code - Dominio con valor vacio',
    'A'
  );
  
  -- Si son mas valores, agregarlos con comas, (select 'a,b,c' from dual)
  INSERT INTO DOMAIN_ELEMENTS
  SELECT rownum +
  (SELECT NVL(MAX(DE.DOMAIN_ELEMENT_ID),0) + 1 FROM DOMAIN_ELEMENTS DE)
  DOMAIN_ELEMENT_ID,
  trim(regexp_substr(valor, '[^,]+', 1, level)) ELEMENT_VALUE,
  lv_domain_id DOMAIN_ID, --Dominio al que pertenece
  'A' STATUS
  FROM (select '' valor from dual) t
  CONNECT BY instr(valor, ',', 1, level - 1) > 0;

  -- DOMAIN_VALUE_RANGES (NO APLICA)
  -- SELECT nvl(max(dvr.domain_value_range_id), 0) + 1 
  -- INTO lv_domain_value_range_id 
  -- FROM DOMAIN_VALUE_RANGES dvr;
  -- INSERT INTO DOMAIN_VALUE_RANGES 
  -- (
  --   DOMAIN_VALUE_RANGE_ID, 
  --   DOMAIN_ID, 
  --   FROM_VALUE,
  --   TO_VALUE, 
  --   ORDER_BY, 
  --   STATUS
  -- )
  -- VALUES 
  -- (
  --   lv_domain_value_range_id, 
  --   lv_domain_id, 
  --   '30', 
  --   '99999999', 
  --   10, 
  --   'A'
  -- );

  -- CONDITION_PROPERTIES
  SELECT nvl(max(cp.condition_property_id), 0) + 1 
  INTO lv_condition_property_id
  FROM CONDITION_PROPERTIES cp;

  INSERT INTO CONDITION_PROPERTIES 
  (
    CONDITION_PROPERTY_ID, 
    CONDITION_ID,
    SUBSCRIBER_PROPERTY_ID,
    ORDER_BY,
    DATA_TYPE, 
    EXPRESSION_CONDITION,
    DOMAIN_ID,
    MIN_NUM_DOMAIN_ELEMENTS, 
    MAX_NUM_DOMAIN_ELEMENTS,
    SUCCESS_MESSAGE,
    FAIL_MESSAGE
  )
  VALUES 
  (
    lv_condition_property_id, 
    lv_condition_id, 
    lv_subscriber_property_id,
    10,
    'VARCHAR', 
    '[SP=DM]',
    lv_domain_id, 
    null, 
    null,
    'No se encuentra el ICCID registrada en el repositorio eSIM.',
    'Si se encuentra el ICCID registrada en el repositorio eSIM.'
  );

  ----- (NO APLICA)
  -- INSERT INTO behaviour_validations 
  -- (
  --   BEHAVIOUR_VALIDATION_ID,
  --   BEHAVIOUR_OPER_STAGE_ID, 
  --   DESCRIPTION, 
  --   CONDITION_ID, 
  --   ORDER_BY, 
  --   SCHEDULE_ID,
  --   STATUS, 
  --   NOTIFICATION_GROUP_ID, 
  --   CONDITION_GROUP_ID
  -- )
  -- VALUES 
  -- (
  --   (SELECT NVL(MAX(T.behaviour_validation_id),0) + 1 FROM behaviour_validations T), 
  --   ln_behaviour_oper_stage_id, 
  --   'Valida que el numero de dias sea mayor a 30', 
  --   lv_condition_id,
  --   ((SELECT NVL(MAX(T.Order_By),0) + 10 FROM behaviour_validations T where
  --   t.behaviour_oper_stage_id = ln_behaviour_oper_stage_id )), 
  --   null, 
  --   'A', 
  --   null, 
  --   ''
  -- );


  dbms_output.put_line('lv_domain_id ' || lv_domain_id);
  dbms_output.put_line('lv_condition_id ' || lv_condition_id);
  dbms_output.put_line('SUBSCRIBER_PROPERTIES ' || lv_subscriber_property_id);
  dbms_output.put_line('ln_behaviour_oper_stage_id number := '||ln_behaviour_oper_stage_id||';');
  dbms_output.put_line('---------------REFRESH--------------------------------------');
  dbms_output.put_line('http://192.168.37.146:8101/quickWin/clearCampaignById/'||ln_campaign_id);
  dbms_output.put_line('http://192.168.37.146:8101/quickWin/clearConditionById/'||lv_condition_id);
  dbms_output.put_line('---------------GUARDE ESTE SCRIPT POR MAYOR SEGURIDAD------------------------');
  dbms_output.put_line('---------------SELECT--------------------------------------');
  --DELETE FROM CONDITION_PROPERTIES t where t.condition_property_id = ;
  dbms_output.put_line('SELECT * FROM DOMAIN_VALUE_RANGES t where t.domain_id = '''||lv_domain_id||''';');
  dbms_output.put_line('SELECT * FROM DOMAIN_ELEMENTS t where t.domain_id = '''||lv_domain_id||''';');
  dbms_output.put_line('SELECT * FROM DOMAIN t where t.domain_id = '''||lv_domain_id||''';');
  dbms_output.put_line('SELECT * FROM CONDITION_PROPERTIES T WHERE T.CONDITION_ID = '''||lv_condition_id||''';');
  dbms_output.put_line('SELECT * FROM CONDITION t where t.condition_id = '''||lv_condition_id||''';');
  dbms_output.put_line('http://192.168.37.146:8101/quickWin/findConditionById/'||lv_condition_id);
  dbms_output.put_line('SELECT * FROM behaviour_oper_stages T WHERE T.BEHAVIOUR_OPERATION_ID = '||ln_behaviour_oper_id||' order by t.order_by;');
  dbms_output.put_line('SELECT * FROM behaviour_validations T WHERE T.BEHAVIOUR_OPER_STAGE_ID = '||ln_behaviour_oper_stage_id||' order by t.order_by;');
  dbms_output.put_line('--------------UPDATE STATUS---------------------------------------');
  dbms_output.put_line('UPDATE DOMAIN_VALUE_RANGES t set status = ''I'' where t.domain_id = '''||lv_domain_id||''';');
  dbms_output.put_line('UPDATE DOMAIN_ELEMENTS t set status = ''I'' where t.domain_id = '''||lv_domain_id||''';');
  dbms_output.put_line('UPDATE DOMAIN t set status = ''I'' where t.domain_id = '''||lv_domain_id||''';');
  dbms_output.put_line('UPDATE CONDITION_PROPERTIES T set status = ''I'' WHERE T.CONDITION_ID = '''||lv_condition_id||''';');
  dbms_output.put_line('UPDATE SUBSCRIBER_PROPERTIES t set status = ''I'' where t.Condition_Id = '''||lv_condition_id||''';');
  dbms_output.put_line('UPDATE CONDITION t set status = ''I'' where t.condition_id = '''||lv_condition_id||''';');
  dbms_output.put_line('http://192.168.37.146:8101/quickWin/clearConditionById/'||lv_condition_id);
  dbms_output.put_line('update behaviour_validations t set status = ''I'' where t.BEHAVIOUR_OPER_STAGE_ID = '||ln_behaviour_oper_stage_id||';');
  dbms_output.put_line('--------------DELETE---------------------------------------');
  dbms_output.put_line('DELETE FROM DOMAIN_VALUE_RANGES t where t.domain_id = '''||lv_domain_id||''';');
  dbms_output.put_line('DELETE FROM DOMAIN_ELEMENTS t where t.domain_id = '''||lv_domain_id||''';');
  dbms_output.put_line('DELETE FROM DOMAIN t where t.domain_id = '''||lv_domain_id||''';');
  dbms_output.put_line('DELETE FROM CONDITION_PROPERTIES T WHERE T.CONDITION_ID = '''||lv_condition_id||''';');
  dbms_output.put_line('DELETE FROM CONDITION t where t.condition_id = '''||lv_condition_id||''';');
  dbms_output.put_line('delete behaviour_validations b where b.BEHAVIOUR_OPER_STAGE_ID = '||ln_behaviour_oper_stage_id||';');
  dbms_output.put_line('---------------REQUEST----------------------------------------------');
  dbms_output.put_line('http://192.168.37.146:8101/quickWin/getActivateRequest');

  dbms_output.put_line('---------------REQUEST----------------------------------------------');
  dbms_output.put_line('http://192.168.37.146:8101/quickWin/executeCondition');
  dbms_output.put_line('---------------POST REST--------------------------------------');
  dbms_output.put_line('{
  "conditionId": "'||lv_condition_id||'",
  "invokerName":"TestQuickWin",
  "cacheOptions":"0",
  "sessionData": {
    "externalSubscriberProperties": [');
    FOR subs IN (SELECT T.SUBSCRIBER_PROPERTY_ID FROM CONDITION_PROPERTIES T WHERE
    T.CONDITION_ID = lv_condition_id) LOOP
    dbms_output.put_line(' {"id":
    "'||subs.subscriber_property_id||'","value": [""]},');
    END LOOP;
    -- DATOS DE LA FUNCION
    dbms_output.put_line(' {"id": "'||'DUMMY'||'","value": [""]}');
    dbms_output.put_line(' ]');
    dbms_output.put_line(' }
  }');

--chequear los erroes
exception when others then
rollback;
dbms_output.put_line(sqlerrm);
end;