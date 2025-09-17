                  ***********************        BSEG      **************************

SELECT <%=sourceSystem%>  || 'CustomerAccountDebitItem_' || "BSEG"."MANDT" || "BSEG"."BUKRS" || "BSEG"."BELNR" || "BSEG"."GJAHR"
    || "BSEG"."BUZEI"                                                              		AS "ID",
    CAST("BKPF"."CPUDT" AS DATE) + CAST(TIMESTAMPDIFF(SECOND, CAST("BKPF"."CPUTM" AS DATE),
            "BKPF"."CPUTM") AS INTERVAL SECOND)                                    		AS "CreationTime",
	<%=sourceSystem%>  || 'User_' || "BKPF"."MANDT" || "BKPF"."USNAM"                 	AS "CreatedBy",
    CASE
        WHEN "USR02"."USTYP" IN ('B', 'C') THEN 'Automatic'
        ELSE 'Manual' END                                                          		AS "CreationExecutionType",
	<%=sourceSystem%>  || CASE
        WHEN "BKPF"."AWTYP" = 'VBRK' AND "BSEG"."BSCHL" = '01'
            THEN 'CustomerInvoice_' || "BKPF"."MANDT" || "BKPF"."AWKEY" END        		AS "CustomerInvoice",
	<%=sourceSystem%>  || CASE
        WHEN "BKPF"."AWTYP" = 'VBRK' AND "BSEG"."BSCHL" = '02'
            THEN 'CreditMemoCancellation_' || "BKPF"."MANDT" || "BKPF"."AWKEY" END 		AS "CreditMemoCancellation",
    'CustomerAccountDebitHead_' || "BKPF"."MANDT" || "BKPF"."BUKRS" || "BKPF"."BELNR"
    || "BKPF"."GJAHR"                                                              		AS "CustomerAccountHead",
    CASE
        WHEN "BSEG"."BSCHL" = '01' THEN 'CustomerInvoice'
        WHEN "BSEG"."BSCHL" = '02' THEN 'ReverseCreditMemo'
        WHEN "BSEG"."BSCHL" = '03' THEN 'BankCharges'
        WHEN "BSEG"."BSCHL" = '05' THEN 'OutgoingPayment'
        WHEN "BSEG"."BSCHL" = '06' THEN 'PaymentDifferences'
        WHEN "BSEG"."BSCHL" = '08' THEN 'PaymentClearing'
        WHEN "BSEG"."BSCHL" = '09' THEN 'OutgoingDebitPosting'
        ELSE 'Other' END                                                           AS "CustomerAccountTransactionType",
    CAST("BSEG"."MANST" AS BIGINT)                                                 AS "DunningLevel",
    CAST("BSEG"."ZFBDT" AS TIMESTAMP)                                              AS "BaselineDate",
    "BSEG"."ZBD1P"                                                                 AS "CashDiscountPercentage1",
    "BSEG"."ZBD2P"                                                                 AS "CashDiscountPercentage2",
    "BSEG"."ZTERM"                                                                 AS "PaymentTerms",
    "BSEG"."ZBD1T"                                                                 AS "PaymentDays1",
    "BSEG"."ZBD2T"                                                                 AS "PaymentDays2",
    "BSEG"."ZBD3T"                                                                 AS "PaymentDays3",
    "BSEG"."SGTXT"                                                                 AS "ItemText",
    "BSEG"."WRBTR"                                                                 AS "Amount",
    "BKPF"."WAERS"                                                                 AS "Currency",
    "BKPF"."BLART"                                                                 AS "DocumentType",
    CAST("BKPF"."BLDAT" AS TIMESTAMP)                                              AS "DocumentDate",
    CAST("BSEG"."AUGDT" AS TIMESTAMP)                                              AS "ClearingDate",
    "BSEG"."WSKTO"                                                                 AS "CashDiscountTakenAmount",
    "BSEG"."SKFBT"                                                                 AS "CashDiscountEligibleAmount",
    "BSEG"."BELNR"                                                                 AS "SystemAccountingDocumentNumber",
    "BSEG"."MANSP"                                                                 AS "DunningBlock",
    CASE
        WHEN "BKPF"."XREVERSAL" = '1' THEN 'Reversed Document'
        WHEN "BKPF"."XREVERSAL" = '2' THEN 'Reversal Document' END                 AS "ReversalIndicator",
    'SAP'                                                                          AS "SourceSystemType",
	<%=sourceSystem%>  || "BSEG"."MANDT"                                           AS "SourceSystemInstance",
    "BSEG"."BUZEI"                                                                 AS "SystemAccountingDocumentItemNumber",
    "BSEG"."BELNR"                                                                 AS "DatabaseAccountingDocumentNumber",
    "BSEG"."BUZEI"                                                                 AS "DatabaseAccountingDocumentItemNumber",
    "BSEG"."BUKRS"                                                                 AS "CompanyCode",
    CAST("BSEG"."GJAHR" AS BIGINT)                                                 AS "FiscalYear",
	<%=sourceSystem%>  || 'Customer_' || "BSEG"."MANDT" || "BSEG"."KUNNR"          AS "Customer",
	<%=sourceSystem%>  || 'CustomerMasterCompanyCode_' || "BSEG"."MANDT" || "BSEG"."KUNNR"
    || "BSEG"."BUKRS"                                                              AS "CustomerMasterCompanyCode"
