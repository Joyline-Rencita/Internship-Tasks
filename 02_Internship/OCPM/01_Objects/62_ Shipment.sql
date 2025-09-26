                ******************************      VTTK      ************************************

SELECT <%=sourceSystem%>  || 'Shipment_' || "VTTK"."MANDT" || "VTTK"."TKNUM" 						AS "ID",
    CAST("VTTK"."ERDAT" AS DATE) + CAST(TIMESTAMPDIFF(SECOND, CAST("VTTK"."ERZET" AS DATE),
            "VTTK"."ERZET") AS INTERVAL SECOND)                              						AS "CreationTime",
	<%=sourceSystem%>  || 'User_' || "VTTK"."MANDT" || "VTTK"."ERNAM"           					AS "CreatedBy",
    CASE
        WHEN "USR02"."USTYP" IN ('B', 'C') THEN 'Automatic'
        ELSE 'Manual' END                                                    						AS "CreationExecutionType",
    'SAP'                                                                    						AS "SourceSystemType",
	<%=sourceSystem%>  || "VTTK"."MANDT"                                        					AS "SourceSystemInstance",
    "VTTK"."TKNUM"                                                           						AS "SystemShipmentNumber",
    "VTTK"."TKNUM"                                                           AS "DatabaseShipmentNumber",
    "VTTK"."SHTYP"                                                           AS "ShippingType",
    "VTTK"."VSBED"                                                           AS "ShippingConditions",
    "VTTK"."ROUTE"                                                           AS "ShipmentRoute"

  FROM "VTTK" AS "VTTK"
         LEFT JOIN "USR02" AS "USR02"
         ON "VTTK"."MANDT" = "USR02"."MANDT"
         AND "VTTK"."ERNAM" = "USR02"."BNAME"

=====================================================================================================================================================================


                  *****************************        CDPOS      *********************************

SELECT <%=sourceSystem%>  || 'Shipment_' || "CDPOS"."TABKEY" AS "ObjectID",
	<%=sourceSystem%>  || "CDPOS"."TABKEY" || "CDPOS"."TABNAME" || "CDPOS"."FNAME"
       || "CDPOS"."CHANGENR" || "CDPOS"."CHNGIND"            AS "ID",
       CAST("CDHDR"."UDATE" AS DATE) + CAST(TIMESTAMPDIFF(SECOND, CAST("CDHDR"."UTIME" AS DATE),
            "CDHDR"."UTIME") AS INTERVAL SECOND)             AS "Time",
       CASE
           WHEN "CDPOS"."FNAME" = 'ROUTE' THEN 'ShipmentRoute'
           WHEN "CDPOS"."FNAME" = 'SHTYP' THEN 'ShippingType'
           WHEN "CDPOS"."FNAME" = 'VSBED' THEN 'ShippingConditions'
           END                                               AS "Attribute",
       CASE
           WHEN "CDPOS"."VALUE_OLD" LIKE '%-' THEN CONCAT('-', REPLACE(LTRIM("CDPOS"."VALUE_OLD"), '-', ''))
           ELSE "CDPOS"."VALUE_OLD" END                      AS "OldValue",
       CASE
           WHEN "CDPOS"."VALUE_NEW" LIKE '%-' THEN CONCAT('-', REPLACE(LTRIM("CDPOS"."VALUE_NEW"), '-', ''))
           ELSE "CDPOS"."VALUE_NEW" END                      AS "NewValue",
       'User_' || "CDHDR"."MANDANT" || "CDHDR"."USERNAME"    AS "ChangedBy",
       "CDHDR"."TCODE"                                       AS "OperationType",
       "CDHDR"."CHANGENR"                                    AS "OperationID",
       CASE
           WHEN "USR02"."USTYP" IN ('B', 'C') THEN 'Automatic'
           ELSE 'Manual' END                                 AS "ExecutionType"
FROM "CDPOS" AS "CDPOS"
         LEFT JOIN "CDHDR" AS "CDHDR"
                   ON "CDPOS"."MANDANT" = "CDHDR"."MANDANT"
                       AND "CDPOS"."OBJECTCLAS" = "CDHDR"."OBJECTCLAS"
                       AND "CDPOS"."OBJECTID" = "CDHDR"."OBJECTID"
                       AND "CDPOS"."CHANGENR" = "CDHDR"."CHANGENR"
                       AND "CDPOS"."OBJECTCLAS" = 'TRANSPORT'
         LEFT JOIN "USR02" AS "USR02"
                   ON "CDHDR"."USERNAME" = "USR02"."BNAME"
                       AND "CDHDR"."MANDANT" = "USR02"."MANDT"
WHERE "CDPOS"."TABNAME" = 'VTTK'
  AND "CDPOS"."FNAME" IN ('ROUTE', 'SHTYP', 'VSBED')
  AND "CDPOS"."CHNGIND" = 'U'
  AND "CDPOS"."MANDANT" IS NOT NULL
  AND "CDHDR"."MANDANT" IS NOT NULL
