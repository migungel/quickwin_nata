ln_behaviour_oper_stage_id number := 4068;
---------------REFRESH--------------------------------------
http://192.168.37.146:8101/quickWin/clearCampaignById/100129
---------------SELECT--------------------------------------
SELECT * FROM behaviour_oper_stages T WHERE T.BEHAVIOUR_OPERATION_ID = 865 ORDER BY t.order_by;
SELECT * FROM behaviour_enrichment T WHERE T.BEHAVIOUR_OPER_STAGE_ID = 4068 ORDER BY t.order_by;
--------------UPDATE STATUS---------------------------------------
UPDATE behaviour_enrichment T SET status = 'I' WHERE T.BEHAVIOUR_OPER_STAGE_ID = 4068;
--------------DELETE---------------------------------------
DELETE behaviour_enrichment B WHERE B.BEHAVIOUR_OPER_STAGE_ID = 4068;
---------------REQUEST----------------------------------------------
http://192.168.37.146:8101/quickWin/getActivateRequest
