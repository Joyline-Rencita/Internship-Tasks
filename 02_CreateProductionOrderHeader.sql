SELECT 'CreateProductionOrderHeader' || '_' || "ProductionOrder"."ID" AS "ID",
       "ProductionOrder"."ID"                                         AS "ProductionOrder",
       "ProductionOrder"."CreationTime"                               AS "Time",
       "ProductionOrder"."CreatedBy_ID"                               AS "ExecutedBy",
       "ProductionOrder"."CreationExecutionType"                      AS "ExecutionType"
FROM "o_celonis_ProductionOrder" AS "ProductionOrder"
WHERE "ProductionOrder"."CreationTime" IS NOT NULL
