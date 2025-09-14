              *******************************        VBAP      *********************************

SELECT <%=sourceSystem%>  || 'SalesOrderItem_' || "VBAP"."MANDT" || "VBAP"."VBELN" || "VBAP"."POSNR"              AS "ID",
    CAST("VBAP"."ERDAT" AS DATE) + CAST(TIMESTAMPDIFF(SECOND, CAST("VBAP"."ERZET" AS DATE),
            "VBAP"."ERZET") AS INTERVAL SECOND)                                                                   AS "CreationTime",
	<%=sourceSystem%>  || 'SalesOrder_' || "VBAP"."MANDT" || "VBAP"."VBELN"                                          AS "Header",
	<%=sourceSystem%>  || CASE
        WHEN "VBAP"."VGTYP" = 'B' THEN 'QuotationItem_' || "VBAP"."MANDT" || "VBAP"."VGBEL" || "VBAP"."VGPOS" END AS "QuotationItem",
	<%=sourceSystem%>  || 'User_' || "VBAP"."MANDT" || "VBAP"."ERNAM"                                                AS "CreatedBy",
    CASE
        WHEN "USR02"."USTYP" IN ('B', 'C') THEN 'Automatic'
        ELSE 'Manual' END                                                                                         AS "CreationExecutionType",
    "VBAP"."NETWR"                                                                                                AS "NetAmount",
    "VBAP"."WAERK"                                                                                                AS "Currency",
    "VBAP"."NETPR" / COALESCE("VBAP"."KPEIN", 1)                                                                  AS "NetUnitPrice",
	<%=sourceSystem%>  || 'Material_' || "VBAP"."MANDT" || "VBAP"."MATNR"                                            AS "Material",
	<%=sourceSystem%>  || 'Plant_' || "VBAP"."MANDT" || "VBAP"."WERKS"                                               AS "Plant",
    "VBAP"."ABGRU"                                                                                                AS "RejectionReason",
    "TVAGT"."BEZEI"                                                                                               AS "RejectionReasonText",
    "VBAP"."OBJNR"                                                                                                AS "ObjectNumber",
    "VBAP"."FKREL"                                                                                                AS "BillingRelevance",
    "VBAP"."PSTYV"                                                                                                AS "ItemCategory",
    "TVAPT"."VTEXT"                                                                                               AS "ItemCategoryText",
    "TVRO"."TRAZTD" / 240000                                                                                      AS "TransitDurationDays",
	<%=sourceSystem%>  || "VBAP"."MANDT"                                                                             AS "SourceSystemInstance",
    "VBAP"."VBELN"                                                                                                AS "SystemSalesOrderNumber",
    "VBAP"."VBELN"                                                                                                AS "DatabaseSalesOrderNumber",
    'SAP'                                                                                                         AS "SourceSystemType",
    "VBAP"."POSNR"                                                                                                AS "SystemSalesOrderItemNumber",
    "VBAP"."POSNR"                                                                                                AS "DatabaseSalesOrderItemNumber",
    "VBAP"."BRGEW"                                                                                                AS "GrossItemWeight",
    "VBAP"."GEWEI"                                                                                                AS "WeightUnit",
    "VBAP"."NTGEW"                                                                                                AS "NetItemWeight",
	<%=sourceSystem%>  || 'MaterialMasterPlant_' || "VBAP"."MANDT" || "VBAP"."MATNR" || "VBAP"."WERKS"               AS "MaterialMasterPlant",
    NULL                                                                                                          AS "ProcessingStatus",
    "VBAP"."VRKME"                                                                                                AS "QuantityUnit",
    "VBAP"."KWMENG"                                                                                               AS "OrderedQuantity",
    "VBAP"."KDMAT"                                                                                                AS "ExternalMaterialNumber"
