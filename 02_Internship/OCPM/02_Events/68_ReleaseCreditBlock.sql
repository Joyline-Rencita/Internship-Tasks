SELECT 'ReleaseCreditBlock' || '_' || "SalesOrderBlock"."ID" AS "ID",
       "SalesOrderBlock"."ID"                                AS "SalesOrderBlock",
       "SalesOrder"."ID"                                     AS "SalesOrder",
       "SalesOrderBlock"."ReleaseTime"                       AS "Time",
       "SalesOrderBlock"."ReleasedBy_ID"                     AS "ExecutedBy",
       "SalesOrderBlock"."ReleaseExecutionType"              AS "ExecutionType",
       "SalesOrderBlock"."ReleaseReason"                     AS "OldValue",
       NULL                                                  AS "NewValue"
FROM "o_celonis_SalesOrder" AS "SalesOrder"
         LEFT JOIN "o_celonis_SalesOrderBlock" AS "SalesOrderBlock"
                   ON "SalesOrder"."ID" = "SalesOrderBlock"."SalesOrder_ID"
WHERE "SalesOrderBlock"."BlockType" = 'CreditBlock'
  AND "SalesOrderBlock"."ReleaseTime" IS NOT NULL
