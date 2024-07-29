LN_EXT_RES_GROUP ID: 452
LN_EXT_RES ID: 14937
INVOKE ID: 3087
---------------REFRESH---------------------------------- ----
http://192.168.37.146:8101/quickWin/refreshInvokeById/3087
---------------GUARDE ESTE SCRIPT POR MAYOR SEGURIDAD-------------------------------------
---------------SELECT--------------------------------------
SELECT * FROM INVOKE T WHERE T.INVOKE_ID = '3087';
SELECT * FROM EXTERNAL_RESOURCE_GROUPS T WHERE T.EXTERNAL_RESOURCE_GROUP_ID = '452';
SELECT * FROM EXTERNAL_RESOURCES T WHERE T.EXTERNAL_RESOURCE_ID = '14937';
SELECT * FROM EXTERNAL_RESOURCE_COMPONENTS T WHERE T.EXTERNAL_RESOURCE_ID = '14937';
SELECT * FROM INVOKE_MAPPING T WHERE T.INVOKE_ID = '3087';
SELECT * FROM INVOKE_RESPONSE_EVALUATION T WHERE T.INVOKE_ID = '3087';
--------------UPDATE STATUS---------------------------------------
update INVOKE T set status = 'I' WHERE T.INVOKE_ID = '3087';
update EXTERNAL_RESOURCE_GROUPS T set status = 'I' WHERE T.EXTERNAL_RESOURCE_GROUP_ID = '452';
update EXTERNAL_RESOURCES T set status = 'I' WHERE T.EXTERNAL_RESOURCE_ID = '14937';
update EXTERNAL_RESOURCE_COMPONENTS T set status = 'I' WHERE T.EXTERNAL_RESOURCE_ID = '14937';
update INVOKE_MAPPING T set status = 'I' WHERE T.INVOKE_ID = '3087';
update INVOKE_RESPONSE_EVALUATION T set status = 'I' WHERE T.INVOKE_ID = '3087';
--------------DELETE---------------------------------------
delete INVOKE_RESPONSE_EVALUATION T WHERE T.INVOKE_ID = '3087';
delete INVOKE_MAPPING T WHERE T.INVOKE_ID = '3087';
delete EXTERNAL_RESOURCE_COMPONENTS T WHERE T.EXTERNAL_RESOURCE_ID = '14937';
delete EXTERNAL_RESOURCES T WHERE T.EXTERNAL_RESOURCE_ID = '14937';
delete EXTERNAL_RESOURCE_GROUPS T WHERE T.EXTERNAL_RESOURCE_GROUP_ID = '452';
delete INVOKE T WHERE T.INVOKE_ID = '3087';
---------------REQUEST----------------------------------------------
http://192.168.37.146:8101/quickWin/executeInvoke
---------------POST REST--------------------------------- -----
{
  "invokeId": "3087", 
  "invokerName": "Prueba Invoke", 
  "cacheOptions":"0", 
  "sync":"YES", 
  "customerInvokerId":"id12345", 
  "sessionData": { 
    "externalSubscriberProperties": [
 {"id": "ICCID","value": [""]},
 {"id": "INFORMATION_SERVICE","value": [""]},
 {"id": "ESTADO","value": [""]},
 {"id": "DUMMY","value": [""]}
 ] } }
