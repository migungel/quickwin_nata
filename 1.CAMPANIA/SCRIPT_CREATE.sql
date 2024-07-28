-- Created on 18/12/2019 by MGARCIAR@CLARO.COM.EC
DECLARE
  ln_behaviour_id       NUMBER;
  ln_beh_operation_id   NUMBER;
  ln_beh_oper_stage_id1 NUMBER;
  ln_beh_oper_stage_id2 NUMBER;
  ln_campaign_id        NUMBER;
  ln_offer_id1          NUMBER;
  product_type_id1      VARCHAR2(200);
  product_id1           VARCHAR2(200);
  ln_operation_type_id1 VARCHAR2(200) := 'confirmOrder';
  ln_project_owner      VARCHAR(3000) := 'TIC Manuel Garcia <mgarciar@claro.com.ec>;';
  -- PR_SUFFIX CAMBIAR PARA PRUEBAS
  pr_suffix VARCHAR2(11) := 'CLONE1_QW'; -- TEST1_QW
  -- AGREGAR EL STAGE QUE SE DESEA
  lv_description_campaign VARCHAR(255) := '[QWV1-CPM] '; -- QWV1-MGR
  lv_invoke                VARCHAR2(200) := 'OPERATION_INVOKE';
  lv_dynamic_bl           VARCHAR2(200) := 'DYNAMIC_BLOCKING'; --Evalua una condición y si es positiva bloquea
  lv_description          VARCHAR2(200) := '[22921] CHANGE PAYMENT METHOD QUICKWIN'; -- TEST QUICKWIN
  lv_response_properties  VARCHAR2(200) := '[
        {
          "responseAlias":"FUNCTION_EXECUTION_STATUS",
          "subscriberPropertyId":"STATUS"
        },
        {
          "responseAlias":"EID",
          "subscriberPropertyId":"EID"
        },
        {
          "responseAlias":"MATCHING_ID",
          "subscriberPropertyId":"MATCHING_ID"
        },
        {
          "responseAlias":"SMDP_ADDRESS",
          "subscriberPropertyId":"SMDP_ADDRESS"
        }
      ]';
