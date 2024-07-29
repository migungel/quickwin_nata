DECLARE
  -- Local variables here
  ln_invoke_id          NUMBER := 0;
  ln_ext_res_group_id   NUMBER := 0;
  ln_ext_res_id         NUMBER := 0;
  lv_description        VARCHAR(255) := '[22385] ';
  SP_COUNTER            NUMBER:=0;
  SP_MATCHING_ID        VARCHAR2(60) := 'MATCHING_ID';
  SP_FUNCTION_REQUESTER_IDENTIFIER        VARCHAR2(60) := 'FUNCTION_REQUESTER_IDENTIFIER';
  SP_FUNCTION_CALL_IDENTIFIER        VARCHAR2(60) := 'FUNCTION_CALL_IDENTIFIER';
  SP_EID                VARCHAR2(60) := 'EID';
  SP_ICCID              VARCHAR2(60) := 'ICCID';
  SP_CONFIRMATION_CODE  VARCHAR2(60) := 'CONFIRMATION_CODE';
  SP_SMDS_ADDRESS       VARCHAR2(60) := 'SMDS_ADDRESS';
  SP_RELEASE_FLAG       VARCHAR2(60) := 'RELEASE_FLAG';
  SP_DISPLAY_PROFILE_NAME   VARCHAR2(60) := 'DISPLAY_PROFILE_NAME';
  SP_STATUS             VARCHAR2(60) := 'STATUS';
  SP_ERRORMESSAGE       VARCHAR2(60) := 'ERRORMESSAGE';
  SP_ERRORCODE          VARCHAR2(60) := 'ERRORCODE';
  SP_ERRORVARIABLES     VARCHAR2(60) := 'ERRORVARIABLES';
  SP_SMDP_ADDRESS       VARCHAR2(60) := 'SMDP_ADDRESS';

