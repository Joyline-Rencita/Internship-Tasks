SELECT 'BeginProductionOrder' || '_' || "ProductionOrder"."ID" AS "ID",
       "ProductionOrder"."ID"                                  AS "ProductionOrder",
       "ProductionOrder"."StartTime"                           AS "Time",
       NULL                                                    AS "ExecutedBy",
       NULL                                                    AS "ExecutionType"
FROM "o_celonis_ProductionOrder" AS "ProductionOrder"
WHERE "ProductionOrder"."StartTime" IS NOT NULL
