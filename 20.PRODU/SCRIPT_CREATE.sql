DECLARE
  ln_behaviour_id         NUMBER;
  ln_beh_operation_id     NUMBER;
  ln_beh_oper_stage_id1   NUMBER;
  ln_beh_oper_stage_id2   NUMBER;
  ln_campaign_id          NUMBER;
  ln_offer_id1            NUMBER;
  product_type_id1        VARCHAR2(60);
  product_id1             VARCHAR2(60);
  ln_operation_type_id1   VARCHAR2(60) := 'confirmOrder';
  ln_project_owner        VARCHAR(100) := 'TIC Galo Jerez';
  pr_suffix               VARCHAR2(20) := 'CLONE_QW';
  lv_desc_camp            VARCHAR(60) := '[22385] ';
  lv_invoke               VARCHAR2(60) := 'OPERATION_INVOKE';
  lv_dynamic_bl           VARCHAR2(60) := 'DYNAMIC_BLOCKING';
  lv_description          VARCHAR2(100) := 'eSIM QR Code';
  lv_response_properties  VARCHAR2(32767) := '[
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
  lv_session_data             VARCHAR2(32767) := '[
 {
    "id":"INFORMATION_SERVICE",
    "value":[
      "Esim:updateEstadoPorICCID"    
    ]
  },
  {
    "id":"ESTADO",
    "value":[
      "U"    
    ]
  },
  {
    "id":"COMENTARIOS",
    "value":[
      "Se actualiza estado de ICCID a Utilizado"    
    ]
  },{
    "id":"STATUS",
    "value":[
      "Execute-Success"    
    ]
  },{
    "id":"MATCHING_ID",
    "value":[
      "DKA73E08L23XVVB9DBPSKCXQWR8WBBT0BWF2UYNC3AK6FRPDH3LGQD2ZO61XXVVI"    
    ]
  },{
    "id":"SMDP_ADDRESS",
    "value":[
      "claroecuador.validspereachdpplus.com"    
    ]
  } 
]';

  lv_data VARCHAR2(32767) := '[
  {
    "id":"INFORMATION_SERVICE",
    "value":[
      "ESIM:ConsultaICCIDCompleto"    
    ]
  },{
    "id":"ESTADO",
    "value":[
      "R"    
    ]
  },{
    "id":"STATUS",
    "value":[
      "FAILED"    
    ]
  }
  ]';

  lv_data2 VARCHAR2(32767) := '[
  {
    "id":"STATUS",
    "value":[
      "FAILED"    
    ]
  }
  ]';

  lv_data3 VARCHAR2(32767) := '[
  {
    "id":"STATUS",
    "value":[
      "Execute-Success"
    ]
  },{
    "id":"MATCHING_ID",
    "value":[
      "DKA73E08L23XVVB9DBPSKCXQWR8WBBT0BWF2UYNC3AK6FRPDH3LGQD2ZO61XXVVI"
    ]
  },{
    "id":"SMDP_ADDRESS",
    "value":[
      "claroecuador.validspereachdpplus.com"
    ]
  } 
  ]';

  ln_beh_oper_invoke_id1  NUMBER;
  ln_beh_oper_invoke_id2  NUMBER;
  ln_ext_res_group_id1     NUMBER := 0;
  ln_ext_res_group_id2     NUMBER := 0;
  ln_ext_res_group_id3     NUMBER := 0;
  ln_ext_res_id1          NUMBER := 0;
  ln_ext_res_id2          NUMBER := 0;
  ln_ext_res_id3          NUMBER := 0;
  ln_invoke_id1           NUMBER := 0;
  ln_invoke_id2           NUMBER := 0;
  ln_invoke_id3           NUMBER := 0;
  ln_condition_id1        NUMBER := 0;
  ln_domain_id1           NUMBER := 0;
  ln_condition_property_id1 NUMBER := 0;

  SP_COUNTER              NUMBER:=0;
  -- SUBSCRIBER PROPERTIES NAMES
  SP_MATCHING_ID                VARCHAR2(60) := 'MATCHING_ID';
  SP_FUNCTION_REQUESTER_IDENTIFIER  VARCHAR2(60) := 'FUNCTION_REQUESTER_IDENTIFIER';
  SP_FUNCTION_CALL_IDENTIFIER   VARCHAR2(60) := 'FUNCTION_CALL_IDENTIFIER';
  SP_EID                        VARCHAR2(60) := 'EID';
  SP_ICCID                      VARCHAR2(60) := 'ICCID';
  SP_CONFIRMATION_CODE          VARCHAR2(60) := 'CONFIRMATION_CODE';
  SP_SMDS_ADDRESS               VARCHAR2(60) := 'SMDS_ADDRESS';
  SP_RELEASE_FLAG               VARCHAR2(60) := 'RELEASE_FLAG';
  SP_DISPLAY_PROFILE_NAME       VARCHAR2(60) := 'DISPLAY_PROFILE_NAME';
  SP_STATUS                     VARCHAR2(60) := 'STATUS';
  SP_ERRORMESSAGE               VARCHAR2(60) := 'ERRORMESSAGE';
  SP_ERRORCODE                  VARCHAR2(60) := 'ERRORCODE';
  SP_ERRORVARIABLES             VARCHAR2(60) := 'ERRORVARIABLES';
  SP_SMDP_ADDRESS               VARCHAR2(60) := 'SMDP_ADDRESS';
  SP_INFORMATION_SERVICE        VARCHAR2(60) := 'INFORMATION_SERVICE';
  SP_ESTADO                     VARCHAR2(60) := 'ESTADO';
  SP_COMENTARIOS                VARCHAR2(60) := 'COMENTARIOS';
  SP_CODE                       VARCHAR2(60) := 'CODE';
  SP_MENSAJE                    VARCHAR2(60) := 'MENSAJE';
  SP_TRANSACTIONDATE            VARCHAR2(60) := '$TRANSACTIONDATE$'; --variable por defecto, no crear

  -- REEMPLAZAR POR LOS ENDPOINTS PRODUCCION
  URI_CONFIRMORDER              VARCHAR(200) := 'http://200.95.160.7:8312/gsma/rsp2/es2plus/confirmOrder';
  URI_MICROPERSISTOR            VARCHAR(200) := 'http://192.168.37.146:8194/microPersistor/consumer/invoke';
  URI_MICROEIS                  VARCHAR(200) := 'http://micro-jeis-silver.router-default.apps.aro-dev.conecel.com/microjeis/resources/ws/eipConsumeServicioMicroEis';

  LV_ERROR VARCHAR2(500);
  LE_ERROR EXCEPTION;

