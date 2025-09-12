                   ************************************       EKET         *************************************

SELECT <%=sourceSystem%>  || 'PurchaseOrderScheduleLine_' || "EKET"."MANDT" || "EKET"."EBELN" || "EKET"."EBELP" || "EKET"."ETENR" AS "ID",
    CAST('9999-01-01 00:00:00' AS TIMESTAMP)                                                                                      AS "CreationTime",
    <%=sourceSystem%>  || 'PurchaseOrderItem_' || "EKET"."MANDT" || "EKET"."EBELN"
    || "EKET"."EBELP"                                                                                                             AS "PurchaseOrderItem",
    CAST("EKET"."EINDT" AS TIMESTAMP)                                                                                             AS "ItemDeliveryDate",
    "EKET"."WEMNG"                                                                                                                AS "GoodsReceivedQuantity",
    "EKET"."MENGE"                                                                                                                AS "ScheduledQuantity",
    "EKPO"."MEINS"                                                                                                                AS "QuantityUnit",
    'SAP'                                                                                                                         AS "SourceSystemType",
	<%=sourceSystem%>  || "EKET"."MANDT"                                                                                          AS "SourceSystemInstance",
    "EKET"."EBELN"                                                                                                                AS "SystemPurchaseOrderNumber",
    "EKET"."EBELP"                                                                                                                AS "SystemPurchaseOrderItemNumber",
    "EKET"."ETENR"                                                                                                                AS "SystemPurchaseOrderScheduleLineNumber",
    "EKET"."EBELN"                                                                                                                AS "DatabasePurchaseOrderNumber",
    "EKET"."EBELP"                                                                                                                AS "DatabasePurchaseOrderItemNumber",
    "EKET"."ETENR"                                                                                                                AS "DatabasePurchaseOrderScheduleLineNumber"
FROM "EKET" AS "EKET"
         LEFT JOIN "EKPO" AS "EKPO"
                   ON "EKET"."MANDT" = "EKPO"."MANDT"
                       AND "EKET"."EBELN" = "EKPO"."EBELN"
                       AND "EKET"."EBELP" = "EKPO"."EBELP"
WHERE "EKET"."MANDT" IS NOT NULL

									OR
	
SELECT <%=sourceSystem%>  || 'PurchaseOrderScheduleLine_' || "CDPOS"."TABKEY" AS "ObjectID",
	<%=sourceSystem%>  || "CDPOS"."TABKEY" || "CDPOS"."FNAME"
       || "CDPOS"."TABKEY" || "CDPOS"."TABNAME" || "CDPOS"."FNAME"
       || "CDPOS"."CHANGENR" || "CDPOS"."CHNGIND"                             AS "ID",
       CAST("CDHDR"."UDATE" AS DATE)
            + COALESCE(CAST(TIMESTAMPDIFF(SECOND, CAST("CDHDR"."UTIME" AS DATE),
            "CDHDR"."UTIME") AS INTERVAL SECOND), INTERVAL '86399' SECOND)    AS "Time",
       CASE
           WHEN "CDPOS"."CHNGIND" = 'I' THEN 'CreationTime'
           WHEN "CDPOS"."CHNGIND" = 'D' THEN 'DeletionTime'
           END                                                                AS "Attribute",
       'NULL'                                                                 AS "OldValue",
       'NULL'                                                                 AS "NewValue",
       'User_' || "CDHDR"."MANDANT" || "CDHDR"."USERNAME"                     AS "ChangedBy",
       "CDHDR"."TCODE"                                                        AS "OperationType",
       "CDHDR"."CHANGENR"                                                     AS "OperationID",
       CASE
           WHEN "USR02"."USTYP" IN ('B', 'C') THEN 'Automatic'
           ELSE 'Manual' END                                                  AS "ExecutionType"
FROM "CDPOS" AS "CDPOS"
         LEFT JOIN "CDHDR" AS "CDHDR"
                   ON "CDPOS"."MANDANT" = "CDHDR"."MANDANT"
                       AND "CDPOS"."OBJECTCLAS" = "CDHDR"."OBJECTCLAS"
                       AND "CDPOS"."OBJECTID" = "CDHDR"."OBJECTID"
                       AND "CDPOS"."CHANGENR" = "CDHDR"."CHANGENR"
                       AND "CDPOS"."OBJECTCLAS" = 'EINKBELEG'
         LEFT JOIN "USR02" AS "USR02"
                   ON "CDHDR"."USERNAME" = "USR02"."BNAME"
                       AND "CDHDR"."MANDANT" = "USR02"."MANDT"
WHERE 
-- "CDPOS"."TABNAME" = 'EKET'  -- not available
  "CDPOS"."FNAME" = 'KEY'
  AND "CDPOS"."MANDANT" IS NOT NULL
  AND "CDHDR"."MANDANT" IS NOT NULL



--  ===============================================================================================================================================================


--                        ***********************          CDPOS         *******************************


SELECT <%=sourceSystem%>  || 'PurchaseOrderScheduleLine_' || "CDPOS"."TABKEY" AS "ObjectID",
	<%=sourceSystem%>  || "CDPOS"."TABKEY" || "CDPOS"."FNAME"
       || "CDPOS"."TABKEY" || "CDPOS"."TABNAME" || "CDPOS"."FNAME"
       || "CDPOS"."CHANGENR" || "CDPOS"."CHNGIND"                             AS "ID",
       CAST("CDHDR"."UDATE" AS DATE)
            + COALESCE(CAST(TIMESTAMPDIFF(SECOND, CAST("CDHDR"."UTIME" AS DATE),
            "CDHDR"."UTIME") AS INTERVAL SECOND), INTERVAL '86399' SECOND)    AS "Time",
       CASE
           WHEN "CDPOS"."CHNGIND" = 'I' THEN 'CreationTime'
           WHEN "CDPOS"."CHNGIND" = 'D' THEN 'DeletionTime'
           END                                                                AS "Attribute",
       'NULL'                                                                   AS "OldValue",
       'NULL'                                                                   AS "NewValue",
       'User_' || "CDHDR"."MANDANT" || "CDHDR"."USERNAME"                     AS "ChangedBy",
       "CDHDR"."TCODE"                                                        AS "OperationType",
       "CDHDR"."CHANGENR"                                                     AS "OperationID",
       CASE
           WHEN "USR02"."USTYP" IN ('B', 'C') THEN 'Automatic'
           ELSE 'Manual' END                                                  AS "ExecutionType"
FROM "CDPOS" AS "CDPOS"
         LEFT JOIN "CDHDR" AS "CDHDR"
                   ON "CDPOS"."MANDANT" = "CDHDR"."MANDANT"
                       AND "CDPOS"."OBJECTCLAS" = "CDHDR"."OBJECTCLAS"
                       AND "CDPOS"."OBJECTID" = "CDHDR"."OBJECTID"
                       AND "CDPOS"."CHANGENR" = "CDHDR"."CHANGENR"
                       AND "CDPOS"."OBJECTCLAS" = 'EINKBELEG'
         LEFT JOIN "USR02" AS "USR02"
                   ON "CDHDR"."USERNAME" = "USR02"."BNAME"
                       AND "CDHDR"."MANDANT" = "USR02"."MANDT"
WHERE "CDPOS"."TABNAME" = 'EKET'
  AND "CDPOS"."FNAME" = 'KEY'
  AND "CDPOS"."MANDANT" IS NOT NULL
  AND "CDHDR"."MANDANT" IS NOT NULL
