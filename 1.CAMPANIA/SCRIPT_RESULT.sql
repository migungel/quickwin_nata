ln_beh_operation_id number := 865;
---------------REFRESH--------------------------------------
http://192.168.37.146:8101/quickWin/clearCampaignById/100129
---------------GUARDE ESTE SCRIPT POR MAYOR SEGURIDAD--------------------------------------
---------------SELECT--------------------------------------
SELECT * FROM CAMPAIGN T WHERE T.CAMPAIGN_ID = '100129';
SELECT * FROM CAMPAIGN_OFFERS T WHERE T.CAMPAIGN_ID = '100129';
SELECT * FROM BEHAVIOUR_OPERATION T WHERE T.BEHAVIOUR_OPERATION_ID = '865';
SELECT * FROM BEHAVIOUR_OPER_STAGES T WHERE T.BEHAVIOUR_OPERATION_ID = '865';
SELECT * FROM BEHAVIOUR_PRODUCT T WHERE T.BEHAVIOUR_OPER_STAGE_ID = '4068';
SELECT * FROM BEHAVIOUR_PRODUCT T WHERE T.BEHAVIOUR_OPER_STAGE_ID = '4069';
SELECT * FROM offer_products T WHERE T.offer_id = '400136958';
SELECT * FROM campaign_offers T WHERE T.offer_id = '400136958';
SELECT * FROM PRODUCT_TYPES T WHERE T.PRODUCT_TYPE_ID = 'PRT_CLONE1_QW';
SELECT * FROM PRODUCTS T WHERE T.PRODUCT_TYPE_ID = 'PRT_CLONE1_QW';
--------------UPDATE STATUS---------------------------------------
update offer_products t set status = 'I' where t.offer_id = '400136958';
update campaign_offers t set status = 'I' where t.offer_id = '400136958';
update offers t set status = 'I' where t.offer_id = '400136958';
update products p set status = 'I' where p.product_type_id = 'PRT_CLONE1_QW';
update product_types p set status = 'I' where p.product_type_id = 'PRT_CLONE1_QW';
update campaign c set status = 'I' where c.behaviour_id = '672';
update behaviour a set status = 'I' where a.behaviour_id ='672';
--------------DELETE---------------------------------------
delete behaviour_oper_stages b where b.behaviour_operation_id = '865';
delete behaviour_operation b where b.behaviour_id = '672';
delete offer_products t where t.offer_id = '400136958';
delete campaign_offers t where t.offer_id = '400136958';
delete offers t where t.offer_id = '400136958';
delete products p where p.product_type_id = 'PRT_CLONE1_QW';
delete product_types p where p.product_type_id = 'PRT_CLONE1_QW';
delete campaign c where c.behaviour_id = '672';
delete behaviour a where a.behaviour_id ='672';
---------------REQUEST----------------------------------------------
http://192.168.37.146:8101/quickWin/getActivateRequest
---------------POST REST--------------------------------------

{
  "commonHeaderRequest": {
    "channelInfo": {
      "channelId": "",
      "mediaDetailId": "",
      "mediaId": ""
    },
    "consumerInfo": {
      "companyId": "",
      "consumerType": "",
      "consumerId": "",
      "terminal": ""
    },
    "geolocationInfo": {
      "location": {
        "latitude": "",
        "longitude": ""
      }
    },
    "operationInfo": {
      "externalOperation": "confirmOrder",
      "externalTransactionDate": "22/09/2022 12:07:05",
      "externalTransactionId": "bf9491b2-0573-4001-89fa-ad9923b16090",
      "operationId": "confirmOrder",
      "processingMethod": "SY"
    }
  },
  "body": {
    "activationInfo": {
      "offerId": "400136958",
      "subscription": {
        "type": "ICCID",
        "value": "8959301000967633954"
      },
      "paymentInfo": {
        "paymentMethod": {
          "amount": "",
          "paymentMethodId": "",
          "paymentMethodType": ""
        }
      },
      "campaignId": "100129",
      "sessionData": {
        "externalSubscriberProperties": [
          {
            "id": "ICCID",
            "value": ["89354010111104000222"]
          },
          {
            "id": "EID",
            "value": ["00636856000000000000000000000777"]
          },
          {
            "id": "MATCHING_ID",
            "value": ["1234-5678-9ABC"]
          },
          {
            "id": "CONFIRMATION_CODE",
            "value": ["1234"]
          },
          {
            "id": "SMDS_ADDRESS",
            "value": ["smds.gsma.com"]
          },
          {
            "id": "RELEASE_FLAG",
            "value": ["true"]
          },
          {
            "id": "DISPLAY_PROFILE_NAME",
            "value": ["new personal optional description"]
          }
        ]
      }
    }
  }
}
EJEMPLO AVANZADO BEHAVIOUR OPERATION. Permite que la operacion devuelva los subscriber properties definidos en RESPONSE_PROPERTIES REQUEST QUICKWIN Al ejecutar este Script genera un request. POST http://192.168.37.146:8101/quickWin/getActivateRequest HTTP/1.1