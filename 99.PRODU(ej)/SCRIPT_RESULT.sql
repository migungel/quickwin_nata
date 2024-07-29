CONFIG_CODE: Change Payment Method Quickwin
BEHAVIOUR_ID: 639
CAMPAIGN_ID: 100098
OFFER_ID: 400136927
PRODUCT_TYPE: PRT_CPAYMET_QW
PRODUCT: PRT_CPAYMET_QW
PR_SUFFIX: CPAYMET_QW
OPERATION_TYPE_ID: activeChangeAccount
BEH_OPERATION_ID: 822
BEH_OPER_STAGE_INVOKE1: 3652
BEH_OPER_STAGE_INVOKE2: 3653
BEH_OPER_STAGE_INVOKE3: 3654
EXTERNAL_RESOURCE_GROUPS_1: 525
INVOKE_ID_1: 2815
INVOKE_ID_2: 2816
INVOKE_ID_3: 2817
EXTERNA_RESOURCES_1: 14662
EXTERNA_RESOURCES_2: 14663
EXTERNA_RESOURCES_3: 14664
FUNCTION_DOMAIN: 6861
FUNCTION: 338
DEFINITION FUNCTION CALL: 402
DOMAIN1: 5982
CONDITION1: 3450
DOMAIN2: 5983
CONDITION2: 3451

