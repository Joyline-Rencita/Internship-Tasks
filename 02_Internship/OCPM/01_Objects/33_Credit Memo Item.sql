              ****************************            VBRP          ******************************

SELECT <%=sourceSystem%>  || 'CreditMemoItem_' || CAST("VBRP"."MANDT" AS VARCHAR(100)) || CAST("VBRP"."VBELN" AS VARCHAR(100))
    || CAST("VBRP"."POSNR" AS VARCHAR(100))                                                                          	AS "ID",
    CAST("VBRP"."ERDAT" AS DATE)
            + CAST(TIMESTAMPDIFF(SECOND, CAST("VBRP"."ERZET" AS DATE),
            "VBRP"."ERZET") AS INTERVAL SECOND)                                                                      	AS "CreationTime",
	<%=sourceSystem%>  || 'User_' || CAST("VBRP"."MANDT" AS VARCHAR(100)) || CAST("VBRP"."ERNAM" AS VARCHAR(100))       AS "CreatedBy",
    CASE
        WHEN "USR02"."USTYP" IN ('B', 'C') THEN 'Automatic'
        ELSE 'Manual' END                                                                                            	AS "CreationExecutionType",
    'SAP'                                                                                                            	AS "SourceSystemType",
	<%=sourceSystem%>  || CAST("VBRP"."MANDT" AS VARCHAR(100))                                                          AS "SourceSystemInstance",
    CAST("VBRP"."VBELN" AS VARCHAR(100))                                                                             	AS "SystemCreditMemoNumber",
    CAST("VBRP"."POSNR" AS VARCHAR(100))                                                                             	AS "SystemCreditMemoItemNumber",
    CAST("VBRP"."VBELN" AS VARCHAR(100))                                                                             	AS "DatabaseCreditMemoNumber",
    CAST("VBRP"."POSNR" AS VARCHAR(100))                                                                             	AS "DatabaseCreditMemoItemNumber",
	<%=sourceSystem%>  || 'CreditMemo_' || CAST("VBRP"."MANDT" AS VARCHAR(100)) || CAST("VBRP"."VBELN" AS VARCHAR(100)) AS "Header",
	<%=sourceSystem%>  || 'Material_' || CAST("VBRP"."MANDT" AS VARCHAR(100)) || CAST("VBRP"."MATNR" AS VARCHAR(100))   AS "Material",
	<%=sourceSystem%>  || 'MaterialMasterPlant_' || CAST("VBRP"."MANDT" AS VARCHAR(100)) || CAST("VBRP"."MATNR" AS VARCHAR(100))
    || CAST("VBRP"."WERKS" AS VARCHAR(100))                                                                          	AS "MaterialMasterPlant",
	<%=sourceSystem%>  || 'Plant_' || CAST("VBRP"."MANDT" AS VARCHAR(100)) || CAST("VBRP"."WERKS" AS VARCHAR(100))      AS "Plant"
FROM "VBRP" AS "VBRP"
         LEFT JOIN "VBRK" AS "VBRK"
                   ON "VBRP"."MANDT" = "VBRK"."MANDT"
                       AND "VBRP"."VBELN" = "VBRK"."VBELN"
         LEFT JOIN "USR02" AS "USR02"
                   ON "VBRP"."ERNAM" = "USR02"."BNAME"
                       AND "VBRP"."MANDT" = "USR02"."MANDT"
WHERE "VBRP"."MANDT" IS NOT NULL
  AND "VBRK"."VBTYP" = 'O'

