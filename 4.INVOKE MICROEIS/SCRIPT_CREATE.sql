DECLARE
  -- Local variables here
  ln_invoke_id          NUMBER := 0;
  ln_ext_res_group_id   NUMBER := 0;
  ln_ext_res_id         NUMBER := 0;
  lv_description        VARCHAR(255) := '[22385] ';
  SP_COUNTER            NUMBER:=0;
  SP_ICCID              VARCHAR2(60) := 'ICCID';
  SP_CODE               VARCHAR2(60) := 'CODE';
  SP_MENSAJE            VARCHAR2(60) := 'MENSAJE';
  SP_INFORMATION_SERVICE   VARCHAR2(60) := 'INFORMATION_SERVICE';
  SP_ESTADO             VARCHAR2(60) := 'ESTADO';

BEGIN
  SELECT Min(S.external_resource_group_id) EXTERNAL_RESOURCE_GROUP_ID
  INTO   ln_ext_res_group_id
  FROM   external_resource_groups s
  WHERE  Upper(s.description) LIKE Upper('%[22385]%')
  AND    Upper(s.description) LIKE Upper('%DownloadOrder%');
  
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
  WHERE SUBSCRIBER_PROPERTY_ID = SP_ICCID;
  IF SP_COUNTER = 0 THEN
    INSERT INTO subscriber_properties(subscriber_property_id,description,status)
    VALUES (SP_ICCID,lv_description||'eSIM QR Code - ICCID','A');
  END IF;

  SELECT count(SUBSCRIBER_PROPERTY_ID) INTO SP_COUNTER
  FROM SUBSCRIBER_PROPERTIES
  WHERE SUBSCRIBER_PROPERTY_ID = SP_CODE;
  IF SP_COUNTER = 0 THEN
    INSERT INTO subscriber_properties(subscriber_property_id,description,status)
    VALUES (SP_CODE,lv_description||' Activacion - Codigo de retorno','A');
  END IF;

  SELECT count(SUBSCRIBER_PROPERTY_ID) INTO SP_COUNTER
  FROM SUBSCRIBER_PROPERTIES
  WHERE SUBSCRIBER_PROPERTY_ID = SP_MENSAJE;
  IF SP_COUNTER = 0 THEN
    INSERT INTO subscriber_properties(subscriber_property_id,description,status)
    VALUES (SP_MENSAJE,lv_description||'CANCELCLOUDPRODUCT - MENSAJE DE RETORNO DEL SRE','A');
  END IF;

  SELECT count(SUBSCRIBER_PROPERTY_ID) INTO SP_COUNTER
  FROM SUBSCRIBER_PROPERTIES
  WHERE SUBSCRIBER_PROPERTY_ID = SP_INFORMATION_SERVICE;
  IF SP_COUNTER = 0 THEN
    INSERT INTO subscriber_properties(subscriber_property_id,description,status)
    VALUES (SP_INFORMATION_SERVICE,'INFORMATION_SERVICE','A');
  END IF;

  SELECT count(SUBSCRIBER_PROPERTY_ID) INTO SP_COUNTER
  FROM SUBSCRIBER_PROPERTIES
  WHERE SUBSCRIBER_PROPERTY_ID = SP_ESTADO;
  IF SP_COUNTER = 0 THEN
    INSERT INTO subscriber_properties(subscriber_property_id,description,status)
    VALUES (SP_ESTADO,'ESTADO','A');
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
    '[22385] eSIM QR Code - MicroEis ESIM:ConsultaICCIDCompleto',
    'Consulta de ICCID completo atravez de ICCID con 18 digitos',
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
</xsl:stylesheet>',
    1000,
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
    'http://micro-jeis-silver.router-default.apps.aro-dev.conecel.com/microjeis/resources/ws/eipConsumeServicioMicroEis',
    '[22385] eSIM QR Code- Endpoint de MicroEis',
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
    '[22385] eSIM QR Code - MicroEis ESIM:ConsultaICCIDCompleto',
    'Consulta de ICCID 19 digitos por ICCID 18 digitos',
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
    'SP',
    SP_ICCID,
    '',
    '',
    '=>',
    '',
    '',
    '_ICCID',
    'ICCID con 18 digitos',
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
    '<=',
    '',
    '$.response[0].ICCID',
    '',
    'ICCID con 19 digitos',
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
    SP_CODE,
    '',
    '',
    '<=',
    '',
    '$.code',
    '',
    'Codigo de respuesta',
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
    SP_MENSAJE,
    '',
    '',
    '<=',
    '',
    '$.message',
    '',
    'Mensaje de respuesta',
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
    SP_INFORMATION_SERVICE,
    '',
    '',
    '=>',
    '',
    '',
    '_informationService',
    'Information Service de MicroEis',
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
    SP_ESTADO,
    '',
    '',
    '<=',
    '',
    '$.response[0].ESTADO',
    '',
    'Estado de ICCID',
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
    SP_ESTADO,
    '',
    '',
    '=>',
    '',
    '',
    '_estado',
    'Estado de ICCID',
    'A'
  );

  --response evalutaion
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
    '$.code',
    'FV',
    0,
    'VARCHAR',
    '==',
    'YES',
    'SEP=#MENSAJE#Error en consulta con MicroEis: %s',
    'A'
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
    status,
    fail_code
  )
  VALUES
  (
    (
      SELECT Nvl(Max(IR.invoke_response_evaluation_id),0) + 1
      FROM   invoke_response_evaluation IR
    ),
    ln_invoke_id,
    20,
    '$.response[0].ICCID',
    'FV',
    '',
    'VARCHAR',
    '!=',
    'YES',
    'No se encontro el ICCID registrado en repositorio eSIM',
    'A',
    10
  );
  
  dbms_output.Put_line('INVOKE ID: '|| ln_invoke_id );
  dbms_output.Put_line('---------------REFRESH---------------------------------- ----');
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