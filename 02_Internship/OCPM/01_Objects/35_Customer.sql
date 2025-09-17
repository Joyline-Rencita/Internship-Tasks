                   **************************          KNA1         ******************************

SELECT <%=sourceSystem%>  || 'Customer_' || "KNA1"."MANDT" || "KNA1"."KUNNR" AS "ID",
    "KNA1"."NAME1"                                                           AS "Name",
    CASE WHEN "KNA1"."VBUND" IS NULL THEN FALSE ELSE TRUE END                AS "InternalFlag",
    "KNA1"."LAND1"                                                           AS "Country",
    "KNA1"."REGIO"                                                           AS "Region",
    "KNA1"."ORT01"                                                           AS "City",
    "KNA1"."PSTLZ"                                                           AS "PostalCode",
    "KNA1"."STRAS"                                                           AS "AddressLine1",
    NULL                                                                     AS "AddressLine2",
    "KNA1"."KUNNR"                                                           AS "Number",
    'SAP'                                                                    AS "SourceSystemType",
	<%=sourceSystem%>  || "KNA1"."MANDT"                                     AS "SourceSystemInstance"
					   
FROM "KNA1" AS "KNA1"
WHERE "KNA1"."MANDT" IS NOT NULL


==================================================================================================================================================================


                  ************************          CHANGES-KNA1      **************************


SELECT <%=sourceSystem%>  || 'Customer_' || "KNA1"."MANDT" || "KNA1"."KUNNR" 	AS "ObjectID",
	<%=sourceSystem%>  || "CDPOS"."TABKEY" || "CDPOS"."TABNAME" || "CDPOS"."FNAME"
       || "CDPOS"."CHANGENR" || "CDPOS"."CHNGIND"                            	AS "ID",
       CAST("CDHDR"."UDATE" AS DATE)
            + CAST(TIMESTAMPDIFF(SECOND, CAST("CDHDR"."UTIME" AS DATE),
            "CDHDR"."UTIME") AS INTERVAL SECOND)                             	AS "Time",
       CASE
           WHEN "CDPOS"."FNAME" = 'LAND1' THEN 'Country'
           WHEN "CDPOS"."FNAME" = 'NAME1' THEN 'Name'
           WHEN "CDPOS"."FNAME" = 'ORT01' THEN 'City'
           WHEN "CDPOS"."FNAME" = 'PSTLZ' THEN 'PostalCode'
           WHEN "CDPOS"."FNAME" = 'REGIO' THEN 'Region'
           WHEN "CDPOS"."FNAME" = 'STRAS' THEN 'AddressLine1'
           WHEN "CDPOS"."FNAME" = 'VBUND' THEN 'InternalTradingPartner'
           END                                                               	AS "Attribute",
       CASE
           WHEN "CDPOS"."VALUE_OLD" LIKE '%-' THEN CONCAT('-', REPLACE(LTRIM("CDPOS"."VALUE_OLD"), '-', ''))
           ELSE "CDPOS"."VALUE_OLD" END                                      	AS "OldValue",
       CASE
           WHEN "CDPOS"."VALUE_NEW" LIKE '%-' THEN CONCAT('-', REPLACE(LTRIM("CDPOS"."VALUE_NEW"), '-', ''))
           ELSE "CDPOS"."VALUE_NEW" END                                      	AS "NewValue",
       'User_' || "CDHDR"."MANDANT" || "CDHDR"."USERNAME"                    	AS "ChangedBy",
       "CDHDR"."TCODE"                                                       	AS "OperationType",
       "CDHDR"."CHANGENR"                                                    	AS "OperationID",
       CASE
           WHEN "USR02"."USTYP" IN ('B', 'C') THEN 'Automatic'
           ELSE 'Manual' END                                                 	AS "ExecutionType"
					   
FROM "KNA1" AS "KNA1"
         LEFT JOIN "CDPOS" AS "CDPOS" ON
            "KNA1"."MANDT" = "CDPOS"."MANDANT"
            AND "CDPOS"."TABNAME" = 'KNA1'
            AND "CDPOS"."TABKEY" = "KNA1"."MANDT" || "KNA1"."KUNNR"
            AND "CDPOS"."CHNGIND" = 'U'
         LEFT JOIN "CDHDR" AS "CDHDR" ON
            "CDPOS"."MANDANT" = "CDHDR"."MANDANT"
            AND "CDPOS"."OBJECTCLAS" = "CDHDR"."OBJECTCLAS"
            AND "CDPOS"."OBJECTID" = "CDHDR"."OBJECTID"
            AND "CDPOS"."CHANGENR" = "CDHDR"."CHANGENR"
         LEFT JOIN "USR02" AS "USR02"
                   ON "CDHDR"."USERNAME" = "USR02"."BNAME"
                       AND "CDHDR"."MANDANT" = "USR02"."MANDT"
WHERE "CDPOS"."FNAME" IN ('LAND1', 'NAME1', 'ORT01', 'PSTLZ', 'REGIO', 'STRAS', 'VBUND')
  AND "KNA1"."MANDT" IS NOT NULL
  AND "CDPOS"."MANDANT" IS NOT NULL
  AND "CDHDR"."MANDANT" IS NOT NULL
