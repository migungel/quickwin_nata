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

  ln_beh_oper_invoke_id1  NUMBER;
  ln_beh_oper_invoke_id2  NUMBER;
  ln_beh_oper_invoke_id3  NUMBER;
  ln_ext_res_group_id     NUMBER := 0;
  ln_ext_res_id1          NUMBER := 0;
  ln_ext_res_id2          NUMBER := 0;
  ln_ext_res_id3          NUMBER := 0;
  ln_invoke_id1           NUMBER := 0;
  ln_invoke_id2           NUMBER := 0;
  ln_invoke_id3           NUMBER := 0;
  ln_function_name        VARCHAR2(100) := 'calcularDiferenciaEnDias';
  ln_function_dom_id      NUMBER := 0;
  ln_function_id          NUMBER := 0;
  lv_def_func_id          VARCHAR(150) := 'EXECUTE_ANY_FUNCTION';
  ln_def_func_call_id     NUMBER := 0;
  ln_id_param             NUMBER := 0;
  ln_condition_id1        NUMBER := 0;
  ln_condition_id2        NUMBER := 0;
  ln_domain_id1           NUMBER := 0;
  ln_domain_id2           NUMBER := 0;
  ln_domain_value_range_id NUMBER := 0;
  ln_condition_property_id1 NUMBER := 0;
  ln_condition_property_id2 NUMBER := 0;
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

  SP_COMPANY                    VARCHAR2(60) := '$COMPANYID$';
  SP_EXTERNALOPERATION          VARCHAR2(60) := '$EXTERNALOPERATION$';
  SP_EXTERNALTRANSACTIONDATE    VARCHAR2(60) := '$EXTERNALTRANSACTIONDATE$';
  SP_MEDIAID                    VARCHAR2(60) := '$MEDIAID$';
  SP_CONSUMERID                 VARCHAR2(60) := '$CONSUMERID$';
  SP_EXTERNALTRANSACTIONID      VARCHAR2(60) := '$EXTERNALTRANSACTIONID$';
  SP_MEDIADETAILID              VARCHAR2(60) := '$MEDIADETAILID$';
  SP_TERMINAL                   VARCHAR2(60) := '$TERMINAL$';
  SP_LATITUDE                   VARCHAR2(60) := '$LATITUDE$';
  SP_LONGITUDE                  VARCHAR2(60) := '$LONGITUDE$';

  URI_QUERYACCOUNT    VARCHAR(200) := 'http://esbgold.integra.conecel.com/Customer/QueryAccount/V1.0';                  --'http://192.168.37.205:8001/Customer/QueryAccount/V1.0';
  URI_CREDITENGINE    VARCHAR(200) := 'http://esbgold.integra.conecel.com/Customer/CreditProfile/CreditRequest/V1.0';   --'http://192.168.37.205:8001/Rest/CreditEngine/CreditRequest/V1.0';
  URI_CHANGEACCOUNT   VARCHAR(200) := 'http://esbgold.integra.conecel.com/Customer/V2.0';                               --'http://192.168.37.205:8001/Customer/V1.0';

  LV_ERROR VARCHAR2(500);
  LE_ERROR EXCEPTION;

  REQUEST_CHANGEACCOUNT VARCHAR(32767) := '<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:xs="http://www.w3.org/2001/XMLSchema">
   <xsl:output method="xml" indent="yes" omit-xml-declaration="yes" />
   <xsl:template match="/">
      <soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope"
         xmlns:v1="http://claro.com.ec/osb/message/Customer/CustomerMessage/v1"
         xmlns:typ="http://claro.com.ec/CommonTypes/types"
         xmlns:v11="http://claro.com.ec/osb/bss/message/Customer/ChangeAccount/v1">
         <soap:Header />
         <soap:Body>
            <v1:ChangeAccountRequest>
               <typ:header>
                  <typ:channelId><xsl:value-of select="//_channelId"/></typ:channelId>
                  <typ:externalTransactionDate><xsl:value-of select="//_externalTransactionDate"/></typ:externalTransactionDate>
                  <typ:mediaId><xsl:value-of select="//_mediaId"/></typ:mediaId>
               </typ:header>
               <account>
                  <accountInformation>
                     <id><xsl:value-of select="//_accountId"/></id>
                     <code><xsl:value-of select="//_accountCode"/></code>
                     <email><xsl:value-of select="//_accountEmail"/></email>
                     <lastName><xsl:value-of select="//_lastName"/></lastName>
                     <secondLastName><xsl:value-of select="//_secondLastName"/></secondLastName>
                     <firstName><xsl:value-of select="//_firstName"/></firstName>
                     <fullName><xsl:value-of select="//_fullName"/></fullName>
                     <paymentType><xsl:value-of select="//_paymentType"/></paymentType>
                     <paymentMethod><xsl:value-of select="//_paymentMethod"/></paymentMethod>
                     <status><xsl:value-of select="//_status"/></status>
                     <statusTime><xsl:value-of select="//_statusTime"/></statusTime>
                     <initialBalance><xsl:value-of select="//_initialBalance"/></initialBalance>
                     <billLanguage><xsl:value-of select="//_billLanguage"/></billLanguage>
                     <billCycleType><xsl:value-of select="//_billCycleType"/></billCycleType>
                     <creditLimit>
                        <type><xsl:value-of select="//_creditLimitType"/></type>
                        <value><xsl:value-of select="//_creditLimitValue"/></value>
                     </creditLimit>
                     <billMedium>
                        <id><xsl:value-of select="//_billMediumId"/></id>
                        <type><xsl:value-of select="//_billMediumType"/></type>
                        <contentMode><xsl:value-of select="//_contentMode"/></contentMode>
                     </billMedium>
                     <autoPaymentChannel>
                        <id><xsl:value-of select="//_autoPaymentChannelId"/></id>
                        <bankCode><xsl:value-of select="//_bankCode"/></bankCode>
                        <paymentMode><xsl:value-of select="//_paymentMode"/></paymentMode>
                        <bankAccountType><xsl:value-of select="//_bankAccountType"/></bankAccountType>
                        <bankAccountName><xsl:value-of select="//_bankAccountName"/></bankAccountName>
                        <bankAccountNumber><xsl:value-of select="//_bankAccountNumber"/></bankAccountNumber>
                        <effectiveTime><xsl:value-of select="//_effectiveTime"/></effectiveTime>
                        <expiryTime><xsl:value-of select="//_expiryTime"/></expiryTime>
                        <paymentPlan>
                          <id><xsl:value-of select="//_payPlanId"/></id>
                          <type><xsl:value-of select="//_payPlanType"/></type>
                          <effectiveTime><xsl:value-of select="//_payPlanEffTime"/></effectiveTime>
                          <expiryTime><xsl:value-of select="//_payPlanExpTime"/></expiryTime>
                        </paymentPlan>
                        <priority></priority>
                     </autoPaymentChannel>
                     <property>
                        <id><xsl:value-of select="//_propertyId"/></id>
                        <value><xsl:value-of select="//_propertyValue"/></value>
                     </property>
                  </accountInformation>
                  <address>
                     <id><xsl:value-of select="//_addressId"/></id>
                     <formatedType><xsl:value-of select="//_formatedType"/></formatedType>
                     <postalCode></postalCode>
                     <addressInformation>
                        <formatedAddress>
                           <address1><xsl:value-of select="//_address1"/></address1>
                           <address2><xsl:value-of select="//_address2"/></address2>
                           <address3><xsl:value-of select="//_address3"/></address3>
                           <address4><xsl:value-of select="//_address4"/></address4>
                           <address6><xsl:value-of select="//_address6"/></address6>
                           <address9><xsl:value-of select="//_address9"/></address9>
                           <address10><xsl:value-of select="//_address10"/></address10>
                           <address12><xsl:value-of select="//_address12"/></address12>
                        </formatedAddress>
                     </addressInformation>
                  </address>
               </account>
            </v1:ChangeAccountRequest>
         </soap:Body>
      </soap:Envelope>
   </xsl:template>
</xsl:stylesheet>';

