WITH "CTE_Reduce_Calendar" AS (SELECT "CELONIS_CALENDAR"."LastDayOfMonth",
                                     "CELONIS_CALENDAR"."Year",
                                     LPAD(CAST("CELONIS_CALENDAR"."Month" AS VARCHAR(2)), 2, '0') AS "Month"
                              FROM "CELONIS_CALENDAR"
                              GROUP BY "LastDayOfMonth", "Year", "Month"),
    "CTE_Date_Range_MBEWH" AS (SELECT "MBEWH"."MANDT"                                       AS "MANDT",
                                      "MBEWH"."MATNR"                                       AS "MATNR",
                                      "MBEWH"."BWKEY"                                       AS "BWKEY",
                                      CAST(MIN("Reduce_Calendar"."LastDayOfMonth") AS DATE) AS "MinDate"
                               FROM "MBEWH" AS "MBEWH"
                                        LEFT JOIN "CTE_Reduce_Calendar" AS "Reduce_Calendar"
                                                  ON "MBEWH"."LFGJA" = "Reduce_Calendar"."YEAR"
                                                      AND "MBEWH"."LFMON" = "Reduce_Calendar"."Month"
                               WHERE "MBEWH"."BWTAR" IS NULL
                               GROUP BY "MBEWH"."MANDT", "MBEWH"."MATNR", "MBEWH"."BWKEY"),
    "CTE_Calendar" AS (SELECT "Date_Range_MBEWH"."MANDT"                            AS "MANDT",
                              "Date_Range_MBEWH"."MATNR"                            AS "MATNR",
                              "Date_Range_MBEWH"."BWKEY"                            AS "BWKEY",
                              CAST("Reduce_Calendar"."LastDayOfMonth" AS TIMESTAMP) AS "DateRange",
                              CAST("Reduce_Calendar"."Year" AS VARCHAR)             AS "Year",
                              CAST("Reduce_Calendar"."Month" AS VARCHAR)            AS "Month"
                       FROM "CTE_Date_Range_MBEWH" AS "Date_Range_MBEWH"
                                LEFT JOIN "CTE_Reduce_Calendar" AS "Reduce_Calendar"
                                          ON "Date_Range_MBEWH"."MinDate"
                                             <= CAST("Reduce_Calendar"."LastDayOfMonth" AS DATE)
                                              AND CAST("Reduce_Calendar"."LastDayOfMonth" AS DATE) <= CAST(
                                                      TIMESTAMPADD(DAY, -1, TIMESTAMPADD(MONTH, 1,
                                                                                         CAST(CAST(YEAR(NOW()) AS VARCHAR)
                                                                                              || '-'
                                                                                              || CAST(MONTH(NOW()) AS VARCHAR)
                                                                                              || '-01' AS DATE))) AS DATE)),
    "CTE_QuanitityConversion" AS (SELECT "MARA"."MANDT",
                                         "MARA"."MATNR",
                                         "MARA"."MEINS" AS "FromUnit",
                                         CASE
                                             WHEN "T006"."DIMID" != 'AAAADL'
                                                 THEN "T006D"."MSSIE"
                                             WHEN "T006"."DIMID" = 'AAAADL'
                                                 THEN "MARM"."MEINH"
                                             END        AS "ToUnit",
                                         CASE
                                             WHEN "T006"."DIMID" != 'AAAADL'
                                                 THEN "T006"."ZAEHL" / "T006"."NENNR" * POWER(10, "T006"."EXP10")
                                             WHEN "T006"."DIMID" = 'AAAADL'
                                                 THEN "MARM"."UMREN" / "MARM"."UMREZ"
                                             END        AS "Rate"
                                  FROM "MARA" AS "MARA"
                                           LEFT JOIN "T006" AS "T006"
                                                     ON "MARA"."MANDT" = "T006"."MANDT"
                                                         AND "MARA"."MEINS" = "T006"."MSEHI"
                                           LEFT JOIN "T006D" AS "T006D"
                                                     ON "T006"."MANDT" = "T006D"."MANDT"
                                                         AND "T006"."DIMID" = "T006D"."DIMID"
                                           LEFT JOIN "MARM" AS "MARM"
                                                     ON "MARA"."MANDT" = "MARM"."MANDT"
                                                         AND "MARA"."MATNR" = "MARM"."MATNR"
                                  WHERE "T006"."MANDT" IS NOT NULL
                                    AND "MARM"."MANDT" IS NOT NULL),
    "CTE_TEMP_AGG" AS (SELECT "MSEG"."MANDT",
                              "MSEG"."MATNR",
                              "MSEG"."WERKS",
                              COALESCE("MSEG"."MEINS", "MARA"."MEINS")                               AS "MEINS",
                              "MSEG"."WAERS"                                                         AS "WAERS",
                              CAST(TIMESTAMPADD(DAY, -1, TIMESTAMPADD(MONTH, 1,
                                                                      CAST(YEAR(CAST("MSEG"."CPUDT_MKPF" AS DATE))
                                                                           || '-'
                                                                          || MONTH(CAST("MSEG"."CPUDT_MKPF" AS DATE))
                                                                          ||
                                                                           '-01' AS DATE))) AS DATE) AS "MSEG_EndOfMonth",
                              CASE
                                  WHEN "MSEG"."SHKZG" = 'H' AND "T156"."SHKZG" IS NOT NULL AND "T156"."XSTBW" IS NULL
                                      THEN SUM("MSEG"."MENGE")
                                  WHEN "MSEG"."SHKZG" = 'S' AND "T156"."SHKZG" IS NOT NULL AND "T156"."XSTBW" = 'X'
                                      THEN SUM("MSEG"."MENGE") * -1.0
                                  END                                                                AS "Consupmtion_MENGE",
                              CASE
                                  WHEN "MSEG"."SHKZG" = 'S' AND "T156"."SHKZG" IS NOT NULL AND "T156"."XSTBW" IS NULL
                                      THEN SUM("MSEG"."MENGE")
                                  WHEN "MSEG"."SHKZG" = 'H' AND "T156"."SHKZG" IS NOT NULL AND "T156"."XSTBW" = 'X'
                                      THEN SUM("MSEG"."MENGE") * -1.0
                                  END                                                                AS "Replenishment_MENGE"
                       FROM "MSEG" AS "MSEG"
                                LEFT JOIN "T156" AS "T156"
                                          ON "MSEG"."MANDT" = "T156"."MANDT"
                                              AND "MSEG"."BWART" = "T156"."BWART"
                                              AND "T156"."KZVBU" IS NOT NULL
                                LEFT JOIN "MARA" AS "MARA"
                                          ON "MSEG"."MANDT" = "MARA"."MANDT"
                                              AND "MSEG"."MATNR" = "MARA"."MATNR"
                       WHERE "MSEG"."BWTAR" IS NULL
                       GROUP BY "MSEG"."MANDT", "MSEG"."MATNR", "MSEG"."WERKS", "MSEG"."SHKZG",
                                COALESCE("MSEG"."MEINS", "MARA"."MEINS"), "MSEG"."WAERS",
                                CAST(TIMESTAMPADD(DAY, -1, TIMESTAMPADD(MONTH, 1,
                                                                        CAST(YEAR(CAST("MSEG"."CPUDT_MKPF" AS DATE))
                                                                             || '-'
                                                                            || MONTH(CAST("MSEG"."CPUDT_MKPF" AS DATE))
                                                                            || '-01' AS DATE))) AS DATE),
                                "T156"."SHKZG", "T156"."XSTBW"),
    "CTE_TEMP_AGG_Converting" AS (SELECT "CTE_TEMP_AGG"."MANDT",
                                         "CTE_TEMP_AGG"."MATNR",
                                         "CTE_TEMP_AGG"."WERKS",
                                         "MARA"."MEINS",
                                         "CTE_TEMP_AGG"."WAERS",
                                         "CTE_TEMP_AGG"."MSEG_EndOfMonth",
                                         "CTE_TEMP_AGG"."Consupmtion_MENGE"
                                             * COALESCE("CTE_QuanitityConversion"."Rate", 1.0) AS "Consupmtion_MENGE",
                                         "CTE_TEMP_AGG"."Replenishment_MENGE"
                                             * COALESCE("CTE_QuanitityConversion"."Rate", 1.0) AS "Replenishment_MENGE"
                                  FROM "CTE_TEMP_AGG"
                                           LEFT JOIN "MARA"
                                                     ON "CTE_TEMP_AGG"."MANDT" = "MARA"."MANDT"
                                                         AND "CTE_TEMP_AGG"."MATNR" = "MARA"."MATNR"
                                           LEFT JOIN "CTE_QuanitityConversion"
                                                     ON "CTE_TEMP_AGG"."MANDT" = "CTE_QuanitityConversion"."MANDT"
                                                         AND "CTE_TEMP_AGG"."MATNR" = "CTE_QuanitityConversion"."MATNR"
                                                         AND "MARA"."MEINS" = "CTE_QuanitityConversion"."ToUnit"),
    "CTE_MSEG_AGG" AS (SELECT "TEMP_AGG"."MANDT",
                              "TEMP_AGG"."MATNR",
                              "TEMP_AGG"."WERKS",
                              "TEMP_AGG"."MEINS",
                              "TEMP_AGG"."WAERS",
                              "TEMP_AGG"."MSEG_EndOfMonth",
                              SUM("TEMP_AGG"."Consupmtion_MENGE")   AS "Consupmtion_MENGE",
                              SUM("TEMP_AGG"."Replenishment_MENGE") AS "Replenishment_MENGE"
                       FROM "CTE_TEMP_AGG_Converting" AS "TEMP_AGG"
                       GROUP BY "TEMP_AGG"."MANDT", "TEMP_AGG"."MATNR", "TEMP_AGG"."WERKS",
                                "TEMP_AGG"."MEINS", "TEMP_AGG"."WAERS", "TEMP_AGG"."MSEG_EndOfMonth"),
    "CTE_MBEW_AGG" AS (SELECT "MBEWH"."MANDT",
                              "MBEWH"."MATNR",
                              "MBEWH"."BWKEY",
                              CAST("MBEWH"."LFGJA" AS VARCHAR) AS "LFGJA",
                              CAST("MBEWH"."LFMON" AS VARCHAR) AS "LFMON",
                              CAST("MBEWH"."LBKUM" AS NUMERIC) AS "LBKUM",
                              CAST("MBEWH"."SALK3" AS NUMERIC) AS "SALK3",
                              CAST("MBEWH"."VERPR" AS NUMERIC) AS "VERPR",
                              CAST("MBEWH"."STPRS" AS NUMERIC) AS "STPRS",
                              CAST("MBEWH"."PEINH" AS NUMERIC) AS "PEINH",
                              "MBEWH"."VPRSV"
                       FROM "MBEWH" AS "MBEWH"
                       WHERE "MBEWH"."BWTAR" IS NULL
                       UNION ALL
                       SELECT "MBEW"."MANDT",
                              "MBEW"."MATNR",
                              "MBEW"."BWKEY",
                              CAST("MBEW"."LFGJA" AS VARCHAR) AS "LFGJA",
                              CAST("MBEW"."LFMON" AS VARCHAR) AS "LFMON",
                              CAST("MBEW"."LBKUM" AS NUMERIC) AS "LBKUM",
                              CAST("MBEW"."SALK3" AS NUMERIC) AS "SALK3",
                              CAST("MBEW"."VERPR" AS NUMERIC) AS "VERPR",
                              CAST("MBEW"."STPRS" AS NUMERIC) AS "STPRS",
                              CAST("MBEW"."PEINH" AS NUMERIC) AS "PEINH",
                              "MBEW"."VPRSV"
                       FROM "MBEW" AS "MBEW"
                       WHERE "MBEW"."BWTAR" IS NULL),
    "CTE_Calendar_Merge_Temp"
        AS (SELECT "Calendar"."MANDT" || "Calendar"."MATNR" || "Calendar"."BWKEY"
                       || "Calendar"."Year" || "Calendar"."Month" AS "StockHistoryID",
                   "Calendar"."DateRange"                         AS "CurrentPeriod",
                   CASE
                       WHEN "MBEW_AGG"."MATNR" IS NULL THEN 'X'
                       END                                        AS "AddedPeriod",
                   "MBEW_AGG"."MATNR"                             AS "MaterialNumber",
                   "MBEW_AGG"."LBKUM"                             AS "BaseTotalValuatedStockQuantity",
                   "MBEW_AGG"."SALK3"                             AS "BaseTotalValuatedStockAmount",
                   CASE
                       WHEN "MBEW_AGG"."VPRSV" = 'V' THEN COALESCE(
                               "MBEW_AGG"."VERPR" / NULLIF("MBEW_AGG"."PEINH", 0),
                               "MBEW_AGG"."VERPR")
                       WHEN "MBEW_AGG"."VPRSV" = 'S' THEN COALESCE(
                               "MBEW_AGG"."STPRS" / NULLIF("MBEW_AGG"."PEINH", 0),
                               "MBEW_AGG"."STPRS")
                       ELSE "MBEW_AGG"."SALK3" / NULLIF("MBEW_AGG"."LBKUM", 0)
                       END                                        AS "UnitPrice",
                   "T001"."WAERS"                                 AS "BaseCurrency",
                   "MSEG_AGG"."MEINS"                             AS "QuantityUnit",
                   "MSEG_AGG"."Consupmtion_MENGE"                 AS "ConsumptionQuantity",
                   "MSEG_AGG"."Replenishment_MENGE"               AS "ReplenishmentQuantity",
                   "Calendar"."MANDT" || "Calendar"."BWKEY"       AS "Plant_ID",
                   "Calendar"."MANDT" || "Calendar"."MATNR"       AS "Material_ID",
                   "Calendar"."MANDT" || "Calendar"."MATNR"
                       || "Calendar"."BWKEY"                      AS "MaterialMasterPlant_ID",
                   "Calendar"."MANDT"                             AS "Client"
            FROM (SELECT *
                  FROM "CTE_Calendar"
                  ORDER BY "MANDT", "MATNR", "BWKEY", "year", "Month") AS "Calendar"
                     LEFT JOIN (SELECT *
                                FROM "CTE_MBEW_AGG"
                                ORDER BY "MANDT", "MATNR", "BWKEY", "LFGJA", "LFMON") AS "MBEW_AGG"
                               ON "Calendar"."MANDT" = "MBEW_AGG"."MANDT"
                                  AND "Calendar"."MATNR" = "MBEW_AGG"."MATNR"
                                  AND "Calendar"."BWKEY" = "MBEW_AGG"."BWKEY"
                                  AND "Calendar"."Year" = "MBEW_AGG"."LFGJA"
                                  AND "Calendar"."Month" = "MBEW_AGG"."LFMON"
                     LEFT JOIN "T001K" AS "T001K"
                               ON "MBEW_AGG"."MANDT" = "T001K"."MANDT"
                                   AND "MBEW_AGG"."BWKEY" = "T001K"."BWKEY"
                     LEFT JOIN "T001" AS "T001"
                               ON "T001K"."MANDT" = "T001"."MANDT"
                                   AND "T001K"."BUKRS" = "T001"."BUKRS"
                     LEFT JOIN "CTE_MSEG_AGG" AS "MSEG_AGG"
                               ON "Calendar"."MANDT" = "MSEG_AGG"."MANDT"
                                   AND "Calendar"."MATNR" = "MSEG_AGG"."MATNR"
                                   AND "Calendar"."BWKEY" = "MSEG_AGG"."WERKS"
                                   AND "Calendar"."DateRange" = "MSEG_AGG"."MSEG_EndOfMonth"),
    "CTE_Calendar_Merge" AS (SELECT "Calendar_Merge"."StockHistoryID"                     AS "ID",
                                    "Calendar_Merge"."CurrentPeriod"                      AS "CurrentPeriod",
                                    "Calendar_Merge"."AddedPeriod"                        AS "AddedPeriod",
                                    COALESCE(CAST("BaseTotalValuatedStockQuantity" AS DOUBLE),
                                             CAST(LAST_VALUE("BaseTotalValuatedStockQuantity") IGNORE NULLS
                                                  OVER (PARTITION BY "MaterialMasterPlant_ID" ORDER BY "CurrentPeriod" DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS DOUBLE),
                                             CAST(FIRST_VALUE("BaseTotalValuatedStockQuantity") IGNORE NULLS
                                                  OVER (PARTITION BY "MaterialMasterPlant_ID" ORDER BY "CurrentPeriod" DESC ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) AS DOUBLE)
                                    )                                                     AS "BaseTotalValuatedStockQuantity",
                                    COALESCE(CAST("BaseTotalValuatedStockAmount" AS DOUBLE),
                                             CAST(LAST_VALUE("BaseTotalValuatedStockAmount") IGNORE NULLS
                                                  OVER (PARTITION BY "MaterialMasterPlant_ID" ORDER BY "CurrentPeriod" DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS DOUBLE),
                                             CAST(FIRST_VALUE("BaseTotalValuatedStockAmount") IGNORE NULLS
                                                  OVER (PARTITION BY "MaterialMasterPlant_ID" ORDER BY "CurrentPeriod" DESC ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) AS DOUBLE)
                                    )                                                     AS "BaseTotalValuatedStockAmount",
                                    COALESCE(CAST("UnitPrice" AS DOUBLE),
                                             CAST(LAST_VALUE("UnitPrice") IGNORE NULLS
                                                  OVER (PARTITION BY "MaterialMasterPlant_ID" ORDER BY "CurrentPeriod" DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS DOUBLE),
                                             CAST(FIRST_VALUE("UnitPrice") IGNORE NULLS
                                                  OVER (PARTITION BY "MaterialMasterPlant_ID" ORDER BY "CurrentPeriod" DESC ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) AS DOUBLE)
                                    )                                                     AS "UnitPrice",
                                    COALESCE("BaseCurrency",
                                             CAST(LAST_VALUE("BaseCurrency") IGNORE NULLS
                                                  OVER (PARTITION BY "MaterialMasterPlant_ID" ORDER BY "CurrentPeriod" DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS VARCHAR(255)),
                                             CAST(FIRST_VALUE("BaseCurrency") IGNORE NULLS
                                                  OVER (PARTITION BY "MaterialMasterPlant_ID" ORDER BY "CurrentPeriod" DESC ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) AS VARCHAR(255))
                                    )                                                     AS "BaseCurrency",
                                    COALESCE("QuantityUnit",
                                             CAST(LAST_VALUE("QuantityUnit") IGNORE NULLS
                                                  OVER (PARTITION BY "MaterialMasterPlant_ID" ORDER BY "CurrentPeriod" DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS VARCHAR(255)),
                                             CAST(FIRST_VALUE("QuantityUnit") IGNORE NULLS
                                                  OVER (PARTITION BY "MaterialMasterPlant_ID" ORDER BY "CurrentPeriod" DESC ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) AS VARCHAR(255))
                                    )                                                     AS "QuantityUnit",
                                    COALESCE("Calendar_Merge"."ConsumptionQuantity", 0)   AS "ConsumptionQuantity",
                                    COALESCE("Calendar_Merge"."ReplenishmentQuantity", 0) AS "ReplenishmentQuantity",
                                    "Calendar_Merge"."Plant_ID"                           AS "Plant_ID",
                                    "Calendar_Merge"."Material_ID"                        AS "Material_ID",
                                    COALESCE("MaterialMasterPlant_ID",
                                             CAST(LAST_VALUE("MaterialMasterPlant_ID") IGNORE NULLS
                                                  OVER (PARTITION BY "MaterialMasterPlant_ID" ORDER BY "CurrentPeriod" DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS VARCHAR(255)),
                                             CAST(FIRST_VALUE("MaterialMasterPlant_ID") IGNORE NULLS
                                                  OVER (PARTITION BY "MaterialMasterPlant_ID" ORDER BY "CurrentPeriod" DESC ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) AS VARCHAR(255))
                                    )                                                     AS "MaterialMasterPlant_ID",
                                    'SAP'                                                 AS "SourceSystemType",
                                    "Calendar_Merge"."Client"                             AS "SourceSystemInstance"
                             FROM "CTE_Calendar_Merge_Temp" AS "Calendar_Merge")
SELECT <%=sourceSystem%>  || 'StockHistory_' || "Calendar_Merge"."ID"                      AS "ID",
       "Calendar_Merge"."CurrentPeriod"                                                    AS "CurrentPeriod",
       "Calendar_Merge"."AddedPeriod"                                                      AS "AddedPeriod",
       "Calendar_Merge"."BaseTotalValuatedStockQuantity"                                   AS "BaseTotalValuatedStockQuantity",
       "Calendar_Merge"."BaseTotalValuatedStockAmount"                                     AS "BaseTotalValuatedStockAmount",
       "Calendar_Merge"."UnitPrice"                                                        AS "UnitPrice",
       "Calendar_Merge"."BaseCurrency"                                                     AS "BaseCurrency",
       "Calendar_Merge"."QuantityUnit"                                                     AS "QuantityUnit",
       "Calendar_Merge"."ConsumptionQuantity"                                              AS "ConsumptionQuantity",
       "Calendar_Merge"."ReplenishmentQuantity"                                            AS "ReplenishmentQuantity",
	<%=sourceSystem%>  || 'Plant_' || "Calendar_Merge"."Plant_ID"                             AS "Plant",
	<%=sourceSystem%>  || 'Material_' || "Calendar_Merge"."Material_ID"                       AS "Material",
	<%=sourceSystem%>  || 'MaterialMasterPlant_' || "Calendar_Merge"."MaterialMasterPlant_ID" AS "MaterialMasterPlant",
       "Calendar_Merge"."SourceSystemType"                                                 AS "SourceSystemType",
	<%=sourceSystem%>  || "Calendar_Merge"."SourceSystemInstance"                             AS "SourceSystemInstance"
FROM "CTE_Calendar_Merge" AS "Calendar_Merge"
WHERE "CurrentPeriod" >= TIMESTAMPADD(MONTH, (-12 * <%=stockHistoryYears%>  - 1), NOW())
