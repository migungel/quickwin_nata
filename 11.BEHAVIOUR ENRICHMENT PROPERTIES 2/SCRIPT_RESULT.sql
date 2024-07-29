ln_behaviour_oper_stage_id number := 4068;
---------------REFRESH--------------------------------------
http://192.168.37.146:8101/quickWin/clearCampaignById/100129
---------------SELECT--------------------------------------
SELECT * FROM behaviour_oper_stages T WHERE T.BEHAVIOUR_OPERATION_ID = 865 order by t.order_by;
SELECT * FROM behaviour_enrichment_property T WHERE T.BEHAVIOUR_OPER_STAGE_ID = 4068 order by t.order_by;
--------------UPDATE STATUS---------------------------------------
update behaviour_enrichment_property t set status = 'I' where t.BEHAVIOUR_OPER_STAGE_ID = 4068;
--------------DELETE---------------------------------------
delete behaviour_enrichment_property b where b.BEHAVIOUR_OPER_STAGE_ID = 4068;
---------------REQUEST----------------------------------------------
http://192.168.37.146:8101/quickWin/getActivateRequest
