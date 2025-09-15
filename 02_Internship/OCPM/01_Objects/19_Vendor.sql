                     **************************          LFA1       ****************************

SELECT <%=sourceSystem%>  || 'Vendor_' || "LFA1"."MANDT" || "LFA1"."LIFNR"||"LFA1"."NAME1" AS "ID",
       "LFA1"."LAND1"                                                      AS "Country",
       "LFA1"."NAME1"                                                      AS "Name",
       "LFA1"."ORT01"                                                      AS "City",
       CASE WHEN "LFA1"."VBUND" IS NULL THEN FALSE ELSE TRUE END           AS "InternalFlag",
       "LFA1"."LIFNR"                                                      AS "Number",
       'SAP'                                                               AS "SourceSystemType",
	<%=sourceSystem%>  || "LFA1"."MANDT"                                   AS "SourceSystemInstance"
FROM "LFA1" AS "LFA1"
