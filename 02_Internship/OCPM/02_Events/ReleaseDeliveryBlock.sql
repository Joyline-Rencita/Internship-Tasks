SELECT 'ReleaseDeliveryBlock' || '_' || "SalesOrderBlock"."ID" AS "ID",
       "SalesOrderBlock"."ID"                                  AS "SalesOrderBlock",
       "SalesOrder"."ID"                                       AS "SalesOrder",
       "SalesOrderBlock"."ReleaseTime"                         AS "Time",
       "SalesOrderBlock"."ReleasedBy_ID"                       AS "ExecutedBy",
       "SalesOrderBlock"."ReleaseExecutionType"                AS "ExecutionType",
       NULL                                                    AS "NewValue",
       "SalesOrderBlock"."ReleaseReason"                       AS "OldValue"
FROM "o_celonis_SalesOrder" AS "SalesOrder"
         LEFT JOIN "o_celonis_SalesOrderBlock" AS "SalesOrderBlock"
                   ON "SalesOrder"."ID" = "SalesOrderBlock"."SalesOrder_ID"
WHERE "SalesOrderBlock"."BlockType" = 'DeliveryBlock'
  AND "SalesOrderBlock"."ReleaseTime" IS NOT NULL
