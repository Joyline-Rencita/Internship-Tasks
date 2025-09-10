                      **************************            VBRP          ***************************

SELECT <%=sourceSystem%>  || 'CustomerInvoiceCancellationItem_' || "VBRP"."MANDT" || "VBRP"."VBELN" || "VBRP"."POSNR" AS "ID",
    CAST("VBRP"."ERDAT" AS DATE) + CAST(TIMESTAMPDIFF(SECOND, CAST("VBRP"."ERZET" AS DATE),
            "VBRP"."ERZET") AS INTERVAL SECOND)                                                                       AS "CreationTime",
	<%=sourceSystem%>  || 'CustomerInvoiceCancellation_' || "VBRP"."MANDT" || "VBRP"."VBELN"                             AS "Header",
	<%=sourceSystem%>  || 'User_' || "VBRP"."MANDT" || "VBRP"."ERNAM"                                                    AS "CreatedBy",
    CASE
        WHEN "USR02"."USTYP" IN ('B', 'C') THEN 'Automatic'
        ELSE 'Manual' END                                                                                             AS "CreationExecutionType",
    'SAP'                                                                                                             AS "SourceSystemType",
	<%=sourceSystem%>  || "VBRP"."MANDT"                                                                                 AS "SourceSystemInstance",
    "VBRP"."VBELN"                                                                                                    AS "SystemCustomerInvoiceCancellationNumber",
    "VBRP"."POSNR"                                                                                                    AS "SystemCustomerInvoiceCancellationItemNumber",
    "VBRP"."VBELN"                                                                                                    AS "DatabaseCustomerInvoiceCancellationNumber",
    "VBRP"."POSNR"                                                                                                    AS "DatabaseCustomerInvoiceCancellationItemNumber",
	<%=sourceSystem%>  || 'Material_' || "VBRP"."MANDT" || "VBRP"."MATNR"                                                AS "Material",
	<%=sourceSystem%>  || 'Plant_' || "VBRP"."MANDT" || "VBRP"."WERKS"                                                   AS "Plant"
FROM "VBRP" AS "VBRP"
         LEFT JOIN "VBRK" AS "VBRK"
                   ON "VBRP"."MANDT" = "VBRK"."MANDT"
                       AND "VBRP"."VBELN" = "VBRK"."VBELN"
         LEFT JOIN "USR02" AS "USR02"
                   ON "VBRP"."MANDT" = "USR02"."MANDT"
                       AND "VBRP"."ERNAM" = "USR02"."BNAME"
WHERE "VBRP"."MANDT" IS NOT NULL
  AND "VBRK"."VBTYP" = 'N'
