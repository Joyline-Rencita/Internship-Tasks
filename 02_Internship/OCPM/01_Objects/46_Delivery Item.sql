                        ************************        LIPS         *******************************

SELECT <%=sourceSystem%>  || 'DeliveryItem_' || "LIPS"."MANDT" || "LIPS"."VBELN" || "LIPS"."POSNR" 		AS "ID",
    CAST("LIPS"."ERDAT" AS DATE)
            + CAST(TIMESTAMPDIFF(SECOND, CAST("LIPS"."ERZET" AS DATE),
            "LIPS"."ERZET") AS INTERVAL SECOND)                                                    		AS "CreationTime",
	<%=sourceSystem%>  || 'Delivery_' || "LIPS"."MANDT" || "LIPS"."VBELN"                             	AS "Header",
	<%=sourceSystem%>  || 'User_' || "LIPS"."MANDT" || "LIPS"."ERNAM"                                 	AS "CreatedBy",
    CASE
        WHEN "USR02"."USTYP" IN ('B', 'C') THEN 'Automatic'
        ELSE 'Manual' END                                                                          		AS "CreationExecutionType",
    "LIPS"."LFIMG"                                                                                 		AS "Quantity",
    "LIPS"."VRKME"                                                                                 		AS "QuantityUnit",
    "LIPS"."NTGEW"                                                                                 		AS "NetWeight",
    "LIPS"."GEWEI"                                                                                 AS "WeightUnit",
    "LIPS"."VOLUM"                                                                                 AS "Volume",
    "LIPS"."VOLEH"                                                                                 AS "VolumeUnit",
    "LIPS"."LGORT"                                                                                 AS "StorageLocation",
    'SAP'                                                                                          AS "SourceSystemType",
	<%=sourceSystem%>  || "LIPS"."MANDT"                                                              AS "SourceSystemInstance",
    "LIPS"."VBELN"                                                                                 AS "SystemDeliveryNumber",
    "LIPS"."POSNR"                                                                                 AS "SystemDeliveryItemNumber",
    "LIPS"."VBELN"                                                                                 AS "DatabaseDeliveryNumber",
    "LIPS"."POSNR"                                                                                 AS "DatabaseDeliveryItemNumber",
	<%=sourceSystem%>  || CASE
        WHEN "LIPS"."VGTYP" IN ('C', 'I') THEN
            'SalesOrderItem_' || "LIPS"."MANDT" || "LIPS"."VGBEL" || "LIPS"."VGPOS"
        END                                                                                        AS "SalesOrderItem",
	<%=sourceSystem%>  || 'Material_' || "LIPS"."MANDT" || "LIPS"."MATNR"                             AS "Material",
	<%=sourceSystem%>  || 'Plant_' || "LIPS"."MANDT" || "LIPS"."WERKS"                                AS "Plant"
FROM "LIPS" AS "LIPS"
         LEFT JOIN "LIKP" AS "LIKP"
                   ON "LIPS"."MANDT" = "LIKP"."MANDT"
                       AND "LIPS"."VBELN" = "LIKP"."VBELN"
         LEFT JOIN "USR02" AS "USR02"
                   ON "LIPS"."ERNAM" = "USR02"."BNAME"
                       AND "LIPS"."MANDT" = "USR02"."MANDT"
WHERE "LIPS"."MANDT" IS NOT NULL
  AND "LIKP"."VBTYP" = 'J'


================================================================================================================================================================


                  **********************          CDPOS      ***************************

SELECT <%=sourceSystem%>  || 'DeliveryItem_' || "CDPOS"."TABKEY" AS "ObjectID",
	<%=sourceSystem%>  || "CDPOS"."TABKEY" || "CDPOS"."TABNAME" || "CDPOS"."FNAME"
       || "CDPOS"."CHANGENR" || "CDPOS"."CHNGIND"                AS "ID",
       CAST("CDHDR"."UDATE" AS DATE)
            + CAST(TIMESTAMPDIFF(SECOND, CAST("CDHDR"."UTIME" AS DATE),
            "CDHDR"."UTIME") AS INTERVAL SECOND)                 AS "Time",
       CASE
           WHEN "CDPOS"."FNAME" = 'GEWEI' THEN 'WeightUnit'
           WHEN "CDPOS"."FNAME" = 'LFIMG' THEN 'Quantity'
           WHEN "CDPOS"."FNAME" = 'LGORT' THEN 'StorageLocation'
           WHEN "CDPOS"."FNAME" = 'MATWA' THEN 'MaterialGroup'
           WHEN "CDPOS"."FNAME" = 'NTGEW' THEN 'NetWeight'
           WHEN "CDPOS"."FNAME" = 'VOLEH' THEN 'VolumeUnit'
           WHEN "CDPOS"."FNAME" = 'VOLUM' THEN 'Volume'
           WHEN "CDPOS"."FNAME" = 'WERKS' THEN 'Plant'
           END                                                   AS "Attribute",
       CASE
           WHEN "CDPOS"."VALUE_OLD" LIKE '%-' THEN CONCAT('-', REPLACE(LTRIM("CDPOS"."VALUE_OLD"), '-', ''))
           ELSE "CDPOS"."VALUE_OLD" END                          AS "OldValue",
       CASE
           WHEN "CDPOS"."VALUE_NEW" LIKE '%-' THEN CONCAT('-', REPLACE(LTRIM("CDPOS"."VALUE_NEW"), '-', ''))
           ELSE "CDPOS"."VALUE_NEW" END                          AS "NewValue",
       'User_' || "CDHDR"."MANDANT" || "CDHDR"."USERNAME"        AS "ChangedBy",
       "CDHDR"."TCODE"                                           AS "OperationType",
       "CDHDR"."CHANGENR"                                        AS "OperationID",
       CASE
           WHEN "USR02"."USTYP" IN ('B', 'C') THEN 'Automatic'
           ELSE 'Manual' END                                     AS "ExecutionType"
FROM "CDPOS" AS "CDPOS"
         LEFT JOIN "CDHDR" AS "CDHDR"
                   ON "CDPOS"."MANDANT" = "CDHDR"."MANDANT"
                       AND "CDPOS"."OBJECTCLAS" = "CDHDR"."OBJECTCLAS"
                       AND "CDPOS"."OBJECTID" = "CDHDR"."OBJECTID"
                       AND "CDPOS"."CHANGENR" = "CDHDR"."CHANGENR"
                       AND "CDPOS"."OBJECTCLAS" = 'LIEFERUNG'
         LEFT JOIN "LIKP" AS "LIKP"
                   ON SUBSTRING("CDPOS"."TABKEY", 1, 13) = "LIKP"."MANDT" || "LIKP"."VBELN"
         LEFT JOIN "USR02" AS "USR02"
                   ON "CDHDR"."USERNAME" = "USR02"."BNAME"
                       AND "CDHDR"."MANDANT" = "USR02"."MANDT"
WHERE "CDPOS"."TABNAME" = 'LIPS'
  AND "CDPOS"."FNAME" IN ('GEWEI', 'LFIMG', 'LGORT', 'MATWA', 'NTGEW', 'VOLEH', 'VOLUM', 'WERKS')
  AND "CDPOS"."CHNGIND" = 'U'
  AND "LIKP"."VBTYP" = 'J'
  AND "CDPOS"."MANDANT" IS NOT NULL
  AND "CDHDR"."MANDANT" IS NOT NULL
  AND "LIKP"."MANDT" IS NOT NULL
