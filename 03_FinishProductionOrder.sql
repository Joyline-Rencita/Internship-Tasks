SELECT 'FinishProductionOrder' || '_' || "ProductionOrder"."ID" AS "ID",
       "ProductionOrder"."ID"                                   AS "ProductionOrder",
       "ProductionOrder"."FinishTime"                           AS "Time",
       NULL                                                     AS "ExecutedBy",
       NULL                                                     AS "ExecutionType"
FROM "o_celonis_ProductionOrder" AS "ProductionOrder"
WHERE "ProductionOrder"."FinishTime" IS NOT NULL