BEGIN
  BEGIN

  -- RESOURCE GROUP
  SELECT Nvl(Max(E.EXTERNAL_RESOURCE_GROUP_ID),0) + 1 INTO ln_ext_res_group_id1 FROM EXTERNAL_RESOURCE_GROUPS E
  WHERE  Upper(s.description) LIKE Upper('%[22385]%') AND Upper(s.description) LIKE Upper('%ConfirmOrder%');

  SELECT Nvl(Max(E.EXTERNAL_RESOURCE_GROUP_ID),0) + 1 INTO ln_ext_res_group_id2 FROM EXTERNAL_RESOURCE_GROUPS E
  WHERE  Upper(s.description) LIKE Upper('%[22385]%') AND Upper(s.description) LIKE Upper('%Grupo para Esim:updateEstadoPorICCID%');

  SELECT Nvl(Max(E.EXTERNAL_RESOURCE_GROUP_ID),0) + 1 INTO ln_ext_res_group_id3 FROM EXTERNAL_RESOURCE_GROUPS E
  WHERE  Upper(s.description) LIKE Upper('%[22385]%') AND Upper(s.description) LIKE Upper('%DownloadOrder%');
  --YA DEBERIAN EXISTIR LOS GRUPOS DE RECURSOS PORQUE ES CLONADO ?

  --INSERT INTO EXTERNAL_RESOURCE_GROUPS (EXTERNAL_RESOURCE_GROUP_ID, DESCRIPTION)
  --VALUES(ln_ext_res_group_id1,lv_desc_camp||lv_description);

  -- BEHAVIOUR
  SELECT Nvl(Max(B.behaviour_id),0) + 1 INTO ln_behaviour_id FROM behaviour B;
  INSERT INTO behaviour (behaviour_id,description)
  VALUES (ln_behaviour_id,lv_desc_camp||lv_description);
  
  -- CAMPAIGN
  SELECT Nvl(Max(C.campaign_id),0) + 1 INTO ln_campaign_id FROM campaign C;
  INSERT INTO campaign (campaign_id,short_description,long_description,behaviour_id,PROJECT_OWNER)
  VALUES (ln_campaign_id,lv_desc_camp||lv_description,lv_desc_camp||lv_description,ln_behaviour_id,ln_project_owner);
  
  -- PRODUCT_TYPES
  product_type_id1 := 'PRT_' || pr_suffix;
  INSERT INTO product_types (product_type_id,description)
  VALUES (product_type_id1,lv_desc_camp||lv_description);
  
  -- PRODUCTS
  product_id1 := 'PR_' || pr_suffix;
  INSERT INTO products (product_id,description,product_type_id)
  VALUES (product_id1,lv_description,product_type_id1);
  
  -- OFFERS
  SELECT Nvl(Max(O.offer_id),0) + 1 INTO ln_offer_id1 FROM offers O;
  INSERT INTO offers (offer_id,short_description,long_description,offer_type_id)
  VALUES (ln_offer_id1,lv_description,lv_desc_camp||lv_description,'');
  
  -- CAMPAÑA OFERTAS
  INSERT INTO campaign_offers (campaign_id,offer_id)
  VALUES (ln_campaign_id,ln_offer_id1);
  
  -- OFFER_PRODUCTS
  INSERT INTO offer_products (offer_id,product_id,order_by)
  VALUES (ln_offer_id1,product_id1,10);

  -- OPERATION_TYPES
  INSERT INTO OPERATION_TYPES(OPERATION_TYPE_ID,OPERATION_NAME,VALID_FROM,VALID_UNTIL,STATUS ) 
  VALUES (ln_operation_type_id1,lv_desc_camp||lv_description,sysdate,to_date('20-03-2987 23:59:59','dd-mm-yyyy hh24:mi:ss'),'A');


  -- SUBCRIBER_PROPERTIES
  select count(SUBSCRIBER_PROPERTY_ID) into SP_COUNTER from SUBSCRIBER_PROPERTIES where SUBSCRIBER_PROPERTY_ID = SP_MATCHING_ID;
  IF SP_COUNTER = 0 THEN
    insert into subscriber_properties(subscriber_property_id,description,status) values (SP_MATCHING_ID,lv_desc_camp||'eSIM QR Code - MatchingId','A');
  END IF;

  select count(SUBSCRIBER_PROPERTY_ID) into SP_COUNTER from SUBSCRIBER_PROPERTIES where SUBSCRIBER_PROPERTY_ID = SP_FUNCTION_REQUESTER_IDENTIFIER;
  IF SP_COUNTER = 0 THEN
    insert into subscriber_properties(subscriber_property_id,description,status) values (SP_FUNCTION_REQUESTER_IDENTIFIER,lv_desc_camp||'eSIM QR Code - Identificador','A');
  END IF;

  select count(SUBSCRIBER_PROPERTY_ID) into SP_COUNTER from SUBSCRIBER_PROPERTIES where SUBSCRIBER_PROPERTY_ID = SP_FUNCTION_CALL_IDENTIFIER;
  IF SP_COUNTER = 0 THEN
    insert into subscriber_properties(subscriber_property_id,description,status) values (SP_FUNCTION_CALL_IDENTIFIER,lv_desc_camp||'eSIM QR Code - Identificador','A');
  END IF;

  select count(SUBSCRIBER_PROPERTY_ID) into SP_COUNTER from SUBSCRIBER_PROPERTIES where SUBSCRIBER_PROPERTY_ID = SP_EID;
  IF SP_COUNTER = 0 THEN
    insert into subscriber_properties(subscriber_property_id,description,status) values (SP_EID,lv_desc_camp||'eSIM QR Code - EID','A');
  END IF;

  select count(SUBSCRIBER_PROPERTY_ID) into SP_COUNTER from SUBSCRIBER_PROPERTIES where SUBSCRIBER_PROPERTY_ID = SP_ICCID;
  IF SP_COUNTER = 0 THEN
    insert into subscriber_properties(subscriber_property_id,description,status) values (SP_ICCID,lv_desc_camp||'eSIM QR Code - ICCID','A');
  END IF;

  select count(SUBSCRIBER_PROPERTY_ID) into SP_COUNTER from SUBSCRIBER_PROPERTIES where SUBSCRIBER_PROPERTY_ID = SP_CONFIRMATION_CODE;
  IF SP_COUNTER = 0 THEN
    insert into subscriber_properties(subscriber_property_id,description,status) values (SP_CONFIRMATION_CODE,lv_desc_camp||'eSIM QR Code - ConfirmationCode','A');
  END IF;

  select count(SUBSCRIBER_PROPERTY_ID) into SP_COUNTER from SUBSCRIBER_PROPERTIES where SUBSCRIBER_PROPERTY_ID = SP_SMDS_ADDRESS;
  IF SP_COUNTER = 0 THEN
    insert into subscriber_properties(subscriber_property_id,description,status) values (SP_SMDS_ADDRESS,lv_desc_camp||'eSIM QR Code - SMDS Address','A');
  END IF;

  select count(SUBSCRIBER_PROPERTY_ID) into SP_COUNTER from SUBSCRIBER_PROPERTIES where SUBSCRIBER_PROPERTY_ID = SP_RELEASE_FLAG;
  IF SP_COUNTER = 0 THEN
    insert into subscriber_properties(subscriber_property_id,description,status) values (SP_RELEASE_FLAG,lv_desc_camp||'eSIM QR Code - Release Flag','A');
  END IF;

  select count(SUBSCRIBER_PROPERTY_ID) into SP_COUNTER from SUBSCRIBER_PROPERTIES where SUBSCRIBER_PROPERTY_ID = SP_DISPLAY_PROFILE_NAME;
  IF SP_COUNTER = 0 THEN
    insert into subscriber_properties(subscriber_property_id,description,status) values (SP_DISPLAY_PROFILE_NAME,lv_desc_camp||'eSIM QR Code - Display Profile Name','A');
  END IF;
  
  select count(SUBSCRIBER_PROPERTY_ID) into SP_COUNTER from SUBSCRIBER_PROPERTIES where SUBSCRIBER_PROPERTY_ID = SP_STATUS;
  IF SP_COUNTER = 0 THEN
    insert into subscriber_properties(subscriber_property_id,description,status) values (SP_STATUS,lv_desc_camp||'Variable para Guardar Estados','A');
  END IF;
  
  select count(SUBSCRIBER_PROPERTY_ID) into SP_COUNTER from SUBSCRIBER_PROPERTIES where SUBSCRIBER_PROPERTY_ID = SP_ERRORMESSAGE;
  IF SP_COUNTER = 0 THEN
    insert into subscriber_properties(subscriber_property_id,description,status) values (SP_ERRORMESSAGE,lv_desc_camp||'Mensaje de error','A');
  END IF;

  select count(SUBSCRIBER_PROPERTY_ID) into SP_COUNTER from SUBSCRIBER_PROPERTIES where SUBSCRIBER_PROPERTY_ID = SP_ERRORCODE;
  IF SP_COUNTER = 0 THEN
    insert into subscriber_properties(subscriber_property_id,description,status) values (SP_ERRORCODE,lv_desc_camp||'almacena el codigo de error','A');
  END IF;
  
  select count(SUBSCRIBER_PROPERTY_ID) into SP_COUNTER from SUBSCRIBER_PROPERTIES where SUBSCRIBER_PROPERTY_ID = SP_ERRORVARIABLES;
  IF SP_COUNTER = 0 THEN
    insert into subscriber_properties(subscriber_property_id,description,status) values (SP_ERRORVARIABLES,lv_desc_camp||'variables','A');
  END IF;

  select count(SUBSCRIBER_PROPERTY_ID) into SP_COUNTER from SUBSCRIBER_PROPERTIES where SUBSCRIBER_PROPERTY_ID = SP_SMDP_ADDRESS;
  IF SP_COUNTER = 0 THEN
    insert into subscriber_properties(subscriber_property_id,description,status) values (SP_SMDP_ADDRESS,lv_desc_camp||'eSIM QR Code - SMDP Address','A');
  END IF;

  select count(SUBSCRIBER_PROPERTY_ID) into SP_COUNTER from SUBSCRIBER_PROPERTIES where SUBSCRIBER_PROPERTY_ID = SP_INFORMATION_SERVICE;
  IF SP_COUNTER = 0 THEN
    insert into subscriber_properties(subscriber_property_id,description,status) values (SP_INFORMATION_SERVICE,lv_desc_camp||'INFORMATION_SERVICE','A');
  END IF;

  select count(SUBSCRIBER_PROPERTY_ID) into SP_COUNTER from SUBSCRIBER_PROPERTIES where SUBSCRIBER_PROPERTY_ID = SP_ESTADO;
  IF SP_COUNTER = 0 THEN
    insert into subscriber_properties(subscriber_property_id,description,status) values (SP_ESTADO,lv_desc_camp||'ESTADO','A');
  END IF;

  select count(SUBSCRIBER_PROPERTY_ID) into SP_COUNTER from SUBSCRIBER_PROPERTIES where SUBSCRIBER_PROPERTY_ID = SP_COMENTARIOS;
  IF SP_COUNTER = 0 THEN
    insert into subscriber_properties(subscriber_property_id,description,status) values (SP_COMENTARIOS,lv_desc_camp||'COMENTARIOS','A');
  END IF;
  
  select count(SUBSCRIBER_PROPERTY_ID) into SP_COUNTER from SUBSCRIBER_PROPERTIES where SUBSCRIBER_PROPERTY_ID = SP_CODE;
  IF SP_COUNTER = 0 THEN
    insert into subscriber_properties(subscriber_property_id,description,status) values (SP_CODE,lv_desc_camp||'Activacion - Codigo de retorno','A');
  END IF;
  
  select count(SUBSCRIBER_PROPERTY_ID) into SP_COUNTER from SUBSCRIBER_PROPERTIES where SUBSCRIBER_PROPERTY_ID = SP_MENSAJE;
  IF SP_COUNTER = 0 THEN
    insert into subscriber_properties(subscriber_property_id,description,status) values (SP_MENSAJE,lv_desc_camp||'CANCELCLOUDPRODUCT - MENSAJE DE RETORNO DEL SRE','A');
  END IF;


  -- EXTERNAL RESOURCE
  SELECT Nvl(Max(E.external_resource_id),0)+1 INTO ln_ext_res_id1 FROM external_resources E;
  insert into external_resources (external_resource_id,external_resource_group_id,operation_name_description,resource_description,request_pattern_xslt,timeout,status,ext_res_type,request_method,content_type,data_type)
  values (ln_ext_res_id1,ln_ext_res_group_id1,lv_desc_camp||'eSIM QR Code - API ConfirmOrder',lv_desc_camp||'API Confirm Order [HUB IOT]','<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output  method="text" indent="yes" media-type="text/json" omit-xml-declaration="yes"/>
    <xsl:template match="/">
    {
    <xsl:for-each select="//params">
    "header": {
        "functionRequesterIdentifier": "<xsl:value-of select="functionRequesterIdentifier"/>",
        "functionCallIdentifier": "<xsl:value-of select="functionCallIdentifier"/>"
    },
    "iccid": "<xsl:value-of select="iccid"/>",
    "eid": "<xsl:value-of select="eid"/>",
    "matchingId": "<xsl:value-of select="matchingId"/>",
    "confirmationCode": "<xsl:value-of select="confirmationCode"/>",
    "smdsAddress": "<xsl:value-of select="smdsAddress"/>",
    "releaseFlag": "<xsl:value-of select="releaseFlag"/>",
    "displayProfileName" : "<xsl:value-of select="displayProfileName"/>"
    </xsl:for-each>
    }
    </xsl:template>
    </xsl:stylesheet>',11000,'A','REST','POST','application/json','json');

  SELECT Nvl(Max(E.external_resource_id),0)+1 INTO ln_ext_res_id2 FROM external_resources E;
  INSERT INTO external_resources (external_resource_id,external_resource_group_id,operation_name_description,resource_description,request_pattern_xslt,timeout,status,ext_res_type,request_method,content_type,data_type)
  VALUES (ln_ext_res_id2,ln_ext_res_group_id2,lv_desc_camp||'eSIM QR Code - MicroPersistor Esim:updateEstadoPorICCID',lv_desc_camp||'Actualiza el estado de los ICCID en la tabala ESIM_FILE',
    '<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output  method="text" indent="yes" media-type="text/json" omit-xml-declaration="yes"/>
  <xsl:template match="/">
  {
  <xsl:for-each select="//params">
    "informationService": "<xsl:value-of select="_informationService"/>",
    "inputs": [
      {
        "key": "ESTADO",
        "value": "<xsl:value-of select="_estado"/>"
      },
      {
        "key": "COMENTARIOS",
        "value": "<xsl:value-of select="_comentarios"/>"
      },
      {
        "key": "ICCID",
        "value": "<xsl:value-of select="_iccid"/>"
      },
      {
        "key": "INFO_QR",
        "value": "LPA:1$<xsl:value-of select="_smdpAddress"/>$<xsl:value-of select="_matchingId"/>"
      },
      {
        "key":"FECHA_GENERACION_QR",
        "value": "<xsl:value-of select="_fechaGeneracionQr"/>"
      }
    ]
  </xsl:for-each>
  }
  </xsl:template>
</xsl:stylesheet>',1000,'A','REST','POST','application/json','json');

  SELECT Nvl(Max(E.external_resource_id),0)+1 INTO ln_ext_res_id3 FROM external_resources E;
  insert into external_resources (external_resource_id,external_resource_group_id,operation_name_description,resource_description,request_pattern_xslt,timeout,status,ext_res_type,request_method,content_type,data_type)
  values (ln_ext_res_id3,ln_ext_res_group_id3,lv_desc_camp||'eSIM QR Code - MicroEis ESIM:ConsultaICCIDCompleto',lv_desc_camp||'Consulta de ICCID completo atravez de ICCID con 18 digitos',
  '<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output  method="text" indent="yes" media-type="text/json" omit-xml-declaration="yes"/>
<xsl:template match="/">
{
<xsl:for-each select="//params">
  "informationService": "<xsl:value-of select="_informationService"/>",
  "inputs": [
    {
      "key": "ICCID",
      "value": "<xsl:value-of select="_ICCID"/>"
    },{
      "key": "ESTADO",
      "value": "<xsl:value-of select="_estado"/>"
    }
  ]
</xsl:for-each>
}
</xsl:template>
</xsl:stylesheet>',1000,'A','REST','POST','application/json','json');

  -- EXTERNAL RESOURCE COMPONENTS
  INSERT INTO external_resource_components (external_resource_component_id,external_resource_id,endpoint_url,short_description,routing_type,order_by,weight)
  VALUES ((SELECT Nvl(Max(EC.external_resource_component_id),0)+1 FROM external_resource_components EC),ln_ext_res_id1,URI_CONFIRMORDER,lv_desc_camp||'eSIM QR Code - Endpoint API ConfirmOrder','B',10,100);

  INSERT INTO external_resource_components (external_resource_component_id,external_resource_id,endpoint_url,short_description,routing_type,order_by,weight)
  VALUES ((SELECT Nvl(Max(EC.external_resource_component_id),0)+1 FROM external_resource_components EC),ln_ext_res_id2,URI_MICROPERSISTOR,lv_desc_camp||'eSIM QR Code- Endpoint de MicroPersistor Esim:updateEstadoPorICCID','B',10,100);

  INSERT INTO external_resource_components (external_resource_component_id,external_resource_id,endpoint_url,short_description,routing_type,order_by,weight)
  VALUES ((SELECT Nvl(Max(EC.external_resource_component_id),0)+1 FROM external_resource_components EC),ln_ext_res_id3,URI_MICROEIS,lv_desc_camp||'eSIM QR Code- Endpoint de MicroEis','B',10,100);

  -- INVOKE
  SELECT Nvl(Max(I.invoke_id),0)+1 INTO ln_invoke_id1 FROM invoke I;
  INSERT INTO invoke (invoke_id,external_resource_id,operation_name_description,description,status,retries,time_between_retries)
  VALUES (ln_invoke_id1,ln_ext_res_id1,lv_desc_camp||'eSIM QR Code - API ConfirmOrder',lv_desc_camp||'API Confirm Order [HUB IOT]','A',0,1000);

  SELECT Nvl(Max(I.invoke_id),0)+1 INTO ln_invoke_id2 FROM invoke I;
  INSERT INTO invoke (invoke_id,external_resource_id,operation_name_description,description,status,retries,time_between_retries)
  VALUES (ln_invoke_id2,ln_ext_res_id2,lv_desc_camp||'eSIM QR Code - MicroPersistor Esim:updateEstadoPorICCID',lv_desc_camp||'Actualiza el estado de un ICCID en ESIM_FILE','A',0,1000);

  SELECT Nvl(Max(I.invoke_id),0)+1 INTO ln_invoke_id3 FROM invoke I;
  INSERT INTO invoke (invoke_id,external_resource_id,operation_name_description,description,status,retries,time_between_retries)
  VALUES (ln_invoke_id3,ln_ext_res_id3,lv_desc_camp||'eSIM QR Code - MicroEis ESIM:ConsultaICCIDCompleto',lv_desc_camp||'Consulta de ICCID 19 digitos por ICCID 18 digitos','A',0,1000);

  -- MAPPING CONFIRMORDER
  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id1,'FV','','','WSSE Realm="AMXhub", Profile="UsernameToken"','>>','','','Authorization','Header','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id1,'FV','','','UsernameToken Username="PA00003022",PasswordDigest="Li2fKU8Ry2vM+hdYRV+8N+mTzfguSBH2EaVrzCQDU5A=", Nonce="7EOuOyzCrxD3tpIAPgyNfQ16ab6", Created="2022-10-03T15:46:29Z"','>>','','','X-WSSE','Header','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id1,'FV','','','request TransId="AP20009", iccidManager="ValProdECU", providerId="PA00003432", AppId="AP20009", AspCallBackUrl=http://181.209.207.33:19315, enterpriseId="esimtest", country="ECU"','>>','','','X-RequestHeader','Header','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id1,'FV','','','gsma/rsp/v2.2.0','>>','','','X-Admin-Protocol','Header','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id1,'SP',SP_MATCHING_ID,'','','<=','','$.matchingId','','','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id1,'SP',SP_FUNCTION_REQUESTER_IDENTIFIER,'','','=>','','','functionRequesterIdentifier',lv_desc_camp||'Identificador de request','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id1,'SP',SP_FUNCTION_CALL_IDENTIFIER,'','','=>','','','functionCallIdentifier',lv_desc_camp||'Identificador de llamada','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id1,'SP',SP_EID,'','','=>','','','eid',lv_desc_camp||'Identificador del dispositivo','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id1,'SP',SP_ICCID,'','','=>','','','iccid',lv_desc_camp||'SIM Card','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id1,'SP',SP_MATCHING_ID,'','','=>','','','matchingId',lv_desc_camp||'Matching Id','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id1,'SP',SP_CONFIRMATION_CODE,'','','=>','','','confirmationCode',lv_desc_camp||'Confirmation Code','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id1,'SP',SP_SMDS_ADDRESS,'','','=>','','','smdsAddress',lv_desc_camp||'SMDS Address','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id1,'SP',SP_RELEASE_FLAG,'','','=>','','','releaseFlag',lv_desc_camp||'Release Flag','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id1,'SP',SP_DISPLAY_PROFILE_NAME,'','','=>','','','displayProfileName',lv_desc_camp||'Display Profile Name','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id1,'SP',SP_EID,'','','<=','','$.eid','','','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id1,'SP',SP_STATUS,'','','<=','','$.header.functionExecutionStatus.status','','','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id1,'SP',SP_ERRORMESSAGE,'','','<=','','$.serviceException.text','','','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id1,'SP',SP_ERRORCODE,'','','<=','','$.serviceException.messageId','','','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id1,'SP',SP_ERRORVARIABLES,'','','<=','','$.serviceException.variables','','','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id1,'SP',SP_SMDP_ADDRESS,'','','<=','','$.smdpAddress','','','A');

  -- MAPPING MICROPERSISTOR
  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id2,'SP',SP_INFORMATION_SERVICE,'','','=>','','','_informationService','Information service para microeis','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id2,'SP',SP_SMDP_ADDRESS,'','','=>','','','_smdpAddress','Informacion para Qr','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id2,'SP',SP_TRANSACTIONDATE,'','','=>','','','_fechaGeneracionQr','la fecha en la que se genera la informacion para el Qr Code','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id2,'SP',SP_MATCHING_ID,'','','=>','','','_matchingId','Informacion para Qr','A');
  
  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id2,'SP',SP_ESTADO,'','','=>','','','_estado','Actualizacion del estado','A');
  
  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id2,'SP',SP_COMENTARIOS,'','','=>','','','_comentarios','Comentarios actualizados','A');
  
  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id2,'SP',SP_ICCID,'','','=>','','','_iccid','EL ICCID a actualizar','A');
  
  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id2,'SP',SP_CODE,'','','<=','','$.code','','Codigo de respuesta','A');
  
  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id2,'SP',SP_MENSAJE,'','','<=','','$.message','','Mensaje de respuesta','A');

  -- MAPPING MICROEIS
  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id3,'SP',SP_ICCID,'','','=>','','','_ICCID','ICCID con 18 digitos','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id3,'SP',SP_ICCID,'','','<=','','$.response[0].ICCID','','ICCID con 19 digitos','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id3,'SP',SP_CODE,'','','<=','','$.code','','Codigo de respuesta','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id3,'SP',SP_MENSAJE,'','','<=','','$.message','','Mensaje de respuesta','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id3,'SP',SP_INFORMATION_SERVICE,'','','=>','','','_informationService','Information Service de MicroEis','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id3,'SP',SP_ESTADO,'','','<=','','$.response[0].ESTADO','','Estado de ICCID','A');
  
  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id3,'SP',SP_ESTADO,'','','=>','','','_estado','Estado de ICCID','A');

  --RESPONSE EVALUATION
  INSERT INTO invoke_response_evaluation (invoke_response_evaluation_id,invoke_id,order_by,xpath,evaluation_type,expected_value,value_type,evaluation_operator,success,failure_message,status)
  VALUES ((SELECT Nvl(Max(IR.invoke_response_evaluation_id),0)+1 FROM invoke_response_evaluation IR),ln_invoke_id1,10,'$.serviceException.messageId','FV',null,'VARCHAR','!=','NO','SEP=#ERRORMESSAGE#ERRORVARIABLES# Ocurrio un error en el API ConfirmOrder: %s (%s)','I');

  INSERT INTO invoke_response_evaluation (invoke_response_evaluation_id,invoke_id,order_by,xpath,evaluation_type,expected_value,value_type,evaluation_operator,success,failure_message,status)
  VALUES ((SELECT Nvl(Max(IR.invoke_response_evaluation_id),0)+1 FROM invoke_response_evaluation IR),ln_invoke_id1,20,'$.header.functionExecutionStatus.status','FV','Failed','VARCHAR','==','NO','SEP=#ERRORMESSAGE#ERRORVARIABLES# Ocurrio un error en el API ConfirmOrder: %s (%s)','I');

  INSERT INTO invoke_response_evaluation (invoke_response_evaluation_id,invoke_id,order_by,xpath,evaluation_type,expected_value,value_type,evaluation_operator,success,failure_message,status)
  VALUES ((SELECT Nvl(Max(IR.invoke_response_evaluation_id),0)+1 FROM invoke_response_evaluation IR),ln_invoke_id2,10,'$.code','FV',0,'VARCHAR','==','YES','Error en el update del estado del ICCID  a la tabla ESIM_FILE','A');

  INSERT INTO invoke_response_evaluation (invoke_response_evaluation_id,invoke_id,order_by,xpath,evaluation_type,expected_value,value_type,evaluation_operator,success,failure_message,status)
  VALUES ((SELECT Nvl(Max(IR.invoke_response_evaluation_id),0)+1 FROM invoke_response_evaluation IR),ln_invoke_id3,10,'$.code','FV',0,'VARCHAR','==','YES','SEP=#MENSAJE#Error en consulta con MicroEis: %s','A');

  INSERT INTO invoke_response_evaluation (invoke_response_evaluation_id,invoke_id,order_by,xpath,evaluation_type,expected_value,value_type,evaluation_operator,success,failure_message,status,fail_code)
  VALUES ((SELECT Nvl(Max(IR.invoke_response_evaluation_id),0)+1 FROM invoke_response_evaluation IR),ln_invoke_id3,20,'$.response[0].ICCID','FV','','VARCHAR','!=','YES','No se encontro el ICCID registrado en repositorio eSIM','A',10);


  -- BEHAVIOUR_OPERATION - AGREGAR TODOS LOS CAMPOS QUE SE NECESITEN
  SELECT Nvl(Max(BO.behaviour_operation_id),0) + 1 INTO ln_beh_operation_id FROM behaviour_operation BO;
  INSERT INTO behaviour_operation (behaviour_operation_id,behaviour_id,operation_type_id,description,response_properties)
  VALUES (ln_beh_operation_id,ln_behaviour_id,ln_operation_type_id1,lv_desc_camp||lv_description,lv_response_properties);
  
  -- Creacion del esqueleto o STAGES
  SELECT Nvl(Max(BS.behaviour_oper_stage_id),0) + 1 INTO ln_beh_oper_stage_id1 FROM behaviour_oper_stages BS;
  INSERT INTO behaviour_oper_stages (behaviour_oper_stage_id,stage_id,order_by,behaviour_operation_id)
  VALUES (ln_beh_oper_stage_id1,lv_invoke,10,ln_beh_operation_id);

  SELECT NVL(MAX(BS.BEHAVIOUR_OPER_STAGE_ID),0) + 1 INTO ln_beh_oper_stage_id2 FROM BEHAVIOUR_OPER_STAGES BS;
  INSERT INTO behaviour_oper_stages (BEHAVIOUR_OPER_STAGE_ID,STAGE_ID,ORDER_BY,BEHAVIOUR_OPERATION_ID)
  VALUES (ln_beh_oper_stage_id2,lv_dynamic_bl,20,ln_beh_operation_id);


  -- BEHAVIOUR OPER INVOKE (CONFIRMORDER)
  SELECT Nvl(Max(BI.behaviour_oper_invoke_id),0)+1 INTO ln_beh_oper_invoke_id1 FROM behaviour_oper_invoke BI;
  INSERT INTO behaviour_oper_invoke (behaviour_oper_invoke_id,behaviour_oper_stage_id,when,condition_id,invoke_id,order_by,required,status,sync,notification_group_id,session_data,schedule_id,when_condition,when_schedule,when_resp_not_success,retries,apply_compensation,invoke_id_comp_backward,invoke_id_comp_forward,condition_group_id,looping_operation_id,copy_from_subs_to_subs)
  VALUES (ln_beh_oper_invoke_id1,ln_beh_oper_stage_id1,'POST',null,ln_invoke_id1,10,'YES','A','YES',null,'[]',null,null,'','',0,'NO','','','',null,'');

  -- BEHAVIOUR OPER INVOKE (MICROPERSISTOR)
  SELECT Nvl(Max(BI.behaviour_oper_invoke_id),0)+1 INTO ln_beh_oper_invoke_id2 FROM behaviour_oper_invoke BI;
  INSERT INTO behaviour_oper_invoke (behaviour_oper_invoke_id,behaviour_oper_stage_id,when,condition_id,invoke_id,order_by,required,status,sync,notification_group_id,session_data,schedule_id,when_condition,when_schedule,when_resp_not_success,retries,apply_compensation,invoke_id_comp_backward,invoke_id_comp_forward,condition_group_id,looping_operation_id,copy_from_subs_to_subs)
  VALUES (ln_beh_oper_invoke_id2,ln_beh_oper_stage_id1,'POST',null,ln_invoke_id2,20,'YES','A','YES',null,lv_session_data,null,null,'','',0,'NO','','','',null,'');

  -- BEHAVIOUR ENCRICHMENT INVOKE
  INSERT INTO behaviour_enrichment (BEHAVIOUR_ENRICHMENT_ID,BEHAVIOUR_OPER_STAGE_ID,CONDITION_ID,INVOKE_ID,ORDER_BY,REQUIRED,STATUS,NOTIFICATION_GROUP_ID,WHEN_RESP_NOT_SUCCESS,CONDITION_GROUP_ID,DEFINED_FUNCTION_CALL_ID,EXECUTION_PRIORITY,RETRIES,APPLY_COMPENSATION,INVOKE_ID_COMP_BACKWARD,INVOKE_ID_COMP_FORWARD)
  VALUES ((SELECT NVL(MAX(T.behaviour_enrichment_id), 0) + 1 FROM behaviour_enrichment T),ln_beh_oper_stage_id1,NULL,ln_invoke_id3,10,'YES','A',NULL,'','',NULL,'CONDITION',0,'NO','','');

  -- BEHAVIOUR ENCRICHMENT PROPERTY 1
  INSERT INTO behaviour_enrichment_property (BEHAVIOUR_ENRICHE_PROPERTY_ID,BEHAVIOUR_OPER_STAGE_ID,CONDITION_ID,WHEN,ORDER_BY,SESSION_DATA,STATUS,CONDITION_GROUP_ID,DEFINED_FUNCTION_CALL_ID,EXECUTION_PRIORITY)
  VALUES ((SELECT NVL(MAX(BP.BEHAVIOUR_ENRICHE_PROPERTY_ID),0)+1 FROM BEHAVIOUR_ENRICHMENT_PROPERTY BP),ln_beh_oper_stage_id1,NULL,'PRE',10,lv_data,'A','',NULL,'CONDITION');

  -- CONDITION
  SELECT nvl(max(c.condition_id), 0)+1 INTO ln_condition_id1 FROM CONDITION c;
  INSERT INTO CONDITION (CONDITION_ID,DESCRIPTION)
  VALUES (ln_condition_id1,lv_desc_camp||'eSIM QR Code - Valida si el estado del ICCID se encuentra vacio');

  -- DOMAIN
  SELECT nvl(max(d.domain_id),0)+1 INTO ln_domain_id1 FROM DOMAIN d;
  INSERT INTO DOMAIN (DOMAIN_ID,DESCRIPTION,STATUS)
  VALUES (ln_domain_id1,lv_desc_camp||'eSIM QR Code - Dominio con valor vacio','A');

  -- DOMAIN ELEMENTS
  INSERT INTO DOMAIN_ELEMENTS SELECT rownum + (SELECT NVL(MAX(DE.DOMAIN_ELEMENT_ID),0) + 1 FROM DOMAIN_ELEMENTS DE) DOMAIN_ELEMENT_ID,
  trim(regexp_substr(valor, '[^,]+', 1, level)) ELEMENT_VALUE,ln_domain_id1 DOMAIN_ID,'A' STATUS
  FROM (select '' valor from dual) t CONNECT BY instr(valor, ',', 1, level - 1) > 0;

  -- DOMAIN VALUE RANGES (NO APLICA)

  -- CONDITION PROPERTIES
  SELECT nvl(max(cp.condition_property_id),0)+1 INTO ln_condition_property_id1 FROM CONDITION_PROPERTIES cp;
  INSERT INTO CONDITION_PROPERTIES (CONDITION_PROPERTY_ID,CONDITION_ID,SUBSCRIBER_PROPERTY_ID,ORDER_BY,DATA_TYPE,EXPRESSION_CONDITION,DOMAIN_ID,MIN_NUM_DOMAIN_ELEMENTS,MAX_NUM_DOMAIN_ELEMENTS,SUCCESS_MESSAGE,FAIL_MESSAGE)
  VALUES (ln_condition_property_id1,ln_condition_id1,SP_ESTADO,10,'VARCHAR','[SP=DM]',ln_domain_id1,null,null,'No se encuentra el ICCID registrada en el repositorio eSIM','Si se encuentra el ICCID registrada en el repositorio eSIM');

  -- BEHAVIOUR ENCRICHMENT PROPERTY 2 
  -- DESHABILITADO ?
  INSERT INTO behaviour_enrichment_property (BEHAVIOUR_ENRICHE_PROPERTY_ID,BEHAVIOUR_OPER_STAGE_ID,CONDITION_ID,WHEN,ORDER_BY,SESSION_DATA,STATUS,CONDITION_GROUP_ID,DEFINED_FUNCTION_CALL_ID,EXECUTION_PRIORITY)
  VALUES ((SELECT NVL(MAX(BP.BEHAVIOUR_ENRICHE_PROPERTY_ID),0)+1 FROM BEHAVIOUR_ENRICHMENT_PROPERTY BP),ln_beh_oper_stage_id1,ln_condition_id1,'POST',20,lv_data2,'I','',NULL,'CONDITION');

  INSERT INTO behaviour_enrichment_property (BEHAVIOUR_ENRICHE_PROPERTY_ID,BEHAVIOUR_OPER_STAGE_ID,CONDITION_ID,WHEN,ORDER_BY,SESSION_DATA,STATUS,CONDITION_GROUP_ID,DEFINED_FUNCTION_CALL_ID,EXECUTION_PRIORITY,WHEN_CONDITION)
  VALUES ((SELECT NVL(MAX(BP.BEHAVIOUR_ENRICHE_PROPERTY_ID),0)+1 FROM BEHAVIOUR_ENRICHMENT_PROPERTY BP),ln_beh_oper_stage_id2,ln_condition_id1,'POST',10,lv_data3,'A','',NULL,'CONDITION','FALSE');

  
  commit;
  DBMS_OUTPUT.PUT_LINE('CONFIG_CODE: ' || lv_description);
  DBMS_OUTPUT.PUT_LINE('BEHAVIOUR_ID: ' || ln_behaviour_id);
  DBMS_OUTPUT.PUT_LINE('CAMPAIGN_ID: ' || ln_campaign_id);
  DBMS_OUTPUT.PUT_LINE('OFFER_ID: ' || ln_offer_id1);
  DBMS_OUTPUT.PUT_LINE('PRODUCT_TYPE: ' || product_type_id1);
  DBMS_OUTPUT.PUT_LINE('PRODUCT: ' || product_id1);
  DBMS_OUTPUT.PUT_LINE('PR_SUFFIX: ' || pr_suffix);
  DBMS_OUTPUT.PUT_LINE('OPERATION_TYPE_ID: ' || ln_operation_type_id1);
  DBMS_OUTPUT.PUT_LINE('BEH_OPERATION_ID: ' || ln_beh_operation_id);
  DBMS_OUTPUT.PUT_LINE('BEH_OPER_STAGE_INVOKE1: ' || ln_beh_oper_invoke_id1);
  DBMS_OUTPUT.PUT_LINE('BEH_OPER_STAGE_INVOKE2: ' || ln_beh_oper_invoke_id2);
  DBMS_OUTPUT.PUT_LINE('EXTERNAL_RESOURCE_GROUPS_1: ' || ln_ext_res_group_id1);
  DBMS_OUTPUT.PUT_LINE('EXTERNAL_RESOURCE_GROUPS_2: ' || ln_ext_res_group_id2);
  DBMS_OUTPUT.PUT_LINE('EXTERNAL_RESOURCE_GROUPS_3: ' || ln_ext_res_group_id3);
  DBMS_OUTPUT.PUT_LINE('INVOKE_ID_1: ' || ln_invoke_id1);
  DBMS_OUTPUT.PUT_LINE('INVOKE_ID_2: ' || ln_invoke_id2);
  DBMS_OUTPUT.PUT_LINE('INVOKE_ID_3: ' || ln_invoke_id3);
  DBMS_OUTPUT.PUT_LINE('EXTERNA_RESOURCES_1: ' || ln_ext_res_id1);
  DBMS_OUTPUT.PUT_LINE('EXTERNA_RESOURCES_2: ' || ln_ext_res_id2);
  DBMS_OUTPUT.PUT_LINE('EXTERNA_RESOURCES_3: ' || ln_ext_res_id3);
  DBMS_OUTPUT.PUT_LINE('DOMAIN: ' || ln_domain_id1);
  DBMS_OUTPUT.PUT_LINE('CONDITION: ' || ln_condition_id1);

  dbms_output.Put_line('ln_beh_operation_id number := '||ln_beh_operation_id||';');
  dbms_output.put_line('ln_beh_oper_stage_id1 number := '||ln_beh_oper_stage_id1||';');
  dbms_output.put_line('ln_beh_oper_stage_id2 number := '||ln_beh_oper_stage_id2||';');
  dbms_output.put_line('ln_beh_oper_invoke_id1 number := '||ln_beh_oper_invoke_id1||';');
  dbms_output.Put_line('INVOKE ID1 := '|| ln_invoke_id1 );
  dbms_output.put_line('ln_beh_oper_invoke_id2 number := '||ln_beh_oper_invoke_id2||';');
  dbms_output.Put_line('INVOKE ID2 := '|| ln_invoke_id2 );
  dbms_output.Put_line('INVOKE ID3 := '|| ln_invoke_id3 );

  dbms_output.put_line('ln_domain_id := ' || ln_domain_id1);
  dbms_output.put_line('ln_condition_id := ' || ln_condition_id1);

  dbms_output.Put_line('---------------REFRESH------------------------------------');
  dbms_output.put_line('http://192.168.37.146:8101/quickWin/clearCampaignById/'||ln_campaign_id);
  dbms_output.put_line('http://192.168.37.146:8101/quickWin/clearInvokeById/'||ln_invoke_id1);
  dbms_output.Put_line('---------------GUARDE ESTE SCRIPT POR MAYOR SEGURIDAD--------------------------------------');
  dbms_output.Put_line('---------------SELECT--------------------------------------');
  dbms_output.Put_line('SELECT * FROM CAMPAIGN T WHERE T.CAMPAIGN_ID = '''||ln_campaign_id||''';');
  dbms_output.Put_line('SELECT * FROM CAMPAIGN_OFFERS T WHERE T.CAMPAIGN_ID = '''||ln_campaign_id||''';');
  dbms_output.Put_line('SELECT * FROM BEHAVIOUR_OPERATION T WHERE T.BEHAVIOUR_OPERATION_ID = '''||ln_beh_operation_id||''';');
  dbms_output.Put_line('SELECT * FROM BEHAVIOUR_OPER_STAGES T WHERE T.BEHAVIOUR_OPERATION_ID = '''||ln_beh_operation_id||''' order by t.order_by;');

  dbms_output.put_line('SELECT * FROM behaviour_oper_stages T WHERE T.BEHAVIOUR_OPER_STAGE_ID = '||ln_beh_oper_stage_id1||' order by t.order_by;');
  dbms_output.put_line('SELECT * FROM behaviour_oper_stages T WHERE T.BEHAVIOUR_OPER_STAGE_ID = '||ln_beh_oper_stage_id2||' order by t.order_by;');
  dbms_output.put_line('SELECT * FROM behaviour_enrichment T WHERE T.BEHAVIOUR_OPER_STAGE_ID = ' || ln_beh_oper_stage_id1 || ' ORDER BY t.order_by;');

  dbms_output.Put_line('SELECT * FROM BEHAVIOUR_PRODUCT T WHERE T.BEHAVIOUR_OPER_STAGE_ID = '''||ln_beh_oper_stage_id1||''';');
  dbms_output.Put_line('SELECT * FROM offer_products T WHERE T.offer_id = '''||ln_offer_id1||''';');
  dbms_output.Put_line('SELECT * FROM campaign_offers T WHERE T.offer_id = '''||ln_offer_id1||''';');
  dbms_output.Put_line('SELECT * FROM PRODUCT_TYPES T WHERE T.PRODUCT_TYPE_ID = '''||product_type_id1||''';');
  dbms_output.Put_line('SELECT * FROM PRODUCTS T WHERE T.PRODUCT_TYPE_ID = '''||product_type_id1||''';');

  dbms_output.put_line('SELECT * FROM behaviour_enrichment_property T WHERE T.BEHAVIOUR_OPER_STAGE_ID = '||ln_beh_oper_stage_id2||' order by t.order_by;');
  dbms_output.put_line('SELECT * FROM DOMAIN_VALUE_RANGES t where t.domain_id = '''||ln_domain_id1||''';');
  dbms_output.put_line('SELECT * FROM DOMAIN_ELEMENTS t where t.domain_id = '''||ln_domain_id1||''';');
  dbms_output.put_line('SELECT * FROM DOMAIN t where t.domain_id = '''||ln_domain_id1||''';');
  dbms_output.put_line('SELECT * FROM CONDITION_PROPERTIES T WHERE T.CONDITION_ID = '''||ln_condition_id1||''';');
  dbms_output.put_line('SELECT * FROM CONDITION t where t.condition_id = '''||ln_condition_id1||''';');
  dbms_output.put_line('SELECT * FROM behaviour_validations T WHERE T.BEHAVIOUR_OPER_STAGE_ID = '||ln_beh_oper_stage_id2||' order by t.order_by;');

  dbms_output.Put_line('---------------INVOKE CONFIRM ORDER--------------------------------------');
  dbms_output.Put_line('SELECT * FROM INVOKE T WHERE T.INVOKE_ID = '''||ln_invoke_id1||''';');
  dbms_output.Put_line('SELECT * FROM EXTERNAL_RESOURCE_GROUPS T WHERE T.EXTERNAL_RESOURCE_GROUP_ID = '''||ln_ext_res_group_id1||''';');
  dbms_output.Put_line('SELECT * FROM EXTERNAL_RESOURCES T WHERE T.EXTERNAL_RESOURCE_ID = '''||ln_ext_res_id1||''';');
  dbms_output.Put_line('SELECT * FROM EXTERNAL_RESOURCE_COMPONENTS T WHERE T.EXTERNAL_RESOURCE_ID = '''||ln_ext_res_id1||''';');
  dbms_output.Put_line('SELECT * FROM INVOKE_MAPPING T WHERE T.INVOKE_ID = '''||ln_invoke_id1||''';');
  dbms_output.Put_line('SELECT * FROM INVOKE_RESPONSE_EVALUATION T WHERE T.INVOKE_ID = '''||ln_invoke_id1||''';');
  dbms_output.put_line('SELECT * FROM BEHAVIOUR_OPER_INVOKE T WHERE T.BEHAVIOUR_OPER_STAGE_ID = '||ln_beh_oper_stage_id1||' order by t.order_by;');

  dbms_output.Put_line('---------------INVOKE MICROPERSISTOR--------------------------------------');
  dbms_output.Put_line('SELECT * FROM INVOKE T WHERE T.INVOKE_ID = '''||ln_invoke_id2||''';');
  dbms_output.Put_line('SELECT * FROM EXTERNAL_RESOURCE_GROUPS T WHERE T.EXTERNAL_RESOURCE_GROUP_ID = '''||ln_ext_res_group_id2||''';');
  dbms_output.Put_line('SELECT * FROM EXTERNAL_RESOURCES T WHERE T.EXTERNAL_RESOURCE_ID = '''||ln_ext_res_id2||''';');
  dbms_output.Put_line('SELECT * FROM EXTERNAL_RESOURCE_COMPONENTS T WHERE T.EXTERNAL_RESOURCE_ID = '''||ln_ext_res_id2||''';');
  dbms_output.Put_line('SELECT * FROM INVOKE_MAPPING T WHERE T.INVOKE_ID = '''||ln_invoke_id2||''';');
  dbms_output.Put_line('SELECT * FROM INVOKE_RESPONSE_EVALUATION T WHERE T.INVOKE_ID = '''||ln_invoke_id2||''';');

  dbms_output.Put_line('---------------INVOKE MICROEIS--------------------------------------');
  dbms_output.Put_line('SELECT * FROM INVOKE T WHERE T.INVOKE_ID = ''' || ln_invoke_id3 || ''';');
  dbms_output.Put_line('SELECT * FROM EXTERNAL_RESOURCE_GROUPS T WHERE T.EXTERNAL_RESOURCE_GROUP_ID = ''' || ln_ext_res_group_id3 || ''';');
  dbms_output.Put_line('SELECT * FROM EXTERNAL_RESOURCES T WHERE T.EXTERNAL_RESOURCE_ID = ''' || ln_ext_res_id3 || ''';');
  dbms_output.Put_line('SELECT * FROM EXTERNAL_RESOURCE_COMPONENTS T WHERE T.EXTERNAL_RESOURCE_ID = ''' || ln_ext_res_id3 || ''';');
  dbms_output.Put_line('SELECT * FROM INVOKE_MAPPING T WHERE T.INVOKE_ID = ''' || ln_invoke_id3 || ''';');
  dbms_output.Put_line('SELECT * FROM INVOKE_RESPONSE_EVALUATION T WHERE T.INVOKE_ID = ''' || ln_invoke_id3 || ''';');

  dbms_output.Put_line('--------------UPDATE STATUS---------------------------------------');
  dbms_output.Put_line('update offer_products t set status = ''I'' where t.offer_id = '''||ln_offer_id1||''';');
  dbms_output.Put_line('update campaign_offers t set status = ''I'' where t.offer_id = '''||ln_offer_id1||''';');
  dbms_output.Put_line('update offers t set status = ''I'' where t.offer_id = '''||ln_offer_id1||''';');
  dbms_output.Put_line('update products p set status = ''I'' where p.product_type_id = '''||product_type_id1||''';');
  dbms_output.Put_line('update product_types p set status = ''I'' where p.product_type_id = '''||product_type_id1||''';');
  dbms_output.Put_line('update campaign c set status = ''I'' where c.behaviour_id = '''||ln_behaviour_id||''';');
  dbms_output.Put_line('update behaviour a set status = ''I'' where a.behaviour_id = '''||ln_behaviour_id||''';');

  dbms_output.put_line('update behaviour_oper_stages t set status = ''I'' where t.BEHAVIOUR_OPERATION_ID = '||ln_beh_operation_id||';');
  dbms_output.put_line('update behaviour_oper_stages t set status = ''I'' where t.BEHAVIOUR_OPER_STAGE_ID = '||ln_beh_oper_stage_id1||';');
  dbms_output.put_line('update behaviour_oper_stages t set status = ''I'' where t.BEHAVIOUR_OPER_STAGE_ID = '||ln_beh_oper_stage_id2||';');
  dbms_output.put_line('UPDATE behaviour_enrichment T SET status = ''I'' WHERE T.BEHAVIOUR_OPER_STAGE_ID = ' || ln_beh_oper_stage_id1 || ';');

  dbms_output.put_line('update behaviour_enrichment_property t set status = ''I'' where t.BEHAVIOUR_OPER_STAGE_ID = '||ln_beh_oper_stage_id2||';');
  dbms_output.put_line('UPDATE DOMAIN_VALUE_RANGES t set status = ''I'' where t.domain_id = '''||ln_domain_id1||''';');
  dbms_output.put_line('UPDATE DOMAIN_ELEMENTS t set status = ''I'' where t.domain_id = '''||ln_domain_id1||''';');
  dbms_output.put_line('UPDATE DOMAIN t set status = ''I'' where t.domain_id = '''||ln_domain_id1||''';');
  dbms_output.put_line('UPDATE CONDITION_PROPERTIES T set status = ''I'' WHERE T.CONDITION_ID = '''||ln_condition_id1||''';');
  dbms_output.put_line('UPDATE CONDITION t set status = ''I'' where t.condition_id = '''||ln_condition_id1||''';');
  dbms_output.put_line('update behaviour_validations t set status = ''I'' where t.BEHAVIOUR_OPER_STAGE_ID = '||ln_beh_oper_stage_id2||';');

  dbms_output.Put_line('---------------INVOKE CONFIRMORDER--------------------------------------');
  dbms_output.Put_line('update INVOKE T set status = ''I'' WHERE T.INVOKE_ID = '''||ln_invoke_id1||''';');
  dbms_output.Put_line('update EXTERNAL_RESOURCE_GROUPS T set status = ''I'' WHERE T.EXTERNAL_RESOURCE_GROUP_ID = '''||ln_ext_res_group_id1||''';');
  dbms_output.Put_line('update EXTERNAL_RESOURCES T set status = ''I'' WHERE T.EXTERNAL_RESOURCE_ID = '''||ln_ext_res_id1||''';');
  dbms_output.Put_line('update EXTERNAL_RESOURCE_COMPONENTS T set status = ''I'' WHERE T.EXTERNAL_RESOURCE_ID = '''||ln_ext_res_id1||''';');
  dbms_output.Put_line('update INVOKE_MAPPING T set status = ''I'' WHERE T.INVOKE_ID = '''||ln_invoke_id1||''';');
  dbms_output.Put_line('update INVOKE_RESPONSE_EVALUATION T set status = ''I'' WHERE T.INVOKE_ID = '''||ln_invoke_id1||''';');
  dbms_output.put_line('update BEHAVIOUR_OPER_INVOKE t set status = ''I'' where t.BEHAVIOUR_OPER_STAGE_ID = '||ln_beh_oper_stage_id1||';');

  dbms_output.Put_line('---------------INVOKE MICROPERSISTOR--------------------------------------');
  dbms_output.Put_line('update INVOKE T set status = ''I'' WHERE T.INVOKE_ID = '''||ln_invoke_id2||''';');
  dbms_output.Put_line('update EXTERNAL_RESOURCE_GROUPS T set status = ''I'' WHERE T.EXTERNAL_RESOURCE_GROUP_ID = '''||ln_ext_res_group_id2||''';');
  dbms_output.Put_line('update EXTERNAL_RESOURCES T set status = ''I'' WHERE T.EXTERNAL_RESOURCE_ID = '''||ln_ext_res_id2||''';');
  dbms_output.Put_line('update EXTERNAL_RESOURCE_COMPONENTS T set status = ''I'' WHERE T.EXTERNAL_RESOURCE_ID = '''||ln_ext_res_id2||''';');
  dbms_output.Put_line('update INVOKE_MAPPING T set status = ''I'' WHERE T.INVOKE_ID = '''||ln_invoke_id2||''';');
  dbms_output.Put_line('update INVOKE_RESPONSE_EVALUATION T set status = ''I'' WHERE T.INVOKE_ID = '''||ln_invoke_id2||''';');

  dbms_output.Put_line('---------------INVOKE MICROEIS--------------------------------------');
  dbms_output.Put_line('update INVOKE T set status = ''I'' WHERE T.INVOKE_ID = ''' || ln_invoke_id3 || ''';');
  dbms_output.Put_line('update EXTERNAL_RESOURCE_GROUPS T set status = ''I'' WHERE T.EXTERNAL_RESOURCE_GROUP_ID = ''' || ln_ext_res_group_id3 || ''';');
  dbms_output.Put_line('update EXTERNAL_RESOURCES T set status = ''I'' WHERE T.EXTERNAL_RESOURCE_ID = ''' || ln_ext_res_id3 || ''';');
  dbms_output.Put_line('update EXTERNAL_RESOURCE_COMPONENTS T set status = ''I'' WHERE T.EXTERNAL_RESOURCE_ID = ''' || ln_ext_res_id3 || ''';');
  dbms_output.Put_line('update INVOKE_MAPPING T set status = ''I'' WHERE T.INVOKE_ID = ''' || ln_invoke_id3 || ''';');
  dbms_output.Put_line('update INVOKE_RESPONSE_EVALUATION T set status = ''I'' WHERE T.INVOKE_ID = ''' || ln_invoke_id3 || ''';');

  dbms_output.Put_line('--------------DELETE---------------------------------------');
  dbms_output.Put_line('DELETE behaviour_oper_stages b where b.behaviour_operation_id = '''||ln_beh_operation_id||''';');
  dbms_output.Put_line('DELETE behaviour_operation b where b.behaviour_id = '''||ln_behaviour_id||''';');
  dbms_output.Put_line('DELETE offer_products t where t.offer_id = '''||ln_offer_id1||''';');
  dbms_output.Put_line('DELETE campaign_offers t where t.offer_id = '''||ln_offer_id1||''';');
  dbms_output.Put_line('DELETE offers t where t.offer_id = '''||ln_offer_id1||''';');
  dbms_output.Put_line('DELETE products p where p.product_type_id = '''||product_type_id1||''';');
  dbms_output.Put_line('DELETE product_types p where p.product_type_id = '''||product_type_id1||''';');
  dbms_output.Put_line('DELETE campaign c where c.behaviour_id = '''||ln_behaviour_id||''';');
  dbms_output.Put_line('DELETE behaviour a where a.behaviour_id ='''||ln_behaviour_id||''';');

  dbms_output.put_line('delete behaviour_oper_stages b where b.BEHAVIOUR_OPER_STAGE_ID = '||ln_beh_oper_stage_id1||';');
  dbms_output.put_line('delete behaviour_oper_stages b where b.BEHAVIOUR_OPER_STAGE_ID = '||ln_beh_oper_stage_id2||';');
  dbms_output.put_line('DELETE behaviour_enrichment B WHERE B.BEHAVIOUR_OPER_STAGE_ID = ' || ln_beh_oper_stage_id1 || ';');

  dbms_output.put_line('DELETE behaviour_enrichment_property b where b.BEHAVIOUR_OPER_STAGE_ID = '||ln_beh_oper_stage_id2||';');
  dbms_output.put_line('DELETE FROM DOMAIN_VALUE_RANGES t where t.domain_id = '''||ln_domain_id1||''';');
  dbms_output.put_line('DELETE FROM DOMAIN_ELEMENTS t where t.domain_id = '''||ln_domain_id1||''';');
  dbms_output.put_line('DELETE FROM DOMAIN t where t.domain_id = '''||ln_domain_id1||''';');
  dbms_output.put_line('DELETE FROM CONDITION_PROPERTIES T WHERE T.CONDITION_ID = '''||ln_condition_id1||''';');
  dbms_output.put_line('DELETE FROM CONDITION t where t.condition_id = '''||ln_condition_id1||''';');
  dbms_output.put_line('delete behaviour_validations b where b.BEHAVIOUR_OPER_STAGE_ID = '||ln_beh_oper_stage_id2||';');

  dbms_output.Put_line('---------------INVOKE CONFIRMORDER--------------------------------------');
  dbms_output.Put_line('DELETE INVOKE_RESPONSE_EVALUATION T WHERE T.INVOKE_ID = '''||ln_invoke_id1||''';');
  dbms_output.put_line('DELETE INVOKE_MAPPING T WHERE T.INVOKE_ID = '''||ln_invoke_id1||''';');
  dbms_output.Put_line('DELETE EXTERNAL_RESOURCE_COMPONENTS T WHERE T.EXTERNAL_RESOURCE_ID = '''||ln_ext_res_id1||''';');
  dbms_output.Put_line('DELETE EXTERNAL_RESOURCES T WHERE T.EXTERNAL_RESOURCE_ID = '''||ln_ext_res_id1||''';');
--   dbms_output.Put_line('DELETE EXTERNAL_RESOURCE_GROUPS T WHERE T.EXTERNAL_RESOURCE_GROUP_ID = '''||ln_ext_res_group_id||''';');
  dbms_output.Put_line('DELETE INVOKE T WHERE T.INVOKE_ID = '''||ln_invoke_id1||''';');
  dbms_output.put_line('DELETE BEHAVIOUR_OPER_INVOKE b where b.BEHAVIOUR_OPER_STAGE_ID = '||ln_beh_oper_stage_id1||';');

  dbms_output.Put_line('---------------INVOKE MICROPERSISTOR--------------------------------------');
  dbms_output.Put_line('delete INVOKE_RESPONSE_EVALUATION T WHERE T.INVOKE_ID = '''||ln_invoke_id2||''';');
  dbms_output.put_line('delete INVOKE_MAPPING T WHERE T.INVOKE_ID = '''||ln_invoke_id2||''';');
  dbms_output.Put_line('delete EXTERNAL_RESOURCE_COMPONENTS T WHERE T.EXTERNAL_RESOURCE_ID = '''||ln_ext_res_id2||''';');
  dbms_output.Put_line('delete EXTERNAL_RESOURCES T WHERE T.EXTERNAL_RESOURCE_ID = '''||ln_ext_res_id2||''';');
  -- dbms_output.Put_line('delete EXTERNAL_RESOURCE_GROUPS T WHERE T.EXTERNAL_RESOURCE_GROUP_ID = '''||ln_ext_res_group_id||''';');
  dbms_output.Put_line('delete INVOKE T WHERE T.INVOKE_ID = '''||ln_invoke_id2||''';');

  dbms_output.Put_line('---------------INVOKE MICROEIS--------------------------------------');
  dbms_output.Put_line('delete INVOKE_RESPONSE_EVALUATION T WHERE T.INVOKE_ID = ''' || ln_invoke_id3 || ''';');
  dbms_output.put_line('delete INVOKE_MAPPING T WHERE T.INVOKE_ID = ''' || ln_invoke_id3 || ''';');
  dbms_output.Put_line('delete EXTERNAL_RESOURCE_COMPONENTS T WHERE T.EXTERNAL_RESOURCE_ID = ''' || ln_ext_res_id3 || ''';');
  dbms_output.Put_line('delete EXTERNAL_RESOURCES T WHERE T.EXTERNAL_RESOURCE_ID = ''' || ln_ext_res_id3 || ''';');
  -- dbms_output.Put_line('delete EXTERNAL_RESOURCE_GROUPS T WHERE T.EXTERNAL_RESOURCE_GROUP_ID = ''' || ln_ext_res_group_id || ''';');
  dbms_output.Put_line('delete INVOKE T WHERE T.INVOKE_ID = ''' || ln_invoke_id3 || ''';');

  dbms_output.Put_line('---------------REQUEST----------------------------------------------');
  dbms_output.Put_line('http://192.168.37.146:8101/quickWin/getActivateRequest');
  dbms_output.Put_line('---------------POST REST--------------------------------------');
  dbms_output.Put_line('{ 
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
        "operationId": "'||ln_operation_type_id1||'", 
        "processingMethod": "SY", 
        "compensationTransactionId": "XXXX" 
      }, 
      "securityInfo": { 
        "authorizationId": "12345" 
      } 
    }, 
    "body": { 
      "activationInfo": { 
        "expectedExecutionDate": "", "offerId": "'||ln_offer_id1||'", 
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
        "campaignId": "'||ln_campaign_id||'", 
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
        "unit": "", 
        "amount": "", 
        "sessionData": { 
          "externalSubscriberProperties": [ 
            {
              "id": "ACCOUNT_CODE",
              "value": [""]
            },
            {
              "id": "CUSTOMER_ID_CPM",
              "value": [""]
            },
            {
              "id": "SERVICE_NUMBER_CPM",
              "value": [""]
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
              "value":[""]
            },
            {
              "id":"IDENTIFICATION_NUMBER_CPM",
              "value":[""]
            },
            {
              "id":"BUSINESS_SERIAL_NUMBER",
              "value":[""]
            }
          ] 
        } 
      } 
    }  
  }');
  --chequear los erroes
END;

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    LV_ERROR := 'Configuracion QuickWin-Error: ' || SQLERRM || '.' || to_char(SQLCODE);
    RAISE LE_ERROR;
END;