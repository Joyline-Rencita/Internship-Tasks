--                        *****************************            BSEG             ************************************


WITH "CTE_BSEG_FILTERED" AS (SELECT "MANDT" AS "MANDT",
                                    "BUKRS" AS "BUKRS",
                                    "BELNR" AS "BELNR",
                                    "GJAHR" AS "GJAHR",
                                    "BUZEI" AS "BUZEI",
                                    "KOART" AS "KOART",
                                    "SHKZG" AS "SHKZG",
                                    "AUGDT" AS "AUGDT",
                                    "BSCHL" AS "BSCHL",
                                    "LIFNR" AS "LIFNR",
                                    "MATNR" AS "MATNR",
                                    "SGTXT" AS "SGTXT",
                                    "SKFBT" AS "SKFBT",
                                    "WRBTR" AS "WRBTR",
                                    "WSKTO" AS "WSKTO",
                                    "ZBD1P" AS "ZBD1P",
                                    "ZBD1T" AS "ZBD1T",
                                    "ZBD2P" AS "ZBD2P",
                                    "ZBD2T" AS "ZBD2T",
                                    "ZBD3T" AS "ZBD3T",
                                    "ZFBDT" AS "ZFBDT",
                                    "ZLSCH" AS "ZLSCH",
                                    "ZTERM" AS "ZTERM"
                             FROM "BSEG" AS "BSEG"
                             WHERE "BSEG"."SHKZG" = 'H'
                               AND "BSEG"."KOART" = 'K'),
     "CTE_T052_Intermediate" AS (SELECT "BKPF"."MANDT",
                                        "BKPF"."BUKRS",
                                        "BKPF"."BELNR",
                                        "BKPF"."GJAHR",
                                        "BSEG"."BUZEI",
                                        "T052"."ZPRZ1",
                                        "T052"."ZPRZ2",
                                        "T052"."ZTAG1",
                                        "T052"."ZTAG2",
                                        "T052"."ZTAG3",
                                        ROW_NUMBER()
                                        OVER (PARTITION BY "BKPF"."MANDT", "BKPF"."BUKRS", "BKPF"."BELNR", "BKPF"."GJAHR", "BSEG"."BUZEI", "T052"."ZTERM"
                                            ORDER BY "T052"."ZTAGG" ASC) AS "NUM"
                                 FROM "CTE_BSEG_FILTERED" AS "BSEG"
                                          LEFT JOIN "BKPF" AS "BKPF"
                                                    ON "BSEG"."MANDT" = "BKPF"."MANDT"
                                                        AND "BSEG"."BUKRS" = "BKPF"."BUKRS"
                                                        AND "BSEG"."BELNR" = "BKPF"."BELNR"
                                                        AND "BSEG"."GJAHR" = "BKPF"."GJAHR"
                                          LEFT JOIN "LFB1" AS "LFB1"
                                                    ON "BSEG"."MANDT" = "LFB1"."MANDT"
                                                        AND "BSEG"."LIFNR" = "LFB1"."LIFNR"
                                                        AND "BSEG"."BUKRS" = "LFB1"."BUKRS"
                                          LEFT JOIN "T052" AS "T052"
                                                    ON "BKPF"."MANDT" = "T052"."MANDT"
                                                        AND "LFB1"."ZTERM" = "T052"."ZTERM"
                                                        AND
                                                       (DAYOFMONTH(CAST("BKPF"."BLDAT" AS TIMESTAMP))
                                                            <= CAST("T052"."ZTAGG" AS INT)
                                                           OR CAST("T052"."ZTAGG" AS INT) = 0))
