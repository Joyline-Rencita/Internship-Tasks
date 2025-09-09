                    *************************                CTE_ClearingPointer              ******************************

WITH "CTE_ClearingPointer" AS (SELECT DISTINCT "BSEG"."MANDT", "BSEG"."BUKRS", "BSEG"."AUGBL", "BSEG"."AUGGJ", "BSEG"."AUGDT"
                               FROM "BSEG" AS "BSEG"
                               WHERE "BSEG"."KOART" = 'D'
                                 AND "BSEG"."AUGBL" IS NOT NULL)
SELECT <%=sourceSystem%>  || COALESCE('CustomerAccountClearingAssignment_' || "BKPF_PAY"."MANDT" || "BKPF_PAY"."BUKRS"
                || "BKPF_PAY"."BELNR"
                || "BKPF_PAY"."GJAHR",
                'CustomerAccountClearingAssignment_' || "ClearingPointer"."MANDT" || "ClearingPointer"."BUKRS"
                || "ClearingPointer"."AUGBL" || "ClearingPointer"."AUGGJ")     AS "ID",
       CASE
           WHEN "BKPF_PAY"."MANDT" IS NOT NULL
               THEN TIMESTAMPADD(MILLISECOND, 1, CAST("BKPF_PAY"."CPUDT" AS DATE) + CAST(TIMESTAMPDIFF(SECOND, CAST("BKPF_PAY"."CPUTM" AS DATE),
                    "BKPF_PAY"."CPUTM") AS INTERVAL SECOND))
           ELSE CAST(CONCAT(CAST("ClearingPointer"."AUGDT" AS VARCHAR), '23:59:59') AS TIMESTAMP)
           END                                                                 AS "CreationTime",
	<%=sourceSystem%>  || 'User_' || "BKPF_PAY"."MANDT" || "BKPF_PAY"."USNAM"     AS "CreatedBy",
       CASE
           WHEN "USR02"."USTYP" IN ('B', 'C') THEN 'Automatic'
           ELSE 'Manual' END                                                   AS "CreationExecutionType",
       'SAP'                                                                   AS "SourceSystemType",
	<%=sourceSystem%>  || COALESCE("BKPF_PAY"."MANDT", "ClearingPointer"."MANDT") AS "SourceSystemInstance"
FROM "CTE_ClearingPointer" AS "ClearingPointer"
         LEFT JOIN "BKPF" AS "BKPF_PAY"
                   ON "ClearingPointer"."MANDT" = "BKPF_PAY"."MANDT"
                       AND "ClearingPointer"."BUKRS" = "BKPF_PAY"."BUKRS"
                       AND "ClearingPointer"."AUGBL" = "BKPF_PAY"."BELNR"
                       AND "ClearingPointer"."AUGGJ" = "BKPF_PAY"."GJAHR"
         LEFT JOIN "USR02" AS "USR02"
                   ON "BKPF_PAY"."MANDT" = "USR02"."MANDT"
                       AND "BKPF_PAY"."USNAM" = "USR02"."BNAME"
WHERE "ClearingPointer"."AUGBL" IS NOT NULL


================================================================================================================================================================

                                                       RELATIONSHIPS
                      
=================================================================================================================================================================



             ************************************          BSEG      ********************************************


SELECT <%=sourceSystem%>  || 'CustomerAccountClearingAssignment_' || "BSEG"."MANDT" || "BSEG"."BUKRS" || "BSEG"."AUGBL"
       || "BSEG"."AUGGJ"                   AS "ID",
	<%=sourceSystem%>  || 'CustomerAccountCreditItem_' || "BSEG"."MANDT" || "BSEG"."BUKRS" || "BSEG"."BELNR"
       || "BSEG"."GJAHR" || "BSEG"."BUZEI" AS "CustomerAccountCreditItems"
FROM "BSEG" AS "BSEG"
WHERE "BSEG"."KOART" = 'D'
  AND "BSEG"."AUGBL" IS NOT NULL
  AND "BSEG"."SHKZG" = 'H'


             ************************************          BSEG-1      ********************************************


SELECT <%=sourceSystem%>  || 'CustomerAccountClearingAssignment_' || "BSEG"."MANDT" || "BSEG"."BUKRS" || "BSEG"."AUGBL"
       || "BSEG"."AUGGJ"                   AS "ID",
	<%=sourceSystem%>  || 'CustomerAccountDebitItem_' || "BSEG"."MANDT" || "BSEG"."BUKRS" || "BSEG"."BELNR"
       || "BSEG"."GJAHR" || "BSEG"."BUZEI" AS "CustomerAccountDebitItems"
FROM "BSEG" AS "BSEG"
WHERE "BSEG"."KOART" = 'D'
  AND "BSEG"."AUGBL" IS NOT NULL
  AND "BSEG"."SHKZG" = 'S'


