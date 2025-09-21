SELECT 'SetBillingBlockOnItem' || '_' || "SalesOrderItemBlock"."ID" AS "ID",
       "SalesOrderItemBlock"."ID"                                   AS "SalesOrderItemBlock",
       "SalesOrderItem"."ID"                                        AS "SalesOrderItem",
       "SalesOrderItemBlock"."CreationTime"                         AS "Time",
       "SalesOrderItemBlock"."BlockedBy_ID"                         AS "ExecutedBy",
       "SalesOrderItemBlock"."BlockExecutionType"                   AS "ExecutionType",
       NULL                                                         AS "OldValue",
       "SalesOrderItemBlock"."FirstBlockReason"                     AS "NewValue"
FROM "o_celonis_SalesOrderItem" AS "SalesOrderItem"
         LEFT JOIN "o_celonis_SalesOrderItemBlock" AS "SalesOrderItemBlock"
                   ON "SalesOrderItem"."ID" = "SalesOrderItemBlock"."SalesOrderItem_ID"
WHERE "SalesOrderItemBlock"."BlockType" = 'BillingBlock'
  AND "SalesOrderItemBlock"."CreationTime" IS NOT NULL
