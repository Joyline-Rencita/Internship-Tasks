                      ***********************         MARC        *************************
                        

SELECT <%=sourceSystem%>  || 'MaterialMasterPlant_' || "MARC"."MANDT" || "MARC"."MATNR" || "MARC"."WERKS" AS "ID",
    NULL                                                                                                  AS "CreationTime",
    CAST("MARC"."MMSTD" AS TIMESTAMP)                                                                     AS "ValidityPeriodStartDate",
    CAST("MARC"."AUSDT" AS TIMESTAMP)                                                                     AS "ValidityPeriodEndDate",
    "MARC"."PLIFZ"                                                                                        AS "PlannedDeliveryTimeDays",
	<%=sourceSystem%>  || 'Material_' || "MARC"."MANDT" || "MARC"."MATNR"                                 AS "Material",
	<%=sourceSystem%>  || 'Plant_' || "MARC"."MANDT" || "MARC"."WERKS"                                    AS "Plant",
    CAST("MARC"."EISBE" AS BIGINT)                                                                        AS "SafetyStockLevel",
    "MARC"."NFMAT"                                                                                        AS "FollowUpMaterial",
    CASE
        WHEN "MARC"."BESKZ" = 'E' THEN 'In-house Production'
        WHEN "MARC"."BESKZ" = 'F' THEN 'External Procurement'
        WHEN "MARC"."BESKZ" = 'X' THEN 'Both Procurement Types'
        END                                                                                               AS "ProcurementType",
    CAST("MARC"."WEBAZ" AS BIGINT)                                                                        AS "GoodsReceiptProcessingDays",
    CAST("MARC"."DZEIT" AS DOUBLE)                                                                        AS "PlannedProductionLeadTime",
    "MARC"."DISMM"                                                                                        AS "MRPType",
    "MARC"."DISPO"                                                                                        AS "MRPController",
    "MARC"."DISGR"                                                                                        AS "MRPGroup",
    "MARC"."LGRAD" / 100                                                                                  AS "ServiceLevel",
    "MARC"."STRGR"                                                                                        AS "PlanningStrategyGroup",
    "MBEW"."LBKUM"                                                                                        AS "BaseTotalValuatedStockQuantity",
    "MBEW"."SALK3"                                                                                        AS "BaseTotalValuatedStockAmount",
    CAST("MARC"."BSTMI" AS DOUBLE)                                                                        AS "MinimumLotSize",
    CASE
        WHEN "MBEW"."VPRSV" = 'V'
            THEN COALESCE("MBEW"."VERPR" / NULLIF("MBEW"."PEINH", 0), "MBEW"."VERPR")
        WHEN "MBEW"."VPRSV" = 'S'
            THEN COALESCE("MBEW"."STPRS" / NULLIF("MBEW"."PEINH", 0), "MBEW"."STPRS")
        ELSE "MBEW"."SALK3" / NULLIF("MBEW"."LBKUM", 0)
        END                                                                                               AS "BaseUnitPrice",
    "T001K"."BUKRS"                                                                                       AS "CompanyCode",
    "T001"."BUTXT"                                                                                        AS "CompanyCodeText",
    "T001"."WAERS"                                                                                        AS "BaseCurrency",
    "MARA"."MEINS"                                                                                        AS "BaseQuantityUnit",
    'SAP'                                                                                                 AS "SourceSystemType",
	<%=sourceSystem%>  || "MARC"."MANDT"                                                                     AS "SourceSystemInstance"
FROM "MARC" AS "MARC"
         LEFT JOIN "T001W" AS "T001W"
                   ON "MARC"."MANDT" = "T001W"."MANDT"
                       AND "MARC"."WERKS" = "T001W"."WERKS"
         LEFT JOIN "MBEW" AS "MBEW"
                   ON "MARC"."MANDT" = "MBEW"."MANDT"
                       AND "MARC"."MATNR" = "MBEW"."MATNR"
                       AND "T001W"."BWKEY" = "MBEW"."BWKEY"
                       AND "MBEW"."BWTAR" IS NULL
         LEFT JOIN "MARA" AS "MARA"
                   ON "MARC"."MANDT" = "MARA"."MANDT"
                       AND "MARC"."MATNR" = "MARA"."MATNR"
         LEFT JOIN "T001K" AS "T001K"
                   ON "T001W"."MANDT" = "T001K"."MANDT"
                       AND "T001W"."BWKEY" = "T001K"."BWKEY"
         LEFT JOIN "T001" AS "T001"
                   ON "T001K"."MANDT" = "T001"."MANDT"
                       AND "T001K"."BUKRS" = "T001"."BUKRS"
WHERE "MARC"."MANDT" IS NOT NULL
