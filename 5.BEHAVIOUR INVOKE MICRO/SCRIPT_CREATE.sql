DECLARE
  ln_invoke_id  NUMBER := 3086;
  ln_beh_oper_invoke_id       NUMBER;
  ln_behaviour_oper_id        NUMBER := 865;
  ln_behaviour_oper_stage_id  NUMBER := 4068;
  ln_campaign_id              NUMBER := 100129;
  lv_session_data             VARCHAR2(32767) := '[
 {
    "id":"INFORMATION_SERVICE",
    "value":[
      "Esim:updateEstadoPorICCID"    
    ]
  },
  {
    "id":"ESTADO",
    "value":[
      "U"    
    ]
  },
  {
    "id":"COMENTARIOS",
    "value":[
      "Se actualiza estado de ICCID a Utilizado"    
    ]
  },{
    "id":"STATUS",
    "value":[
      "Execute-Success"    
    ]
  },{
    "id":"MATCHING_ID",
    "value":[
      "DKA73E08L23XVVB9DBPSKCXQWR8WBBT0BWF2UYNC3AK6FRPDH3LGQD2ZO61XXVVI"    
    ]
  },{
    "id":"SMDP_ADDRESS",
    "value":[
      "claroecuador.validspereachdpplus.com"    
    ]
  } 
]';

--
BEGIN
-- BEHAVIOUR_OPER_INVOKE --
  SELECT Nvl(Max(BI.behaviour_oper_invoke_id),0) + 1
  INTO   ln_beh_oper_invoke_id
  FROM   behaviour_oper_invoke BI;

  INSERT INTO behaviour_oper_invoke 
  (
    behaviour_oper_invoke_id,
    behaviour_oper_stage_id,
    when,
    condition_id,
    invoke_id,
    order_by,
    required,
    status,
    sync,
    notification_group_id,
    session_data,
    schedule_id,
    when_condition,
    when_schedule,
    when_resp_not_success,
    retries,
    apply_compensation,
    invoke_id_comp_backward,
    invoke_id_comp_forward,
    condition_group_id,
    looping_operation_id,
    copy_from_subs_to_subs
  )
  VALUES 
  (
    ln_beh_oper_invoke_id,
    ln_behaviour_oper_stage_id,
    'POST',
    null,
    ln_invoke_id,
    20,
    'YES',
    'A',
    'YES',
    null,
    lv_session_data,
    null,
    null,
    '',
    '',
    0,
    'NO',
    '',
    '',
    '',
    null,
    ''
  );

dbms_output.put_line('ln_behaviour_oper_stage_id number := '||ln_behaviour_oper_stage_id||';');
dbms_output.put_line('ln_beh_oper_invoke_id number := '||ln_beh_oper_invoke_id||';');
dbms_output.put_line('---------------REFRESH--------------------------------------');
dbms_output.put_line('http://192.168.37.146:8101/quickWin/clearCampaignById/'||ln_campaign_id);
dbms_output.put_line('---------------SELECT--------------------------------------');
dbms_output.put_line('SELECT * FROM behaviour_oper_stages T WHERE T.BEHAVIOUR_OPERATION_ID = '||ln_behaviour_oper_id||' order by t.order_by;');
dbms_output.put_line('SELECT * FROM BEHAVIOUR_OPER_INVOKE T WHERE T.BEHAVIOUR_OPER_STAGE_ID = '||ln_behaviour_oper_stage_id||' order by t.order_by;');
dbms_output.put_line('--------------UPDATE STATUS---------------------------------------');
dbms_output.put_line('update BEHAVIOUR_OPER_INVOKE t set status = ''I'' where t.BEHAVIOUR_OPER_STAGE_ID = '||ln_behaviour_oper_stage_id||';');
dbms_output.put_line('--------------DELETE---------------------------------------');
dbms_output.put_line('delete BEHAVIOUR_OPER_INVOKE b where b.BEHAVIOUR_OPER_STAGE_ID = '||ln_behaviour_oper_stage_id||';');
dbms_output.put_line('---------------REQUEST----------------------------------------------');
dbms_output.put_line('http://192.168.37.146:8101/quickWin/getActivateRequest');
exception when others then
rollback;
dbms_output.put_line(sqlerrm);
end;