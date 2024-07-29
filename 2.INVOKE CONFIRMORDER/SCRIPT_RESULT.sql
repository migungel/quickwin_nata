LN_EXT_RES_GROUP ID: 453
LN_EXT_RES ID: 14935
INVOKE ID: 3085
---------------REFRESH---------------------------------- ----
http://192.168.37.146:8101/quickWin/refreshInvokeById/3085
---------------GUARDE ESTE SCRIPT POR MAYOR SEGURIDAD-------------------------------------
---------------SELECT--------------------------------------
SELECT * FROM INVOKE T WHERE T.INVOKE_ID = '3085';
SELECT * FROM EXTERNAL_RESOURCE_GROUPS T WHERE T.EXTERNAL_RESOURCE_GROUP_ID = '453';
SELECT * FROM EXTERNAL_RESOURCES T WHERE T.EXTERNAL_RESOURCE_ID = '14935';
SELECT * FROM EXTERNAL_RESOURCE_COMPONENTS T WHERE T.EXTERNAL_RESOURCE_ID = '14935';
SELECT * FROM INVOKE_MAPPING T WHERE T.INVOKE_ID = '3085';
SELECT * FROM INVOKE_RESPONSE_EVALUATION T WHERE T.INVOKE_ID = '3085';
--------------UPDATE STATUS---------------------------------------
update INVOKE T set status = 'I' WHERE T.INVOKE_ID = '3085';
update EXTERNAL_RESOURCE_GROUPS T set status = 'I' WHERE T.EXTERNAL_RESOURCE_GROUP_ID = '453';
update EXTERNAL_RESOURCES T set status = 'I' WHERE T.EXTERNAL_RESOURCE_ID = '14935';
update EXTERNAL_RESOURCE_COMPONENTS T set status = 'I' WHERE T.EXTERNAL_RESOURCE_ID = '14935';
update INVOKE_MAPPING T set status = 'I' WHERE T.INVOKE_ID = '3085';
update INVOKE_RESPONSE_EVALUATION T set status = 'I' WHERE T.INVOKE_ID = '3085';
--------------DELETE---------------------------------------
delete INVOKE_RESPONSE_EVALUATION T WHERE T.INVOKE_ID = '3085';
delete INVOKE_MAPPING T WHERE T.INVOKE_ID = '3085';
delete EXTERNAL_RESOURCE_COMPONENTS T WHERE T.EXTERNAL_RESOURCE_ID = '14935';
delete EXTERNAL_RESOURCES T WHERE T.EXTERNAL_RESOURCE_ID = '14935';
delete EXTERNAL_RESOURCE_GROUPS T WHERE T.EXTERNAL_RESOURCE_GROUP_ID = '453';
delete INVOKE T WHERE T.INVOKE_ID = '3085';
---------------REQUEST----------------------------------------------
http://192.168.37.146:8101/quickWin/executeInvoke
---------------POST REST--------------------------------- -----
{
  "invokeId": "3085",
  "invokerName": "Prueba Invoke", 
  "cacheOptions":"0", 
  "sync":"YES", 
  "customerInvokerId":"id12345", 
  "sessionData": { 
    "externalSubscriberProperties": [
      {"id": "FUNCTION_REQUESTER_IDENTIFIER","value": [""]},
      {"id": "FUNCTION_CALL_IDENTIFIER","value": [""]},
      {"id": "EID","value": [""]},
      {"id": "ICCID","value": [""]},
      {"id": "MATCHING_ID","value": [""]},
      {"id": "CONFIRMATION_CODE","value": [""]},
      {"id": "SMDS_ADDRESS","value": [""]},
      {"id": "RELEASE_FLAG","value": [""]},
      {"id": "DISPLAY_PROFILE_NAME","value": [""]},
      {"id": "DUMMY","value": [""]}
 ] } }