BEGIN
  BEGIN

  -- RESOURCE GROUP
  SELECT Nvl(Max(E.EXTERNAL_RESOURCE_GROUP_ID),0) + 1 INTO ln_ext_res_group_id FROM EXTERNAL_RESOURCE_GROUPS E;
  INSERT INTO EXTERNAL_RESOURCE_GROUPS (EXTERNAL_RESOURCE_GROUP_ID, DESCRIPTION)
  VALUES(ln_ext_res_group_id,lv_desc_camp||lv_description);

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


  -- EXTERNAL RESOURCE
  SELECT Nvl(Max(E.external_resource_id),0)+1 INTO ln_ext_res_id1 FROM external_resources E;
  insert into external_resources (external_resource_id,external_resource_group_id,operation_name_description,resource_description,request_pattern_xslt,timeout,status,ext_res_type,request_method,content_type,data_type)
  values (ln_ext_res_id1,ln_ext_res_group_id,lv_desc_camp||'Consulta Fecha Cambio Forma Pago',lv_desc_camp||'Consulta Fecha Cambio Forma Pago','<xsl:stylesheet
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:fn="http://www.w3.org/2005/xpath-functions"
   xmlns:xs="http://www.w3.org/2001/XMLSchema" version="1.0">
   <xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
   <xsl:template match="/">
      <soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope"
         xmlns:v1="http://claro.com.ec/osb/message/Customer/QueryAccountMessage/v1"
         xmlns:typ="http://claro.com.ec/CommonTypes/types">
         <soap:Header/>
         <soap:Body>
            <v1:QueryAccountRequest>
               <typ:header>
                  <typ:channelId><xsl:value-of select="//_channelId"/></typ:channelId>
                  <typ:companyId><xsl:value-of select="//_companyId"/></typ:companyId>
                  <typ:consumerId><xsl:value-of select="//_consumerId"/></typ:consumerId>
                  <typ:consumerProfileId></typ:consumerProfileId>
                  <typ:externalOperation><xsl:value-of select="//_externalOperation"/></typ:externalOperation>
                  <typ:externalTransactionDate><xsl:value-of select="//_externalTransactionDate"/></typ:externalTransactionDate>
                  <typ:externalTransactionId><xsl:value-of select="//_externalTransactionId"/></typ:externalTransactionId>
                  <typ:internalTransactionId></typ:internalTransactionId>
                  <typ:mediaDetailId><xsl:value-of select="//_mediaDetailId"/></typ:mediaDetailId>
                  <typ:mediaId><xsl:value-of select="//_mediaId"/></typ:mediaId>
                  <typ:password></typ:password>
                  <typ:terminal><xsl:value-of select="//_terminal"/></typ:terminal>
                  <typ:token></typ:token>
                  <typ:userId></typ:userId>
                  <typ:username></typ:username>
                  <typ:stackTrace>0</typ:stackTrace>
                  <typ:geoReferenceInfo>
                     <typ:latitude><xsl:value-of select="//_latitude"/></typ:latitude>
                     <typ:longitude><xsl:value-of select="//_longitude"/></typ:longitude>
                     <typ:azimuth>0.0</typ:azimuth>
                     <typ:cellId>0.0</typ:cellId>
                  </typ:geoReferenceInfo>
               </typ:header>
               <typ:additionalFields>
                  <typ:additionalField>
                     <typ:byteValue></typ:byteValue>
                     <typ:dataType></typ:dataType>
                     <typ:encrypted>false</typ:encrypted>
                     <typ:id></typ:id>
                     <typ:multirecords>
                        <typ:multirecord>
                           <typ:record/>
                        </typ:multirecord>
                     </typ:multirecords>
                     <typ:orderable>false</typ:orderable>
                     <typ:searchable>false</typ:searchable>
                     <typ:value></typ:value>
                  </typ:additionalField>
               </typ:additionalFields>
               <v1:customerId><xsl:value-of select="//_customerId"/></v1:customerId>
               <v1:serviceNumber><xsl:value-of select="//_serviceNumber"/></v1:serviceNumber>
               <v1:accountCode><xsl:value-of select="//_accountCode"/></v1:accountCode>
            </v1:QueryAccountRequest>
         </soap:Body>
      </soap:Envelope>
   </xsl:template>
</xsl:stylesheet>',10000,'A','SOAP','POST','text/xml','xml');

  SELECT Nvl(Max(E.external_resource_id),0)+1 INTO ln_ext_res_id2 FROM external_resources E;
  INSERT INTO external_resources (external_resource_id,external_resource_group_id,operation_name_description,resource_description,request_pattern_xslt,timeout,status,ext_res_type,request_method,content_type,data_type)
  VALUES (ln_ext_res_id2,ln_ext_res_group_id,lv_desc_camp||'Consulta Motor de Credito',lv_desc_camp||'Consulta Motor de Credito',
    '<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema">
<xsl:output method="text" indent="yes" media-type="text/json" omit-xml-declaration="yes"/> 
<xsl:template match="/">
{
<xsl:for-each select="//params">   
   "header": {
	  "channelId": "<xsl:value-of select="//_channelid"/>",
	  "companyId": "<xsl:value-of select="//_companyId"/>",
	  "externalOperation": "<xsl:value-of select="//_externalOperation"/>",
	  "externalTransactionDate": "<xsl:value-of select="//_externalTransactionDate"/>",
	  "externalTransactionId": "<xsl:value-of select="//_externalTransactionId"/>",
	  "password": "Zbc1234%",
	  "terminal": "10.57.79.96",
	  "username": "hwbss",
	  "stackTrace": "0"
   },
   "businessCode": "ModifyAccountInfo",
   "businessSerialNo": "<xsl:value-of select="//_businessSerialNo"/>",
   "customerId": "<xsl:value-of select="//_customerId"/>",
   "identificationType": "<xsl:value-of select="//_identificationType"/>",
   "identificationNumber": "<xsl:value-of select="//_identificationNumber"/>",
   "names": "<xsl:value-of select="//_fullName"/>",
   "segundaRespuesta": "-2",
   "lastName": "<xsl:value-of select="//_lastName"/>",
   "secondLastName": "<xsl:value-of select="//_secondLastName"/>",
   "birthday": "",
   "marriedStatus": "",
   "sex": "",
   "gender": "",
   "level": "",
   "segment": "",
   "accountId": "<xsl:value-of select="//_accountID"/>",
   "billCycle": "<xsl:value-of select="//_billCycle"/>",
   "guarantyFlag": "0",
   "bankCode": "<xsl:value-of select="//_bankCode"/>",
   "paymentMethodType": "<xsl:value-of select="//_paymentMethodType"/>",
   "accountType": "<xsl:value-of select="//_accountType"/>",
   "bankAccountNumber": "<xsl:value-of select="//_bankAccountNumber"/>",
   "cardNumber": "<xsl:value-of select="//_bankAccountNumber"/>",
   "ownFullName": "middleNameTest",
   "totalAmount": "0",
   "employeeId": "-1",
   "employeeCode": "-1",
   "userName": "OSB",
   "orgId": "201805150512000011",
   "region": "101001",
   "serviceNumber": "<xsl:value-of select="//_serviceNumber"/>"
</xsl:for-each>
}
</xsl:template>
</xsl:stylesheet>',30000,'A','REST','POST','application/json','json');

  SELECT Nvl(Max(E.external_resource_id),0)+1 INTO ln_ext_res_id3 FROM external_resources E;
  INSERT INTO external_resources (external_resource_id,external_resource_group_id,operation_name_description,resource_description,request_pattern_xslt,timeout,status,ext_res_type,request_method,content_type,data_type)
  VALUES (ln_ext_res_id3,ln_ext_res_group_id,lv_desc_camp||'Consulta Cambio Forma Pago',lv_desc_camp||'Consulta Cambio Forma Pago',
  REQUEST_CHANGEACCOUNT,10000,'A','SOAP','POST','text/xml','xml');

  -- EXTERNAL RESOURCE COMPONENTS
  INSERT INTO external_resource_components (external_resource_component_id,external_resource_id,endpoint_url,short_description,routing_type,order_by,weight)
  VALUES ((SELECT Nvl(Max(EC.external_resource_component_id),0)+1 FROM external_resource_components EC),
  ln_ext_res_id1,URI_QUERYACCOUNT,lv_desc_camp||'Invoke para obtener la informacion del cliente','B',10,100);

  INSERT INTO external_resource_components (external_resource_component_id,external_resource_id,endpoint_url,short_description,routing_type,order_by,weight)
  VALUES ((SELECT Nvl(Max(EC.external_resource_component_id),0)+1 FROM external_resource_components EC),
  ln_ext_res_id2,URI_CREDITENGINE,lv_desc_camp||'Invoke para motor de credito','B',10,100);

  INSERT INTO external_resource_components (external_resource_component_id,external_resource_id,endpoint_url,short_description,routing_type,order_by,weight)
  VALUES ((SELECT Nvl(Max(EC.external_resource_component_id),0)+1 FROM external_resource_components EC),
  ln_ext_res_id3,URI_CHANGEACCOUNT,lv_desc_camp||'Invoke para Cambio Forma Pago','B',10,100);

  -- INVOKE
  SELECT Nvl(Max(I.invoke_id),0)+1 INTO ln_invoke_id1 FROM invoke I;
  INSERT INTO invoke (invoke_id,external_resource_id,operation_name_description,description,status,retries,time_between_retries)
  VALUES (ln_invoke_id1,ln_ext_res_id1,lv_desc_camp||'Obtener informacion del cliente',lv_desc_camp||'Obtener informacion del cliente','A',0,1000);

  SELECT Nvl(Max(I.invoke_id),0)+1 INTO ln_invoke_id2 FROM invoke I;
  INSERT INTO invoke(invoke_id,external_resource_id,operation_name_description,description,status,retries,time_between_retries)
  VALUES (ln_invoke_id2,ln_ext_res_id2,lv_desc_camp||'Consulta Motor de Credito',lv_desc_camp||'Consulta Motor de Credito','A',0,1000);

  SELECT Nvl(Max(I.invoke_id),0)+1 INTO ln_invoke_id3 FROM invoke I;
  INSERT INTO invoke (invoke_id,external_resource_id,operation_name_description,description,status,retries,time_between_retries)
  VALUES (ln_invoke_id3,ln_ext_res_id3,lv_desc_camp||'Cambio Forma Pago',lv_desc_camp||'Cambio Forma Pago','A',0,1000);

  -- MAPPING QUERYACCOUNT
  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id1,'SP',SP_ACCOUNT_CODE,'','','=>','','','_accountCode',lv_desc_camp||'Code Account','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id1,'SP',SP_CHANNELID,'','','=>','','','_channelId',lv_desc_camp||'Id del canal','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id1,'SP',SP_COMPANY,'','','=>','','','_companyId',lv_desc_camp||'Id de la compania','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id1,'SP',SP_CONSUMERID,'','','=>','','','_consumerId',lv_desc_camp||'Consumer ID','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id1,'SP',SP_EXTERNALOPERATION,'','','=>','','','_externalOperation',lv_desc_camp||'Operacion externa','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id1,'SP',SP_EXTERNALTRANSACTIONDATE,'','','=>','','','_externalTransactionDate',lv_desc_camp||'Fecha de transaccion externa','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id1,'SP',SP_EXTERNALTRANSACTIONID,'','','=>','','','_externalTransactionId',lv_desc_camp||'ID de transaccion externa','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id1,'SP',SP_MEDIADETAILID,'','','=>','','','_mediaDetailId',lv_desc_camp||'Media Detail Id','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id1,'SP',SP_MEDIAID,'','','=>','','','_mediaId',lv_desc_camp||'Media Id','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id1,'SP',SP_TERMINAL,'','','=>','','','_terminal',lv_desc_camp||'Terminal','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id1,'SP',SP_LATITUDE,'','','=>','','','_latitude',lv_desc_camp||'Latitud','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id1,'SP',SP_LONGITUDE,'','','=>','','','_longitude',lv_desc_camp||'Longitud','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id1,'SP',SP_CUSTOMER_ID_CPM,'','','=>','','','_customerId',lv_desc_camp||'ID de cliente','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id1,'SP',SP_SERVICE_NUMBER_CPM,'','','=>','','','_serviceNumber',lv_desc_camp||'Numero de servicio','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id1,'SP',SP_DATE_LAST_CHANGE,'','','<=','','//*[local-name()="Account"]/*[local-name()="account"]/*[local-name()="accountInformation"]/*[local-name()="PaymentChannel"]/*[local-name()="effectiveTime"]/text()','',lv_desc_camp||'DateLastChange CPM','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id1,'SP',SP_ACCOUNT_ID,'','','<=','','//*[local-name()="Account"]/*[local-name()="account"]/*[local-name()="accountInformation"]/*[local-name()="id"]/text()','',lv_desc_camp||'ID de la cuenta de usuario','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id1,'SP',SP_ACCINF_SMSNO,'','','<=','','//*[local-name()="Account"]/*[local-name()="account"]/*[local-name()="accountInformation"]/*[local-name()="smsNo"]/text()','',lv_desc_camp||'Numero SMS de la cuenta de usuario','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id1,'SP',SP_ACCINF_EMAIL,'','','<=','','//*[local-name()="Account"]/*[local-name()="account"]/*[local-name()="accountInformation"]/*[local-name()="email"]/text()','',lv_desc_camp||'Email de la cuenta de usuario','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id1,'SP',SP_ACCINF_LASTNAME,'','','<=','','//*[local-name()="Account"]/*[local-name()="account"]/*[local-name()="accountInformation"]/*[local-name()="lastName"]/text()','',lv_desc_camp||'Apellido de la cuenta de usuario','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id1,'SP',SP_ACCINF_SECONDLASTNAME,'','','<=','','//*[local-name()="Account"]/*[local-name()="account"]/*[local-name()="accountInformation"]/*[local-name()="secondLastName"]/text()','',lv_desc_camp||'Segundo apellido de la cuenta de usuario','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id1,'SP',SP_ACCINF_FIRSTNAME,'','','<=','','//*[local-name()="Account"]/*[local-name()="account"]/*[local-name()="accountInformation"]/*[local-name()="firstName"]/text()','',lv_desc_camp||'Primer nombre de la cuenta de usuario','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id1,'SP',SP_ACCINF_FULLNAME,'','','<=','','//*[local-name()="Account"]/*[local-name()="account"]/*[local-name()="accountInformation"]/*[local-name()="fullName"]/text()','',lv_desc_camp||'Nombre completo de la cuenta de usuario','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id1,'SP',SP_ACCINF_PAYTYPE,'','','<=','','//*[local-name()="Account"]/*[local-name()="account"]/*[local-name()="accountInformation"]/*[local-name()="paymentType"]/text()','',lv_desc_camp||'Tipo de pago','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id1,'SP',SP_ACCINF_PAYMETHOD,'','','<=','','//*[local-name()="Account"]/*[local-name()="account"]/*[local-name()="accountInformation"]/*[local-name()="paymentMethod"]/text()','',lv_desc_camp||'Metodo de pago','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id1,'SP',SP_ACCINF_STATUS,'','','<=','','//*[local-name()="Account"]/*[local-name()="account"]/*[local-name()="accountInformation"]/*[local-name()="status"]/text()','',lv_desc_camp||'Estado de la cuenta de usuario','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id1,'SP',SP_ACCINF_STATUSTIME,'','','<=','','//*[local-name()="Account"]/*[local-name()="account"]/*[local-name()="accountInformation"]/*[local-name()="statusTime"]/text()','',lv_desc_camp||'Fecha de la modificacion del estado','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id1,'SP',SP_ACCINF_INITIALBALANCE,'','','<=','','//*[local-name()="Account"]/*[local-name()="account"]/*[local-name()="accountInformation"]/*[local-name()="initialBalance"]/text()','',lv_desc_camp||'Saldo inicial de la cuenta de usuario','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id1,'SP',SP_ACCINF_BILLLANGUAGE,'','','<=','','//*[local-name()="Account"]/*[local-name()="account"]/*[local-name()="accountInformation"]/*[local-name()="billLanguage"]/text()','',lv_desc_camp||'Idioma de la factura de la cuenta de usuario','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id1,'SP',SP_ACCINF_BILLCYCLETYPE,'','','<=','','//*[local-name()="Account"]/*[local-name()="account"]/*[local-name()="accountInformation"]/*[local-name()="billCycleType"]/text()','',lv_desc_camp||'Tipo de ciclo de la cuenta de usuario','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id1,'SP',SP_ACCINF_CREDITLIMITTYPE,'','','<=','','//*[local-name()="Account"]/*[local-name()="account"]/*[local-name()="accountInformation"]/*[local-name()="creditLimit"]/*[local-name()="type"]/text()','',lv_desc_camp||'Codigo de limite de credito de la cuenta de usuario','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id1,'SP',SP_ACCINF_CREDITLIMITVALUE,'','','<=','','//*[local-name()="Account"]/*[local-name()="account"]/*[local-name()="accountInformation"]/*[local-name()="creditLimit"]/*[local-name()="value"]/text()','',lv_desc_camp||'Valor limite de credito','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id1,'SP',SP_ACCINF_BILL_ID,'','','<=','','//*[local-name()="Account"]/*[local-name()="account"]/*[local-name()="accountInformation"]/*[local-name()="billMedium"]/*[local-name()="id"]/text()','',lv_desc_camp||'ID del medio de factura','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id1,'SP',SP_ACCINF_BILL_TYPE,'','','<=','','//*[local-name()="Account"]/*[local-name()="account"]/*[local-name()="accountInformation"]/*[local-name()="billMedium"]/*[local-name()="type"]/text()','',lv_desc_camp||'Tipo de medio de factura','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id1,'SP',SP_ACCINF_BILL_CONTENTMODE,'','','<=','','//*[local-name()="Account"]/*[local-name()="account"]/*[local-name()="accountInformation"]/*[local-name()="billMedium"]/*[local-name()="contentMode"]/text()','',lv_desc_camp||'Tipo de contenido','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id1,'SP',SP_ACCINF_PROPERTY_ID,'','','<=','','//*[local-name()="Account"]/*[local-name()="account"]/*[local-name()="accountInformation"]/*[local-name()="property"]/*[local-name()="id"]/text()','',lv_desc_camp||'Identificador de propiedad','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id1,'SP',SP_ACCINF_PROPERTY_VALUE,'','','<=','','//*[local-name()="Account"]/*[local-name()="account"]/*[local-name()="accountInformation"]/*[local-name()="property"]/*[local-name()="value"]/text()','',lv_desc_camp||'Valor de la propiedad','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id1,'SP',SP_ACCINF_PAYCHANNEL_ID,'','','<=','','//*[local-name()="Account"]/*[local-name()="account"]/*[local-name()="accountInformation"]/*[local-name()="PaymentChannel"]/*[local-name()="id"]/text()','',lv_desc_camp||'ID del canal de pago','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id1,'SP',SP_ACCINF_PAYMODE,'','','<=','','//*[local-name()="Account"]/*[local-name()="account"]/*[local-name()="accountInformation"]/*[local-name()="PaymentChannel"]/*[local-name()="paymentMode"]/text()','',lv_desc_camp||'Codigo de metodo de pago','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id1,'SP',SP_ACCINF_BANKACCNAME,'','','<=','','//*[local-name()="Account"]/*[local-name()="account"]/*[local-name()="accountInformation"]/*[local-name()="PaymentChannel"]/*[local-name()="bankAccountName"]/text()','',lv_desc_camp||'Nombre de la cuenta de banco','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id1,'SP',SP_ACCINF_EFFECTIVETIME,'','','<=','','//*[local-name()="Account"]/*[local-name()="account"]/*[local-name()="accountInformation"]/*[local-name()="PaymentChannel"]/*[local-name()="effectiveTime"]/text()','',lv_desc_camp||'Tiempo efectivo','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id1,'SP',SP_ACCINF_EXPIRYTIME,'','','<=','','//*[local-name()="Account"]/*[local-name()="account"]/*[local-name()="accountInformation"]/*[local-name()="PaymentChannel"]/*[local-name()="expiryTime"]/text()','',lv_desc_camp||'Tiempo de expiracion','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id1,'SP',SP_ACCINF_PAYPLAN_ID,'','','<=','','//*[local-name()="Account"]/*[local-name()="account"]/*[local-name()="accountInformation"]/*[local-name()="PaymentChannel"]/*[local-name()="paymentPlan"]/*[local-name()="id"]/text()','',lv_desc_camp||'ID plan de pago','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id1,'SP',SP_ACCINF_PAYPLAN_TYPE,'','','<=','','//*[local-name()="Account"]/*[local-name()="account"]/*[local-name()="accountInformation"]/*[local-name()="PaymentChannel"]/*[local-name()="paymentPlan"]/*[local-name()="type"]/text()','',lv_desc_camp||'Tipo de plan de pago','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id1,'SP',SP_ACCINF_PAYPLAN_EFFTIME,'','','<=','','//*[local-name()="Account"]/*[local-name()="account"]/*[local-name()="accountInformation"]/*[local-name()="PaymentChannel"]/*[local-name()="paymentPlan"]/*[local-name()="effectiveTime"]/text()','',lv_desc_camp||'Tiempo efectivo plan de pago','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id1,'SP',SP_ACCINF_PAYPLAN_EXPTIME,'','','<=','','//*[local-name()="Account"]/*[local-name()="account"]/*[local-name()="accountInformation"]/*[local-name()="PaymentChannel"]/*[local-name()="paymentPlan"]/*[local-name()="effectiveTime"]/text()','',lv_desc_camp||'Tiempo expiracion plan de pago','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id1,'SP',SP_ACC_ADDRESS_ID,'','','<=','','//*[local-name()="Account"]/*[local-name()="address"]/*[local-name()="id"]/text()','',lv_desc_camp||'ID direccion de usuario','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id1,'SP',SP_ACC_ADDRESS_FORMATEDTYPE,'','','<=','','//*[local-name()="Account"]/*[local-name()="address"]/*[local-name()="formatedType"]/text()','',lv_desc_camp||'Direccion tipo de formato','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id1,'SP',SP_ACC_ADDRESS_1,'','','<=','','//*[local-name()="Account"]/*[local-name()="address"]/*[local-name()="addressInformation"]/*[local-name()="addressInformation"]/*[local-name()="formatedAddress"]/*[local-name()="address1"]/text()','',lv_desc_camp||'Direccion 1 del usuario','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id1,'SP',SP_ACC_ADDRESS_2,'','','<=','','//*[local-name()="Account"]/*[local-name()="address"]/*[local-name()="addressInformation"]/*[local-name()="addressInformation"]/*[local-name()="formatedAddress"]/*[local-name()="address2"]/text()','',lv_desc_camp||'Direccion 2 del usuario','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id1,'SP',SP_ACC_ADDRESS_3,'','','<=','','//*[local-name()="Account"]/*[local-name()="address"]/*[local-name()="addressInformation"]/*[local-name()="addressInformation"]/*[local-name()="formatedAddress"]/*[local-name()="address3"]/text()','',lv_desc_camp||'Direccion 3 del usuario','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id1,'SP',SP_ACC_ADDRESS_4,'','','<=','','//*[local-name()="Account"]/*[local-name()="address"]/*[local-name()="addressInformation"]/*[local-name()="addressInformation"]/*[local-name()="formatedAddress"]/*[local-name()="address4"]/text()','',lv_desc_camp||'Direccion 4 del usuario','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id1,'SP',SP_ACC_ADDRESS_6,'','','<=','','//*[local-name()="Account"]/*[local-name()="address"]/*[local-name()="addressInformation"]/*[local-name()="addressInformation"]/*[local-name()="formatedAddress"]/*[local-name()="address6"]/text()','',lv_desc_camp||'Direccion 6 del usuario','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id1,'SP',SP_ACC_ADDRESS_9,'','','<=','','//*[local-name()="Account"]/*[local-name()="address"]/*[local-name()="addressInformation"]/*[local-name()="addressInformation"]/*[local-name()="formatedAddress"]/*[local-name()="address9"]/text()','',lv_desc_camp||'Direccion 9 del usuario','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id1,'SP',SP_ACC_ADDRESS_10,'','','<=','','//*[local-name()="Account"]/*[local-name()="address"]/*[local-name()="addressInformation"]/*[local-name()="addressInformation"]/*[local-name()="formatedAddress"]/*[local-name()="address10"]/text()','',lv_desc_camp||'Direccion 10 del usuario','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id1,'SP',SP_ACC_ADDRESS_12,'','','<=','','//*[local-name()="Account"]/*[local-name()="address"]/*[local-name()="addressInformation"]/*[local-name()="addressInformation"]/*[local-name()="formatedAddress"]/*[local-name()="address12"]/text()','',lv_desc_camp||'Direccion 12 del usuario','A');

  -- MAPPING CREDITENGINE
  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id2,'SP',SP_CUSTOMER_ID_CPM,'','','=>','','','_customerId',lv_desc_camp||'Customer ID','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id2,'SP',SP_BANK_CODE_CPM,'','','=>','','','_bankCode',lv_desc_camp||'BANK CODE','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id2,'SP',SP_PAYMENT_METHOD_TYPE_CPM,'','','=>','','','_paymentMethodType',lv_desc_camp||'METODO PAGO','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id2,'SP',SP_ACCOUNT_TYPE_CPM,'','','=>','','','_accountType',lv_desc_camp||'TIPO DE CUENTA','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id2,'SP',SP_BANK_ACCOUNT_NUMBER_CPM,'','','=>','','','_bankAccountNumber',lv_desc_camp||'NUMERO CUENTA','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id2,'SP',SP_SERVICE_NUMBER_CPM,'','','=>','','','_serviceNumber',lv_desc_camp||'NUMERO SERVICIO','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id2,'SP',SP_CHANNELID,'','','=>','','','_channelid',lv_desc_camp||'ID del canal','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id2,'SP',SP_COMPANY,'','','=>','','','_companyId',lv_desc_camp||'ID de la compania','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id2,'SP',SP_EXTERNALOPERATION,'','','=>','','','_externalOperation',lv_desc_camp||'Operacion externa','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id2,'SP',SP_EXTERNALTRANSACTIONDATE,'','','=>','','','_externalTransactionDate',lv_desc_camp||'Fecha de trasaccion externa','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id2,'SP',SP_EXTERNALTRANSACTIONID,'','','=>','','','_externalTransactionId',lv_desc_camp||'ID de transacción externa','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id2,'SP',SP_BUSINESS_SERIAL_NUMBER,'','','=>','','','_businessSerialNo',lv_desc_camp||'Codigo unico de orden de transaccion','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id2,'SP',SP_IDENTIFICATION_TYPE_CPM,'','','=>','','','_identificationType',lv_desc_camp||'Tipo de identificacion','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id2,'SP',SP_IDENTIFICATION_NUMBER_CPM,'','','=>','','','_identificationNumber',lv_desc_camp||'Numero de identificacion','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id2,'SP',SP_ACCINF_FULLNAME,'','','=>','','','_fullName',lv_desc_camp||'Nombre completo del usuario','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id2,'SP',SP_ACCINF_LASTNAME,'','','=>','','','_lastName',lv_desc_camp||'Apellido del usuario','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id2,'SP',SP_ACCINF_SECONDLASTNAME,'','','=>','','','_secondLastName',lv_desc_camp||'Segundo apellido del usuario','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id2,'SP',SP_ACCOUNT_ID,'','','=>','','','_accountID',lv_desc_camp||'Id de la cuenta de usuario','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id2,'SP',SP_ACCINF_BILLCYCLETYPE,'','','=>','','','_billCycle',lv_desc_camp||'Ciclo de factura','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id2,'SP',SP_CODE_CREDIT_ENGINE_CPM,'','','<=','','$.code','',lv_desc_camp||'Codigo de respuesta del motor de credito','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id2,'SP',SP_RESP_MESSAGE,'','','<=','','$.messageDescription','',lv_desc_camp||'Mensaje de respuesta del motor de credito','A');

  -- MAPPING CHANGEACCOUNT
  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id3,'SP',SP_CHANNELID,'','','=>','','','_channelId',lv_desc_camp||'CANAL DE ORIGEN','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id3,'SP',SP_EXTERNALTRANSACTIONDATE,'','','=>','','','_externalTransactionDate',lv_desc_camp||'Fecha de transaccion externa','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id3,'SP',SP_MEDIAID,'','','=>','','','_mediaId',lv_desc_camp||'Media Id','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id3,'SP',SP_BANK_ACCOUNT_NUMBER_CPM,'','','=>','','','_bankAccountNumber',lv_desc_camp||'NUMERO CUENTA','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id3,'SP',SP_BANK_CODE_CPM,'','','=>','','','_bankCode',lv_desc_camp||'BANK CODE','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id3,'SP',SP_ACCOUNT_ID,'','','=>','','','_accountId',lv_desc_camp||'ID de cuenta','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id3,'SP',SP_ACCOUNT_CODE,'','','=>','','','_accountCode',lv_desc_camp||'Codigo de cuenta','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id3,'SP',SP_ACCINF_EMAIL,'','','=>','','','_accountEmail',lv_desc_camp||'Correo del accountInformation','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id3,'SP',SP_ACCINF_LASTNAME,'','','=>','','','_lastName',lv_desc_camp||'Apellido de la cuenta de usuario','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id3,'SP',SP_ACCINF_SECONDLASTNAME,'','','=>','','','_secondLastName',lv_desc_camp||'Segundo apellido de la cuenta de usuario','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id3,'SP',SP_ACCINF_FIRSTNAME,'','','=>','','','_firstName',lv_desc_camp||'Primer nombre de la cuenta de usuario','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id3,'SP',SP_ACCINF_FULLNAME,'','','=>','','','_fullName',lv_desc_camp||'Nombre completo de la cuenta de usuario','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id3,'SP',SP_ACCINF_PAYTYPE,'','','=>','','','_paymentType',lv_desc_camp||'Tipo de pago','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id3,'SP',SP_ACCINF_PAYMETHOD,'','','=>','','','_paymentMethod',lv_desc_camp||'Metodo de pago','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id3,'SP',SP_ACCINF_STATUS,'','','=>','','','_status',lv_desc_camp||'Estado de la cuenta de usuario','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id3,'SP',SP_ACCINF_STATUSTIME,'','','=>','','','_statusTime',lv_desc_camp||'Tiempo de estado de la cuenta de usuario','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id3,'SP',SP_ACCINF_INITIALBALANCE,'','','=>','','','_initialBalance',lv_desc_camp||'Saldo inicial de la cuenta de usuario','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id3,'SP',SP_ACCINF_BILLLANGUAGE,'','','=>','','','_billLanguage',lv_desc_camp||'Idioma de la factura de la cuenta de usuario','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id3,'SP',SP_ACCINF_BILLCYCLETYPE,'','','=>','','','_billCycleType',lv_desc_camp||'Tipo de ciclo de la cuenta de usuario','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id3,'SP',SP_ACCINF_CREDITLIMITTYPE,'','','=>','','','_creditLimitType',lv_desc_camp||'Codigo de limite de credito de la cuenta de usuario','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id3,'SP',SP_ACCINF_CREDITLIMITVALUE,'','','=>','','','_creditLimitValue',lv_desc_camp||'Valor limite de credito','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id3,'SP',SP_ACCINF_BILL_ID,'','','=>','','','_billMediumId',lv_desc_camp||'ID del medio de factura','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id3,'SP',SP_ACCINF_BILL_TYPE,'','','=>','','','_billMediumType',lv_desc_camp||'Tipo de medio de factura','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id3,'SP',SP_ACCINF_BILL_CONTENTMODE,'','','=>','','','_contentMode',lv_desc_camp||'Tipo de contenido','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id3,'SP',SP_ACCINF_PROPERTY_ID,'','','=>','','','_propertyId',lv_desc_camp||'Identificador de propiedad','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id3,'SP',SP_ACCINF_PROPERTY_VALUE,'','','=>','','','_propertyValue',lv_desc_camp||'Valor de la propiedad','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id3,'SP',SP_ACCINF_PAYCHANNEL_ID,'','','=>','','','_autoPaymentChannelId',lv_desc_camp||'ID del canal de pago','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id3,'SP',SP_ACCINF_PAYMODE,'','','=>','','','_paymentMode',lv_desc_camp||'Codigo de metodo de pago','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id3,'SP',SP_ACCOUNT_TYPE_CPM,'','','=>','','','_bankAccountType',lv_desc_camp||'Tipo de cuenta','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id3,'SP',SP_ACCINF_BANKACCNAME,'','','=>','','','_bankAccountName',lv_desc_camp||'Nombre de la cuenta de banco','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id3,'SP',SP_ACCINF_EFFECTIVETIME,'','','=>','','','_effectiveTime',lv_desc_camp||'Tiempo efectivo','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id3,'SP',SP_ACCINF_EXPIRYTIME,'','','=>','','','_expiryTime',lv_desc_camp||'Tiempo de expiracion','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id3,'SP',SP_ACCINF_PAYPLAN_ID,'','','=>','','','_payPlanId',lv_desc_camp||'ID plan de pago','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id3,'SP',SP_ACCINF_PAYPLAN_TYPE,'','','=>','','','_payPlanType',lv_desc_camp||'Tipo de plan de pago','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id3,'SP',SP_ACCINF_PAYPLAN_EFFTIME,'','','=>','','','_payPlanEffTime',lv_desc_camp||'Tiempo efectivo plan de pago','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id3,'SP',SP_ACCINF_PAYPLAN_EXPTIME,'','','=>','','','_payPlanExpTime',lv_desc_camp||'Tiempo expiracion plan de pago','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id3,'SP',SP_ACC_ADDRESS_ID,'','','=>','','','_addressId',lv_desc_camp||'ID direccion de usuario','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id3,'SP',SP_ACC_ADDRESS_FORMATEDTYPE,'','','=>','','','_formatedType',lv_desc_camp||'Direccion tipo de formato','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id3,'SP',SP_ACC_ADDRESS_1,'','','=>','','','_address1',lv_desc_camp||'Direccion 1 del usuario','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id3,'SP',SP_ACC_ADDRESS_2,'','','=>','','','_address2',lv_desc_camp||'Direccion 2 del usuario','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id3,'SP',SP_ACC_ADDRESS_3,'','','=>','','','_address3',lv_desc_camp||'Direccion 3 del usuario','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id3,'SP',SP_ACC_ADDRESS_4,'','','=>','','','_address4',lv_desc_camp||'Direccion 4 del usuario','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id3,'SP',SP_ACC_ADDRESS_6,'','','=>','','','_address6',lv_desc_camp||'Direccion 6 del usuario','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id3,'SP',SP_ACC_ADDRESS_9,'','','=>','','','_address9',lv_desc_camp||'Direccion 9 del usuario','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id3,'SP',SP_ACC_ADDRESS_10,'','','=>','','','_address10',lv_desc_camp||'Direccion 10 del usuario','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id3,'SP',SP_ACC_ADDRESS_12,'','','=>','','','_address12',lv_desc_camp||'Direccion 12 del usuario','A');

  INSERT INTO invoke_mapping (invoke_mapping_id,invoke_id,attribute_type,subscriber_property_id,function_id,fixed_value,way,xpath_to_xml_string,xpath,label,description,status)
  VALUES ((SELECT Nvl(Max(im.invoke_mapping_id),0)+1 FROM invoke_mapping im),ln_invoke_id3,'SP',SP_RESP_MESSAGE,'','','<=','','//*[local-name()="response"]/*[local-name()="resultDescription"]/text()','',lv_desc_camp||'Mensaje de respuesta de Change Account','A');

  --RESPONSE EVALUATION
  INSERT INTO invoke_response_evaluation (invoke_response_evaluation_id,invoke_id,order_by,xpath,evaluation_type,expected_value,value_type,evaluation_operator,success,failure_message,status)
  VALUES ((SELECT Nvl(Max(IR.invoke_response_evaluation_id),0)+1 FROM invoke_response_evaluation IR),ln_invoke_id1,10,'//*[local-name()="Account"]/*[local-name()="account"]/*[local-name()="accountInformation"]/*[local-name()="id"]/text()','ND',null,null,'!=','YES','No existe ningun registro de cuenta','A');

  INSERT INTO invoke_response_evaluation (invoke_response_evaluation_id,invoke_id,order_by,xpath,evaluation_type,expected_value,value_type,evaluation_operator,success,failure_message,status)
  VALUES ((SELECT Nvl(Max(IR.invoke_response_evaluation_id),0)+1 FROM invoke_response_evaluation IR),ln_invoke_id3,10,'//*[local-name()="response"]/*[local-name()="idResult"]/text()','FV','0','NUMERIC','==','YES','SEP=#'||SP_RESP_MESSAGE||'#Error Change Account, %s.','A');


  -- BEHAVIOUR_OPERATION - AGREGAR TODOS LOS CAMPOS QUE SE NECESITEN
  SELECT Nvl(Max(BO.behaviour_operation_id),0) + 1 INTO ln_beh_operation_id FROM behaviour_operation BO;
  INSERT INTO behaviour_operation (behaviour_operation_id,behaviour_id,operation_type_id,description)
  VALUES (ln_beh_operation_id,ln_behaviour_id,ln_operation_type_id1,lv_desc_camp||lv_description);
  
  -- Creacion del esqueleto o STAGES
  SELECT Nvl(Max(BS.behaviour_oper_stage_id),0) + 1 INTO ln_beh_oper_stage_id1 FROM behaviour_oper_stages BS;
  INSERT INTO behaviour_oper_stages (behaviour_oper_stage_id,stage_id,order_by,behaviour_operation_id)
  VALUES (ln_beh_oper_stage_id1,lv_stage,10,ln_beh_operation_id);

  SELECT NVL(MAX(BS.BEHAVIOUR_OPER_STAGE_ID),0) + 1 INTO ln_beh_oper_stage_id2 FROM BEHAVIOUR_OPER_STAGES BS;
  INSERT INTO behaviour_oper_stages (BEHAVIOUR_OPER_STAGE_ID,STAGE_ID,ORDER_BY,BEHAVIOUR_OPERATION_ID)
  VALUES (ln_beh_oper_stage_id2,lv_validation,20,ln_beh_operation_id);

  SELECT NVL(MAX(BS.BEHAVIOUR_OPER_STAGE_ID),0) + 1 INTO ln_beh_oper_stage_id3 FROM BEHAVIOUR_OPER_STAGES BS;
  INSERT INTO behaviour_oper_stages (BEHAVIOUR_OPER_STAGE_ID,STAGE_ID,ORDER_BY,BEHAVIOUR_OPERATION_ID)
  VALUES (ln_beh_oper_stage_id3,lv_stage,30,ln_beh_operation_id);

  SELECT NVL(MAX(BS.BEHAVIOUR_OPER_STAGE_ID),0) + 1 INTO ln_beh_oper_stage_id4 FROM BEHAVIOUR_OPER_STAGES BS;
  INSERT INTO behaviour_oper_stages (BEHAVIOUR_OPER_STAGE_ID,STAGE_ID,ORDER_BY,BEHAVIOUR_OPERATION_ID)
  VALUES (ln_beh_oper_stage_id4,lv_validation,40,ln_beh_operation_id);

  SELECT NVL(MAX(BS.BEHAVIOUR_OPER_STAGE_ID),0) + 1 INTO ln_beh_oper_stage_id5 FROM BEHAVIOUR_OPER_STAGES BS;
  INSERT INTO behaviour_oper_stages (BEHAVIOUR_OPER_STAGE_ID, STAGE_ID, ORDER_BY,BEHAVIOUR_OPERATION_ID)
  VALUES (ln_beh_oper_stage_id5,lv_stage,50,ln_beh_operation_id);


  -- BEHAVIOUR OPER INVOKE (QueryAccount)
  SELECT Nvl(Max(BI.behaviour_oper_invoke_id),0)+1 INTO ln_beh_oper_invoke_id1 FROM behaviour_oper_invoke BI;
  INSERT INTO behaviour_oper_invoke (behaviour_oper_invoke_id,behaviour_oper_stage_id,when,condition_id,invoke_id,order_by,required,status,sync,notification_group_id,session_data,schedule_id,when_condition,when_schedule,when_resp_not_success,retries,apply_compensation,invoke_id_comp_backward,invoke_id_comp_forward,condition_group_id,looping_operation_id,copy_from_subs_to_subs)
  VALUES (ln_beh_oper_invoke_id1,ln_beh_oper_stage_id1,'PRE',null,ln_invoke_id1,10,'YES','A','YES',null,'',null,null,'','',0,'NO','','','',null,'');

  -- BEHAVIOUR OPER INVOKE (CreditEngine)
  SELECT Nvl(Max(BI.behaviour_oper_invoke_id),0)+1 INTO ln_beh_oper_invoke_id2 FROM behaviour_oper_invoke BI;
  INSERT INTO behaviour_oper_invoke (behaviour_oper_invoke_id,behaviour_oper_stage_id,when,condition_id,invoke_id,order_by,required,status,sync,notification_group_id,session_data,schedule_id,when_condition,when_schedule,when_resp_not_success,retries,apply_compensation,invoke_id_comp_backward,invoke_id_comp_forward,condition_group_id,looping_operation_id,copy_from_subs_to_subs)
  VALUES (ln_beh_oper_invoke_id2,ln_beh_oper_stage_id3,'PRE',null,ln_invoke_id2,10,'YES','A','YES',null,'',null,null,'','',0,'NO','','','',null,'');

  -- BEHAVIOUR OPER INVOKE (ChangeAccount)
  SELECT Nvl(Max(BI.behaviour_oper_invoke_id),0)+1 INTO ln_beh_oper_invoke_id3 FROM behaviour_oper_invoke BI;
  INSERT INTO behaviour_oper_invoke (behaviour_oper_invoke_id,behaviour_oper_stage_id,when,condition_id,invoke_id,order_by,required,status,sync,notification_group_id,session_data,schedule_id,when_condition,when_schedule,when_resp_not_success,retries,apply_compensation,invoke_id_comp_backward,invoke_id_comp_forward,condition_group_id,looping_operation_id,copy_from_subs_to_subs)
  values (ln_beh_oper_invoke_id3,ln_beh_oper_stage_id5,'PRE',null,ln_invoke_id3,10,'YES','A','YES',null,'',null,null,'','',0,'NO','','','',null,'');


  -- FUNCTIONS
  SELECT nvl(max(t.function_dom_id), 0) + 1 INTO ln_function_dom_id FROM FUNCTION_DOMAINS t;
  INSERT INTO FUNCTION_DOMAINS (FUNCTION_DOM_ID,DESCRIPTION,FUNCTION_FILE,SOURCE_CODE,STATUS,FUNCTION_TYPE)
  VALUES (ln_function_dom_id,lv_desc_camp||'Funcion para obtener diferencia de dias a la fecha actual','',
    'function '||ln_function_name||'(jsonParams) {
      var params = JSON.parse(jsonParams);
      var fechaActual = new Date();
      var externalsubs = params.externalSubscriberProperties;
      var date = externalsubs.filter(function(x) {
        return x.id === '''||SP_DATE_LAST_CHANGE||''';
      });
      var fechas = date[0].value;
      var diferenciaEnDias = 9999;
      if (!(!fechas || fechas.length === 0 || fechas.some(val => val === ""))) {
        var fecha = date[0].value.map(function(dateString) {
          return new Date(dateString);
        });
        var fechaMasReciente = new Date(Math.max.apply(null,fecha));
        var diferenciaEnMs = fechaActual - fechaMasReciente;
        var diferenciaEnDias = Math.floor(diferenciaEnMs/(1000 * 60 * 60 * 24));
      }
      res = JSON.stringify({externalSubscriberProperties: [{id:'''||SP_DATE_LAST_CHANGE||''',value:[diferenciaEnDias]}]}); 
      return res;
    }','A','JavaScript');

  SELECT nvl(max(f.FUNCTION_ID),0)+1 INTO ln_function_id FROM FUNCTIONS f;
  INSERT INTO FUNCTIONS (FUNCTION_ID,FUNCTION_NAME,FUCTION_DOM_ID,STATUS,RESULT_KEY)
  VALUES (ln_function_id,ln_function_name,ln_function_dom_id,'A','sessionData');

  -- DEFINED FUNCTIONS
  SELECT nvl(max(t.DEFINED_FUNCTION_CALL_ID),0)+1 INTO ln_def_func_call_id FROM DEFINED_FUNCTION_CALL t;
  INSERT INTO DEFINED_FUNCTION_CALL (DEFINED_FUNCTION_CALL_ID,DEFINED_FUNCTION_ID,DESCRIPTION,STATUS)
  VALUES (ln_def_func_call_id,lv_def_func_id,lv_desc_camp||'Evalua la fecha '||SP_DATE_LAST_CHANGE||' y retorna la diferencia en dias', 'A');
  
  SELECT t.defined_function_param_id INTO ln_id_param FROM DEFINED_FUNCTION_PARAMS t where t.defined_function_id = lv_def_func_id and t.name = 'FUNCTION_ID';
  INSERT INTO DEFINED_FUNCTION_BINDINGS (DEFINED_FUNCTION_BINDING_ID,DEFINED_FUNCTION_CALL_ID,DEFINED_FUNCTION_PARAM_ID,BINDING_TYPE,SUBSCRIBER_PROPERTY_ID,FIXED_VALUE,STATUS)
  VALUES ((select nvl(max(T.DEFINED_FUNCTION_BINDING_ID),0)+1 from DEFINED_FUNCTION_BINDINGS T),ln_def_func_call_id,ln_id_param,'FV','',ln_function_id,'A');

  SELECT t.defined_function_param_id into ln_id_param FROM DEFINED_FUNCTION_PARAMS t where t.defined_function_id = lv_def_func_id and t.name = 'ADD_SESSION_DATA';
  INSERT INTO DEFINED_FUNCTION_BINDINGS (DEFINED_FUNCTION_BINDING_ID,DEFINED_FUNCTION_CALL_ID,DEFINED_FUNCTION_PARAM_ID,BINDING_TYPE,SUBSCRIBER_PROPERTY_ID,FIXED_VALUE,STATUS)
  VALUES ((select nvl(max(T.DEFINED_FUNCTION_BINDING_ID),0)+1 from DEFINED_FUNCTION_BINDINGS T),ln_def_func_call_id,ln_id_param,'FV','','YES','A');

  --enrichment call
  INSERT INTO behaviour_enrichment_property (BEHAVIOUR_ENRICHE_PROPERTY_ID,BEHAVIOUR_OPER_STAGE_ID,CONDITION_ID,WHEN,ORDER_BY,SESSION_DATA,STATUS,CONDITION_GROUP_ID,DEFINED_FUNCTION_CALL_ID,EXECUTION_PRIORITY)
  VALUES ((SELECT NVL(MAX(BP.BEHAVIOUR_ENRICHE_PROPERTY_ID),0)+1 FROM BEHAVIOUR_ENRICHMENT_PROPERTY BP),ln_beh_oper_stage_id2,null,'PRE',10,'[]','A','',ln_def_func_call_id,'FUNCTION');

  -- CONDITION
  SELECT nvl(max(c.condition_id), 0)+1 INTO ln_condition_id1 FROM CONDITION c;
  INSERT INTO CONDITION (CONDITION_ID,DESCRIPTION)
  VALUES (ln_condition_id1,lv_desc_camp||'Comprobar si '||SP_DAYS_LAST_CHANGE||' >= 30');

  SELECT nvl(max(c.condition_id), 0)+1 INTO ln_condition_id2 FROM CONDITION c;
  INSERT INTO CONDITION (CONDITION_ID,DESCRIPTION)
  VALUES (ln_condition_id2,lv_desc_camp||'Comprobar la respuesta del motor de credito');

  -- DOMAIN
  SELECT nvl(max(d.domain_id),0)+1 INTO ln_domain_id1 FROM DOMAIN d;
  INSERT INTO DOMAIN (DOMAIN_ID,DESCRIPTION,STATUS)
  VALUES (ln_domain_id1,lv_desc_camp||'Valida numero dias mayor a 30','A');

  SELECT nvl(max(d.domain_id), 0)+1 INTO ln_domain_id2 FROM DOMAIN d;
  INSERT INTO DOMAIN (DOMAIN_ID,DESCRIPTION,STATUS)
  VALUES (ln_domain_id2,lv_desc_camp||'La respuesta debe ser exitosa','A');
  

  -- DOMAIN ELEMENTS
  INSERT INTO DOMAIN_ELEMENTS SELECT rownum + (SELECT NVL(MAX(DE.DOMAIN_ELEMENT_ID),0) + 1 FROM DOMAIN_ELEMENTS DE) DOMAIN_ELEMENT_ID,
  trim(regexp_substr(valor, '[^,]+', 1, level)) ELEMENT_VALUE,ln_domain_id1 DOMAIN_ID,'A' STATUS
  FROM (select 30 valor from dual) t CONNECT BY instr(valor, ',', 1, level - 1) > 0;

  INSERT INTO DOMAIN_ELEMENTS SELECT rownum + (SELECT NVL(MAX(DE.DOMAIN_ELEMENT_ID),0) + 1 FROM DOMAIN_ELEMENTS DE) DOMAIN_ELEMENT_ID,
  trim(regexp_substr(valor, '[^,]+', 1, level)) ELEMENT_VALUE,ln_domain_id2 DOMAIN_ID,'A' STATUS
  FROM (select 0 valor from dual) t CONNECT BY instr(valor, ',', 1, level - 1) > 0;

  -- DOMAIN VALUE RANGES
  SELECT nvl(max(dvr.domain_value_range_id),0)+1 INTO ln_domain_value_range_id FROM DOMAIN_VALUE_RANGES dvr;
  INSERT INTO DOMAIN_VALUE_RANGES (DOMAIN_VALUE_RANGE_ID,DOMAIN_ID,FROM_VALUE,TO_VALUE,ORDER_BY,STATUS)
  VALUES (ln_domain_value_range_id,ln_domain_id1,'30','99999999',10,'A');

  -- CONDITION PROPERTIES
  SELECT nvl(max(cp.condition_property_id),0)+1 INTO ln_condition_property_id1 FROM CONDITION_PROPERTIES cp;
  INSERT INTO CONDITION_PROPERTIES (CONDITION_PROPERTY_ID,CONDITION_ID,SUBSCRIBER_PROPERTY_ID,DATA_TYPE,EXPRESSION_CONDITION,DOMAIN_ID,MIN_NUM_DOMAIN_ELEMENTS,MAX_NUM_DOMAIN_ELEMENTS,SUCCESS_MESSAGE,FAIL_MESSAGE)
  VALUES (ln_condition_property_id1,ln_condition_id1, SP_DAYS_LAST_CHANGE,'NUMERIC','[SP>=DM]',ln_domain_id1,null,null,'Numero de dias mayor a 30','El numero de dias de su ultimo cambio, NO es mayor a 30');

  SELECT nvl(max(cp.condition_property_id), 0)+1 INTO ln_condition_property_id2 FROM CONDITION_PROPERTIES cp;
  INSERT INTO CONDITION_PROPERTIES (CONDITION_PROPERTY_ID,CONDITION_ID,SUBSCRIBER_PROPERTY_ID,DATA_TYPE,EXPRESSION_CONDITION,DOMAIN_ID,MIN_NUM_DOMAIN_ELEMENTS,MAX_NUM_DOMAIN_ELEMENTS,SUCCESS_MESSAGE,FAIL_MESSAGE)
  VALUES (ln_condition_property_id2,ln_condition_id2,SP_CODE_CREDIT_ENGINE_CPM,'NUMERIC','[SP=DM]',ln_domain_id2,null,null,'La respuesta del motor de credito es exitosa','SEP=#'||SP_RESP_MESSAGE||'#Error Credit Engine, %s.');
  
  -- BEHAVIOUR VALIDATIONS
  INSERT INTO behaviour_validations (BEHAVIOUR_VALIDATION_ID,BEHAVIOUR_OPER_STAGE_ID,DESCRIPTION,CONDITION_ID,ORDER_BY,SCHEDULE_ID,STATUS,NOTIFICATION_GROUP_ID,CONDITION_GROUP_ID)
  VALUES ((SELECT NVL(MAX(T.behaviour_validation_id),0)+1 FROM behaviour_validations T),ln_beh_oper_stage_id2,'Valida que el numero de dias sea mayor a 30',ln_condition_id1,10,null,'A',null,'');

  INSERT INTO behaviour_validations (BEHAVIOUR_VALIDATION_ID,BEHAVIOUR_OPER_STAGE_ID, DESCRIPTION, CONDITION_ID, ORDER_BY, SCHEDULE_ID,STATUS, NOTIFICATION_GROUP_ID, CONDITION_GROUP_ID)
  VALUES ((SELECT NVL(MAX(T.behaviour_validation_id),0)+1 FROM behaviour_validations T),ln_beh_oper_stage_id4,'Valida la respuesta del Credit Enginee',ln_condition_id2,10,null,'A',null,'');

  
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
  DBMS_OUTPUT.PUT_LINE('BEH_OPER_STAGE_INVOKE3: ' || ln_beh_oper_invoke_id3);
  DBMS_OUTPUT.PUT_LINE('EXTERNAL_RESOURCE_GROUPS_1: ' || ln_ext_res_group_id);
  DBMS_OUTPUT.PUT_LINE('INVOKE_ID_1: ' || ln_invoke_id1);
  DBMS_OUTPUT.PUT_LINE('INVOKE_ID_2: ' || ln_invoke_id2);
  DBMS_OUTPUT.PUT_LINE('INVOKE_ID_3: ' || ln_invoke_id3);
  DBMS_OUTPUT.PUT_LINE('EXTERNA_RESOURCES_1: ' || ln_ext_res_id1);
  DBMS_OUTPUT.PUT_LINE('EXTERNA_RESOURCES_2: ' || ln_ext_res_id2);
  DBMS_OUTPUT.PUT_LINE('EXTERNA_RESOURCES_3: ' || ln_ext_res_id3);
  DBMS_OUTPUT.PUT_LINE('FUNCTION_DOMAIN: '||ln_function_dom_id||';');
  DBMS_OUTPUT.PUT_LINE('FUNCTION: '||ln_function_id||';');
  DBMS_OUTPUT.PUT_LINE('DEFINITION FUNCTION CALL: '||ln_def_func_call_id||';');
  DBMS_OUTPUT.PUT_LINE('DOMAIN1: ' || ln_domain_id1);
  DBMS_OUTPUT.PUT_LINE('CONDITION1: ' || ln_condition_id1);
  DBMS_OUTPUT.PUT_LINE('DOMAIN2: ' || ln_domain_id2);
  DBMS_OUTPUT.PUT_LINE('CONDITION2: ' || ln_condition_id2);

  dbms_output.Put_line('ln_beh_operation_id number := '||ln_beh_operation_id||';');
  dbms_output.put_line('ln_beh_oper_stage_id1 number := '||ln_beh_oper_stage_id1||';');
  dbms_output.put_line('ln_beh_oper_stage_id2 number := '||ln_beh_oper_stage_id2||';');
  dbms_output.put_line('ln_beh_oper_stage_id3 number := '||ln_beh_oper_stage_id3||';');
  dbms_output.put_line('ln_beh_oper_stage_id4 number := '||ln_beh_oper_stage_id4||';');
  dbms_output.put_line('ln_beh_oper_stage_id5 number := '||ln_beh_oper_stage_id5||';');
  dbms_output.put_line('ln_beh_oper_invoke_id1 number := '||ln_beh_oper_invoke_id1||';');
  dbms_output.Put_line('INVOKE ID1: '|| ln_invoke_id1 );
  dbms_output.put_line('ln_beh_oper_invoke_id2 number := '||ln_beh_oper_invoke_id2||';');
  dbms_output.Put_line('INVOKE ID2: '|| ln_invoke_id2 );
  dbms_output.put_line('ln_beh_oper_invoke_id3 number := '||ln_beh_oper_invoke_id3||';');
  dbms_output.Put_line('INVOKE ID3: '|| ln_invoke_id3);

  dbms_output.put_line('ln_function_dom_id number := '||ln_function_dom_id||';');
  dbms_output.put_line('ln_function_id number := '||ln_function_id||';');
  dbms_output.put_line('ln_def_func_call_id number := '||ln_def_func_call_id||';');
  dbms_output.put_line('ln_domain_id1 ' || ln_domain_id1);
  dbms_output.put_line('ln_condition_id1 ' || ln_condition_id1);
  dbms_output.put_line('ln_domain_id2 ' || ln_domain_id2);
  dbms_output.put_line('ln_condition_id2 ' || ln_condition_id2);

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
  dbms_output.put_line('SELECT * FROM behaviour_oper_stages T WHERE T.BEHAVIOUR_OPER_STAGE_ID = '||ln_beh_oper_stage_id3||' order by t.order_by;');
  dbms_output.put_line('SELECT * FROM behaviour_oper_stages T WHERE T.BEHAVIOUR_OPER_STAGE_ID = '||ln_beh_oper_stage_id4||' order by t.order_by;');
  dbms_output.put_line('SELECT * FROM behaviour_oper_stages T WHERE T.BEHAVIOUR_OPER_STAGE_ID = '||ln_beh_oper_stage_id5||' order by t.order_by;');

  dbms_output.Put_line('SELECT * FROM BEHAVIOUR_PRODUCT T WHERE T.BEHAVIOUR_OPER_STAGE_ID = '''||ln_beh_oper_stage_id1||''';');
  dbms_output.Put_line('SELECT * FROM offer_products T WHERE T.offer_id = '''||ln_offer_id1||''';');
  dbms_output.Put_line('SELECT * FROM campaign_offers T WHERE T.offer_id = '''||ln_offer_id1||''';');
  dbms_output.Put_line('SELECT * FROM PRODUCT_TYPES T WHERE T.PRODUCT_TYPE_ID = '''||product_type_id1||''';');
  dbms_output.Put_line('SELECT * FROM PRODUCTS T WHERE T.PRODUCT_TYPE_ID = '''||product_type_id1||''';');

  dbms_output.put_line('SELECT * FROM FUNCTIONS t where t.fuction_dom_id = '''||ln_function_dom_id||''';');
  dbms_output.put_line('SELECT * FROM FUNCTION_DOMAINS t where t.function_dom_id = '''||ln_function_dom_id||''';');
  dbms_output.put_line('SELECT * FROM DEFINED_FUNCTION_BINDINGS t where t.defined_function_call_id = '''||ln_def_func_call_id||''';');
  dbms_output.put_line('SELECT * FROM DEFINED_FUNCTION_CALL t where t.defined_function_call_id = '''||ln_def_func_call_id||''';');
  dbms_output.put_line('SELECT * FROM behaviour_enrichment_property T WHERE T.BEHAVIOUR_OPER_STAGE_ID = '||ln_beh_oper_stage_id2||' order by t.order_by;');
  dbms_output.put_line('SELECT * FROM DOMAIN_VALUE_RANGES t where t.domain_id = '''||ln_domain_id1||''';');
  dbms_output.put_line('SELECT * FROM DOMAIN_ELEMENTS t where t.domain_id = '''||ln_domain_id1||''';');
  dbms_output.put_line('SELECT * FROM DOMAIN t where t.domain_id = '''||ln_domain_id1||''';');
  dbms_output.put_line('SELECT * FROM CONDITION_PROPERTIES T WHERE T.CONDITION_ID = '''||ln_condition_id1||''';');
  dbms_output.put_line('SELECT * FROM CONDITION t where t.condition_id = '''||ln_condition_id1||''';');
  dbms_output.put_line('SELECT * FROM behaviour_validations T WHERE T.BEHAVIOUR_OPER_STAGE_ID = '||ln_beh_oper_stage_id2||' order by t.order_by;');

  dbms_output.put_line('SELECT * FROM DOMAIN_ELEMENTS t where t.domain_id = '''||ln_domain_id2||''';');
  dbms_output.put_line('SELECT * FROM DOMAIN t where t.domain_id = '''||ln_domain_id2||''';');
  dbms_output.put_line('SELECT * FROM CONDITION_PROPERTIES T WHERE T.CONDITION_ID = '''||ln_condition_id2||''';');
  dbms_output.put_line('SELECT * FROM CONDITION t where t.condition_id = '''||ln_condition_id2||''';');
  dbms_output.put_line('SELECT * FROM behaviour_validations T WHERE T.BEHAVIOUR_OPER_STAGE_ID = '||ln_beh_oper_stage_id4||' order by t.order_by;');

  dbms_output.Put_line('---------------INVOKE QUERY ACCOUNT--------------------------------------');
  dbms_output.Put_line('SELECT * FROM INVOKE T WHERE T.INVOKE_ID = '''||ln_invoke_id1||''';');
  dbms_output.Put_line('SELECT * FROM EXTERNAL_RESOURCE_GROUPS T WHERE T.EXTERNAL_RESOURCE_GROUP_ID = '''||ln_ext_res_group_id||''';');
  dbms_output.Put_line('SELECT * FROM EXTERNAL_RESOURCES T WHERE T.EXTERNAL_RESOURCE_ID = '''||ln_ext_res_id1||''';');
  dbms_output.Put_line('SELECT * FROM EXTERNAL_RESOURCE_COMPONENTS T WHERE T.EXTERNAL_RESOURCE_ID = '''||ln_ext_res_id1||''';');
  dbms_output.Put_line('SELECT * FROM INVOKE_MAPPING T WHERE T.INVOKE_ID = '''||ln_invoke_id1||''';');
  dbms_output.Put_line('SELECT * FROM INVOKE_RESPONSE_EVALUATION T WHERE T.INVOKE_ID = '''||ln_invoke_id1||''';');
  dbms_output.put_line('SELECT * FROM BEHAVIOUR_OPER_INVOKE T WHERE T.BEHAVIOUR_OPER_STAGE_ID = '||ln_beh_oper_stage_id1||' order by t.order_by;');

  dbms_output.Put_line('---------------INVOKE CREDIT ENGINE--------------------------------------');
  dbms_output.Put_line('SELECT * FROM INVOKE T WHERE T.INVOKE_ID = '''||ln_invoke_id2||''';');
  dbms_output.Put_line('SELECT * FROM EXTERNAL_RESOURCE_GROUPS T WHERE T.EXTERNAL_RESOURCE_GROUP_ID = '''||ln_ext_res_group_id||''';');
  dbms_output.Put_line('SELECT * FROM EXTERNAL_RESOURCES T WHERE T.EXTERNAL_RESOURCE_ID = '''||ln_ext_res_id2||''';');
  dbms_output.Put_line('SELECT * FROM EXTERNAL_RESOURCE_COMPONENTS T WHERE T.EXTERNAL_RESOURCE_ID = '''||ln_ext_res_id2||''';');
  dbms_output.Put_line('SELECT * FROM INVOKE_MAPPING T WHERE T.INVOKE_ID = '''||ln_invoke_id2||''';');
  dbms_output.Put_line('SELECT * FROM INVOKE_RESPONSE_EVALUATION T WHERE T.INVOKE_ID = '''||ln_invoke_id2||''';');
  dbms_output.put_line('SELECT * FROM BEHAVIOUR_OPER_INVOKE T WHERE T.BEHAVIOUR_OPER_STAGE_ID = '||ln_beh_oper_stage_id3||' order by t.order_by;');

  dbms_output.Put_line('---------------INVOKE CHANGE ACCOUNT--------------------------------------');
  dbms_output.Put_line('SELECT * FROM INVOKE T WHERE T.INVOKE_ID = ''' || ln_invoke_id3 || ''';');
  dbms_output.Put_line('SELECT * FROM EXTERNAL_RESOURCE_GROUPS T WHERE T.EXTERNAL_RESOURCE_GROUP_ID = ''' || ln_ext_res_group_id || ''';');
  dbms_output.Put_line('SELECT * FROM EXTERNAL_RESOURCES T WHERE T.EXTERNAL_RESOURCE_ID = ''' || ln_ext_res_id3 || ''';');
  dbms_output.Put_line('SELECT * FROM EXTERNAL_RESOURCE_COMPONENTS T WHERE T.EXTERNAL_RESOURCE_ID = ''' || ln_ext_res_id3 || ''';');
  dbms_output.Put_line('SELECT * FROM INVOKE_MAPPING T WHERE T.INVOKE_ID = ''' || ln_invoke_id3 || ''';');
  dbms_output.Put_line('SELECT * FROM INVOKE_RESPONSE_EVALUATION T WHERE T.INVOKE_ID = ''' || ln_invoke_id3 || ''';');
  dbms_output.put_line('SELECT * FROM BEHAVIOUR_OPER_INVOKE T WHERE T.BEHAVIOUR_OPER_STAGE_ID = '||ln_beh_oper_stage_id5||' order by t.order_by;');

  dbms_output.Put_line('--------------UPDATE STATUS---------------------------------------');
  dbms_output.Put_line('update offer_products t set status = ''I'' where t.offer_id = '''||ln_offer_id1||''';');
  dbms_output.Put_line('update campaign_offers t set status = ''I'' where t.offer_id = '''||ln_offer_id1||''';');
  dbms_output.Put_line('update offers t set status = ''I'' where t.offer_id = '''||ln_offer_id1||''';');
  dbms_output.Put_line('update products p set status = ''I'' where p.product_type_id = '''||product_type_id1||''';');
  dbms_output.Put_line('update product_types p set status = ''I'' where p.product_type_id = '''||product_type_id1||''';');
  dbms_output.Put_line('update campaign c set status = ''I'' where c.behaviour_id = '''||ln_behaviour_id||''';');
  dbms_output.Put_line('update behaviour a set status = ''I'' where a.behaviour_id ='''||ln_behaviour_id||''';');

  dbms_output.put_line('update behaviour_oper_stages t set status = ''I'' where t.BEHAVIOUR_OPERATION_ID = '||ln_beh_operation_id||';');
  dbms_output.put_line('update behaviour_oper_stages t set status = ''I'' where t.BEHAVIOUR_OPER_STAGE_ID = '||ln_beh_oper_stage_id1||';');
  dbms_output.put_line('update behaviour_oper_stages t set status = ''I'' where t.BEHAVIOUR_OPER_STAGE_ID = '||ln_beh_oper_stage_id2||';');
  dbms_output.put_line('update behaviour_oper_stages t set status = ''I'' where t.BEHAVIOUR_OPER_STAGE_ID = '||ln_beh_oper_stage_id3||';');
  dbms_output.put_line('update behaviour_oper_stages t set status = ''I'' where t.BEHAVIOUR_OPER_STAGE_ID = '||ln_beh_oper_stage_id4||';');
  dbms_output.put_line('update behaviour_oper_stages t set status = ''I'' where t.BEHAVIOUR_OPER_STAGE_ID = '||ln_beh_oper_stage_id5||';');

  dbms_output.put_line('UPDATE FUNCTIONS t set status = ''I'' where t.fuction_dom_id = '''||ln_function_dom_id||''';');
  dbms_output.put_line('UPDATE FUNCTION_DOMAINS t set status = ''I'' where t.function_dom_id = '''||ln_function_dom_id||''';');
  dbms_output.put_line('UPDATE DEFINED_FUNCTION_BINDINGS t set status = ''I'' where t.defined_function_call_id = '''||ln_def_func_call_id||''';');
  dbms_output.put_line('UPDATE DEFINED_FUNCTION_CALL t set status = ''I'' where t.defined_function_call_id = '''||ln_def_func_call_id||''';');
  dbms_output.put_line('update behaviour_enrichment_property t set status = ''I'' where t.BEHAVIOUR_OPER_STAGE_ID = '||ln_beh_oper_stage_id2||';');
  dbms_output.put_line('UPDATE DOMAIN_VALUE_RANGES t set status = ''I'' where t.domain_id = '''||ln_domain_id1||''';');
  dbms_output.put_line('UPDATE DOMAIN_ELEMENTS t set status = ''I'' where t.domain_id = '''||ln_domain_id1||''';');
  dbms_output.put_line('UPDATE DOMAIN t set status = ''I'' where t.domain_id = '''||ln_domain_id1||''';');
  dbms_output.put_line('UPDATE CONDITION_PROPERTIES T set status = ''I'' WHERE T.CONDITION_ID = '''||ln_condition_id1||''';');
  dbms_output.put_line('UPDATE CONDITION t set status = ''I'' where t.condition_id = '''||ln_condition_id1||''';');
  dbms_output.put_line('update behaviour_validations t set status = ''I'' where t.BEHAVIOUR_OPER_STAGE_ID = '||ln_beh_oper_stage_id2||';');

  dbms_output.put_line('UPDATE DOMAIN_ELEMENTS t set status = ''I'' where t.domain_id = '''||ln_domain_id2||''';');
  dbms_output.put_line('UPDATE DOMAIN t set status = ''I'' where t.domain_id = '''||ln_domain_id2||''';');
  dbms_output.put_line('UPDATE CONDITION_PROPERTIES T set status = ''I'' WHERE T.CONDITION_ID = '''||ln_condition_id2||''';');
  dbms_output.put_line('UPDATE CONDITION t set status = ''I'' where t.condition_id = '''||ln_condition_id2||''';');
  dbms_output.put_line('update behaviour_validations t set status = ''I'' where t.BEHAVIOUR_OPER_STAGE_ID = '||ln_beh_oper_stage_id4||';');

  dbms_output.Put_line('---------------INVOKE QUERY ACCOUNT--------------------------------------');
  dbms_output.Put_line('update INVOKE T set status = ''I'' WHERE T.INVOKE_ID = '''||ln_invoke_id1||''';');
  dbms_output.Put_line('update EXTERNAL_RESOURCE_GROUPS T set status = ''I'' WHERE T.EXTERNAL_RESOURCE_GROUP_ID = '''||ln_ext_res_group_id||''';');
  dbms_output.Put_line('update EXTERNAL_RESOURCES T set status = ''I'' WHERE T.EXTERNAL_RESOURCE_ID = '''||ln_ext_res_id1||''';');
  dbms_output.Put_line('update EXTERNAL_RESOURCE_COMPONENTS T set status = ''I'' WHERE T.EXTERNAL_RESOURCE_ID = '''||ln_ext_res_id1||''';');
  dbms_output.Put_line('update INVOKE_MAPPING T set status = ''I'' WHERE T.INVOKE_ID = '''||ln_invoke_id1||''';');
  dbms_output.Put_line('update INVOKE_RESPONSE_EVALUATION T set status = ''I'' WHERE T.INVOKE_ID = '''||ln_invoke_id1||''';');
  dbms_output.put_line('update BEHAVIOUR_OPER_INVOKE t set status = ''I'' where t.BEHAVIOUR_OPER_STAGE_ID = '||ln_beh_oper_stage_id1||';');

  dbms_output.Put_line('---------------INVOKE CREDIT ENGINE--------------------------------------');
  dbms_output.Put_line('update INVOKE T set status = ''I'' WHERE T.INVOKE_ID = '''||ln_invoke_id2||''';');
  dbms_output.Put_line('update EXTERNAL_RESOURCE_GROUPS T set status = ''I'' WHERE T.EXTERNAL_RESOURCE_GROUP_ID = '''||ln_ext_res_group_id||''';');
  dbms_output.Put_line('update EXTERNAL_RESOURCES T set status = ''I'' WHERE T.EXTERNAL_RESOURCE_ID = '''||ln_ext_res_id2||''';');
  dbms_output.Put_line('update EXTERNAL_RESOURCE_COMPONENTS T set status = ''I'' WHERE T.EXTERNAL_RESOURCE_ID = '''||ln_ext_res_id2||''';');
  dbms_output.Put_line('update INVOKE_MAPPING T set status = ''I'' WHERE T.INVOKE_ID = '''||ln_invoke_id2||''';');
  dbms_output.Put_line('update INVOKE_RESPONSE_EVALUATION T set status = ''I'' WHERE T.INVOKE_ID = '''||ln_invoke_id2||''';');
  dbms_output.put_line('update BEHAVIOUR_OPER_INVOKE t set status = ''I'' where t.BEHAVIOUR_OPER_STAGE_ID = '||ln_beh_oper_stage_id3||';');

  dbms_output.Put_line('---------------INVOKE CHANGE ACCOUNT--------------------------------------');
  dbms_output.Put_line('update INVOKE T set status = ''I'' WHERE T.INVOKE_ID = ''' || ln_invoke_id3 || ''';');
  dbms_output.Put_line('update EXTERNAL_RESOURCE_GROUPS T set status = ''I'' WHERE T.EXTERNAL_RESOURCE_GROUP_ID = ''' || ln_ext_res_group_id || ''';');
  dbms_output.Put_line('update EXTERNAL_RESOURCES T set status = ''I'' WHERE T.EXTERNAL_RESOURCE_ID = ''' || ln_ext_res_id3 || ''';');
  dbms_output.Put_line('update EXTERNAL_RESOURCE_COMPONENTS T set status = ''I'' WHERE T.EXTERNAL_RESOURCE_ID = ''' || ln_ext_res_id3 || ''';');
  dbms_output.Put_line('update INVOKE_MAPPING T set status = ''I'' WHERE T.INVOKE_ID = ''' || ln_invoke_id3 || ''';');
  dbms_output.Put_line('update INVOKE_RESPONSE_EVALUATION T set status = ''I'' WHERE T.INVOKE_ID = ''' || ln_invoke_id3 || ''';');
  dbms_output.put_line('update BEHAVIOUR_OPER_INVOKE t set status = ''I'' where t.BEHAVIOUR_OPER_STAGE_ID = '||ln_beh_oper_stage_id5||';');

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
  dbms_output.put_line('delete behaviour_oper_stages b where b.BEHAVIOUR_OPER_STAGE_ID = '||ln_beh_oper_stage_id3||';');
  dbms_output.put_line('delete behaviour_oper_stages b where b.BEHAVIOUR_OPER_STAGE_ID = '||ln_beh_oper_stage_id4||';');
  dbms_output.put_line('delete behaviour_oper_stages b where b.BEHAVIOUR_OPER_STAGE_ID = '||ln_beh_oper_stage_id5||';');

  dbms_output.put_line('DELETE FROM FUNCTIONS t where t.fuction_dom_id = '''||ln_function_dom_id||''';');
  dbms_output.put_line('DELETE FROM FUNCTION_DOMAINS t where t.function_dom_id = '''||ln_function_dom_id||''';');
  dbms_output.put_line('DELETE FROM DEFINED_FUNCTION_BINDINGS t where t.defined_function_call_id = '''||ln_def_func_call_id||''';');
  dbms_output.put_line('DELETE FROM DEFINED_FUNCTION_CALL t where t.defined_function_call_id = '''||ln_def_func_call_id||''';');
  dbms_output.put_line('DELETE behaviour_enrichment_property b where b.BEHAVIOUR_OPER_STAGE_ID = '||ln_beh_oper_stage_id2||';');
  dbms_output.put_line('DELETE FROM DOMAIN_VALUE_RANGES t where t.domain_id = '''||ln_domain_id1||''';');
  dbms_output.put_line('DELETE FROM DOMAIN_ELEMENTS t where t.domain_id = '''||ln_domain_id1||''';');
  dbms_output.put_line('DELETE FROM DOMAIN t where t.domain_id = '''||ln_domain_id1||''';');
  dbms_output.put_line('DELETE FROM CONDITION_PROPERTIES T WHERE T.CONDITION_ID = '''||ln_condition_id1||''';');
  dbms_output.put_line('DELETE FROM CONDITION t where t.condition_id = '''||ln_condition_id1||''';');
  dbms_output.put_line('delete behaviour_validations b where b.BEHAVIOUR_OPER_STAGE_ID = '||ln_beh_oper_stage_id2||';');

  dbms_output.put_line('DELETE FROM DOMAIN_VALUE_RANGES t where t.domain_id = '''||ln_domain_id2||''';');
  dbms_output.put_line('DELETE FROM DOMAIN_ELEMENTS t where t.domain_id = '''||ln_domain_id2||''';');
  dbms_output.put_line('DELETE FROM DOMAIN t where t.domain_id = '''||ln_domain_id2||''';');
  dbms_output.put_line('DELETE FROM CONDITION_PROPERTIES T WHERE T.CONDITION_ID = '''||ln_condition_id2||''';');
  dbms_output.put_line('DELETE FROM CONDITION t where t.condition_id = '''||ln_condition_id2||''';');
  dbms_output.put_line('delete behaviour_validations b where b.BEHAVIOUR_OPER_STAGE_ID = '||ln_beh_oper_stage_id4||';');

  dbms_output.Put_line('---------------INVOKE QUERY ACCOUNT--------------------------------------');
  dbms_output.Put_line('DELETE INVOKE_RESPONSE_EVALUATION T WHERE T.INVOKE_ID = '''||ln_invoke_id1||''';');
  dbms_output.put_line('DELETE INVOKE_MAPPING T WHERE T.INVOKE_ID = '''||ln_invoke_id1||''';');
  dbms_output.Put_line('DELETE EXTERNAL_RESOURCE_COMPONENTS T WHERE T.EXTERNAL_RESOURCE_ID = '''||ln_ext_res_id1||''';');
  dbms_output.Put_line('DELETE EXTERNAL_RESOURCES T WHERE T.EXTERNAL_RESOURCE_ID = '''||ln_ext_res_id1||''';');
--   dbms_output.Put_line('DELETE EXTERNAL_RESOURCE_GROUPS T WHERE T.EXTERNAL_RESOURCE_GROUP_ID = '''||ln_ext_res_group_id||''';');
  dbms_output.Put_line('DELETE INVOKE T WHERE T.INVOKE_ID = '''||ln_invoke_id1||''';');
  dbms_output.put_line('DELETE BEHAVIOUR_OPER_INVOKE b where b.BEHAVIOUR_OPER_STAGE_ID = '||ln_beh_oper_stage_id1||';');

  dbms_output.Put_line('---------------INVOKE CREDIT ENGINE--------------------------------------');
  dbms_output.Put_line('delete INVOKE_RESPONSE_EVALUATION T WHERE T.INVOKE_ID = '''||ln_invoke_id2||''';');
  dbms_output.put_line('delete INVOKE_MAPPING T WHERE T.INVOKE_ID = '''||ln_invoke_id2||''';');
  dbms_output.Put_line('delete EXTERNAL_RESOURCE_COMPONENTS T WHERE T.EXTERNAL_RESOURCE_ID = '''||ln_ext_res_id2||''';');
  dbms_output.Put_line('delete EXTERNAL_RESOURCES T WHERE T.EXTERNAL_RESOURCE_ID = '''||ln_ext_res_id2||''';');
  -- dbms_output.Put_line('delete EXTERNAL_RESOURCE_GROUPS T WHERE T.EXTERNAL_RESOURCE_GROUP_ID = '''||ln_ext_res_group_id||''';');
  dbms_output.Put_line('delete INVOKE T WHERE T.INVOKE_ID = '''||ln_invoke_id2||''';');
  dbms_output.put_line('delete BEHAVIOUR_OPER_INVOKE b where b.BEHAVIOUR_OPER_STAGE_ID = '||ln_beh_oper_stage_id3||';');

  dbms_output.Put_line('---------------INVOKE CHANGE ACCOUNT--------------------------------------');
  dbms_output.Put_line('delete INVOKE_RESPONSE_EVALUATION T WHERE T.INVOKE_ID = ''' || ln_invoke_id3 || ''';');
  dbms_output.put_line('delete INVOKE_MAPPING T WHERE T.INVOKE_ID = ''' || ln_invoke_id3 || ''';');
  dbms_output.Put_line('delete EXTERNAL_RESOURCE_COMPONENTS T WHERE T.EXTERNAL_RESOURCE_ID = ''' || ln_ext_res_id3 || ''';');
  dbms_output.Put_line('delete EXTERNAL_RESOURCES T WHERE T.EXTERNAL_RESOURCE_ID = ''' || ln_ext_res_id3 || ''';');
  -- dbms_output.Put_line('delete EXTERNAL_RESOURCE_GROUPS T WHERE T.EXTERNAL_RESOURCE_GROUP_ID = ''' || ln_ext_res_group_id || ''';');
  dbms_output.Put_line('delete INVOKE T WHERE T.INVOKE_ID = ''' || ln_invoke_id3 || ''';');
  dbms_output.put_line('delete BEHAVIOUR_OPER_INVOKE b where b.BEHAVIOUR_OPER_STAGE_ID = '||ln_beh_oper_stage_id5||';');

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