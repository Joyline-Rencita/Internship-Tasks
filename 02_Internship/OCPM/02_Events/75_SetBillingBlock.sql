SELECT 'SetBillingBlock' || '_' || "SalesOrderBlock"."ID" AS "ID",
       "SalesOrderBlock"."ID"                             AS "SalesOrderBlock",
       "SalesOrder"."ID"                                  AS "SalesOrder",
       "SalesOrderBlock"."CreationTime"                   AS "Time",
       "SalesOrderBlock"."BlockedBy_ID"                   AS "ExecutedBy",
       "SalesOrderBlock"."BlockExecutionType"             AS "ExecutionType",
       NULL                                               AS "OldValue",
       "SalesOrderBlock"."FirstBlockReason"               AS "NewValue"
FROM "o_celonis_SalesOrder" AS "SalesOrder"
         LEFT JOIN "o_celonis_SalesOrderBlock" AS "SalesOrderBlock"
                   ON "SalesOrder"."ID" = "SalesOrderBlock"."SalesOrder_ID"
WHERE "SalesOrderBlock"."BlockType" = 'BillingBlock'
  AND "SalesOrderBlock"."CreationTime" IS NOT NULL
