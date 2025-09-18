              ***********************         VBRP      ****************************

SELECT <%=sourceSystem%>  || 'CustomerInvoiceItem_' || "VBRP"."MANDT" || "VBRP"."VBELN" || "VBRP"."POSNR" 	AS "ID",
    CAST("VBRP"."ERDAT" AS DATE) + CAST(TIMESTAMPDIFF(SECOND, CAST("VBRP"."ERZET" AS DATE),
            "VBRP"."ERZET") AS INTERVAL SECOND)                                                           	AS "CreationTime",
	<%=sourceSystem%>  || 'CustomerInvoice_' || "VBRP"."MANDT" || "VBRP"."VBELN"                            AS "Header",
	<%=sourceSystem%>  || 'User_' || "VBRP"."MANDT" || "VBRP"."ERNAM"                                       AS "CreatedBy",
    CASE
        WHEN "USR02"."USTYP" IN ('B', 'C') THEN 'Automatic'
        ELSE 'Manual' END                                                                                 	AS "CreationExecutionType",
    'SAP'                                                                                                 	AS "SourceSystemType",
	<%=sourceSystem%>  || "VBRP"."MANDT"                                                                    AS "SourceSystemInstance",
    "VBRP"."VBELN"                                                                                        	AS "SystemCustomerInvoiceNumber",
    "VBRP"."POSNR"                                                                                        	AS "SystemCustomerInvoiceItemNumber",
    "VBRP"."VBELN"                                                                                        	AS "DatabaseCustomerInvoiceNumber",
    "VBRP"."POSNR"                                                                                        AS "DatabaseCustomerInvoiceItemNumber",
    "VBRP"."VRKME"                                                                                        AS "QuantityUnit",
    "VBRK"."WAERK"                                                                                        AS "Currency",
    "VBRP"."FKIMG"                                                                                        AS "InvoicedQuantity",
    "VBRP"."NETWR"                                                                                        AS "NetAmount",
    CASE
        WHEN "VBRP"."NETWR" = 0 AND "VBRP"."FKIMG" = 0 THEN 0
        ELSE "VBRP"."NETWR" / "VBRP"."FKIMG" END                                                          	AS "NetUnitPrice",
	<%=sourceSystem%>  || 'Material_' || "VBRP"."MANDT" || "VBRP"."MATNR"                                    AS "Material",
	<%=sourceSystem%>  || 'Plant_' || "VBRP"."MANDT" || "VBRP"."WERKS"                                       AS "Plant",
	<%=sourceSystem%>  || 'SalesOrderItem_' || "VBRP"."MANDT" || "VBRP"."AUBEL" || "VBRP"."AUPOS"            AS "SalesOrderItem"
FROM "VBRP" AS "VBRP"
         LEFT JOIN "VBRK" AS "VBRK"
                   ON "VBRP"."MANDT" = "VBRK"."MANDT"
                       AND "VBRP"."VBELN" = "VBRK"."VBELN"
         LEFT JOIN "USR02" AS "USR02"
                   ON "VBRP"."MANDT" = "USR02"."MANDT"
                       AND "VBRP"."ERNAM" = "USR02"."BNAME"
WHERE "VBRP"."MANDT" IS NOT NULL
  AND "VBRK"."VBTYP" = 'M'


===================================================================================================================================================================

								RELATIONSHIP -  Delivery Items
				  
===================================================================================================================================================================



					***********************			VBRP - 1 		************************


SELECT <%=sourceSystem%>  || 'CustomerInvoiceItem_' || "VBRP"."MANDT" || "VBRP"."VBELN" || "VBRP"."POSNR" AS "ID",
	<%=sourceSystem%>  || 'DeliveryItem_' || "LIPS"."MANDT" || "LIPS"."VBELN" || "LIPS"."POSNR"              AS "DeliveryItems"
FROM (SELECT "VBRP"."MANDT" AS "MANDT",
             "VBRP"."VGBEL" AS "VGBEL",
             "VBRP"."VGPOS" AS "VGPOS",
             "VBRP"."VBELN" AS "VBELN",
             "VBRP"."POSNR" AS "POSNR"
      FROM "VBRP" AS "VBRP"
          INNER JOIN "VBRK" AS "VBRK"
      ON "VBRP"."MANDT" = "VBRK"."MANDT"
          AND "VBRP"."VBELN" = "VBRK"."VBELN"
          AND "VBRK"."VBTYP" = 'M'
      ORDER BY "VBRP"."MANDT", "VBRP"."VGBEL", "VBRP"."VGPOS") AS "VBRP"
         INNER JOIN "LIPS" AS "LIPS"
                ON "VBRP"."MANDT" = "LIPS"."MANDT"
                    AND "VBRP"."VGBEL" = "LIPS"."VBELN"
                    AND "VBRP"."VGPOS" = "LIPS"."POSNR"
