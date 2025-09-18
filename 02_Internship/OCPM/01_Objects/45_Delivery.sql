                ********************        LIPK      *****************************

SELECT <%=sourceSystem%>  || 'Delivery_' || "LIKP"."MANDT" || "LIKP"."VBELN" 				AS "ID",
    CAST("LIKP"."ERDAT" AS DATE)
            + CAST(TIMESTAMPDIFF(SECOND, CAST("LIKP"."ERZET" AS DATE),
            "LIKP"."ERZET") AS INTERVAL SECOND)                              				AS "CreationTime",
	<%=sourceSystem%>  || 'User_' || "LIKP"."MANDT" || "LIKP"."ERNAM"           			AS "CreatedBy",
    CASE
        WHEN "USR02"."USTYP" IN ('B', 'C') THEN 'Automatic'
        ELSE 'Manual' END                                                    				AS "CreationExecutionType",
    "LIKP"."LFART"                                                           				AS "DeliveryType",
    CAST("LIKP"."KODAT" AS DATE) + CAST(TIMESTAMPDIFF(SECOND, CAST("LIKP"."KOUHR" AS DATE),
                    "LIKP"."KOUHR") AS INTERVAL SECOND)                      				AS "PickingDate",
    CAST("LIKP"."PODAT" AS DATE) + CAST(TIMESTAMPDIFF(SECOND, CAST("LIKP"."POTIM" AS DATE),
                    "LIKP"."POTIM") AS INTERVAL SECOND)                      				AS "ProofOfDeliveryDate",
    CAST("LIKP"."LFDAT" AS TIMESTAMP)                                        				AS "DeliveryDate",
    "LIKP"."NTGEW"                                                           				AS "NetWeight",
    "LIKP"."BTGEW"                                                           				AS "GrossWeight",
    "LIKP"."GEWEI"                                                           				AS "WeightUnit",
    "LIKP"."VOLUM"                                                           				AS "Volume",
    "LIKP"."VOLEH"                                                           				AS "VolumeUnit",
    'SAP'                                                                    				AS "SourceSystemType",
	<%=sourceSystem%>  || "LIKP"."MANDT"                                        			AS "SourceSystemInstance",
    "LIKP"."VBELN"                                                           				AS "SystemDeliveryNumber",
    "LIKP"."VBELN"                                                           				AS "DatabaseDeliveryNumber",
	<%=sourceSystem%>  || 'Customer_' || "LIKP"."MANDT" || "LIKP"."KUNNR"       			AS "Customer",
    CAST("LIKP"."WADAT" AS TIMESTAMP)                                        				AS "ExpectedGoodsIssueDate"
FROM "LIKP" AS "LIKP"
         LEFT JOIN "USR02" AS "USR02"
                   ON "LIKP"."MANDT" = "USR02"."MANDT"
                       AND "LIKP"."ERNAM" = "USR02"."BNAME"
WHERE "LIKP"."MANDT" IS NOT NULL
  AND "LIKP"."VBTYP" = 'J'


===================================================================================================================================================================


                      ****************************          CDPOS        *********************************