SELECT <%=sourceSystem%>  || 'VendorAccountCreditItem_' || "BSEG"."MANDT" || "BSEG"."BUKRS" || "BSEG"."BELNR" || "BSEG"."GJAHR"
           || "BSEG"."BUZEI"                                                                  AS "ID",
       CAST("BKPF"."CPUDT" AS DATE) + CAST(TIMESTAMPDIFF(SECOND, CAST("BKPF"."CPUTM" AS DATE),
                    "BKPF"."CPUTM") AS INTERVAL SECOND)                                       AS "CreationTime",
	<%=sourceSystem%>  || 'User_' || "BKPF"."MANDT" || "BKPF"."USNAM"                            AS "CreatedBy",
       CASE
           WHEN "USR02"."USTYP" IN ('B', 'C') THEN 'Automatic'
           ELSE 'Manual' END                                                                  AS "CreationExecutionType",
	<%=sourceSystem%>  || 'VendorInvoice_' || "RBKP"."MANDT" || "RBKP"."BELNR" || "RBKP"."GJAHR" AS "VendorInvoice",
       "BKPF"."BLART"                                                                         AS "DocumentType",
       "T003T"."LTEXT"                                                                        AS "DocumentTypeText",
       CAST("BKPF"."BLDAT" AS TIMESTAMP)                                                      AS "DocumentDate",
       "BSEG"."ZLSCH"                                                                         AS "PaymentMethod",
       "BKPF"."XBLNR"                                                                         AS "ReferenceDocumentNumber",
       CAST("BSEG"."ZFBDT" AS TIMESTAMP)                                                      AS "BaseLineDate",
       "BSEG"."ZBD1T"                                                                         AS "PaymentDays1",
       "BSEG"."ZBD2T"                                                                         AS "PaymentDays2",
       "BSEG"."ZBD3T"                                                                         AS "PaymentDays3",
       "BSEG"."ZBD1P"                                                                         AS "CashDiscountPercentage1",
       "BSEG"."ZBD2P"                                                                         AS "CashDiscountPercentage2",
       "BSEG"."SGTXT"                                                                         AS "ItemText",
       'VendorAccountCreditHead_' || "BSEG"."MANDT" || "BSEG"."BUKRS" || "BSEG"."BELNR"
           || "BSEG"."GJAHR"                                                                  AS "VendorAccountHead",
	<%=sourceSystem%>  || 'Vendor_' || "BSEG"."MANDT" || "BSEG"."LIFNR"                          AS "Vendor",
       "T052_Intermediate"."ZPRZ1"                                                            AS "VendorCashDiscountPercentage1",
       "T052_Intermediate"."ZPRZ2"                                                            AS "VendorCashDiscountPercentage2",
       "BSEG"."WRBTR"                                                                         AS "Amount",
       "BKPF"."WAERS"                                                                         AS "Currency",
       "BSEG"."WSKTO"                                                                         AS "CashDiscountTakenAmount",
       "BSEG"."SKFBT"                                                                         AS "CashDiscountEligibleAmount",
       CAST("BSEG"."AUGDT" AS TIMESTAMP)                                                      AS "ClearingDate",
       "BSEG"."ZTERM"                                                                         AS "PaymentTerms",
       "BSEG"."BUKRS"                                                                         AS "CompanyCode",
       "T001"."BUTXT"                                                                         AS "CompanyCodeText",
       CAST("T052_Intermediate"."ZTAG1" AS BIGINT)                                            AS "VendorPaymentDays1",
       CAST("T052_Intermediate"."ZTAG2" AS BIGINT)                                            AS "VendorPaymentDays2",
       CAST("T052_Intermediate"."ZTAG3" AS BIGINT)                                            AS "VendorPaymentDays3",
       'SAP'                                                                                  AS "SourceSystemType",
	<%=sourceSystem%>  || "BSEG"."MANDT"                                                         AS "SourceSystemInstance",
       CAST("BSEG"."GJAHR" AS BIGINT)                                                         AS "FiscalYear",
       "BSEG"."BELNR"                                                                         AS "SystemAccountingDocumentNumber",
       "BSEG"."BELNR"                                                                         AS "DatabaseAccountingDocumentNumber",
       CASE
           WHEN "BKPF"."XREVERSAL" = '1' THEN 'Reversed Document'
           WHEN "BKPF"."XREVERSAL" = '2' THEN 'Reversal Document'
           WHEN "BSEG"."BSCHL" = 31 AND "BKPF"."TCODE" = 'MR8M' THEN 'Reversal Document'
           WHEN "RBKP"."STBLG" IS NOT NULL THEN 'Reversed Document'
           END                                                                                AS "ReversalIndicator",
       "BSEG"."BUZEI"                                                                         AS "SystemAccountingDocumentItemNumber",
       "BSEG"."BUZEI"                                                                         AS "DatabaseAccountingDocumentItemNumber",
       CASE
           WHEN "BSEG"."BSCHL" = 31 THEN 'InvoiceItem'
           WHEN "BSEG"."BSCHL" = 32 THEN 'ReverseCreditMemoItem'
           WHEN "BSEG"."BSCHL" = 34 THEN 'OtherPayables'
           WHEN "BSEG"."BSCHL" = 35 THEN 'IncomingPayment'
           WHEN "BSEG"."BSCHL" = 36 THEN 'PaymentDifference'
           WHEN "BSEG"."BSCHL" = 37 THEN 'OtherClearings'
           WHEN "BSEG"."BSCHL" = 38 THEN 'PaymentClearings'
           WHEN "BSEG"."BSCHL" = 39 THEN 'SpecialG/LCredit'
           ELSE 'OtherCreditItem'
           END                                                                                AS "VendorAccountTransactionType",
       CASE
           WHEN "BSEG"."ZBD3T" > 0
               THEN
                   CAST((CAST("BSEG"."ZFBDT" AS DATE)
                         + "BSEG"."ZBD2T" * INTERVAL '1' DAY) AS DATE) + INTERVAL '86399' SECOND
           WHEN "BSEG"."ZBD3T" = 0 AND "BSEG"."ZBD2T" > 0
               THEN
                   CAST((CAST("BSEG"."ZFBDT" AS DATE)
                         + "BSEG"."ZBD1T" * INTERVAL '1' DAY) AS DATE) + INTERVAL '86399' SECOND
           END                                                                                AS "CashDiscountDueDate",
       CASE
           WHEN "BSEG"."ZBD3T" > 0
               THEN
                   CAST((CAST("BSEG"."ZFBDT" AS DATE)
                         + "BSEG"."ZBD3T" * INTERVAL '1' DAY) AS DATE) + INTERVAL '86399' SECOND
           WHEN "BSEG"."ZBD3T" = 0 AND "BSEG"."ZBD2T" > 0
               THEN
                   CAST((CAST("BSEG"."ZFBDT" AS DATE)
                         + "BSEG"."ZBD2T" * INTERVAL '1' DAY) AS DATE) + INTERVAL '86399' SECOND
           WHEN "BSEG"."ZBD3T" = 0 AND "BSEG"."ZBD2T" = 0
               AND "BSEG"."ZBD1T" > 0
               THEN
                   CAST((CAST("BSEG"."ZFBDT" AS DATE)
                         + "BSEG"."ZBD1T" * INTERVAL '1' DAY) AS DATE) + INTERVAL '86399' SECOND
           ELSE CAST("BSEG"."ZFBDT" AS DATE) + INTERVAL '86399' SECOND
           END                                                                                AS "DueDate",
       CASE
           WHEN "BKPF"."AWTYP" = 'RMRP' THEN TRUE
           ELSE FALSE END                                                                     AS "PurchaseOrderRelated",
	<%=sourceSystem%>  || 'Material_' || "BSEG"."MANDT" || "BSEG"."MATNR"                        AS "Material",
	<%=sourceSystem%>  || 'VendorMasterCompanyCode_' || "BSEG"."MANDT"
           || "BSEG"."LIFNR" || "BSEG"."BUKRS"                                                AS "VendorMasterCompanyCode"
