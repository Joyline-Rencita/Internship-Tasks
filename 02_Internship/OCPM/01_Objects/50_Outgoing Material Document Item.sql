                    ************************        MSEG        ****************************

WITH "CTE_EKBE" AS (SELECT DISTINCT "EKBE"."MANDT",
                                    "EKBE"."BELNR",
                                    "EKBE"."GJAHR",
                                    "EKBE"."BUZEI",
                                    "EKBE"."WAERS",
                                    "EKBE"."MENGE",
                                    "EKBE"."WRBTR"
                    FROM "EKBE" AS "EKBE"
                    WHERE "EKBE"."VGABE" = '1')
SELECT <%=sourceSystem%>  || 'OutgoingMaterialDocumentItem_' || "MSEG"."MANDT" || "MSEG"."MBLNR" || "MSEG"."MJAHR" || "MSEG"."ZEILE" AS "ID",
    CAST("MSEG"."CPUDT_MKPF" AS DATE) + CAST(TIMESTAMPDIFF(SECOND, CAST("MSEG"."CPUTM_MKPF" AS DATE),
            "MSEG"."CPUTM_MKPF") AS INTERVAL SECOND)                                                                                 AS "CreationTime",
	<%=sourceSystem%>  || 'User_' || "MSEG"."MANDT" || "MSEG"."USNAM_MKPF"                                                           AS "CreatedBy",
    CASE
        WHEN "USR02"."USTYP" IN ('B', 'C') THEN 'Automatic'
        ELSE 'Manual' END                                                                                                            AS "CreationExecutionType",
    CASE
        WHEN "T156"."XSTBW" = 'X' THEN '1'
        ELSE 0
        END                                                                                                                          AS "ReversalFlag",
    CASE
        WHEN "MSEG"."BWART" = '601' THEN 'GoodsIssue'
        WHEN "MSEG"."BWART" = '102' THEN 'ReverseGoodsReceipt'
        WHEN "MSEG"."BWART" = '651' THEN 'ReturnGoodsReceipt'
        WHEN "MSEG"."BWART" = '122' THEN 'ReturnDeliveryToVendor'
        END                                                                                                                          AS "MaterialTransactionType",
    CASE
        WHEN "MSEG"."MATNR" IS NULL THEN "EKBE"."MENGE"
        WHEN "T156"."XSTBW" = 'X' THEN "MSEG"."MENGE" * -1.0
        ELSE "MSEG"."MENGE"
        END                                                                                                                          AS "Quantity",
    "MSEG"."ERFME"                                                                                                                   AS "QuantityUnit",
    "MSEG"."MEINS"                                                                                                                   AS "BaseQuantityUnit",
    "MSEG"."LGORT"                                                                                                                   AS "StorageLocation",
    "MSEG"."LBKUM"                                                                                                                   AS "BasePrePostingTotalValuatedStockQuantity",
    "EKBE"."WRBTR"                                                                                                                   AS "Amount",
    "EKBE"."WAERS"                                                                                                                   AS "Currency",
    'SAP'                                                                                                                            AS "SourceSystemType",
	<%=sourceSystem%>  || "MSEG"."MANDT"                                                                                             AS "SourceSystemInstance",
    "MSEG"."MBLNR"                                                                                                                   AS "SystemOutgoingMaterialDocumentNumber",
    "MSEG"."ZEILE"                                                                                                                   AS "SystemOutgoingMaterialDocumentItemNumber",
    "MSEG"."MBLNR"                                                                                                                   AS "DatabaseOutgoingMaterialDocumentNumber",
    "MSEG"."ZEILE"                                                                                                                   AS "DatabaseOutgoingMaterialDocumentItemNumber",
	<%=sourceSystem%>  || 'DeliveryItem_' || "MSEG"."MANDT" || "MSEG"."VBELN_IM"
    || "MSEG"."VBELP_IM"                                                                                                             AS "DeliveryItem",
	<%=sourceSystem%>  || 'SalesOrderItem_' || "MSEG"."MANDT" || "MSEG"."KDAUF" || "MSEG"."KDPOS"                                    AS "SalesOrderItem",
	<%=sourceSystem%>  || 'IncomingMaterialDocumentItem_' || "MSEG"."MANDT" || "MSEG"."SMBLN" || "MSEG"."SJAHR"
    || "MSEG"."SMBLP"                                                                                                                AS "ReversedIncomingGood",
	<%=sourceSystem%>  || 'Material_' || "MSEG"."MANDT" || "MSEG"."MATNR"                                                            AS "Material",
	<%=sourceSystem%>  || 'MaterialMasterPlant_' || "MSEG"."MANDT" || "MSEG"."MATNR"
    || "MSEG"."WERKS"                                                                                                                AS "MaterialMasterPlant",
	<%=sourceSystem%>  || 'Plant_' || "MSEG"."MANDT" || "MSEG"."WERKS"                                                               AS "Plant",
	<%=sourceSystem%>  || 'Vendor_' || "MSEG"."MANDT" || "MSEG"."LIFNR"                                                              AS "Vendor"
FROM "MSEG" AS "MSEG"
         LEFT JOIN "CTE_EKBE" AS "EKBE"
                   ON "MSEG"."MANDT" = "EKBE"."MANDT"
                       AND "MSEG"."MBLNR" = "EKBE"."BELNR"
                       AND "MSEG"."MJAHR" = "EKBE"."GJAHR"
                       AND "MSEG"."ZEILE" = "EKBE"."BUZEI"
         LEFT JOIN "T156" AS "T156"
                   ON "MSEG"."MANDT" = "T156"."MANDT"
                       AND "MSEG"."BWART" = "T156"."BWART"
         LEFT JOIN "USR02" AS "USR02"
                   ON "MSEG"."MANDT" = "USR02"."MANDT"
                       AND "MSEG"."USNAM_MKPF" = "USR02"."BNAME"
WHERE "MSEG"."MANDT" IS NOT NULL
  AND "MSEG"."SHKZG" = 'H'
