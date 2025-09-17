              ***********************************              RSEG            **********************************

SELECT <%=sourceSystem%>  || 'VendorInvoiceItem_' || "RSEG"."MANDT" || "RSEG"."BELNR" || "RSEG"."GJAHR" || "RSEG"."BUZEI" AS "ID",
    CAST("RBKP"."CPUDT" AS DATE) + CAST(TIMESTAMPDIFF(SECOND, CAST("RBKP"."CPUTM" AS DATE),
            "RBKP"."CPUTM") AS INTERVAL SECOND)                                                                           AS "CreationTime",
	<%=sourceSystem%>  || 'User_' || "RBKP"."MANDT" || "RBKP"."USNAM"                                                     AS "CreatedBy",
    CASE
        WHEN "USR02"."USTYP" IN ('B', 'C') THEN 'Automatic'
        ELSE 'Manual' END                                                                                                 AS "CreationExecutionType",
	<%=sourceSystem%>  || 'PurchaseOrderItem_' || "RSEG"."MANDT" || "RSEG"."EBELN"
    || "RSEG"."EBELP"                                                                                                     AS "PurchaseOrderItem",
    "RSEG"."MENGE"                                                                                                        AS "Quantity",
    "RSEG"."BSTME"                                                                                                        AS "QuantityUnit",
    "RBKP"."WAERS"                                                                                                        AS "Currency",
    "RSEG"."WRBTR"                                                                                                        AS "Amount",
    "RBKP"."VGART"                                                                                                        AS "TransactionType",
	<%=sourceSystem%>  || 'VendorInvoice_' || "RSEG"."MANDT" || "RSEG"."BELNR" || "RSEG"."GJAHR"                          AS "Header",
    'SAP'                                                                                                                 AS "SourceSystemType",
	<%=sourceSystem%>  || "RSEG"."MANDT"                                                                                  AS "SourceSystemInstance",
    CAST("RSEG"."GJAHR" AS BIGINT)                                                                                        AS "FiscalYear",
    "RSEG"."BELNR"                                                                                                        AS "SystemVendorInvoiceNumber",
    "RSEG"."BUZEI"                                                                                                        AS "SystemVendorInvoiceItemNumber",
    "RSEG"."BELNR"                                                                                                        AS "DatabaseVendorInvoiceNumber",
    "RSEG"."BUZEI"                                                                                                        AS "DatabaseVendorInvoiceItemNumber",
	<%=sourceSystem%>  || 'IncomingMaterialDocumentItem_' || "RSEG"."MANDT" || "RSEG"."LFBNR" || "RSEG"."LFGJA"
    || "RSEG"."LFPOS"                                                                                                     AS "IncomingMaterialDocumentItem",
	<%=sourceSystem%>  || 'Material_' || "RSEG"."MANDT" || "RSEG"."MATNR"                                                 AS "Material",
	<%=sourceSystem%>  || 'Plant_' || "RSEG"."MANDT" || "RSEG"."WERKS"                                                    AS "Plant",
	<%=sourceSystem%>  || 'VendorMasterCompanyCode_' || "RSEG"."MANDT" || "RSEG"."LIFNR"
    || "RSEG"."BUKRS"                                                                                                     AS "VendorMasterCompanyCode",
	<%=sourceSystem%>  || 'Vendor_' || "RSEG"."MANDT" || "RSEG"."LIFNR"                                                   AS "Vendor"
FROM "RSEG" AS "RSEG"
         LEFT JOIN "RBKP" AS "RBKP"
                   ON "RSEG"."MANDT" = "RBKP"."MANDT"
                       AND "RSEG"."BELNR" = "RBKP"."BELNR"
                       AND "RSEG"."GJAHR" = "RBKP"."GJAHR"
         LEFT JOIN "USR02" AS "USR02"
                   ON "RBKP"."MANDT" = "USR02"."MANDT"
                       AND "RBKP"."USNAM" = "USR02"."BNAME"
