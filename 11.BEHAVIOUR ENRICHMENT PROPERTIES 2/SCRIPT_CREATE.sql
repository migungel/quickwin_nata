DECLARE
ln_condition_id number := 3793;
ln_function_call_id number := null;
ln_behaviour_oper_id number := 865;
ln_behaviour_oper_stage_id number := 4068;
ln_campaign_id              NUMBER := 100129;
lv_data VARCHAR2(32767) := '[
 {
    "id":"STATUS",
    "value":[
      "FAILED"    
    ]
  }
]';

BEGIN
  INSERT INTO behaviour_enrichment_property 
  (
    BEHAVIOUR_ENRICHE_PROPERTY_ID,
    BEHAVIOUR_OPER_STAGE_ID, 
    CONDITION_ID, 
    WHEN, 
    ORDER_BY, 
    SESSION_DATA, 
    STATUS,
    CONDITION_GROUP_ID, 
    DEFINED_FUNCTION_CALL_ID, 
    EXECUTION_PRIORITY
  )
  VALUES 
  (
    (
      SELECT NVL(MAX(BP.BEHAVIOUR_ENRICHE_PROPERTY_ID),0) + 1 
      FROM BEHAVIOUR_ENRICHMENT_PROPERTY BP
    ),
    ln_behaviour_oper_stage_id, 
    ln_condition_id,
    'POST',
    20,
    lv_data,
    'I', --INHABILITADO?
    '', 
    ln_function_call_id, 
    'CONDITION'
  );
  
  dbms_output.put_line('ln_behaviour_oper_stage_id number := '||ln_behaviour_oper_stage_id||';');
  dbms_output.put_line('---------------REFRESH--------------------------------------');
  dbms_output.put_line('http://192.168.37.146:8101/quickWin/clearCampaignById/'||ln_campaign_id);
  dbms_output.put_line('---------------SELECT--------------------------------------');
  dbms_output.put_line('SELECT * FROM behaviour_oper_stages T WHERE T.BEHAVIOUR_OPERATION_ID = '||ln_behaviour_oper_id||' order by t.order_by;');
  dbms_output.put_line('SELECT * FROM behaviour_enrichment_property T WHERE T.BEHAVIOUR_OPER_STAGE_ID = '||ln_behaviour_oper_stage_id||' order by t.order_by;');
  dbms_output.put_line('--------------UPDATE STATUS---------------------------------------');
  dbms_output.put_line('update behaviour_enrichment_property t set status = ''I'' where t.BEHAVIOUR_OPER_STAGE_ID = '||ln_behaviour_oper_stage_id||';');
  dbms_output.put_line('--------------DELETE---------------------------------------');
  dbms_output.put_line('delete behaviour_enrichment_property b where b.BEHAVIOUR_OPER_STAGE_ID = '||ln_behaviour_oper_stage_id||';');
  dbms_output.put_line('---------------REQUEST----------------------------------------------');
  dbms_output.put_line('http://192.168.37.146:8101/quickWin/getActivateRequest');
  exception when others then
  rollback;
  dbms_output.put_line(sqlerrm);
end;