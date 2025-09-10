				******************************			CTE_DATE_RANGE			******************************

WITH "CTE_TCURF_TMP" AS (SELECT "TCURF"."MANDT",
                                "TCURF"."KURST",
                                "TCURF"."FCURR",
                                "TCURF"."TCURR",
                                "TCURF"."GDATU",
                                "TCURF"."FFACT",
                                "TCURF"."TFACT",
                                DENSE_RANK()
                                    OVER (ORDER BY "TCURF"."MANDT", "TCURF"."KURST", "TCURF"."FCURR", "TCURF"."TCURR")                                                              AS "TCURF_KEY",
                                 ROW_NUMBER() OVER (PARTITION BY "TCURF"."MANDT", "TCURF"."KURST", "TCURF"."FCURR", "TCURF"."TCURR" ORDER BY CAST("TCURF"."GDATU" AS INTEGER) DESC) AS "TCURF_ROWNR"
                         FROM "TCURF" AS "TCURF"
                         WHERE 99999999 - CAST("TCURF"."GDATU" AS INTEGER) >= 18000000
                             AND 99999999 - CAST("TCURF"."GDATU" AS INTEGER) <= 20990000),
     "CTE_TCURF_CC" AS (SELECT *,
                               CAST("LPAD"(CAST(99999999 - CAST("TCURF_TMP"."GDATU" AS INTEGER) AS VARCHAR(10)), 8, '0') || ' ' || '00:00:00' AS TIMESTAMP) AS "VALID_START"
                        FROM "CTE_TCURF_TMP" AS "TCURF_TMP"),
     "CTE_TCURF_CC_2" AS (SELECT "TCURF_CC".*,
                                 CASE
                                     WHEN "TCURF_CC_Offset"."TCURF_ROWNR" IS NOT NULL
                                         THEN "TCURF_CC_Offset"."VALID_START"
                                     ELSE CAST('2099-01-01' AS TIMESTAMP)
                                     END AS "VALID_END"
                          FROM "CTE_TCURF_CC" AS "TCURF_CC"
                                   LEFT JOIN "CTE_TCURF_CC" AS "TCURF_CC_Offset" ON "TCURF_CC"."TCURF_KEY" = "TCURF_CC_Offset"."TCURF_KEY" AND "TCURF_CC"."TCURF_ROWNR" + 1 = "TCURF_CC_Offset"."TCURF_ROWNR"),
     "CTE_TCURR_TMP" AS (SELECT "TCURR"."MANDT",
                                "TCURR"."KURST",
                                "TCURR"."FCURR",
                                "TCURR"."TCURR",
                                "TCURR"."GDATU",
                                "TCURR"."UKURS",
                                "TCURR"."FFACT",
                                "TCURR"."TFACT",
                                DENSE_RANK() OVER (ORDER BY "TCURR"."MANDT", "TCURR"."KURST", "TCURR"."FCURR", "TCURR"."TCURR")                                                     AS "TCURR_KEY",
                                 ROW_NUMBER() OVER (PARTITION BY "TCURR"."MANDT", "TCURR"."KURST", "TCURR"."FCURR", "TCURR"."TCURR" ORDER BY CAST("TCURR"."GDATU" AS INTEGER) DESC) AS "TCURR_ROWNR"
                         FROM "TCURR" AS "TCURR"
                         WHERE 99999999 - CAST("TCURR"."GDATU" AS INTEGER) >= 18000000
                             AND 99999999 - CAST("TCURR"."GDATU" AS INTEGER) <= 20990000),
     "CTE_TCURR_CC" AS (SELECT *,
                               CAST("LPAD"(CAST(99999999 - CAST("TCURR_TMP"."GDATU" AS INTEGER) AS VARCHAR(10)), 8, '0') || ' ' || '00:00:00' AS TIMESTAMP) AS "VALID_START"
                        FROM "CTE_TCURR_TMP" AS "TCURR_TMP"),
     "CTE_TCURR_CC_2" AS (SELECT "TCURR_CC".*,
                                 CASE
                                     WHEN "TCURR_CC_Offset"."TCURR_ROWNR" IS NOT NULL
                                         THEN "TCURR_CC_Offset"."VALID_START"
                                     ELSE CAST('2099-01-01' AS TIMESTAMP)
                                     END AS "VALID_END"
                          FROM "CTE_TCURR_CC" AS "TCURR_CC"
                                   LEFT JOIN "CTE_TCURR_CC" AS "TCURR_CC_Offset" ON "TCURR_CC"."TCURR_KEY" = "TCURR_CC_Offset"."TCURR_KEY" AND "TCURR_CC"."TCURR_ROWNR" + 1 = "TCURR_CC_Offset"."TCURR_ROWNR"),
     "CTE_DATE_RANGE" AS (SELECT CAST("CELONIS_CALENDAR"."Date" AS TIMESTAMP) AS "_DATE"
                          FROM "CELONIS_CALENDAR"
                          WHERE "CELONIS_CALENDAR"."Date" >= '2017-01-01'
                              AND "CELONIS_CALENDAR"."Date" <= "NOW"()
                          ORDER BY "CELONIS_CALENDAR"."Date"),
     "CTE_TCURX" AS (SELECT "TCURX"."CURRKEY",
                            CAST("TCURX"."CURRDEC" AS INTEGER)       AS "CURRDEC",
                            POWER(CAST(10 AS DOUBLE), 2 - "CURRDEC") AS "TDEC"
                     FROM "TCURX" AS "TCURX"),
     "CTE_DIRECT_CONVERSION" AS (
         SELECT
             "TCURR_CC_2"."FCURR" || '_' || "TCURR_CC_2"."TCURR" || '_' || "_DATE" || '_' || 'SAP' || '_' || "TCURR_CC_2"."MANDT" AS "ID",
             "TCURR_CC_2"."FCURR"                                                                                                 AS "FromCurrency",
             "TCURR_CC_2"."TCURR"                                                                                                 AS "ToCurrency",
             "DATE_RANGE"."_DATE"                                                                                                 AS "FromDate",
             "DATE_RANGE"."_DATE"                                                                                                 AS "ToDate",
             CASE
                 WHEN "TCURR_CC_2"."UKURS" < 0
                     THEN 1 / ABS("TCURR_CC_2"."UKURS")
                 ELSE "TCURR_CC_2"."UKURS"
                 END
                 * COALESCE("TCURX"."TDEC", 1)
                 /
             CASE
                 WHEN COALESCE("TCURF_CC_2"."FFACT", "TCURR_CC_2"."FFACT", 0) = 0 THEN 1
                 ELSE COALESCE("TCURF_CC_2"."FFACT", "TCURR_CC_2"."FFACT", 1)
                 END
                 *
             CASE
                 WHEN COALESCE("TCURF_CC_2"."TFACT", "TCURR_CC_2"."TFACT", 0) = 0 THEN 1
                 ELSE COALESCE("TCURF_CC_2"."TFACT", "TCURR_CC_2"."TFACT", 1)
                 END                                                                                                              AS "Rate",
             'SAP'                                                                                                                AS "SourceSystemType",
             "TCURR_CC_2"."MANDT"                                                                                                 AS "SourceSystemInstance",
             "TCURR_CC_2"."KURST"                                                                                                 AS "ExchangeRateType",
             'Direct'                                                                                                             AS "ConversionType"
         FROM "CTE_DATE_RANGE" AS "DATE_RANGE"
                  LEFT JOIN "CTE_TCURR_CC_2" AS "TCURR_CC_2"
                            ON "DATE_RANGE"."_DATE" >= "TCURR_CC_2"."VALID_START"
                                AND "DATE_RANGE"."_DATE" < "TCURR_CC_2"."VALID_END"
                  LEFT JOIN "CTE_TCURF_CC_2" AS "TCURF_CC_2"
                            ON "TCURR_CC_2"."MANDT" = "TCURF_CC_2"."MANDT"
                                AND "TCURR_CC_2"."TCURR" = "TCURF_CC_2"."TCURR"
                                AND "TCURR_CC_2"."FCURR" = "TCURF_CC_2"."FCURR"
                                AND "TCURR_CC_2"."KURST" = "TCURF_CC_2"."KURST"
                                AND "DATE_RANGE"."_DATE" >= "TCURF_CC_2"."VALID_START"
                                AND "DATE_RANGE"."_DATE" < "TCURF_CC_2"."VALID_END"
                  LEFT JOIN "CTE_TCURX" AS "TCURX"
                            ON "TCURR_CC_2"."FCURR" = "TCURX"."CURRKEY"
         WHERE "TCURR_CC_2"."MANDT" IS NOT NULL),
     "CTE_INVERSE_CONVERSION" AS (
         SELECT
             "TCURR_CC_2"."TCURR" || '_' || "TCURR_CC_2"."FCURR" || '_' || "_DATE" || '_' || 'SAP' || '_' || "TCURR_CC_2"."MANDT" AS "ID",
             "TCURR_CC_2"."TCURR"                                                                                                 AS "FromCurrency",
             "TCURR_CC_2"."FCURR"                                                                                                 AS "ToCurrency",
             "DATE_RANGE"."_DATE"                                                                                                 AS "FromDate",
             "DATE_RANGE"."_DATE"                                                                                                 AS "ToDate",
             (1
              / (CASE
                   WHEN "TCURR_CC_2"."UKURS" < 0 THEN (1 / ABS("TCURR_CC_2"."UKURS"))
                   ELSE "TCURR_CC_2"."UKURS" END
                   *
               COALESCE("TCURX"."TDEC", 1)
                   /
               COALESCE("TCURF_CC_2"."FFACT", "TCURR_CC_2"."FFACT", 1)
                  *
               COALESCE("TCURF_CC_2"."TFACT", "TCURR_CC_2"."TFACT", 1)
                  )
                 )                                                                                                                AS "Rate",
             'SAP'                                                                                                                AS "SourceSystemType",
             "TCURR_CC_2"."MANDT"                                                                                                 AS "SourceSystemInstance",
             "TCURR_CC_2"."KURST"                                                                                                 AS "ExchangeRateType",
             'Inverse'                                                                                                            AS "ConversionType"
         FROM "CTE_DATE_RANGE" AS "DATE_RANGE"
                  LEFT JOIN "CTE_TCURR_CC_2" AS "TCURR_CC_2"
                            ON "DATE_RANGE"."_DATE" >= "TCURR_CC_2"."VALID_START"
                                AND "DATE_RANGE"."_DATE" < "TCURR_CC_2"."VALID_END"
                  LEFT JOIN "CTE_TCURF_CC_2" AS "TCURF_CC_2"
                            ON "TCURR_CC_2"."MANDT" = "TCURF_CC_2"."MANDT"
                                AND "TCURR_CC_2"."TCURR" = "TCURF_CC_2"."TCURR"
                                AND "TCURR_CC_2"."FCURR" = "TCURF_CC_2"."FCURR"
                                AND "TCURR_CC_2"."KURST" = "TCURF_CC_2"."KURST"
                                AND "DATE_RANGE"."_DATE" >= "TCURF_CC_2"."VALID_START"
                                AND "DATE_RANGE"."_DATE" < "TCURF_CC_2"."VALID_END"
                  LEFT JOIN "CTE_TCURX" AS "TCURX"
                            ON "TCURR_CC_2"."FCURR" = "TCURX"."CURRKEY"
         WHERE "TCURR_CC_2"."MANDT" IS NOT NULL),
    "CTE_DIRECT_CONVERSION_TO" AS (
            SELECT "DIRECT_CONVERSION".*
            FROM "CTE_DIRECT_CONVERSION" AS "DIRECT_CONVERSION"
            WHERE
                (
                    "DIRECT_CONVERSION"."ExchangeRateType" = <%=ExchangeRateType%> 
                    AND "DIRECT_CONVERSION"."ToCurrency" = <%=CurrencyKey%> 
                )
               OR
                (
                    "DIRECT_CONVERSION"."ExchangeRateType" = <%=ExchangeRateType_2%> 
                    AND "DIRECT_CONVERSION"."ToCurrency" = <%=CurrencyKey_2%> 
                )
        ),
    "CTE_DIRECT_CONVERSION_FROM" AS (
            SELECT "DIRECT_CONVERSION".*
            FROM "CTE_DIRECT_CONVERSION" AS "DIRECT_CONVERSION"
            WHERE
                (
                    "DIRECT_CONVERSION"."ExchangeRateType" = <%=ExchangeRateType%> 
                        AND "DIRECT_CONVERSION"."FromCurrency" = <%=CurrencyKey%> 
                    )
               OR
                (
                    "DIRECT_CONVERSION"."ExchangeRateType" = <%=ExchangeRateType_2%> 
                        AND "DIRECT_CONVERSION"."FromCurrency" = <%=CurrencyKey_2%> 
                    )
        ),
    "CTE_INVERSE_CONVERSION_TO" AS (
            SELECT "INVERSE_CONVERSION".*
            FROM "CTE_INVERSE_CONVERSION" AS "INVERSE_CONVERSION"
            WHERE
                (
                    "INVERSE_CONVERSION"."ExchangeRateType" = <%=ExchangeRateType%> 
                        AND "INVERSE_CONVERSION"."ToCurrency" = <%=CurrencyKey%> 
                    )
               OR
                (
                    "INVERSE_CONVERSION"."ExchangeRateType" = <%=ExchangeRateType_2%> 
                        AND "INVERSE_CONVERSION"."ToCurrency" = <%=CurrencyKey_2%> 
                    )
        ),
    "CTE_INVERSE_CONVERSION_FROM" AS (
            SELECT "INVERSE_CONVERSION".*
            FROM "CTE_INVERSE_CONVERSION" AS "INVERSE_CONVERSION"
            WHERE
                (
                    "INVERSE_CONVERSION"."ExchangeRateType" = <%=ExchangeRateType%> 
                        AND "INVERSE_CONVERSION"."FromCurrency" = <%=CurrencyKey%> 
                    )
               OR
                (
                    "INVERSE_CONVERSION"."ExchangeRateType" = <%=ExchangeRateType_2%> 
                        AND "INVERSE_CONVERSION"."FromCurrency" = <%=CurrencyKey_2%> 
                    )
        ),
    "CTE_CONVERSION_ALL" AS (
            SELECT "DIRECT_CONVERSION_TO".*
            FROM "CTE_DIRECT_CONVERSION_TO" AS "DIRECT_CONVERSION_TO"
            UNION ALL
            SELECT "DIRECT_CONVERSION_FROM".*
            FROM "CTE_DIRECT_CONVERSION_FROM" AS "DIRECT_CONVERSION_FROM"
            WHERE "DIRECT_CONVERSION_FROM"."ID" NOT IN (SELECT "DIRECT_CONVERSION_TO"."ID"
                                                        FROM "CTE_DIRECT_CONVERSION_TO" AS "DIRECT_CONVERSION_TO")
            UNION ALL
            SELECT "INVERSE_CONVERSION_FROM".*
            FROM "CTE_INVERSE_CONVERSION_FROM" AS "INVERSE_CONVERSION_FROM"
            WHERE "INVERSE_CONVERSION_FROM"."ID" NOT IN (SELECT "DIRECT_CONVERSION_TO"."ID"
                                                         FROM "CTE_DIRECT_CONVERSION_TO" AS "DIRECT_CONVERSION_TO"
                                                         UNION ALL
                                                         SELECT "DIRECT_CONVERSION_FROM"."ID"
                                                         FROM "CTE_DIRECT_CONVERSION_FROM" AS "DIRECT_CONVERSION_FROM")
            UNION ALL
            SELECT "INVERSE_CONVERSION_TO".*
            FROM "CTE_INVERSE_CONVERSION_TO" AS "INVERSE_CONVERSION_TO"
            WHERE "INVERSE_CONVERSION_TO"."ID" NOT IN (SELECT "DIRECT_CONVERSION_TO"."ID"
                                                       FROM "CTE_DIRECT_CONVERSION_TO" AS "DIRECT_CONVERSION_TO"
                                                       UNION ALL
                                                       SELECT "DIRECT_CONVERSION_FROM"."ID"
                                                       FROM "CTE_DIRECT_CONVERSION_FROM" AS "DIRECT_CONVERSION_FROM"
                                                       UNION ALL
                                                       SELECT "INVERSE_CONVERSION_FROM"."ID"
                                                       FROM "CTE_INVERSE_CONVERSION_FROM" AS "INVERSE_CONVERSION_FROM")
        )
SELECT <%=sourceSystem%>  || 'CurrencyConversion_' || "CONVERSION_ALL"."ID" AS "ID",
       "CONVERSION_ALL"."FromCurrency"                                      AS "FromCurrency",
       "CONVERSION_ALL"."ToCurrency"                                        AS "ToCurrency",
       "CONVERSION_ALL"."FromDate"                                          AS "FromDate",
       "CONVERSION_ALL"."ToDate"                                            AS "ToDate",
       "CONVERSION_ALL"."Rate"                                              AS "Rate",
       "CONVERSION_ALL"."SourceSystemType"                                  AS "SourceSystemType",
	<%=sourceSystem%>  || "CONVERSION_ALL"."SourceSystemInstance"              AS "SourceSystemInstance",
       "CONVERSION_ALL"."ExchangeRateType"                                  AS "ExchangeRateType",
       "CONVERSION_ALL"."ConversionType"                                    AS "ConversionType"
FROM "CTE_CONVERSION_ALL" AS "CONVERSION_ALL"