WHERE "RSEG"."MANDT" IS NOT NULL
  AND "RBKP"."VGART" = 'RD'
  AND "RSEG"."SHKZG" = 'S'

--=========================================================================================================================================



--                          **************************        CDPOS  ******************************


SELECT <%=sourceSystem%>  || 'VendorInvoiceItem_' || "CDPOS"."TABKEY" AS "ObjectID",
	<%=sourceSystem%>  || "CDPOS"."TABKEY" || "CDPOS"."TABNAME" || "CDPOS"."FNAME"
           || "CDPOS"."CHANGENR" || "CDPOS"."CHNGIND"                 AS "ID",
       CAST("CDHDR"."UDATE" AS DATE) + CAST(TIMESTAMPDIFF(SECOND, CAST("CDHDR"."UTIME" AS DATE),
            "CDHDR"."UTIME") AS INTERVAL SECOND)                      AS "Time",
       CASE
           WHEN "CDPOS"."FNAME" = 'MENGE' THEN 'Quantity'
           WHEN "CDPOS"."FNAME" = 'WRBTR' THEN 'Amount'
           END                                                        AS "Attribute",
       CASE
           WHEN "CDPOS"."VALUE_OLD" LIKE '%-' THEN CONCAT('-', REPLACE(LTRIM("CDPOS"."VALUE_OLD"), '-', ''))
           ELSE "CDPOS"."VALUE_OLD" END                               AS "OldValue",
       CASE
           WHEN "CDPOS"."VALUE_NEW" LIKE '%-' THEN CONCAT('-', REPLACE(LTRIM("CDPOS"."VALUE_NEW"), '-', ''))
           ELSE "CDPOS"."VALUE_NEW" END                               AS "NewValue",
       'User_' || "CDHDR"."MANDANT" || "CDHDR"."USERNAME"             AS "ChangedBy",
       "CDHDR"."TCODE"                                                AS "OperationType",
       "CDHDR"."CHANGENR"                                             AS "OperationID",
       CASE
           WHEN "USR02"."USTYP" IN ('B', 'C') THEN 'Automatic'
           ELSE 'Manual' END                                          AS "ExecutionType"
FROM "CDPOS" AS "CDPOS"
         LEFT JOIN "CDHDR" AS "CDHDR"
                   ON "CDPOS"."MANDANT" = "CDHDR"."MANDANT"
                       AND "CDPOS"."OBJECTCLAS" = "CDHDR"."OBJECTCLAS"
                       AND "CDPOS"."OBJECTID" = "CDHDR"."OBJECTID"
                       AND "CDPOS"."CHANGENR" = "CDHDR"."CHANGENR"
                       AND "CDPOS"."OBJECTCLAS" = 'INCOMINGINVOICE'
         LEFT JOIN "RSEG" AS "RSEG"
                   ON "RSEG"."MANDT" || "RSEG"."BELNR" || "RSEG"."GJAHR" || "RSEG"."BUZEI" = "CDPOS"."TABKEY"
         LEFT JOIN "RBKP" AS "RBKP"
                   ON "RSEG"."MANDT" = "RBKP"."MANDT"
                       AND "RSEG"."BELNR" = "RBKP"."BELNR"
                       AND "RSEG"."GJAHR" = "RBKP"."GJAHR"
         LEFT JOIN "USR02" AS "USR02"
                   ON "CDHDR"."USERNAME" = "USR02"."BNAME"
                       AND "CDHDR"."MANDANT" = "USR02"."MANDT"
WHERE "CDHDR"."UDATE" IS NOT NULL
  AND "CDPOS"."TABNAME" = 'RSEG'
  AND "CDPOS"."FNAME" IN ('MENGE', 'WRBTR')
  AND "CDPOS"."CHNGIND" = 'U'
  AND "CDPOS"."MANDANT" IS NOT NULL
  AND "CDHDR"."MANDANT" IS NOT NULL
  AND "RSEG"."MANDT" IS NOT NULL
  AND "RBKP"."MANDT" IS NOT NULL
  AND "RSEG"."SHKZG" = 'S'
