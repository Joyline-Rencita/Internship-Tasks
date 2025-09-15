                   *******************************        RBKP        *****************************************

SELECT <%=sourceSystem%>  || 'VendorInvoice_' || "RBKP"."MANDT" || "RBKP"."BELNR" || "RBKP"."GJAHR"     AS "ID",
    CAST("RBKP"."CPUDT" AS DATE) + CAST(TIMESTAMPDIFF(SECOND, CAST("RBKP"."CPUTM" AS DATE),
            "RBKP"."CPUTM") AS INTERVAL SECOND)                                                         AS "CreationTime",
    --'NULL'                                                                                            AS "DeletionTime",
	<%=sourceSystem%>  || 'User_' || "RBKP"."MANDT" || "RBKP"."USNAM"                                   AS "CreatedBy",
    CASE
        WHEN "USR02"."USTYP" IN ('B', 'C') THEN 'Automatic'
        ELSE 'Manual' END                                                                               AS "CreationExecutionType",
    CAST("RBKP"."BLDAT" AS TIMESTAMP)                                                                   AS "DocumentDate",
    "RBKP"."ZTERM"                                                                                      AS "PaymentTerms",
    "RBKP"."ZLSPR"                                                                                      AS "PaymentBlock",
    "RBKP"."ZLSCH"                                                                                      AS "PaymentMethod",
    CAST("RBKP"."ZFBDT" AS TIMESTAMP)                                                                   AS "BaseLineDate",
    "RBKP"."ZBD1T"                                                                                      AS "PaymentDays1",
    "RBKP"."ZBD2T"                                                                                      AS "PaymentDays2",
    "RBKP"."ZBD3T"                                                                                      AS "PaymentDays3",
    "RBKP"."ZBD1P"                                                                                      AS "CashDiscountPercentage1",
    "RBKP"."ZBD2P"                                                                                      AS "CashDiscountPercentage2",
    "RBKP"."SGTXT"                                                                                      AS "ItemText",
    CASE
        WHEN "RBKP"."ZBD3T" > 0
            THEN
                CAST(CONCAT(CAST(CAST((CAST("RBKP"."ZFBDT" AS DATE)
                       + "RBKP"."ZBD2T" * INTERVAL '1' DAY) AS DATE) AS VARCHAR), ' 23:59:59') AS TIMESTAMP)
        WHEN "RBKP"."ZBD3T" = 0 AND "RBKP"."ZBD2T" > 0
            THEN
                CAST(CONCAT(CAST(CAST((CAST("RBKP"."ZFBDT" AS DATE)
                       + "RBKP"."ZBD1T" * INTERVAL '1' DAY) AS DATE) AS VARCHAR), ' 23:59:59') AS TIMESTAMP)
        END                                                                                             AS "CashDiscountDueDate",
    CASE
        WHEN "RBKP"."ZBD3T" > 0
            THEN
                CAST(CONCAT(CAST(CAST((CAST("RBKP"."ZFBDT" AS DATE)
                       + "RBKP"."ZBD3T" * INTERVAL '1' DAY) AS DATE) AS VARCHAR), ' 23:59:59') AS TIMESTAMP)
        WHEN "RBKP"."ZBD3T" = 0 AND "RBKP"."ZBD2T" > 0
            THEN
                CAST(CONCAT(CAST(CAST((CAST("RBKP"."ZFBDT" AS DATE)
                       + "RBKP"."ZBD2T" * INTERVAL '1' DAY) AS DATE) AS VARCHAR), ' 23:59:59') AS TIMESTAMP)
        WHEN "RBKP"."ZBD3T" = 0 AND "RBKP"."ZBD2T" = 0
             AND "RBKP"."ZBD1T" > 0
            THEN
                CAST(CONCAT(CAST(CAST((CAST("RBKP"."ZFBDT" AS DATE)
                       + "RBKP"."ZBD1T" * INTERVAL '1' DAY) AS DATE) AS VARCHAR), ' 23:59:59') AS TIMESTAMP)
        ELSE CAST(CONCAT(CAST("RBKP"."ZFBDT" AS VARCHAR), ' 23:59:59') AS TIMESTAMP)
        END                                                                                             	AS "DueDate",
    'SAP'                                                                                               	AS "SourceSystemType",
	<%=sourceSystem%>  || "RBKP"."MANDT"                                                                    AS "SourceSystemInstance",
    "RBKP"."BELNR"                                                                                      	AS "SystemVendorInvoiceNumber",
    "RBKP"."BELNR"                                                                                      	AS "DatabaseVendorInvoiceNumber",
    CAST("RBKP"."GJAHR" AS BIGINT)                                                                      	AS "FiscalYear",
	<%=sourceSystem%>  || 'VendorMasterCompanyCode_' || "RBKP"."MANDT" || "RBKP"."LIFNR" || "RBKP"."BUKRS"  AS "VendorMasterCompanyCode",
	<%=sourceSystem%>  || 'Vendor_' || "RBKP"."MANDT" || "RBKP"."LIFNR"                                    	AS "Vendor"