FROM "VBAP" AS "VBAP"
         LEFT JOIN "VBAK" AS "VBAK"
                   ON "VBAP"."MANDT" = "VBAK"."MANDT"
                       AND "VBAP"."VBELN" = "VBAK"."VBELN"
         LEFT JOIN "USR02" AS "USR02"
                   ON "VBAP"."MANDT" = "USR02"."MANDT"
                       AND "VBAP"."ERNAM" = "USR02"."BNAME"
         LEFT JOIN "TVAPT" AS "TVAPT"
                   ON "VBAP"."MANDT" = "TVAPT"."MANDT"
                       AND "VBAP"."PSTYV" = "TVAPT"."PSTYV"
                       AND "TVAPT"."SPRAS" = <%=LanguageKey%> 
         LEFT JOIN "TVAGT" AS "TVAGT"
                   ON "VBAP"."MANDT" = "TVAGT"."MANDT"
                       AND "VBAP"."ABGRU" = "TVAGT"."ABGRU"
                       AND "TVAGT"."SPRAS" = <%=LanguageKey%> 
         LEFT JOIN "TVRO" AS "TVRO"
                   ON "VBAP"."MANDT" = "TVRO"."MANDT"
                       AND "VBAP"."ROUTE" = "TVRO"."ROUTE"
WHERE "VBAP"."MANDT" IS NOT NULL
  AND "VBAK"."VBTYP" IN ('C', 'I')


====================================================================================================================================================================


								**************************			CDPOS			**********************************

SELECT <%=sourceSystem%>  || 'SalesOrderItem_' || SUBSTRING("CDPOS"."TABKEY", 1, 19) AS "ObjectID",
	<%=sourceSystem%>  || "CDPOS"."TABKEY" || "CDPOS"."TABNAME" || "CDPOS"."FNAME"
       || "CDPOS"."CHANGENR" || "CDPOS"."CHNGIND"                                    AS "ID",
       CAST("CDHDR"."UDATE" AS DATE)
            + CAST(TIMESTAMPDIFF(SECOND, CAST("CDHDR"."UTIME" AS DATE),
            "CDHDR"."UTIME") AS INTERVAL SECOND)                                     AS "Time",
       CASE
           WHEN "CDPOS"."FNAME" = 'NETPR' THEN 'NetUnitPrice'
           WHEN "CDPOS"."FNAME" = 'MATNR' THEN 'MaterialNumber'
           WHEN "CDPOS"."FNAME" = 'ABGRU' THEN 'RejectionReason'
           WHEN "CDPOS"."FNAME" = 'WERKS' THEN 'Plant'
           WHEN "CDPOS"."FNAME" = 'KWMENG' THEN 'OrderedQuantity'
           END                                                                       AS "Attribute",
       CASE
           WHEN "CDPOS"."VALUE_OLD" LIKE '%-'
               THEN CONCAT('-', REPLACE(LTRIM("CDPOS"."VALUE_OLD"), '-', ''))
           ELSE "CDPOS"."VALUE_OLD" END                                              AS "OldValue",
       CASE
           WHEN "CDPOS"."VALUE_NEW" LIKE '%-'
               THEN CONCAT('-', REPLACE(LTRIM("CDPOS"."VALUE_NEW"), '-', ''))
           ELSE "CDPOS"."VALUE_NEW" END                                              AS "NewValue",
       'User_' || "CDHDR"."MANDANT" || "CDHDR"."USERNAME"                            AS "ChangedBy",
       "CDHDR"."TCODE"                                                               AS "OperationType",
       "CDHDR"."CHANGENR"                                                            AS "OperationID",
       CASE
           WHEN "USR02"."USTYP" IN ('B', 'C') THEN 'Automatic'
           ELSE 'Manual' END                                                         AS "ExecutionType"
FROM "CDPOS" AS "CDPOS"
         LEFT JOIN "CDHDR" AS "CDHDR"
                   ON "CDPOS"."MANDANT" = "CDHDR"."MANDANT"
                       AND "CDPOS"."OBJECTCLAS" = "CDHDR"."OBJECTCLAS"
                       AND "CDPOS"."OBJECTID" = "CDHDR"."OBJECTID"
                       AND "CDPOS"."CHANGENR" = "CDHDR"."CHANGENR"
                       AND "CDPOS"."OBJECTCLAS" = 'VERKBELEG'
         LEFT JOIN "USR02" AS "USR02"
                   ON "CDHDR"."USERNAME" = "USR02"."BNAME"
                       AND "CDHDR"."MANDANT" = "USR02"."MANDT"
WHERE "CDPOS"."TABNAME" = 'VBAP'
  AND "CDPOS"."FNAME" IN ('NETPR', 'MATNR', 'ABGRU', 'WERKS', 'KWMENG')
  AND "CDPOS"."CHNGIND" = 'U'
  AND "CDPOS"."MANDANT" IS NOT NULL
  AND "CDHDR"."MANDANT" IS NOT NULL



================================================================================================================================================================


