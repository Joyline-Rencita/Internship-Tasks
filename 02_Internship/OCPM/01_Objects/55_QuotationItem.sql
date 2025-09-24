              *****************************        VBAP        **********************************


SELECT <%=sourceSystem%>  || 'QuotationItem_' || "VBAP"."MANDT" || "VBAP"."VBELN" || "VBAP"."POSNR" 	AS "ID",
    CAST("VBAP"."ERDAT" AS DATE)
            + CAST(TIMESTAMPDIFF(SECOND, CAST("VBAP"."ERZET" AS DATE),
            "VBAP"."ERZET") AS INTERVAL SECOND)                                                     	AS "CreationTime",
	<%=sourceSystem%>  || 'Quotation_' || "VBAP"."MANDT" || "VBAP"."VBELN"                             	AS "Header",
	<%=sourceSystem%>  || 'User_' || "VBAP"."MANDT" || "VBAP"."ERNAM"                                  	AS "CreatedBy",
    CASE
        WHEN "USR02"."USTYP" IN ('B', 'C') THEN 'Automatic'
        ELSE 'Manual' END                                                                           AS "CreationExecutionType",
    'SAP'                                                                                           AS "SourceSystemType",
	<%=sourceSystem%>  || "VBAP"."MANDT"                                                               AS "SourceSystemInstance"
FROM "VBAP" AS "VBAP"
         LEFT JOIN "VBAK" AS "VBAK"
                   ON "VBAP"."MANDT" = "VBAK"."MANDT"
                       AND "VBAP"."VBELN" = "VBAK"."VBELN"
         LEFT JOIN "USR02" AS "USR02"
                   ON "VBAP"."MANDT" = "USR02"."MANDT"
                       AND "VBAP"."ERNAM" = "USR02"."BNAME"
WHERE "VBAK"."MANDT" IS NOT NULL
  AND "VBAK"."VBTYP" = 'B'