FROM "CTE_BSEG_FILTERED" AS "BSEG"
         LEFT JOIN "BKPF" AS "BKPF"
                   ON "BSEG"."MANDT" = "BKPF"."MANDT"
                       AND "BSEG"."BUKRS" = "BKPF"."BUKRS"
                       AND "BSEG"."BELNR" = "BKPF"."BELNR"
                       AND "BSEG"."GJAHR" = "BKPF"."GJAHR"
         LEFT JOIN "T003T" AS "T003T"
                   ON "BKPF"."MANDT" = "T003T"."MANDT"
                       AND "BKPF"."BLART" = "T003T"."BLART"
                       AND "T003T"."SPRAS" = <%=LanguageKey%> 
         LEFT JOIN "USR02" AS "USR02"
                   ON "BKPF"."MANDT" = "USR02"."MANDT"
                       AND "BKPF"."USNAM" = "USR02"."BNAME"
         LEFT JOIN "CTE_T052_Intermediate" AS "T052_Intermediate"
                   ON "BSEG"."MANDT" = "T052_Intermediate"."MANDT"
                       AND "BSEG"."BUKRS" = "T052_Intermediate"."BUKRS"
                       AND "BSEG"."BELNR" = "T052_Intermediate"."BELNR"
                       AND "BSEG"."GJAHR" = "T052_Intermediate"."GJAHR"
                       AND "BSEG"."BUZEI" = "T052_Intermediate"."BUZEI"
                       AND "T052_Intermediate"."NUM" = 1
         LEFT JOIN "T001" AS "T001"
                   ON "BSEG"."MANDT" = "T001"."MANDT"
                       AND "BSEG"."BUKRS" = "T001"."BUKRS"
         LEFT JOIN "RBKP" AS "RBKP"
                   ON "BKPF"."MANDT" = "RBKP"."MANDT"
                       AND "BKPF"."BUKRS" = "RBKP"."BUKRS"
                       AND "BKPF"."AWKEY" = "RBKP"."BELNR" || "RBKP"."GJAHR"


-- ==============================================================================================================================================


--                *********************          CDPOS          ***************************** 


