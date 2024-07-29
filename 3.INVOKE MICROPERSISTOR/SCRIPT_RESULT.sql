LN_EXT_RES_GROUP ID: 490
LN_EXT_RES ID: 14936
INVOKE ID: 3086
---------------REFRESH---------------------------------- ----
http://192.168.37.146:8101/quickWin/refreshInvokeById/3086
---------------GUARDE ESTE SCRIPT POR MAYOR SEGURIDAD-------------------------------------
---------------SELECT--------------------------------------
SELECT * FROM INVOKE T WHERE T.INVOKE_ID = '3086';
SELECT * FROM EXTERNAL_RESOURCE_GROUPS T WHERE T.EXTERNAL_RESOURCE_GROUP_ID = '490';
SELECT * FROM EXTERNAL_RESOURCES T WHERE T.EXTERNAL_RESOURCE_ID = '14936';
SELECT * FROM EXTERNAL_RESOURCE_COMPONENTS T WHERE T.EXTERNAL_RESOURCE_ID = '14936';
SELECT * FROM INVOKE_MAPPING T WHERE T.INVOKE_ID = '3086';
SELECT * FROM INVOKE_RESPONSE_EVALUATION T WHERE T.INVOKE_ID = '3086';
--------------UPDATE STATUS---------------------------------------
update INVOKE T set status = 'I' WHERE T.INVOKE_ID = '3086';
update EXTERNAL_RESOURCE_GROUPS T set status = 'I' WHERE T.EXTERNAL_RESOURCE_GROUP_ID = '490';
update EXTERNAL_RESOURCES T set status = 'I' WHERE T.EXTERNAL_RESOURCE_ID = '14936';
update EXTERNAL_RESOURCE_COMPONENTS T set status = 'I' WHERE T.EXTERNAL_RESOURCE_ID = '14936';
update INVOKE_MAPPING T set status = 'I' WHERE T.INVOKE_ID = '3086';
update INVOKE_RESPONSE_EVALUATION T set status = 'I' WHERE T.INVOKE_ID = '3086';
--------------DELETE---------------------------------------
delete INVOKE_RESPONSE_EVALUATION T WHERE T.INVOKE_ID = '3086';
delete INVOKE_MAPPING T WHERE T.INVOKE_ID = '3086';
delete EXTERNAL_RESOURCE_COMPONENTS T WHERE T.EXTERNAL_RESOURCE_ID = '14936';
delete EXTERNAL_RESOURCES T WHERE T.EXTERNAL_RESOURCE_ID = '14936';
delete EXTERNAL_RESOURCE_GROUPS T WHERE T.EXTERNAL_RESOURCE_GROUP_ID = '490';
delete INVOKE T WHERE T.INVOKE_ID = '3086';
---------------REQUEST----------------------------------------------
http://192.168.37.146:8101/quickWin/executeInvoke
---------------POST REST--------------------------------- -----
{
  "invokeId": "3086", 
  "invokerName": "Prueba Invoke", 
  "cacheOptions":"0", 
  "sync":"YES", 
  "customerInvokerId":"id12345", 
  "sessionData": { 
    "externalSubscriberProperties": [
      {"id": "SMDP_ADDRESS","value": [""]},
      {"id": "MATCHING_ID","value": [""]},
      {"id": "ESTADO","value": [""]},
      {"id": "COMENTARIOS","value": [""]},
      {"id": "ICCID","value": [""]},
      {"id": "INFORMATION_SERVICE","value": [""]},
      {"id": "DUMMY","value": [""]}
    ] } }