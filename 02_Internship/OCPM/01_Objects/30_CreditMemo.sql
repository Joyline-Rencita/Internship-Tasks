SELECT <%=sourceSystem%>  || 'CreditMemo_' || "VBRK"."MANDT" || "VBRK"."VBELN" AS "ID",
    CAST("VBRK"."ERDAT" AS DATE)
            + CAST(TIMESTAMPDIFF(SECOND, CAST("VBRK"."ERZET" AS DATE),
            "VBRK"."ERZET") AS INTERVAL SECOND)                                AS "CreationTime",
	<%=sourceSystem%>  || 'User_' || "VBRK"."MANDT" || "VBRK"."ERNAM"             AS "CreatedBy",
    CASE
        WHEN "USR02"."USTYP" IN ('B', 'C') THEN 'Automatic'
        ELSE 'Manual' END                                                      AS "CreationExecutionType",
    'SAP'                                                                      AS "SourceSystemType",
	<%=sourceSystem%>  || "VBRK"."MANDT"                                          AS "SourceSystemInstance",
    "VBRK"."VBELN"                                                             AS "SystemCreditMemoNumber",
    "VBRK"."VBELN"                                                             AS "DatabaseCreditMemoNumber"
FROM "VBRK" AS "VBRK"
         LEFT JOIN "USR02" AS "USR02"
                   ON "VBRK"."MANDT" = "USR02"."MANDT"
                       AND "VBRK"."ERNAM" = "USR02"."BNAME"
WHERE "VBRK"."MANDT" IS NOT NULL
  AND "VBRK"."VBTYP" = 'O'