FROM "BSEG" AS "BSEG"
         LEFT JOIN "BKPF" AS "BKPF"
                   ON "BSEG"."MANDT" = "BKPF"."MANDT"
                       AND "BSEG"."BUKRS" = "BKPF"."BUKRS"
                       AND "BSEG"."BELNR" = "BKPF"."BELNR"
                       AND "BSEG"."GJAHR" = "BKPF"."GJAHR"
         LEFT JOIN "USR02" AS "USR02"
                   ON "BKPF"."MANDT" = "USR02"."MANDT"
                       AND "BKPF"."USNAM" = "USR02"."BNAME"
WHERE "BSEG"."MANDT" IS NOT NULL
  AND "BKPF"."MANDT" IS NOT NULL
  AND "BSEG"."KOART" = 'D'
  AND "BSEG"."SHKZG" = 'S'


================================================================================================================================================================


                    
                    *************************            CDPOS          ****************************


SELECT <%=sourceSystem%>  || 'CustomerAccountDebitItem_' || "CDPOS"."TABKEY" AS "ObjectID",
	<%=sourceSystem%>  || "CDPOS"."TABKEY" || "CDPOS"."TABNAME" || "CDPOS"."FNAME"
       || "CDPOS"."CHANGENR" || "CDPOS"."CHNGIND"                            AS "ID",
       CAST("CDHDR"."UDATE" AS DATE)
            + CAST(TIMESTAMPDIFF(SECOND, CAST("CDHDR"."UTIME" AS DATE),
            "CDHDR"."UTIME") AS INTERVAL SECOND)                             AS "Time",
       CASE
           WHEN "CDPOS"."FNAME" = 'MANST' THEN 'DunningLevel'
           WHEN "CDPOS"."FNAME" = 'SGTXT' THEN 'ItemText'
           WHEN "CDPOS"."FNAME" = 'ZFBDT' THEN 'BaselineDate'
           WHEN "CDPOS"."FNAME" = 'ZBD1T' THEN 'PaymentDays1'
           WHEN "CDPOS"."FNAME" = 'ZBD2T' THEN 'PaymentDays2'
           WHEN "CDPOS"."FNAME" = 'ZBD3T' THEN 'PaymentDays3'
           WHEN "CDPOS"."FNAME" = 'ZBD1P' THEN 'CashDiscountPercentage1'
           WHEN "CDPOS"."FNAME" = 'ZBD2P' THEN 'CashDiscountPercentage2'
           WHEN "CDPOS"."FNAME" = 'ZTERM' THEN 'PaymentTerms'
           WHEN "CDPOS"."FNAME" = 'MANSP' THEN 'DunningBlock'
           END                                                               AS "Attribute",
       CASE
           WHEN "CDPOS"."VALUE_OLD" LIKE '%-' THEN CONCAT('-', REPLACE(LTRIM("CDPOS"."VALUE_OLD"), '-', ''))
           ELSE "CDPOS"."VALUE_OLD" END                                      AS "OldValue",
       CASE
           WHEN "CDPOS"."VALUE_NEW" LIKE '%-' THEN CONCAT('-', REPLACE(LTRIM("CDPOS"."VALUE_NEW"), '-', ''))
           ELSE "CDPOS"."VALUE_NEW" END                                      AS "NewValue",
       'User_' || "CDHDR"."MANDANT" || "CDHDR"."USERNAME"                    AS "ChangedBy",
       "CDHDR"."TCODE"                                                       AS "OperationType",
       "CDHDR"."CHANGENR"                                                    AS "OperationID",
       CASE
           WHEN "USR02"."USTYP" IN ('B', 'C') THEN 'Automatic'
           ELSE 'Manual' END                                                 AS "ExecutionType"
FROM "CDPOS" AS "CDPOS"
         LEFT JOIN "CDHDR" AS "CDHDR"
                   ON "CDPOS"."MANDANT" = "CDHDR"."MANDANT"
                       AND "CDPOS"."OBJECTCLAS" = "CDHDR"."OBJECTCLAS"
                       AND "CDPOS"."ObjectID" = "CDHDR"."ObjectID"
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
  AND "CDPOS"."FNAME" IN ('MANST', 'SGTXT', 'ZFBDT', 'ZBD1T', 'ZBD2T', 'ZBD3T', 'ZBD1P',
                          'ZBD2P', 'ZTERM', 'MANSP')
  AND "CDPOS"."CHNGIND" = 'U'
  AND "CDPOS"."MANDANT" IS NOT NULL
  AND "CDHDR"."MANDANT" IS NOT NULL
  AND "BSEG"."MANDT" IS NOT NULL
  AND "BKPF"."MANDT" IS NOT NULL
  AND "BSEG"."SHKZG" = 'S'
  AND "BSEG"."KOART" = 'D'
