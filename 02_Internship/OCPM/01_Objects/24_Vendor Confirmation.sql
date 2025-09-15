                       **************************      EKES       *********************************

SELECT <%=sourceSystem%>  || 'VendorConfirmation_' || "EKES"."MANDT" || "EKES"."EBELN" || "EKES"."EBELP" || "EKES"."ETENS" 		AS "ID",
    CAST("EKES"."ERDAT" AS DATE) + CAST(TIMESTAMPDIFF(SECOND, CAST("EKES"."EZEIT" AS DATE),
            "EKES"."EZEIT") AS INTERVAL SECOND)                                                                            		AS "CreationTime",
	<%=sourceSystem%>  || 'NULL'                                                                                                AS "CreatedBy",
    'NULL'                                                                                                                   	AS "CreationExecutionType",
	<%=sourceSystem%>  || 'PurchaseOrderItem_' || "EKES"."MANDT" || "EKES"."EBELN"
    || "EKES"."EBELP"                                                                                                      		AS "PurchaseOrderItem",
    "EKES"."EBTYP"                                                                                                         		AS "ConfirmationCategory",
    CAST("EKES"."EINDT" AS TIMESTAMP)                                                                                      		AS "ConfirmationDeliveryDate",
    "EKES"."MENGE"                                                                                                         		AS "Quantity",
    "EKPO"."MEINS"                                                                                                         		AS "QuantityUnit",
    'SAP'                                                                                                                  		AS "SourceSystemType",
	<%=sourceSystem%>  || "EKES"."MANDT"                                                                                      	AS "SourceSystemInstance",
    "EKES"."EBELN"                                                                                                         AS "SystemPurchaseOrderNumber",
    "EKES"."EBELP"                                                                                                         AS "SystemPurchaseOrderItemNumber",
    "EKES"."ETENS"                                                                                                         AS "SystemPurchaseOrderVendorConfirmationNumber",
    "EKES"."EBELN"                                                                                                         AS "DatabasePurchaseOrderNumber",
    "EKES"."EBELP"                                                                                                         AS "DatabasePurchaseOrderItemNumber",
    "EKES"."ETENS"                                                                                                         AS "DatabasePurchaseOrderVendorConfirmationNumber",
	<%=sourceSystem%>  || 'Vendor_' || "EKKO"."MANDT" || "EKKO"."LIFNR"                                                       	AS "Vendor"
FROM "EKES" AS "EKES"
         LEFT JOIN "EKKO" AS "EKKO"
                   ON "EKES"."MANDT" = "EKKO"."MANDT"
                       AND "EKES"."EBELN" = "EKKO"."EBELN"
         LEFT JOIN "EKPO" AS "EKPO"
                   ON "EKES"."MANDT" = "EKPO"."MANDT"
                       AND "EKES"."EBELN" = "EKPO"."EBELN"
                       AND "EKES"."EBELP" = "EKPO"."EBELP"
WHERE "EKES"."MANDT" IS NOT NULL
  AND "EKES"."EBTYP" LIKE 'L%'



--==========================================================================================================================================================



--                    *************************        CDPOS        ************************************


SELECT <%=sourceSystem%>  || 'VendorConfirmation_' || "CDPOS"."TABKEY" AS "ObjectID",
	<%=sourceSystem%>  || "CDPOS"."TABKEY" || "CDPOS"."TABNAME" || "CDPOS"."FNAME"
       || "CDPOS"."CHANGENR" || "CDPOS"."CHNGIND"                      AS "ID",
       CAST("CDHDR"."UDATE" AS DATE) + CAST(TIMESTAMPDIFF(SECOND, CAST("CDHDR"."UTIME" AS DATE),
            "CDHDR"."UTIME") AS INTERVAL SECOND)                       AS "Time",
       CASE
           WHEN "CDPOS"."FNAME" = 'EBTYP' THEN 'ConfirmationCategory'
           WHEN "CDPOS"."FNAME" = 'EINDT' THEN 'ConfirmationDeliveryDate'
           END                                                         AS "Attribute",
       CASE
           WHEN "CDPOS"."VALUE_OLD" LIKE '%-' THEN CONCAT('-', REPLACE(LTRIM("CDPOS"."VALUE_OLD"), '-', ''))
           ELSE "CDPOS"."VALUE_OLD" END                                AS "OldValue",
       CASE
           WHEN "CDPOS"."VALUE_NEW" LIKE '%-' THEN CONCAT('-', REPLACE(LTRIM("CDPOS"."VALUE_NEW"), '-', ''))
           ELSE "CDPOS"."VALUE_NEW" END                                AS "NewValue",
       'User_' || "CDHDR"."MANDANT" || "CDHDR"."USERNAME"              AS "ChangedBy",
       "CDHDR"."TCODE"                                                 AS "OperationType",
       "CDHDR"."CHANGENR"                                              AS "OperationID",
       CASE
           WHEN "USR02"."USTYP" IN ('B', 'C') THEN 'Automatic'
           ELSE 'Manual' END                                           AS "ExecutionType"
FROM "CDPOS" AS "CDPOS"
         LEFT JOIN "CDHDR" AS "CDHDR"
                   ON "CDPOS"."MANDANT" = "CDHDR"."MANDANT"
                       AND "CDPOS"."OBJECTCLAS" = "CDHDR"."OBJECTCLAS"
                       AND "CDPOS"."OBJECTID" = "CDHDR"."OBJECTID"
                       AND "CDPOS"."CHANGENR" = "CDHDR"."CHANGENR"
                       AND "CDPOS"."OBJECTCLAS" = 'EINKBELEG'
         LEFT JOIN "EKES" AS "EKES"
                   ON "EKES"."MANDT" || "EKES"."EBELN" || "EKES"."EBELP" || "EKES"."ETENS" = "CDPOS"."TABKEY"
         LEFT JOIN "USR02" AS "USR02"
                   ON "CDHDR"."USERNAME" = "USR02"."BNAME"
                       AND "CDHDR"."MANDANT" = "USR02"."MANDT"
WHERE "CDPOS"."TABNAME" = 'EKES'
  AND "CDPOS"."CHNGIND" = 'U'
  AND "CDPOS"."FNAME" IN ('EBTYP', 'EINDT', 'LOEKZ')
  AND "EKES"."EBTYP" LIKE ('L%')
  AND "CDPOS"."MANDANT" IS NOT NULL
  AND "CDHDR"."MANDANT" IS NOT NULL
  AND "EKES"."MANDT" IS NOT NULL






