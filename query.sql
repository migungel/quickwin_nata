SELECT * FROM CAMPAIGN c 
WHERE c.CAMPAIGN_ID = 100056
ORDER BY c.CAMPAIGN_ID desc;

SELECT * FROM BEHAVIOUR_OPERATION T WHERE T.BEHAVIOUR_OPERATION_ID = '580';
SELECT * FROM BEHAVIOUR_OPER_STAGES T WHERE T.BEHAVIOUR_OPERATION_ID = '580';
SELECT * FROM BEHAVIOUR_OPER_STAGES T WHERE T.BEHAVIOUR_OPER_STAGE_ID = 2314;
SELECT * FROM BEHAVIOUR_OPER_STAGES T WHERE T.BEHAVIOUR_OPER_STAGE_ID = 3196;

SELECT * FROM BEHAVIOUR_OPER_STAGES T WHERE T.BEHAVIOUR_OPERATION_ID = '718';
SELECT * FROM BEHAVIOUR_OPERATION T WHERE T.BEHAVIOUR_OPERATION_ID = '718';

SELECT * FROM BEHAVIOUR_OPERATION T WHERE T.OPERATION_TYPE_ID = 'confirmOrder';

SELECT * FROM BEHAVIOUR_OPER_INVOKE boi WHERE boi.BEHAVIOUR_OPER_STAGE_ID = 3196;

SELECT * FROM INVOKE T WHERE T.INVOKE_ID = '2486';
SELECT * FROM EXTERNAL_RESOURCE_GROUPS T WHERE T.EXTERNAL_RESOURCE_GROUP_ID = '248';
SELECT * FROM EXTERNAL_RESOURCES T WHERE T.EXTERNAL_RESOURCE_ID = '13349';
SELECT * FROM EXTERNAL_RESOURCES T WHERE T.EXTERNAL_RESOURCE_ID = '14351';
SELECT * FROM EXTERNAL_RESOURCE_COMPONENTS T WHERE T.EXTERNAL_RESOURCE_ID = '13349';
SELECT * FROM INVOKE_MAPPING T WHERE T.INVOKE_ID = '1651';
SELECT * FROM INVOKE_RESPONSE_EVALUATION T WHERE T.INVOKE_ID = '1651';

SELECT * FROM BEHAVIOUR_ENRICHMENT_PROPERTY bep WHERE bep.BEHAVIOUR_OPER_STAGE_ID = 3196;
SELECT * FROM BEHAVIOUR_ENRICHMENT be WHERE be.INVOKE_ID = '2486';

SELECT * FROM "CONDITION" c WHERE c.CONDITION_ID = 3182;
SELECT * FROM CONDITION_PROPERTIES cp WHERE cp.CONDITION_ID = 3182;