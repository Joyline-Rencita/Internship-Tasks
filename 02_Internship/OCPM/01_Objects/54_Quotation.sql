                    ***************************        VBAK      *********************************

SELECT <%=sourceSystem%>  || 'Quotation_' || "VBAK"."MANDT" || "VBAK"."VBELN" 	AS "ID",
    CAST("VBAK"."ERDAT" AS DATE)
            + CAST(TIMESTAMPDIFF(SECOND, CAST("VBAK"."ERZET" AS DATE),
            "VBAK"."ERZET") AS INTERVAL SECOND)                               	AS "CreationTime",
	<%=sourceSystem%>  || 'User_' || "VBAK"."MANDT" || "VBAK"."ERNAM"           AS "CreatedBy",
    CASE
        WHEN "USR02"."USTYP" IN ('B', 'C') THEN 'Automatic'
        ELSE 'Manual' END                                                     AS "CreationExecutionType",
    'SAP'                                                                     AS "SourceSystemType",
	<%=sourceSystem%>  || "VBAK"."MANDT"                                         AS "SourceSystemInstance"
FROM "VBAK" AS "VBAK"
         LEFT JOIN "USR02" AS "USR02"
                   ON "VBAK"."MANDT" = "USR02"."MANDT"
                       AND "VBAK"."ERNAM" = "USR02"."BNAME"
WHERE "VBAK"."MANDT" IS NOT NULL
  AND "VBAK"."VBTYP" = 'B'