FROM "RBKP" AS "RBKP"
         LEFT JOIN "USR02" AS "USR02"
                   ON "RBKP"."MANDT" = "USR02"."MANDT"
                       AND "RBKP"."USNAM" = "USR02"."BNAME"
WHERE "RBKP"."MANDT" IS NOT NULL
  AND "RBKP"."VGART" = 'RD'
  AND "RBKP"."XRECH" = 'X'



======================================================================================================================================================


                        ****************************      CDPOS  *****************************


SELECT <%=sourceSystem%>  || 'VendorInvoice_' || "CDPOS"."TABKEY" 						AS "ObjectID",
	<%=sourceSystem%>  || "CDPOS"."TABKEY" || "CDPOS"."TABNAME" || "CDPOS"."FNAME"
       || "CDPOS"."CHANGENR" || "CDPOS"."CHNGIND"                 						AS "ID",
       CAST("CDHDR"."UDATE" AS DATE) + CAST(TIMESTAMPDIFF(SECOND, CAST("CDHDR"."UTIME" AS DATE),
            "CDHDR"."UTIME") AS INTERVAL SECOND)                  						AS "Time",
       CASE
           WHEN "CDPOS"."FNAME" = 'MWSKZ1' THEN 'TaxCode'
           WHEN "CDPOS"."FNAME" = 'ZTERM' THEN 'PaymentTerms'
           END                                                    						AS "Attribute",
       CASE
           WHEN "CDPOS"."VALUE_OLD" LIKE '%-' THEN CONCAT('-', REPLACE(LTRIM("CDPOS"."VALUE_OLD"), '-', ''))
           ELSE "CDPOS"."VALUE_OLD" END                           						AS "OldValue",
       CASE
           WHEN "CDPOS"."VALUE_NEW" LIKE '%-' THEN CONCAT('-', REPLACE(LTRIM("CDPOS"."VALUE_NEW"), '-', ''))
           ELSE "CDPOS"."VALUE_NEW" END                           						AS "NewValue",
       'User_' || "CDHDR"."MANDANT" || "CDHDR"."USERNAME"         						AS "ChangedBy",
       "CDHDR"."TCODE"                                            						AS "OperationType",
       "CDHDR"."CHANGENR"                                         						AS "OperationID",
       CASE
           WHEN "USR02"."USTYP" IN ('B', 'C') THEN 'Automatic'
           ELSE 'Manual' END                                      						AS "ExecutionType"
					   
FROM "CDPOS" AS "CDPOS"
         LEFT JOIN "CDHDR" AS "CDHDR"
                   ON "CDPOS"."MANDANT" = "CDHDR"."MANDANT"
                       AND "CDPOS"."OBJECTCLAS" = "CDHDR"."OBJECTCLAS"
                       AND "CDPOS"."OBJECTID" = "CDHDR"."OBJECTID"
                       AND "CDPOS"."CHANGENR" = "CDHDR"."CHANGENR"
                       AND "CDPOS"."OBJECTCLAS" = 'INCOMINGINVOICE'
         LEFT JOIN "USR02" AS "USR02"
                   ON "CDHDR"."USERNAME" = "USR02"."BNAME"
                       AND "CDHDR"."MANDANT" = "USR02"."MANDT"
         LEFT JOIN "RBKP" AS "RBKP"
                   ON "CDPOS"."TABKEY" = "RBKP"."MANDT" || "RBKP"."BELNR" || "RBKP"."GJAHR"
WHERE "CDPOS"."TABNAME" = 'RBKP'
  AND "CDPOS"."CHNGIND" = 'U'
  AND "CDPOS"."MANDANT" IS NOT NULL
  AND "CDHDR"."MANDANT" IS NOT NULL
  AND "CDPOS"."FNAME" IN ('MWSKZ1', 'ZTERM')
  AND "RBKP"."XRECH" = 'X'
