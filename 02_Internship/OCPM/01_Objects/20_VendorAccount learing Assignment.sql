--                        *****************       CTE_CLEARING POINT       ************************

WITH "CTE_ClearingPointer" AS (SELECT DISTINCT "BSEG"."MANDT", "BSEG"."BUKRS", "BSEG"."AUGBL", "BSEG"."AUGGJ", "BSEG"."AUGDT"
                               FROM "BSEG" AS "BSEG"
                               WHERE "BSEG"."KOART" = 'K'
                                 AND "BSEG"."AUGBL" IS NOT NULL)
SELECT <%=sourceSystem%>  || COALESCE('VendorAccountClearingAssignment_' || "BKPF_PAY"."MANDT" || "BKPF_PAY"."BUKRS" || "BKPF_PAY"."BELNR"
                || "BKPF_PAY"."GJAHR",
                'VendorAccountClearingAssignment_' || "ClearingPointer"."MANDT" || "ClearingPointer"."BUKRS"
                || "ClearingPointer"."AUGBL" || "ClearingPointer"."AUGGJ")     AS "ID",
       CASE
           WHEN "BKPF_PAY"."MANDT" IS NOT NULL
               THEN TIMESTAMPADD(MILLISECOND, 1, CAST("BKPF_PAY"."CPUDT" AS DATE) + CAST(TIMESTAMPDIFF(SECOND, CAST("BKPF_PAY"."CPUTM" AS DATE),
                    "BKPF_PAY"."CPUTM") AS INTERVAL SECOND)
                  )
           ELSE CAST("ClearingPointer"."AUGDT" AS DATE) + INTERVAL '86399' SECOND
           END                                                                 AS "CreationTime",
	<%=sourceSystem%>  || 'User_' || "BKPF_PAY"."MANDT" || "BKPF_PAY"."USNAM"     AS "CreatedBy",
       CASE
           WHEN "USR02"."USTYP" IN ('B', 'C') THEN 'Automatic'
           ELSE 'Manual' END                                                   AS "CreationExecutionType",
       'SAP'                                                                   AS "SourceSystemType",
	<%=sourceSystem%>  || COALESCE("BKPF_PAY"."MANDT", "ClearingPointer"."MANDT") AS "SourceSystemInstance",
	<%=sourceSystem%>  || NULL                                                    AS "Vendor",
	<%=sourceSystem%>  || NULL                                                    AS "VendorMasterCompanyCode"
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



-- =========================================================================================================================================================


--                  ************************         BSEG  ->  VendorAccountCreditItems   ***************************

SELECT <%=sourceSystem%>  || 'VendorAccountClearingAssignment_' || "BSEG"."MANDT" || "BSEG"."BUKRS" || "BSEG"."AUGBL"
       || "BSEG"."AUGGJ"                   AS "ID",
	<%=sourceSystem%>  || 'VendorAccountCreditItem_' || "BSEG"."MANDT" || "BSEG"."BUKRS" || "BSEG"."BELNR"
       || "BSEG"."GJAHR" || "BSEG"."BUZEI" AS "VendorAccountCreditItems"
FROM "BSEG" AS "BSEG"
WHERE "BSEG"."KOART" = 'K'
  AND "BSEG"."AUGBL" IS NOT NULL
  AND "BSEG"."SHKZG" = 'H'

-- ============================================================================================================================================================


--                  ************************         BSEG  -> VendorAccountDebitItems    ***************************


SELECT <%=sourceSystem%>  || 'VendorAccountClearingAssignment_' || "BSEG"."MANDT" || "BSEG"."BUKRS" || "BSEG"."AUGBL"
       || "BSEG"."AUGGJ"                   AS "ID",
	<%=sourceSystem%>  || 'VendorAccountDebitItem_' || "BSEG"."MANDT" || "BSEG"."BUKRS" || "BSEG"."BELNR"
       || "BSEG"."GJAHR" || "BSEG"."BUZEI" AS "VendorAccountDebitItems"
FROM "BSEG" AS "BSEG"
WHERE "BSEG"."KOART" = 'K'
  AND "BSEG"."AUGBL" IS NOT NULL
  AND "BSEG"."SHKZG" = 'S'