BEGIN

  SELECT Nvl(Max(B.behaviour_id),0) + 1
  INTO   ln_behaviour_id
  FROM   behaviour B;
  
  INSERT INTO behaviour
  (
      behaviour_id,
      description
  )
  VALUES
  (
      ln_behaviour_id,
      lv_description_campaign || lv_description
  );
  
  SELECT Nvl(Max(C.campaign_id),0) + 1
  INTO   ln_campaign_id
  FROM   campaign C;
  
  /*campaign*/
  INSERT INTO campaign
  (
      campaign_id,
      short_description,
      long_description,
      behaviour_id,
      PROJECT_OWNER 
  )
  VALUES
  (
      ln_campaign_id,
      lv_description,
      lv_description_campaign || lv_description,
      ln_behaviour_id,
      ln_project_owner
  );
  
  /*product_types*/
  product_type_id1 := 'PRT_' || pr_suffix;
  INSERT INTO product_types
  (
      product_type_id,
      description
  )
  VALUES
  (
      product_type_id1,
      lv_description_campaign || lv_description
  );
  
  /*products*/
  product_id1 := 'PR_' || pr_suffix;
  INSERT INTO products
  (
      product_id,
      description,
      product_type_id
  )
  VALUES
  (
      product_id1,
      lv_description,
      product_type_id1
  );
  
  SELECT Nvl(Max(O.offer_id),0) + 1
  INTO   ln_offer_id1
  FROM   offers O;
  
  -- OFFERS
  INSERT INTO offers
  (
      offer_id,
      short_description,
      long_description,
      offer_type_id
  )
  VALUES
  (
      ln_offer_id1,
      lv_description,
      lv_description_campaign || lv_description,
      ''
  );
  
  --CAMPAÑA OFERTAS
  INSERT INTO campaign_offers
  (
    campaign_id,
    offer_id
  )
  VALUES
  (
      ln_campaign_id,
      ln_offer_id1
  );
  
  -- OFFER_PRODUCTS
  INSERT INTO offer_products
  (
      offer_id,
      product_id,
      order_by
  )
  VALUES
  (
      ln_offer_id1,
      product_id1,
      10
  );
  
  -- BEHAVIOUR_OPERATION
  SELECT Nvl(Max(BO.behaviour_operation_id),0) + 1
  INTO   ln_beh_operation_id
  FROM   behaviour_operation BO;
  
  -- AGREGAR TODOS LOS CAMPOS QUE SE NECESITEN
  INSERT INTO behaviour_operation
  (
      behaviour_operation_id,
      behaviour_id,
      operation_type_id,
      description,
      response_properties
  )
  VALUES
  (
      ln_beh_operation_id,
      ln_behaviour_id,
      ln_operation_type_id1,
      lv_description,
      lv_response_properties
  );
  
  -- Creacion del esqueleto o stages
  SELECT Nvl(Max(BS.behaviour_oper_stage_id),0) + 1
  INTO   ln_beh_oper_stage_id1
  FROM   behaviour_oper_stages BS;
  
  INSERT INTO behaviour_oper_stages
  (
      behaviour_oper_stage_id,
      stage_id,
      order_by,
      behaviour_operation_id
  )
  VALUES
  (
      ln_beh_oper_stage_id1,
      lv_invoke,
      10,
      ln_beh_operation_id
  );

  SELECT Nvl(Max(BS.behaviour_oper_stage_id),0) + 1
  INTO   ln_beh_oper_stage_id2
  FROM   behaviour_oper_stages BS;
  
  INSERT INTO behaviour_oper_stages
  (
      behaviour_oper_stage_id,
      stage_id,
      order_by,
      behaviour_operation_id
  )
  VALUES
  (
      ln_beh_oper_stage_id2,
      lv_dynamic_bl,
      20,
      ln_beh_operation_id
  );
  
  commit;
  dbms_output.Put_line('ln_beh_operation_id number := '
  ||ln_beh_operation_id
  ||';');
  dbms_output.Put_line('---------------REFRESH--------------------------------------');
  dbms_output.put_line('http://192.168.37.146:8101/quickWin/clearCampaignById/'
  ||ln_campaign_id);
  dbms_output.Put_line('---------------GUARDE ESTE SCRIPT POR MAYOR SEGURIDAD--------------------------------------');
  dbms_output.Put_line('---------------SELECT--------------------------------------');
  dbms_output.Put_line('SELECT * FROM CAMPAIGN T WHERE T.CAMPAIGN_ID = '''
  ||ln_campaign_id
  ||''';');
  dbms_output.Put_line('SELECT * FROM CAMPAIGN_OFFERS T WHERE T.CAMPAIGN_ID = '''
  ||ln_campaign_id
  ||''';');
  dbms_output.Put_line('SELECT * FROM BEHAVIOUR_OPERATION T WHERE T.BEHAVIOUR_OPERATION_ID = '''
  ||ln_beh_operation_id
  ||''';');
  dbms_output.Put_line('SELECT * FROM BEHAVIOUR_OPER_STAGES T WHERE T.BEHAVIOUR_OPERATION_ID = '''
  ||ln_beh_operation_id
  ||''';');
  dbms_output.Put_line('SELECT * FROM BEHAVIOUR_PRODUCT T WHERE T.BEHAVIOUR_OPER_STAGE_ID = '''
  ||ln_beh_oper_stage_id1
  ||''';');
  dbms_output.Put_line('SELECT * FROM BEHAVIOUR_PRODUCT T WHERE T.BEHAVIOUR_OPER_STAGE_ID = '''
  ||ln_beh_oper_stage_id2
  ||''';');
  dbms_output.Put_line('SELECT * FROM offer_products T WHERE T.offer_id = '''
  ||ln_offer_id1
  ||''';');
  dbms_output.Put_line('SELECT * FROM campaign_offers T WHERE T.offer_id = '''
  ||ln_offer_id1
  ||''';');
  dbms_output.Put_line('SELECT * FROM PRODUCT_TYPES T WHERE T.PRODUCT_TYPE_ID = '''
  ||product_type_id1
  ||''';');
  dbms_output.Put_line('SELECT * FROM PRODUCTS T WHERE T.PRODUCT_TYPE_ID = '''
  ||product_type_id1
  ||''';');
  dbms_output.Put_line('--------------UPDATE STATUS---------------------------------------');
  dbms_output.Put_line('update offer_products t set status = ''I'' where t.offer_id = '''
  ||ln_offer_id1
  ||''';');
  dbms_output.Put_line('update campaign_offers t set status = ''I'' where t.offer_id = '''
  ||ln_offer_id1
  ||''';');
  dbms_output.Put_line('update offers t set status = ''I'' where t.offer_id = '''
  ||ln_offer_id1
  ||''';');
  dbms_output.Put_line('update products p set status = ''I'' where p.product_type_id = '''
  ||product_type_id1
  ||''';');
  dbms_output.Put_line('update product_types p set status = ''I'' where p.product_type_id = '''
  ||product_type_id1
  ||''';');
  dbms_output.Put_line('update campaign c set status = ''I'' where c.behaviour_id = '''
  ||ln_behaviour_id
  ||''';');
  dbms_output.Put_line('update behaviour a set status = ''I'' where a.behaviour_id ='''
  ||ln_behaviour_id
  ||''';');
  dbms_output.Put_line('--------------DELETE---------------------------------------');
  dbms_output.Put_line('delete behaviour_oper_stages b where b.behaviour_operation_id = '''
  ||ln_beh_operation_id
  ||''';');
  dbms_output.Put_line('delete behaviour_operation b where b.behaviour_id = '''
  ||ln_behaviour_id
  ||''';');
  dbms_output.Put_line('delete offer_products t where t.offer_id = '''
  ||ln_offer_id1
  ||''';');
  dbms_output.Put_line('delete campaign_offers t where t.offer_id = '''
  ||ln_offer_id1
  ||''';');
  dbms_output.Put_line('delete offers t where t.offer_id = '''
  ||ln_offer_id1
  ||''';');
  dbms_output.Put_line('delete products p where p.product_type_id = '''
  ||product_type_id1
  ||''';');
  dbms_output.Put_line('delete product_types p where p.product_type_id = '''
  ||product_type_id1
  ||''';');
  dbms_output.Put_line('delete campaign c where c.behaviour_id = '''
  ||ln_behaviour_id
  ||''';');
  dbms_output.Put_line('delete behaviour a where a.behaviour_id ='''
  ||ln_behaviour_id
  ||''';');
  dbms_output.Put_line('---------------REQUEST----------------------------------------------');
  dbms_output.Put_line('http://192.168.37.146:8101/quickWin/getActivateRequest');
  dbms_output.Put_line('---------------POST REST--------------------------------------');
  dbms_output.Put_line('
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
      "operationId": "'||ln_operation_type_id1||'",
      "processingMethod": "SY"
    }
  },
  "body": {
    "activationInfo": {
      "offerId": "'||ln_offer_id1||'",
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
      "campaignId": "'||ln_campaign_id||'",
      "sessionData": {
        "externalSubscriberProperties": [
          {
            "id": "ICCID",
            "value": [""]
          },
          {
            "id": "EID",
            "value": [""]
          },
          {
            "id": "MATCHING_ID",
            "value": [""]
          },
          {
            "id": "CONFIRMATION_CODE",
            "value": [""]
          },
          {
            "id": "SMDS_ADDRESS",
            "value": [""]
          },
          {
            "id": "RELEASE_FLAG",
            "value": [""]
          },
          {
            "id": "DISPLAY_PROFILE_NAME",
            "value": [""]
          }
        ]
      }
    }
  }
}
EJEMPLO AVANZADO BEHAVIOUR OPERATION. Permite que la operacion devuelva los subscriber properties definidos en RESPONSE_PROPERTIES REQUEST QUICKWIN Al ejecutar este Script genera un request. POST http://192.168.37.146:8101/quickWin/getActivateRequest HTTP/1.1
');
  --chequear los erroes
EXCEPTION
WHEN OTHERS THEN
  ROLLBACK;
  dbms_output.Put_line('BUBU:' || SQLERRM);
END;