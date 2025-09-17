                *************************************             BSEG            ***************************************
					

SELECT <%=sourceSystem%>  || 'CustomerAccountCreditItem_' || "BSEG"."MANDT" || "BSEG"."BUKRS" || "BSEG"."BELNR" || "BSEG"."GJAHR"
       || "BSEG"."BUZEI"                                                                                                     	AS "ID",
       CAST("BKPF"."CPUDT" AS DATE) + CAST(TIMESTAMPDIFF(SECOND, CAST("BKPF"."CPUTM" AS DATE),
            "BKPF"."CPUTM") AS INTERVAL SECOND)                                                                              	AS "CreationTime",
	<%=sourceSystem%>  || 'User_' || "BKPF"."MANDT" || "BKPF"."USNAM"                                                           AS "CreatedBy",
       CASE
           WHEN "USR02"."USTYP" IN ('B', 'C') THEN 'Automatic'
           ELSE 'Manual' END                                                                                                 	AS "CreationExecutionType",
	<%=sourceSystem%>  || CASE
           WHEN "BKPF"."AWTYP" = 'VBRK' AND "BSEG"."BSCHL" = '11' THEN 'CreditMemo_' || "BKPF"."MANDT" || "BKPF"."AWKEY" END 	AS "CreditMemo",
	<%=sourceSystem%>  || CASE
           WHEN "BKPF"."AWTYP" = 'VBRK' AND "BSEG"."BSCHL" = '12'
               THEN 'CustomerInvoiceCancellation_' || "BKPF"."MANDT" || "BKPF"."AWKEY" END                                   	AS "CustomerInvoiceCancellation",
       'CustomerAccountCreditHead_' || "BKPF"."MANDT" || "BKPF"."BUKRS" || "BKPF"."BELNR"
       || "BKPF"."GJAHR"                                                                                                     	AS "CustomerAccountHead",
       CASE
           WHEN "BSEG"."BSCHL" = '11' THEN 'CreditMemo'
           WHEN "BSEG"."BSCHL" = '12' THEN 'CustomerInvoiceCancellation'
           WHEN "BSEG"."BSCHL" = '13' THEN 'ReverseCharges'
           WHEN "BSEG"."BSCHL" = '15' THEN 'IncomingPayment'
           WHEN "BSEG"."BSCHL" = '16' THEN 'PaymentDifferences'
           WHEN "BSEG"."BSCHL" = '18' THEN 'PaymentClearing'
           WHEN "BSEG"."BSCHL" = '19' THEN 'OutgoingCreditPosting'
           ELSE 'Other' END                                                                                                  AS "CustomerAccountTransactionType",
       CAST("BSEG"."ZFBDT" AS TIMESTAMP)                                                                                     AS "BaselineDate",
       "BSEG"."ZBD1P"                                                                                                        AS "CashDiscountPercentage1",
       "BSEG"."ZLSCH"                                                                                                        AS "PaymentMethod",
       "BSEG"."WRBTR"                                                                                                        AS "Amount",
       "BKPF"."WAERS"                                                                                                        AS "Currency",
       "BKPF"."BLART"                                                                                                        AS "DocumentType",
       CAST("BKPF"."BLDAT" AS TIMESTAMP)                                                                                     AS "DocumentDate",
       CAST("BSEG"."AUGDT" AS TIMESTAMP)                                                                                     AS "ClearingDate",
       "BSEG"."WSKTO"                                                                                                        AS "CashDiscountTakenAmount",
       "BSEG"."SKFBT"                                                                                                        AS "CashDiscountEligibleAmount",
       "BSEG"."BELNR"                                                                                                        AS "SystemAccountingDocumentNumber",
       CASE
           WHEN "BKPF"."XREVERSAL" = '1' THEN 'Reversed Document'
           WHEN "BKPF"."XREVERSAL" = '2' THEN 'Reversal Document' END                                                        AS "ReversalIndicator",
       'SAP'                                                                                                                 AS "SourceSystemType",
	<%=sourceSystem%>  || "BSEG"."MANDT"                                                                                     AS "SourceSystemInstance",
       "BSEG"."BUZEI"                                                                                                        AS "SystemAccountingDocumentItemNumber",
       "BSEG"."BELNR"                                                                                                        AS "DatabaseAccountingDocumentNumber",
       "BSEG"."BUZEI"                                                                                                        AS "DatabaseAccountingDocumentItemNumber",
       "BSEG"."BUKRS"                                                                                                        AS "CompanyCode",
       CAST("BSEG"."GJAHR" AS BIGINT)                                                                                        AS "FiscalYear",
	<%=sourceSystem%>  || 'Customer_' || "BSEG"."MANDT" || "BSEG"."KUNNR"                                                    AS "Customer",
	<%=sourceSystem%>  || 'CustomerMasterCompanyCode_' || "BSEG"."MANDT" || "BSEG"."KUNNR"
       || "BSEG"."BUKRS"                                                                                                     AS "CustomerMasterCompanyCode"
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
  AND "BSEG"."SHKZG" = 'H'