SELECT <%=sourceSystem%>  || 'Delivery_' || "CDPOS"."TABKEY" 		AS "ObjectID",
	<%=sourceSystem%>  || "CDPOS"."TABKEY" || "CDPOS"."TABNAME" || "CDPOS"."FNAME"
           || "CDPOS"."CHANGENR" || "CDPOS"."CHNGIND"        		AS "ID",
       CAST("CDHDR"."UDATE" AS DATE)
            + CAST(TIMESTAMPDIFF(SECOND, CAST("CDHDR"."UTIME" AS DATE),
            "CDHDR"."UTIME") AS INTERVAL SECOND)             		AS "Time",
       CASE
           WHEN "CDPOS"."FNAME" = 'BTGEW' THEN 'TotalWeight'
           WHEN "CDPOS"."FNAME" = 'BZIRK' THEN 'SalesDistrict'
           WHEN "CDPOS"."FNAME" = 'GEWEI' THEN 'WeightUnit'
           WHEN "CDPOS"."FNAME" = 'KODAT' THEN 'PickingDate'
           WHEN "CDPOS"."FNAME" = 'LFART' THEN 'DeliveryType'
           WHEN "CDPOS"."FNAME" = 'LFDAT' THEN 'DeliveryDate'
           WHEN "CDPOS"."FNAME" = 'NTGEW' THEN 'NetWeight'
           WHEN "CDPOS"."FNAME" = 'PODAT' THEN 'ProofOfDeliveryDate'
           WHEN "CDPOS"."FNAME" = 'ROUTE' THEN 'Route'
           WHEN "CDPOS"."FNAME" = 'VKORG' THEN 'SalesOrganization'
           WHEN "CDPOS"."FNAME" = 'VOLEH' THEN 'VolumeUnit'
           WHEN "CDPOS"."FNAME" = 'VOLUM' THEN 'Volume'
           WHEN "CDPOS"."FNAME" = 'KOSTK' THEN 'PickingStatus'
           END                                               		AS "Attribute",
       CASE
           WHEN "CDPOS"."VALUE_OLD" LIKE '%-' THEN CONCAT('-', REPLACE(LTRIM("CDPOS"."VALUE_OLD"), '-', ''))
           ELSE "CDPOS"."VALUE_OLD" END                      		AS "OldValue",
       CASE
           WHEN "CDPOS"."VALUE_NEW" LIKE '%-' THEN CONCAT('-', REPLACE(LTRIM("CDPOS"."VALUE_NEW"), '-', ''))
           ELSE "CDPOS"."VALUE_NEW" END                      		AS "NewValue",
       'User_' || "CDHDR"."MANDANT" || "CDHDR"."USERNAME"    		AS "ChangedBy",
       "CDHDR"."TCODE"                                       		AS "OperationType",
       "CDHDR"."CHANGENR"                                    		AS "OperationID",
       CASE
           WHEN "USR02"."USTYP" IN ('B', 'C') THEN 'Automatic'
           ELSE 'Manual' END                                 		AS "ExecutionType"
FROM "CDPOS" AS "CDPOS"
         LEFT JOIN "CDHDR" AS "CDHDR"
                   ON "CDPOS"."MANDANT" = "CDHDR"."MANDANT"
                       AND "CDPOS"."OBJECTCLAS" = "CDHDR"."OBJECTCLAS"
                       AND "CDPOS"."OBJECTID" = "CDHDR"."OBJECTID"
                       AND "CDPOS"."CHANGENR" = "CDHDR"."CHANGENR"
                       AND "CDPOS"."OBJECTCLAS" = 'LIEFERUNG'
         LEFT JOIN "LIKP" AS "LIKP"
                   ON "CDPOS"."TABKEY" = "LIKP"."MANDT" || "LIKP"."VBELN"
         LEFT JOIN "USR02" AS "USR02"
                   ON "CDHDR"."USERNAME" = "USR02"."BNAME"
                       AND "CDHDR"."MANDANT" = "USR02"."MANDT"
WHERE (("CDPOS"."TABNAME" = 'LIKP'
    AND "CDPOS"."FNAME" IN ('BTGEW', 'BZIRK', 'GEWEI', 'KODAT', 'LFART', 'LFDAT', 'NTGEW', 'PODAT', 'ROUTE', 'VKORG',
                            'VOLEH', 'VOLUM'))
    OR ("CDPOS"."TABNAME" = 'VBUK'
        AND "CDPOS"."FNAME" IN ('KOSTK')))
  AND "CDPOS"."CHNGIND" = 'U'
  AND "LIKP"."VBTYP" = 'J'
  AND "CDPOS"."MANDANT" IS NOT NULL
  AND "CDHDR"."MANDANT" IS NOT NULL
  AND "LIKP"."MANDT" IS NOT NULL