SELECT <%=sourceSystem%>  || 'VendorAccountCreditItem_' || "CDPOS"."TABKEY" AS "ObjectID",
	<%=sourceSystem%>  || "CDPOS"."TABKEY" || "CDPOS"."TABNAME" || "CDPOS"."FNAME"
       || "CDPOS"."CHANGENR" || "CDPOS"."CHNGIND"                           AS "ID",
       CAST("CDHDR"."UDATE" AS DATE) + CAST(TIMESTAMPDIFF(SECOND, CAST("CDHDR"."UTIME" AS DATE),
            "CDHDR"."UTIME") AS INTERVAL SECOND)                            AS "Time",
       CASE
           WHEN "CDPOS"."FNAME" = 'SGTXT' THEN 'ItemText'
           WHEN "CDPOS"."FNAME" = 'XBLNR' THEN 'ReferenceDocumentNumber'
           WHEN "CDPOS"."FNAME" = 'ZFBDT' THEN 'BaseLineDate'
           WHEN "CDPOS"."FNAME" = 'ZBD1T' THEN 'PaymentDays1'
           WHEN "CDPOS"."FNAME" = 'ZBD2T' THEN 'PaymentDays2'
           WHEN "CDPOS"."FNAME" = 'ZBD3T' THEN 'PaymentDays3'
           WHEN "CDPOS"."FNAME" = 'ZBD1P' THEN 'CashDiscountPercentage1'
           WHEN "CDPOS"."FNAME" = 'ZBD2P' THEN 'CashDiscountPercentage2'
           WHEN "CDPOS"."FNAME" = 'ZLSCH' THEN 'PaymentMethod'
           WHEN "CDPOS"."FNAME" = 'ZTERM' THEN 'PaymentTerms'
           END                                                              AS "Attribute",
       CASE
           WHEN "CDPOS"."VALUE_OLD" LIKE '%-' THEN CONCAT('-', REPLACE(LTRIM("CDPOS"."VALUE_OLD"), '-', ''))
           ELSE "CDPOS"."VALUE_OLD" END                                     AS "OldValue",
       CASE
           WHEN "CDPOS"."VALUE_NEW" LIKE '%-' THEN CONCAT('-', REPLACE(LTRIM("CDPOS"."VALUE_NEW"), '-', ''))
           ELSE "CDPOS"."VALUE_NEW" END                                     AS "NewValue",
       'User_' || "CDHDR"."MANDANT" || "CDHDR"."USERNAME"                   AS "ChangedBy",
       "CDHDR"."TCODE"                                                      AS "OperationType",
       "CDHDR"."CHANGENR"                                                   AS "OperationID",
       CASE
           WHEN "USR02"."USTYP" IN ('B', 'C') THEN 'Automatic'
           ELSE 'Manual' END                                                AS "ExecutionType"
FROM "CDPOS" AS "CDPOS"
         LEFT JOIN "CDHDR" AS "CDHDR"
                   ON "CDPOS"."MANDANT" = "CDHDR"."MANDANT"
                       AND "CDPOS"."OBJECTCLAS" = "CDHDR"."OBJECTCLAS"
                       AND "CDPOS"."OBJECTID" = "CDHDR"."OBJECTID"
                       AND "CDPOS"."CHANGENR" = "CDHDR"."CHANGENR"
                       AND "CDPOS"."OBJECTCLAS" = 'BELEG'
         LEFT JOIN "BSEG" AS "BSEG"
                   ON "BSEG"."MANDT" || "BSEG"."BUKRS" || "BSEG"."BELNR" || "BSEG"."GJAHR" || "BSEG"."BUZEI"
                      = "CDPOS"."TABKEY"
         LEFT JOIN "BKPF" AS "BKPF"
                   ON "BSEG"."MANDT" = "BKPF"."MANDT"
                       AND "BSEG"."BUKRS" = "BKPF"."BUKRS"
                       AND "BSEG"."BELNR" = "BKPF"."BELNR"
                       AND "BSEG"."GJAHR" = "BKPF"."GJAHR"
         LEFT JOIN "USR02" AS "USR02"
                   ON "CDHDR"."USERNAME" = "USR02"."BNAME"
                       AND "CDHDR"."MANDANT" = "USR02"."MANDT"
WHERE "CDPOS"."TABNAME" = 'BSEG'
  AND "CDPOS"."FNAME" IN ('SGTXT', 'XBLNR', 'ZFBDT', 'ZBD1T', 'ZBD2T', 'ZBD3T', 'ZBD1P', 'ZBD2P', 'ZLSCH', 'ZTERM')
  AND "CDPOS"."CHNGIND" = 'U'
  AND "BSEG"."SHKZG" = 'H'
  AND "BSEG"."KOART" = 'K'
  AND "CDPOS"."MANDANT" IS NOT NULL
  AND "CDHDR"."MANDANT" IS NOT NULL
  AND "BSEG"."MANDT" IS NOT NULL
  AND "BKPF"."MANDT" IS NOT NULL
