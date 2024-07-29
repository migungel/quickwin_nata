lv_domain_id 6099
lv_condition_id 3793
SUBSCRIBER_PROPERTIES ESTADO
ln_behaviour_oper_stage_id number := 4068;
---------------REFRESH--------------------------------------
http://192.168.37.146:8101/quickWin/clearCampaignById/100129
http://192.168.37.146:8101/quickWin/clearConditionById/3793
---------------GUARDE ESTE SCRIPT POR MAYOR SEGURIDAD------------------------
---------------SELECT--------------------------------------
SELECT * FROM DOMAIN_VALUE_RANGES t where t.domain_id = '6099';
SELECT * FROM DOMAIN_ELEMENTS t where t.domain_id = '6099';
SELECT * FROM DOMAIN t where t.domain_id = '6099';
SELECT * FROM CONDITION_PROPERTIES T WHERE T.CONDITION_ID = '3793';
SELECT * FROM CONDITION t where t.condition_id = '3793';
http://192.168.37.146:8101/quickWin/findConditionById/3793
SELECT * FROM behaviour_oper_stages T WHERE T.BEHAVIOUR_OPERATION_ID = 865 order by t.order_by;
SELECT * FROM behaviour_validations T WHERE T.BEHAVIOUR_OPER_STAGE_ID = 4068 order by t.order_by;
--------------UPDATE STATUS---------------------------------------
UPDATE DOMAIN_VALUE_RANGES t set status = 'I' where t.domain_id = '6099';
UPDATE DOMAIN_ELEMENTS t set status = 'I' where t.domain_id = '6099';
UPDATE DOMAIN t set status = 'I' where t.domain_id = '6099';
UPDATE CONDITION_PROPERTIES T set status = 'I' WHERE T.CONDITION_ID = '3793';
UPDATE SUBSCRIBER_PROPERTIES t set status = 'I' where t.Condition_Id = '3793';
UPDATE CONDITION t set status = 'I' where t.condition_id = '3793';
http://192.168.37.146:8101/quickWin/clearConditionById/3793
update behaviour_validations t set status = 'I' where t.BEHAVIOUR_OPER_STAGE_ID = 4068;
--------------DELETE---------------------------------------
DELETE FROM DOMAIN_VALUE_RANGES t where t.domain_id = '6099';
DELETE FROM DOMAIN_ELEMENTS t where t.domain_id = '6099';
DELETE FROM DOMAIN t where t.domain_id = '6099';
DELETE FROM CONDITION_PROPERTIES T WHERE T.CONDITION_ID = '3793';
DELETE FROM CONDITION t where t.condition_id = '3793';
delete behaviour_validations b where b.BEHAVIOUR_OPER_STAGE_ID = 4068;
---------------REQUEST----------------------------------------------
http://192.168.37.146:8101/quickWin/getActivateRequest
---------------REQUEST----------------------------------------------
http://192.168.37.146:8101/quickWin/executeCondition
---------------POST REST--------------------------------------
{
  "conditionId": "3793",
  "invokerName":"TestQuickWin",
  "cacheOptions":"0",
  "sessionData": {
    "externalSubscriberProperties": [
      {
        "id":
        "ESTADO","value": [""]
      },
      {
        "id": 
        "DUMMY","value": [""]
      }
    ]
  }
}