BEGIN
  SELECT Min(S.external_resource_group_id) EXTERNAL_RESOURCE_GROUP_ID
  INTO   ln_ext_res_group_id
  FROM   external_resource_groups s
  WHERE  Upper(s.description) LIKE Upper('%[22385]%')
  AND Upper(s.description) LIKE Upper('%ConfirmOrder%');
  
  --RESOURCE
  SELECT Nvl(Max(E.external_resource_id),0) + 1
  INTO   ln_ext_res_id
  FROM   external_resources E;
  
  -- INVOKE
  SELECT Nvl(Max(I.invoke_id),0) + 1
  INTO   ln_invoke_id
  FROM   invoke I;
  
  dbms_output.Put_line('LN_EXT_RES_GROUP ID: '|| ln_ext_res_group_id );
  dbms_output.Put_line('LN_EXT_RES ID: '|| ln_ext_res_id );

  --CREAR SUBSCRIBER PROPERTIES
  SELECT count(SUBSCRIBER_PROPERTY_ID) INTO SP_COUNTER
  FROM SUBSCRIBER_PROPERTIES
  WHERE SUBSCRIBER_PROPERTY_ID = SP_MATCHING_ID;
  IF SP_COUNTER = 0 THEN
    INSERT INTO subscriber_properties(subscriber_property_id,description,status)
    VALUES (SP_MATCHING_ID,lv_description||'eSIM QR Code - MatchingId','A');
  END IF;

  SELECT count(SUBSCRIBER_PROPERTY_ID) INTO SP_COUNTER
  FROM SUBSCRIBER_PROPERTIES
  WHERE SUBSCRIBER_PROPERTY_ID = SP_FUNCTION_REQUESTER_IDENTIFIER;
  IF SP_COUNTER = 0 THEN
    INSERT INTO subscriber_properties(subscriber_property_id,description,status)
    VALUES (SP_FUNCTION_REQUESTER_IDENTIFIER,lv_description||'eSIM QR Code - Identificador','A');
  END IF;

  SELECT count(SUBSCRIBER_PROPERTY_ID) INTO SP_COUNTER
  FROM SUBSCRIBER_PROPERTIES
  WHERE SUBSCRIBER_PROPERTY_ID = SP_FUNCTION_CALL_IDENTIFIER;
  IF SP_COUNTER = 0 THEN
    INSERT INTO subscriber_properties(subscriber_property_id,description,status)
    VALUES (SP_FUNCTION_CALL_IDENTIFIER,lv_description||'eSIM QR Code - Identificador','A');
  END IF;

  SELECT count(SUBSCRIBER_PROPERTY_ID) INTO SP_COUNTER
  FROM SUBSCRIBER_PROPERTIES
  WHERE SUBSCRIBER_PROPERTY_ID = SP_EID;
  IF SP_COUNTER = 0 THEN
    INSERT INTO subscriber_properties(subscriber_property_id,description,status)
    VALUES (SP_EID,lv_description||'eSIM QR Code - EID','A');
  END IF;

  SELECT count(SUBSCRIBER_PROPERTY_ID) INTO SP_COUNTER
  FROM SUBSCRIBER_PROPERTIES
  WHERE SUBSCRIBER_PROPERTY_ID = SP_ICCID;
  IF SP_COUNTER = 0 THEN
    INSERT INTO subscriber_properties(subscriber_property_id,description,status)
    VALUES (SP_ICCID,lv_description||'eSIM QR Code - ICCID','A');
  END IF;

  SELECT count(SUBSCRIBER_PROPERTY_ID) INTO SP_COUNTER
  FROM SUBSCRIBER_PROPERTIES
  WHERE SUBSCRIBER_PROPERTY_ID = SP_CONFIRMATION_CODE;
  IF SP_COUNTER = 0 THEN
    INSERT INTO subscriber_properties(subscriber_property_id,description,status)
    VALUES (SP_CONFIRMATION_CODE,lv_description||'eSIM QR Code - ConfirmationCode','A');
  END IF;

  SELECT count(SUBSCRIBER_PROPERTY_ID) INTO SP_COUNTER
  FROM SUBSCRIBER_PROPERTIES
  WHERE SUBSCRIBER_PROPERTY_ID = SP_SMDS_ADDRESS;
  IF SP_COUNTER = 0 THEN
    INSERT INTO subscriber_properties(subscriber_property_id,description,status)
    VALUES (SP_SMDS_ADDRESS,lv_description||'eSIM QR Code - SMDS Address','A');
  END IF;

  SELECT count(SUBSCRIBER_PROPERTY_ID) INTO SP_COUNTER
  FROM SUBSCRIBER_PROPERTIES
  WHERE SUBSCRIBER_PROPERTY_ID = SP_RELEASE_FLAG;
  IF SP_COUNTER = 0 THEN
    INSERT INTO subscriber_properties(subscriber_property_id,description,status)
    VALUES (SP_RELEASE_FLAG,lv_description||'eSIM QR Code - Release Flag','A');
  END IF;

  SELECT count(SUBSCRIBER_PROPERTY_ID) INTO SP_COUNTER
  FROM SUBSCRIBER_PROPERTIES
  WHERE SUBSCRIBER_PROPERTY_ID = SP_DISPLAY_PROFILE_NAME;
  IF SP_COUNTER = 0 THEN
    INSERT INTO subscriber_properties(subscriber_property_id,description,status)
    VALUES (SP_DISPLAY_PROFILE_NAME,lv_description||'eSIM QR Code - Display Profile Name','A');
  END IF;

  SELECT count(SUBSCRIBER_PROPERTY_ID) INTO SP_COUNTER
  FROM SUBSCRIBER_PROPERTIES
  WHERE SUBSCRIBER_PROPERTY_ID = SP_STATUS;
  IF SP_COUNTER = 0 THEN
    INSERT INTO subscriber_properties(subscriber_property_id,description,status)
    VALUES (SP_STATUS,'Variable para Guardar Estados','A');
  END IF;

  SELECT count(SUBSCRIBER_PROPERTY_ID) INTO SP_COUNTER
  FROM SUBSCRIBER_PROPERTIES
  WHERE SUBSCRIBER_PROPERTY_ID = SP_ERRORMESSAGE;
  IF SP_COUNTER = 0 THEN
    INSERT INTO subscriber_properties(subscriber_property_id,description,status)
    VALUES (SP_ERRORMESSAGE,'Mensaje de error','A');
  END IF;

  SELECT count(SUBSCRIBER_PROPERTY_ID) INTO SP_COUNTER
  FROM SUBSCRIBER_PROPERTIES
  WHERE SUBSCRIBER_PROPERTY_ID = SP_ERRORCODE;
  IF SP_COUNTER = 0 THEN
    INSERT INTO subscriber_properties(subscriber_property_id,description,status)
    VALUES (SP_ERRORCODE,'almacena el codigo de error','A');
  END IF;

  SELECT count(SUBSCRIBER_PROPERTY_ID) INTO SP_COUNTER
  FROM SUBSCRIBER_PROPERTIES
  WHERE SUBSCRIBER_PROPERTY_ID = SP_ERRORVARIABLES;
  IF SP_COUNTER = 0 THEN
    INSERT INTO subscriber_properties(subscriber_property_id,description,status)
    VALUES (SP_ERRORVARIABLES,'variables','A');
  END IF;

  SELECT count(SUBSCRIBER_PROPERTY_ID) INTO SP_COUNTER
  FROM SUBSCRIBER_PROPERTIES
  WHERE SUBSCRIBER_PROPERTY_ID = SP_SMDP_ADDRESS;
  IF SP_COUNTER = 0 THEN
    INSERT INTO subscriber_properties(subscriber_property_id,description,status)
    VALUES (SP_SMDP_ADDRESS,'eSIM QR Code - SMDP Address','A');
  END IF;

  
  --EXTERNAL RESOURCES
  INSERT INTO external_resources
  (
    external_resource_id,
    external_resource_group_id,
    operation_name_description,
    resource_description,
    request_pattern_xslt,
    timeout,
    status,
    ext_res_type,
    request_method,
    content_type,
    data_type
  )
  VALUES
  (
    ln_ext_res_id,
    ln_ext_res_group_id,
    '[22385] eSIM QR Code - API ConfirmOrder',
    'API Confirm Order [HUB IOT]',
    '<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
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
    </xsl:stylesheet>',
    11000,
    'A',
    'REST',
    'POST',
    'application/json',
    'json'
  );
  
  INSERT INTO external_resource_components
  (
    external_resource_component_id,
    external_resource_id,
    endpoint_url,
    short_description,
    routing_type,
    order_by,
    weight
  )
  VALUES
  (
    (
    SELECT Nvl(Max(EC.external_resource_component_id),0) + 1
    FROM   external_resource_components EC
    ),
    ln_ext_res_id,
    'http://200.95.160.7:8312/gsma/rsp2/es2plus/confirmOrder',
    '[22385] eSIM QR Code - Endpoint API ConfirmOrder',
    'B',
    10,
    100
  );
  
  INSERT INTO invoke
  (
    invoke_id,
    external_resource_id,
    operation_name_description,
    description,
    status,
    retries,
    time_between_retries
  )
  VALUES
  (
    ln_invoke_id,
    ln_ext_res_id,
    '[22385] eSIM QR Code - API ConfirmOrder',
    'API Confirm Order [HUB IOT]',
    'A',
    0,
    1000
  );
  
  --MAPPING
  INSERT INTO invoke_mapping
  (
    invoke_mapping_id,
    invoke_id,
    attribute_type,
    subscriber_property_id,
    function_id,
    fixed_value,
    way,
    xpath_to_xml_string,
    xpath,
    label,
    description,
    status
  )
  VALUES
  (
    (
      SELECT Nvl(Max(im.invoke_mapping_id),0)+1
      FROM   invoke_mapping im
    ),
    ln_invoke_id,
    'FV',
    '',
    '',
    'WSSE Realm="AMXhub", Profile="UsernameToken"',
    '>>',
    '',
    '',
    'Authorization',
    'Header',
    'A'
  );
             
  INSERT INTO invoke_mapping
  (
    invoke_mapping_id,
    invoke_id,
    attribute_type,
    subscriber_property_id,
    function_id,
    fixed_value,
    way,
    xpath_to_xml_string,
    xpath,
    label,
    description,
    status
  )
  VALUES
  (
    (
      SELECT Nvl(Max(im.invoke_mapping_id),0)+1
      FROM   invoke_mapping im
    ),
    ln_invoke_id,
    'FV',
    '',
    '',
    'UsernameToken Username="PA00003022",PasswordDigest="Li2fKU8Ry2vM+hdYRV+8N+mTzfguSBH2EaVrzCQDU5A=", Nonce="7EOuOyzCrxD3tpIAPgyNfQ16ab6", Created="2022-10-03T15:46:29Z"',
    '>>',
    '',
    '',
    'X-WSSE',
    'Header',
    'A'
  );

  INSERT INTO invoke_mapping
  (
    invoke_mapping_id,
    invoke_id,
    attribute_type,
    subscriber_property_id,
    function_id,
    fixed_value,
    way,
    xpath_to_xml_string,
    xpath,
    label,
    description,
    status
  )
  VALUES
  (
    (
      SELECT Nvl(Max(im.invoke_mapping_id),0)+1
      FROM   invoke_mapping im
    ),
    ln_invoke_id,
    'FV',
    '',
    '',
    'request TransId="AP20009", iccidManager="ValProdECU", providerId="PA00003432", AppId="AP20009", AspCallBackUrl=http://181.209.207.33:19315, enterpriseId="esimtest", country="ECU"',
    '>>',
    '',
    '',
    'X-RequestHeader',
    'Header',
    'A'
  );

  INSERT INTO invoke_mapping
  (
    invoke_mapping_id,
    invoke_id,
    attribute_type,
    subscriber_property_id,
    function_id,
    fixed_value,
    way,
    xpath_to_xml_string,
    xpath,
    label,
    description,
    status
  )
  VALUES
  (
    (
      SELECT Nvl(Max(im.invoke_mapping_id),0)+1
      FROM   invoke_mapping im
    ),
    ln_invoke_id,
    'FV',
    '',
    '',
    'gsma/rsp/v2.2.0',
    '>>',
    '',
    '',
    'X-Admin-Protocol',
    'Header',
    'A'
  );

  INSERT INTO invoke_mapping
  (
    invoke_mapping_id,
    invoke_id,
    attribute_type,
    subscriber_property_id,
    function_id,
    fixed_value,
    way,
    xpath_to_xml_string,
    xpath,
    label,
    description,
    status
  )
  VALUES
  (
    (
      SELECT Nvl(Max(im.invoke_mapping_id),0)+1
      FROM   invoke_mapping im
    ),
    ln_invoke_id,
    'SP',
    SP_MATCHING_ID,
    '',
    '',
    '<=',
    '',
    '$.matchingId',
    '',
    '',
    'A'
  );

  INSERT INTO invoke_mapping
  (
    invoke_mapping_id,
    invoke_id,
    attribute_type,
    subscriber_property_id,
    function_id,
    fixed_value,
    way,
    xpath_to_xml_string,
    xpath,
    label,
    description,
    status
  )
  VALUES
  (
    (
      SELECT Nvl(Max(im.invoke_mapping_id),0)+1
      FROM   invoke_mapping im
    ),
    ln_invoke_id,
    'SP',
    SP_FUNCTION_REQUESTER_IDENTIFIER,
    '',
    '',
    '=>',
    '',
    '',
    'functionRequesterIdentifier',
    'Identificador de request',
    'A'
  );

  INSERT INTO invoke_mapping
  (
    invoke_mapping_id,
    invoke_id,
    attribute_type,
    subscriber_property_id,
    function_id,
    fixed_value,
    way,
    xpath_to_xml_string,
    xpath,
    label,
    description,
    status
  )
  VALUES
  (
    (
      SELECT Nvl(Max(im.invoke_mapping_id),0)+1
      FROM   invoke_mapping im
    ),
    ln_invoke_id,
    'SP',
    SP_FUNCTION_CALL_IDENTIFIER,
    '',
    '',
    '=>',
    '',
    '',
    'functionCallIdentifier',
    'Identificador de llamada',
    'A'
  );

  INSERT INTO invoke_mapping
  (
    invoke_mapping_id,
    invoke_id,
    attribute_type,
    subscriber_property_id,
    function_id,
    fixed_value,
    way,
    xpath_to_xml_string,
    xpath,
    label,
    description,
    status
  )
  VALUES
  (
    (
      SELECT Nvl(Max(im.invoke_mapping_id),0)+1
      FROM   invoke_mapping im
    ),
    ln_invoke_id,
    'SP',
    SP_EID,
    '',
    '',
    '=>',
    '',
    '',
    'eid',
    'Identificador del dispositivo',
    'A'
  );

  INSERT INTO invoke_mapping
  (
    invoke_mapping_id,
    invoke_id,
    attribute_type,
    subscriber_property_id,
    function_id,
    fixed_value,
    way,
    xpath_to_xml_string,
    xpath,
    label,
    description,
    status
  )
  VALUES
  (
    (
      SELECT Nvl(Max(im.invoke_mapping_id),0)+1
      FROM   invoke_mapping im
    ),
    ln_invoke_id,
    'SP',
    SP_ICCID,
    '',
    '',
    '=>',
    '',
    '',
    'iccid',
    'SIM Card',
    'A'
  );

  INSERT INTO invoke_mapping
  (
    invoke_mapping_id,
    invoke_id,
    attribute_type,
    subscriber_property_id,
    function_id,
    fixed_value,
    way,
    xpath_to_xml_string,
    xpath,
    label,
    description,
    status
  )
  VALUES
  (
    (
      SELECT Nvl(Max(im.invoke_mapping_id),0)+1
      FROM   invoke_mapping im
    ),
    ln_invoke_id,
    'SP',
    SP_MATCHING_ID,
    '',
    '',
    '=>',
    '',
    '',
    'matchingId',
    'Matching Id',
    'A'
  );

  INSERT INTO invoke_mapping
  (
    invoke_mapping_id,
    invoke_id,
    attribute_type,
    subscriber_property_id,
    function_id,
    fixed_value,
    way,
    xpath_to_xml_string,
    xpath,
    label,
    description,
    status
  )
  VALUES
  (
    (
      SELECT Nvl(Max(im.invoke_mapping_id),0)+1
      FROM   invoke_mapping im
    ),
    ln_invoke_id,
    'SP',
    SP_CONFIRMATION_CODE,
    '',
    '',
    '=>',
    '',
    '',
    'confirmationCode',
    'Confirmation Code',
    'A'
  );

  INSERT INTO invoke_mapping
  (
    invoke_mapping_id,
    invoke_id,
    attribute_type,
    subscriber_property_id,
    function_id,
    fixed_value,
    way,
    xpath_to_xml_string,
    xpath,
    label,
    description,
    status
  )
  VALUES
  (
    (
      SELECT Nvl(Max(im.invoke_mapping_id),0)+1
      FROM   invoke_mapping im
    ),
    ln_invoke_id,
    'SP',
    SP_SMDS_ADDRESS,
    '',
    '',
    '=>',
    '',
    '',
    'smdsAddress',
    'SMDS Address',
    'A'
  );

  INSERT INTO invoke_mapping
  (
    invoke_mapping_id,
    invoke_id,
    attribute_type,
    subscriber_property_id,
    function_id,
    fixed_value,
    way,
    xpath_to_xml_string,
    xpath,
    label,
    description,
    status
  )
  VALUES
  (
    (
      SELECT Nvl(Max(im.invoke_mapping_id),0)+1
      FROM   invoke_mapping im
    ),
    ln_invoke_id,
    'SP',
    SP_RELEASE_FLAG,
    '',
    '',
    '=>',
    '',
    '',
    'releaseFlag',
    'Release Flag',
    'A'
  );

  INSERT INTO invoke_mapping
  (
    invoke_mapping_id,
    invoke_id,
    attribute_type,
    subscriber_property_id,
    function_id,
    fixed_value,
    way,
    xpath_to_xml_string,
    xpath,
    label,
    description,
    status
  )
  VALUES
  (
    (
      SELECT Nvl(Max(im.invoke_mapping_id),0)+1
      FROM   invoke_mapping im
    ),
    ln_invoke_id,
    'SP',
    SP_DISPLAY_PROFILE_NAME,
    '',
    '',
    '=>',
    '',
    '',
    'displayProfileName',
    'Display Profile Name',
    'A'
  );

  INSERT INTO invoke_mapping
  (
    invoke_mapping_id,
    invoke_id,
    attribute_type,
    subscriber_property_id,
    function_id,
    fixed_value,
    way,
    xpath_to_xml_string,
    xpath,
    label,
    description,
    status
  )
  VALUES
  (
    (
      SELECT Nvl(Max(im.invoke_mapping_id),0)+1
      FROM   invoke_mapping im
    ),
    ln_invoke_id,
    'SP',
    SP_EID,
    '',
    '',
    '<=',
    '',
    '$.eid',
    '',
    '',
    'A'
  );

  INSERT INTO invoke_mapping
  (
    invoke_mapping_id,
    invoke_id,
    attribute_type,
    subscriber_property_id,
    function_id,
    fixed_value,
    way,
    xpath_to_xml_string,
    xpath,
    label,
    description,
    status
  )
  VALUES
  (
    (
      SELECT Nvl(Max(im.invoke_mapping_id),0)+1
      FROM   invoke_mapping im
    ),
    ln_invoke_id,
    'SP',
    SP_STATUS,
    '',
    '',
    '<=',
    '',
    '$.header.functionExecutionStatus.status',
    '',
    '',
    'A'
  );

  INSERT INTO invoke_mapping
  (
    invoke_mapping_id,
    invoke_id,
    attribute_type,
    subscriber_property_id,
    function_id,
    fixed_value,
    way,
    xpath_to_xml_string,
    xpath,
    label,
    description,
    status
  )
  VALUES
  (
    (
      SELECT Nvl(Max(im.invoke_mapping_id),0)+1
      FROM   invoke_mapping im
    ),
    ln_invoke_id,
    'SP',
    SP_ERRORMESSAGE,
    '',
    '',
    '<=',
    '',
    '$.serviceException.text',
    '',
    '',
    'A'
  );

  INSERT INTO invoke_mapping
  (
    invoke_mapping_id,
    invoke_id,
    attribute_type,
    subscriber_property_id,
    function_id,
    fixed_value,
    way,
    xpath_to_xml_string,
    xpath,
    label,
    description,
    status
  )
  VALUES
  (
    (
      SELECT Nvl(Max(im.invoke_mapping_id),0)+1
      FROM   invoke_mapping im
    ),
    ln_invoke_id,
    'SP',
    SP_ERRORCODE,
    '',
    '',
    '<=',
    '',
    '$.serviceException.messageId',
    '',
    '',
    'A'
  );

  INSERT INTO invoke_mapping
  (
    invoke_mapping_id,
    invoke_id,
    attribute_type,
    subscriber_property_id,
    function_id,
    fixed_value,
    way,
    xpath_to_xml_string,
    xpath,
    label,
    description,
    status
  )
  VALUES
  (
    (
      SELECT Nvl(Max(im.invoke_mapping_id),0)+1
      FROM   invoke_mapping im
    ),
    ln_invoke_id,
    'SP',
    SP_ERRORVARIABLES,
    '',
    '',
    '<=',
    '',
    '$.serviceException.variables',
    '',
    '',
    'A'
  );

  INSERT INTO invoke_mapping
  (
    invoke_mapping_id,
    invoke_id,
    attribute_type,
    subscriber_property_id,
    function_id,
    fixed_value,
    way,
    xpath_to_xml_string,
    xpath,
    label,
    description,
    status
  )
  VALUES
  (
    (
      SELECT Nvl(Max(im.invoke_mapping_id),0)+1
      FROM   invoke_mapping im
    ),
    ln_invoke_id,
    'SP',
    SP_SMDP_ADDRESS,
    '',
    '',
    '<=',
    '',
    '$.smdpAddress',
    '',
    '',
    'A'
  );

  --response evalutaion (ESTAN DESHABILITADOS)
  INSERT INTO invoke_response_evaluation
  (
    invoke_response_evaluation_id,
    invoke_id,
    order_by,
    xpath,
    evaluation_type,
    expected_value,
    value_type,
    evaluation_operator,
    success,
    failure_message,
    status
  )
  VALUES
  (
    (
      SELECT Nvl(Max(IR.invoke_response_evaluation_id),0) + 1
      FROM   invoke_response_evaluation IR
    ),
    ln_invoke_id,
    10,
    '$.serviceException.messageId',
    'FV',
    null,
    'VARCHAR',
    '!=',
    'NO',
    'SEP=#ERRORMESSAGE#ERRORVARIABLES# Ocurrio un error en el API ConfirmOrder: %s (%s)',
    'I' --Inhabilitado? Revisar
  );

  INSERT INTO invoke_response_evaluation
  (
    invoke_response_evaluation_id,
    invoke_id,
    order_by,
    xpath,
    evaluation_type,
    expected_value,
    value_type,
    evaluation_operator,
    success,
    failure_message,
    status
  )
  VALUES
  (
    (
      SELECT Nvl(Max(IR.invoke_response_evaluation_id),0) + 1
      FROM   invoke_response_evaluation IR
    ),
    ln_invoke_id,
    20,
    '$.header.functionExecutionStatus.status',
    'FV',
    'Failed',
    'VARCHAR',
    '==',
    'NO',
    'SEP=#ERRORMESSAGE#ERRORVARIABLES# Ocurrio un error en el API ConfirmOrder: %s (%s)',
    'I' --Inhabilitado? Revisar
  );
  
  dbms_output.Put_line('INVOKE ID: '|| ln_invoke_id );
  dbms_output.Put_line('---------------REFRESH--------------------------------------');
  dbms_output.put_line('http://192.168.37.146:8101/quickWin/refreshInvokeById/'||ln_invoke_id);
  dbms_output.Put_line('---------------GUARDE ESTE SCRIPT POR MAYOR SEGURIDAD-------------------------------------');
  dbms_output.Put_line('---------------SELECT--------------------------------------');
  dbms_output.Put_line('SELECT * FROM INVOKE T WHERE T.INVOKE_ID = '''||ln_invoke_id||''';');
  dbms_output.Put_line('SELECT * FROM EXTERNAL_RESOURCE_GROUPS T WHERE T.EXTERNAL_RESOURCE_GROUP_ID = '''||ln_ext_res_group_id||''';');
  dbms_output.Put_line('SELECT * FROM EXTERNAL_RESOURCES T WHERE T.EXTERNAL_RESOURCE_ID = '''||ln_ext_res_id||''';');
  dbms_output.Put_line('SELECT * FROM EXTERNAL_RESOURCE_COMPONENTS T WHERE T.EXTERNAL_RESOURCE_ID = '''||ln_ext_res_id||''';');
  dbms_output.Put_line('SELECT * FROM INVOKE_MAPPING T WHERE T.INVOKE_ID = '''||ln_invoke_id||''';');
  dbms_output.Put_line('SELECT * FROM INVOKE_RESPONSE_EVALUATION T WHERE T.INVOKE_ID = '''||ln_invoke_id||''';');
  dbms_output.Put_line('--------------UPDATE STATUS---------------------------------------');
  dbms_output.Put_line('update INVOKE T set status = ''I'' WHERE T.INVOKE_ID = '''||ln_invoke_id||''';');
  dbms_output.Put_line('update EXTERNAL_RESOURCE_GROUPS T set status = ''I'' WHERE T.EXTERNAL_RESOURCE_GROUP_ID = '''||ln_ext_res_group_id||''';');
  dbms_output.Put_line('update EXTERNAL_RESOURCES T set status = ''I'' WHERE T.EXTERNAL_RESOURCE_ID = '''||ln_ext_res_id||''';');
  dbms_output.Put_line('update EXTERNAL_RESOURCE_COMPONENTS T set status = ''I'' WHERE T.EXTERNAL_RESOURCE_ID = '''||ln_ext_res_id||''';');
  dbms_output.Put_line('update INVOKE_MAPPING T set status = ''I'' WHERE T.INVOKE_ID = '''||ln_invoke_id||''';');
  dbms_output.Put_line('update INVOKE_RESPONSE_EVALUATION T set status = ''I'' WHERE T.INVOKE_ID = '''||ln_invoke_id||''';');
  dbms_output.Put_line('--------------DELETE---------------------------------------');
  dbms_output.Put_line('delete INVOKE_RESPONSE_EVALUATION T WHERE T.INVOKE_ID = '''||ln_invoke_id||''';');
  -- borrar invokes plsql plsql
  -- DELETE invokes advertencia. el siguiente ejemplo,
         -- borras todos los invocadores de un grupo espec�fico. antes de borrar los invocadores,
         -- estos no deben tener referencias. 
  dbms_output.put_line('delete INVOKE_MAPPING T WHERE T.INVOKE_ID = '''||ln_invoke_id||''';');
  dbms_output.Put_line('delete EXTERNAL_RESOURCE_COMPONENTS T WHERE T.EXTERNAL_RESOURCE_ID = '''||ln_ext_res_id||''';');
  dbms_output.Put_line('delete EXTERNAL_RESOURCES T WHERE T.EXTERNAL_RESOURCE_ID = '''||ln_ext_res_id||''';');
  dbms_output.Put_line('delete EXTERNAL_RESOURCE_GROUPS T WHERE T.EXTERNAL_RESOURCE_GROUP_ID = '''||ln_ext_res_group_id||''';');
  dbms_output.Put_line('delete INVOKE T WHERE T.INVOKE_ID = '''||ln_invoke_id||''';');
  dbms_output.Put_line('---------------REQUEST----------------------------------------------');
  dbms_output.Put_line('http://192.168.37.146:8101/quickWin/executeInvoke');
  dbms_output.Put_line('---------------POST REST--------------------------------- -----');
  dbms_output.Put_line('{
  "invokeId": "'||ln_invoke_id||'", 
  "invokerName": "Prueba Invoke", 
  "cacheOptions":"0", 
  "sync":"YES", 
  "customerInvokerId":"id12345", 
  "sessionData": { 
    "externalSubscriberProperties": [');
  FOR subs IN
  (
         SELECT T.subscriber_property_id
         FROM   invoke_mapping T
         WHERE  T.invoke_id = ln_invoke_id
         AND    T.way != '<='
         AND    T.SUBSCRIBER_PROPERTY_ID NOT LIKE '%$%'
         AND    T.subscriber_property_id IS NOT NULL)
  LOOP
    dbms_output.Put_line(' {"id": "'
    ||subs.subscriber_property_id
    ||'","value": [""]},');
  END LOOP;
  dbms_output.Put_line(' {"id": "'
  ||'DUMMY'
  ||'","value": [""]}');
  dbms_output.Put_line(' ] } }');
END;