ln_beh_operation_id: 822;
ln_beh_oper_stage_id2: 3653;
ln_beh_oper_stage_id3: 3654;
ln_beh_oper_stage_id1: 3652;
ln_beh_oper_stage_id4: 3655;
ln_beh_oper_stage_id5: 3656;
ln_beh_oper_invoke_id1: 3656;
INVOKE ID1: 2815
ln_beh_oper_invoke_id2: 3657;
INVOKE ID2: 2816
ln_beh_oper_invoke_id3: 3658;
INVOKE ID3: 2817
ln_function_dom_id: 6861;
ln_function_id: 338;
ln_def_func_call_id: 402;
ln_domain_id1: 5982
ln_condition_id1: 3450
ln_domain_id2: 5983
ln_condition_id2: 3451
---------------REFRESH---------------------------------- ----
http://192.168.37.146:8101/quickWin/clearCampaignById/100098
http://192.168.37.146:8101/quickWin/clearInvokeById/2815
---------------GUARDE ESTE SCRIPT POR MAYOR SEGURIDAD--------------------------------------
---------------SELECT--------------------------------------
SELECT * FROM CAMPAIGN T WHERE T.CAMPAIGN_ID = '100098';
SELECT * FROM CAMPAIGN_OFFERS T WHERE T.CAMPAIGN_ID = '100098';
SELECT * FROM BEHAVIOUR_OPERATION T WHERE T.BEHAVIOUR_OPERATION_ID = '822';
SELECT * FROM BEHAVIOUR_OPER_STAGES T WHERE T.BEHAVIOUR_OPERATION_ID = '822' order by t.order_by;
SELECT * FROM behaviour_oper_stages T WHERE T.BEHAVIOUR_OPER_STAGE_ID = 3652 order by t.order_by;
SELECT * FROM behaviour_oper_stages T WHERE T.BEHAVIOUR_OPER_STAGE_ID = 3653 order by t.order_by;
SELECT * FROM behaviour_oper_stages T WHERE T.BEHAVIOUR_OPER_STAGE_ID = 3654 order by t.order_by;
SELECT * FROM behaviour_oper_stages T WHERE T.BEHAVIOUR_OPER_STAGE_ID = 3655 order by t.order_by;
SELECT * FROM behaviour_oper_stages T WHERE T.BEHAVIOUR_OPER_STAGE_ID = 3656 order by t.order_by;
SELECT * FROM BEHAVIOUR_PRODUCT T WHERE T.BEHAVIOUR_OPER_STAGE_ID = '3652';
SELECT * FROM offer_products T WHERE T.offer_id = '400136927';
SELECT * FROM campaign_offers T WHERE T.offer_id = '400136927';
SELECT * FROM PRODUCT_TYPES T WHERE T.PRODUCT_TYPE_ID = 'PRT_CPAYMET_QW_TEST';
SELECT * FROM PRODUCTS T WHERE T.PRODUCT_TYPE_ID = 'PRT_CPAYMET_QW_TEST';
SELECT * FROM FUNCTIONS t where t.fuction_dom_id = '6861';
SELECT * FROM FUNCTION_DOMAINS t where t.function_dom_id = '6861';
SELECT * FROM DEFINED_FUNCTION_BINDINGS t where t.defined_function_call_id = '402';
SELECT * FROM DEFINED_FUNCTION_CALL t where t.defined_function_call_id = '402';
SELECT * FROM behaviour_enrichment_property T WHERE T.BEHAVIOUR_OPER_STAGE_ID = 3653 order by t.order_by;
SELECT * FROM DOMAIN_VALUE_RANGES t where t.domain_id = '5982';
SELECT * FROM DOMAIN_ELEMENTS t where t.domain_id = '5982';
SELECT * FROM DOMAIN t where t.domain_id = '5982';
SELECT * FROM CONDITION_PROPERTIES T WHERE T.CONDITION_ID = '3450';
SELECT * FROM CONDITION t where t.condition_id = '3450';
SELECT * FROM behaviour_validations T WHERE T.BEHAVIOUR_OPER_STAGE_ID = 3653 order by t.order_by;
SELECT * FROM DOMAIN_ELEMENTS t where t.domain_id = '5983';
SELECT * FROM DOMAIN t where t.domain_id = '5983';
SELECT * FROM CONDITION_PROPERTIES T WHERE T.CONDITION_ID = '3451';
SELECT * FROM CONDITION t where t.condition_id = '3451';
SELECT * FROM behaviour_validations T WHERE T.BEHAVIOUR_OPER_STAGE_ID = 3655 order by t.order_by;
---------------INVOKE QUERY ACCOUNT--------------------------------------
SELECT * FROM INVOKE T WHERE T.INVOKE_ID = '2815';
SELECT * FROM EXTERNAL_RESOURCE_GROUPS T WHERE T.EXTERNAL_RESOURCE_GROUP_ID = '525';
SELECT * FROM EXTERNAL_RESOURCES T WHERE T.EXTERNAL_RESOURCE_ID = '14662';
SELECT * FROM EXTERNAL_RESOURCE_COMPONENTS T WHERE T.EXTERNAL_RESOURCE_ID = '14662';
SELECT * FROM INVOKE_MAPPING T WHERE T.INVOKE_ID = '2815';
SELECT * FROM INVOKE_RESPONSE_EVALUATION T WHERE T.INVOKE_ID = '2815';
SELECT * FROM BEHAVIOUR_OPER_INVOKE T WHERE T.BEHAVIOUR_OPER_STAGE_ID = 3652 order by t.order_by;
---------------INVOKE CREDIT ENGINE--------------------------------------
SELECT * FROM INVOKE T WHERE T.INVOKE_ID = '2816';
SELECT * FROM EXTERNAL_RESOURCE_GROUPS T WHERE T.EXTERNAL_RESOURCE_GROUP_ID = '525';
SELECT * FROM EXTERNAL_RESOURCES T WHERE T.EXTERNAL_RESOURCE_ID = '14663';
SELECT * FROM EXTERNAL_RESOURCE_COMPONENTS T WHERE T.EXTERNAL_RESOURCE_ID = '14663';
SELECT * FROM INVOKE_MAPPING T WHERE T.INVOKE_ID = '2816';
SELECT * FROM INVOKE_RESPONSE_EVALUATION T WHERE T.INVOKE_ID = '2816';
SELECT * FROM BEHAVIOUR_OPER_INVOKE T WHERE T.BEHAVIOUR_OPER_STAGE_ID = 3654 order by t.order_by;
---------------INVOKE CHANGE ACCOUNT--------------------------------------
SELECT * FROM INVOKE T WHERE T.INVOKE_ID = '2817';
SELECT * FROM EXTERNAL_RESOURCE_GROUPS T WHERE T.EXTERNAL_RESOURCE_GROUP_ID = '525';
SELECT * FROM EXTERNAL_RESOURCES T WHERE T.EXTERNAL_RESOURCE_ID = '14664';
SELECT * FROM EXTERNAL_RESOURCE_COMPONENTS T WHERE T.EXTERNAL_RESOURCE_ID = '14664';
SELECT * FROM INVOKE_MAPPING T WHERE T.INVOKE_ID = '2817';
SELECT * FROM INVOKE_RESPONSE_EVALUATION T WHERE T.INVOKE_ID = '2817';
SELECT * FROM BEHAVIOUR_OPER_INVOKE T WHERE T.BEHAVIOUR_OPER_STAGE_ID = 3656 order by t.order_by;
--------------UPDATE STATUS---------------------------------------
update offer_products t set status = 'I' where t.offer_id = '400136927';
update campaign_offers t set status = 'I' where t.offer_id = '400136927';
update offers t set status = 'I' where t.offer_id = '400136927';
update products p set status = 'I' where p.product_type_id = 'PRT_CPAYMET_QW_TEST';
update product_types p set status = 'I' where p.product_type_id = 'PRT_CPAYMET_QW_TEST';
update campaign c set status = 'I' where c.behaviour_id = '639';
update behaviour a set status = 'I' where a.behaviour_id ='639';
update behaviour_oper_stages t set status = 'I' where t.BEHAVIOUR_OPERATION_ID = 822;
update behaviour_oper_stages t set status = 'I' where t.BEHAVIOUR_OPER_STAGE_ID = 3652;
update behaviour_oper_stages t set status = 'I' where t.BEHAVIOUR_OPER_STAGE_ID = 3653;
update behaviour_oper_stages t set status = 'I' where t.BEHAVIOUR_OPER_STAGE_ID = 3654;
update behaviour_oper_stages t set status = 'I' where t.BEHAVIOUR_OPER_STAGE_ID = 3655;
update behaviour_oper_stages t set status = 'I' where t.BEHAVIOUR_OPER_STAGE_ID = 3656;
UPDATE FUNCTIONS t set status = 'I' where t.fuction_dom_id = '6861';
UPDATE FUNCTION_DOMAINS t set status = 'I' where t.function_dom_id = '6861';
UPDATE DEFINED_FUNCTION_BINDINGS t set status = 'I' where t.defined_function_call_id = '402';
UPDATE DEFINED_FUNCTION_CALL t set status = 'I' where t.defined_function_call_id = '402';
update behaviour_enrichment_property t set status = 'I' where t.BEHAVIOUR_OPER_STAGE_ID = 3653;
UPDATE DOMAIN_VALUE_RANGES t set status = 'I' where t.domain_id = '5982';
UPDATE DOMAIN_ELEMENTS t set status = 'I' where t.domain_id = '5982';
UPDATE DOMAIN t set status = 'I' where t.domain_id = '5982';
UPDATE CONDITION_PROPERTIES T set status = 'I' WHERE T.CONDITION_ID = '3450';
UPDATE CONDITION t set status = 'I' where t.condition_id = '3450';
update behaviour_validations t set status = 'I' where t.BEHAVIOUR_OPER_STAGE_ID = 3653;
UPDATE DOMAIN_ELEMENTS t set status = 'I' where t.domain_id = '5983';
UPDATE DOMAIN t set status = 'I' where t.domain_id = '5983';
UPDATE CONDITION_PROPERTIES T set status = 'I' WHERE T.CONDITION_ID = '3451';
UPDATE CONDITION t set status = 'I' where t.condition_id = '3451';
update behaviour_validations t set status = 'I' where t.BEHAVIOUR_OPER_STAGE_ID = 3655;
---------------INVOKE QUERY ACCOUNT--------------------------------------
update INVOKE T set status = 'I' WHERE T.INVOKE_ID = '2815';
update EXTERNAL_RESOURCE_GROUPS T set status = 'I' WHERE T.EXTERNAL_RESOURCE_GROUP_ID = '525';
update EXTERNAL_RESOURCES T set status = 'I' WHERE T.EXTERNAL_RESOURCE_ID = '14662';
update EXTERNAL_RESOURCE_COMPONENTS T set status = 'I' WHERE T.EXTERNAL_RESOURCE_ID = '14662';
update INVOKE_MAPPING T set status = 'I' WHERE T.INVOKE_ID = '2815';
update INVOKE_RESPONSE_EVALUATION T set status = 'I' WHERE T.INVOKE_ID = '2815';
update BEHAVIOUR_OPER_INVOKE t set status = 'I' where t.BEHAVIOUR_OPER_STAGE_ID = 3652;
---------------INVOKE CREDIT ENGINE--------------------------------------
update INVOKE T set status = 'I' WHERE T.INVOKE_ID = '2816';
update EXTERNAL_RESOURCE_GROUPS T set status = 'I' WHERE T.EXTERNAL_RESOURCE_GROUP_ID = '525';
update EXTERNAL_RESOURCES T set status = 'I' WHERE T.EXTERNAL_RESOURCE_ID = '14663';
update EXTERNAL_RESOURCE_COMPONENTS T set status = 'I' WHERE T.EXTERNAL_RESOURCE_ID = '14663';
update INVOKE_MAPPING T set status = 'I' WHERE T.INVOKE_ID = '2816';
update INVOKE_RESPONSE_EVALUATION T set status = 'I' WHERE T.INVOKE_ID = '2816';
update BEHAVIOUR_OPER_INVOKE t set status = 'I' where t.BEHAVIOUR_OPER_STAGE_ID = 3654;
---------------INVOKE CHANGE ACCOUNT--------------------------------------
update INVOKE T set status = 'I' WHERE T.INVOKE_ID = '2817';
update EXTERNAL_RESOURCE_GROUPS T set status = 'I' WHERE T.EXTERNAL_RESOURCE_GROUP_ID = '525';
update EXTERNAL_RESOURCES T set status = 'I' WHERE T.EXTERNAL_RESOURCE_ID = '14664';
update EXTERNAL_RESOURCE_COMPONENTS T set status = 'I' WHERE T.EXTERNAL_RESOURCE_ID = '14664';
update INVOKE_MAPPING T set status = 'I' WHERE T.INVOKE_ID = '2817';
update INVOKE_RESPONSE_EVALUATION T set status = 'I' WHERE T.INVOKE_ID = '2817';
update BEHAVIOUR_OPER_INVOKE t set status = 'I' where t.BEHAVIOUR_OPER_STAGE_ID = 3656;
--------------DELETE---------------------------------------
DELETE behaviour_oper_stages b where b.behaviour_operation_id = '822';
DELETE behaviour_operation b where b.behaviour_id = '639';
DELETE offer_products t where t.offer_id = '400136927';
DELETE campaign_offers t where t.offer_id = '400136927';
DELETE offers t where t.offer_id = '400136927';
DELETE products p where p.product_type_id = 'PRT_CPAYMET_QW_TEST';
DELETE product_types p where p.product_type_id = 'PRT_CPAYMET_QW_TEST';
DELETE campaign c where c.behaviour_id = '639';
DELETE behaviour a where a.behaviour_id ='639';
delete behaviour_oper_stages b where b.BEHAVIOUR_OPER_STAGE_ID = 3652;
delete behaviour_oper_stages b where b.BEHAVIOUR_OPER_STAGE_ID = 3653;
delete behaviour_oper_stages b where b.BEHAVIOUR_OPER_STAGE_ID = 3654;
delete behaviour_oper_stages b where b.BEHAVIOUR_OPER_STAGE_ID = 3655;
delete behaviour_oper_stages b where b.BEHAVIOUR_OPER_STAGE_ID = 3656;
DELETE FROM FUNCTIONS t where t.fuction_dom_id = '6861';
DELETE FROM FUNCTION_DOMAINS t where t.function_dom_id = '6861';
DELETE FROM DEFINED_FUNCTION_BINDINGS t where t.defined_function_call_id = '402';
DELETE FROM DEFINED_FUNCTION_CALL t where t.defined_function_call_id = '402';
DELETE behaviour_enrichment_property b where b.BEHAVIOUR_OPER_STAGE_ID = 3653;
DELETE FROM DOMAIN_VALUE_RANGES t where t.domain_id = '5982';
DELETE FROM DOMAIN_ELEMENTS t where t.domain_id = '5982';
DELETE FROM DOMAIN t where t.domain_id = '5982';
DELETE FROM CONDITION_PROPERTIES T WHERE T.CONDITION_ID = '3450';
DELETE FROM CONDITION t where t.condition_id = '3450';
delete behaviour_validations b where b.BEHAVIOUR_OPER_STAGE_ID = 3653;
DELETE FROM DOMAIN_VALUE_RANGES t where t.domain_id = '5983';
DELETE FROM DOMAIN_ELEMENTS t where t.domain_id = '5983';
DELETE FROM DOMAIN t where t.domain_id = '5983';
DELETE FROM CONDITION_PROPERTIES T WHERE T.CONDITION_ID = '3451';
DELETE FROM CONDITION t where t.condition_id = '3451';
delete behaviour_validations b where b.BEHAVIOUR_OPER_STAGE_ID = 3655;
---------------INVOKE QUERY ACCOUNT--------------------------------------
DELETE INVOKE_RESPONSE_EVALUATION T WHERE T.INVOKE_ID = '2815';
DELETE INVOKE_MAPPING T WHERE T.INVOKE_ID = '2815';
DELETE EXTERNAL_RESOURCE_COMPONENTS T WHERE T.EXTERNAL_RESOURCE_ID = '14662';
DELETE EXTERNAL_RESOURCES T WHERE T.EXTERNAL_RESOURCE_ID = '14662';
DELETE INVOKE T WHERE T.INVOKE_ID = '2815';
DELETE BEHAVIOUR_OPER_INVOKE b where b.BEHAVIOUR_OPER_STAGE_ID = 3652;
---------------INVOKE CREDIT ENGINE--------------------------------------
delete INVOKE_RESPONSE_EVALUATION T WHERE T.INVOKE_ID = '2816';
delete INVOKE_MAPPING T WHERE T.INVOKE_ID = '2816';
delete EXTERNAL_RESOURCE_COMPONENTS T WHERE T.EXTERNAL_RESOURCE_ID = '14663';
delete EXTERNAL_RESOURCES T WHERE T.EXTERNAL_RESOURCE_ID = '14663';
delete INVOKE T WHERE T.INVOKE_ID = '2816';
delete BEHAVIOUR_OPER_INVOKE b where b.BEHAVIOUR_OPER_STAGE_ID = 3654;
---------------INVOKE CHANGE ACCOUNT--------------------------------------
delete INVOKE_RESPONSE_EVALUATION T WHERE T.INVOKE_ID = '2817';
delete INVOKE_MAPPING T WHERE T.INVOKE_ID = '2817';
delete EXTERNAL_RESOURCE_COMPONENTS T WHERE T.EXTERNAL_RESOURCE_ID = '14664';
delete EXTERNAL_RESOURCES T WHERE T.EXTERNAL_RESOURCE_ID = '14664';
delete INVOKE T WHERE T.INVOKE_ID = '2817';
delete BEHAVIOUR_OPER_INVOKE b where b.BEHAVIOUR_OPER_STAGE_ID = 3656;
---------------REQUEST----------------------------------------------
http://192.168.37.146:8101/quickWin/getActivateRequest
---------------POST REST--------------------------------------
{ 
  "commonHeaderRequest": { 
    "channelInfo": { 
      "channelId": "CRMHW", 
      "mediaDetailId": "BES.15.101", 
      "mediaId": "WEB" 
    }, 
    "consumerInfo": { 
      "companyId": "CLARO", 
      "consumerType": "CLARO", 
      "consumerId": "SPRXSLT", 
      "terminal": "HUB PLATINUM" 
    }, 
    "geolocationInfo": { 
      "accuracy": "", 
      "location": { 
        "latitude": "", 
        "longitude": "" 
      } 
    }, 
    "operationInfo": { 
      "externalOperation": "activateOffer", 
      "externalTransactionDate": "11/10/2018 10:07:05", 
      "externalTransactionId": "123", 
      "operationId": "activeChangeAccount_TEST", 
      "processingMethod": "SY", 
      "compensationTransactionId": "XXXX" 
    }, 
    "securityInfo": { 
      "authorizationId": "12345" 
    } 
  }, 
  "body": { 
    "activationInfo": { 
      "expectedExecutionDate": "", 
      "offerId": "400136927", 
      "offerDetail": "", 
      "externalOfferId": "", 
      "remarks": "Para Pruebas de Quickwin", 
      "subscription": { 
        "type": "CEL", 
        "value": "5930969249902" 
      }, 
      "paymentInfo": { 
        "paymentMethod": { 
          "paymentAmount": "500", 
          "paymentMethodId": "CARD", 
          "paymentMethodType": "CARDTYPE" 
        }, 
        "paymentDate": "11/10/2018 10:07:05", 
        "currency": { 
          "currencyId": "$", 
          "description": "DOLAR" 
        } 
      }, 
      "campaignId": "100098", 
      "productInfo": { 
        "productId": "", 
        "productName": "", 
        "productOfferingPrice" : { 
          "name":"", 
          "productAmount":"" 
        } 
      }, 
      "period": "", 
      "periodQuantity": "", 
      "quantity": "", 
      "targetSubscription": { 
        "type": "", 
        "value": "" 
      }, 
      "unit": "", "amount": "", 
      "sessionData": { 
        "externalSubscriberProperties": [ 
          {
            "id": "ACCOUNT_CODE",
            "value": ["8525042244"]
          },
          {
            "id": "CUSTOMER_ID_CPM",
            "value": ["44051442045"]
          },
          {
            "id": "SERVICE_NUMBER_CPM",
            "value": ["778664335"]
          },
          {
            "id": "BANK_CODE_CPM",
            "value": [""]
          },
          {
            "id": "PAYMENT_METHOD_TYPE_CPM",
            "value": [""]
          },
          {
            "id": "ACCOUNT_TYPE_CPM",
            "value": [""]
          },
          {
            "id": "BANK_ACCOUNT_NUMBER_CPM",
            "value": [""]
          },
          {
            "id":"IDENTIFICATION_TYPE_CPM",
            "value":["PAS"]
          },
          {
            "id":"IDENTIFICATION_NUMBER_CPM",
            "value":["TICPYP0079"]
          },
          {
            "id":"BUSINESS_SERIAL_NUMBER",
            "value":["b215d98ec7cf47268a63fe1dec454fb8"]
          },
          { 
            "id": "DUMMY", 
            "value": ["TEST"] 
          } 
        ] 
      } 
    } 
  } 
}
