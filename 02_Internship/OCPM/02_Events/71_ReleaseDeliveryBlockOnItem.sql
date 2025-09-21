SELECT 'ReleaseDeliveryBlockOnItem' || '_' || "SalesOrderItemBlock"."ID" AS "ID",
       "SalesOrderItemBlock"."ID"                                        AS "SalesOrderItemBlock",
       "SalesOrderItem"."ID"                                             AS "SalesOrderItem",
       "SalesOrderItemBlock"."ReleaseTime"                               AS "Time",
       "SalesOrderItemBlock"."ReleasedBy_ID"                             AS "ExecutedBy",
       "SalesOrderItemBlock"."ReleaseExecutionType"                      AS "ExecutionType",
       "SalesOrderItemBlock"."ReleaseReason"                             AS "OldValue",
       NULL                                                              AS "NewValue"
FROM "o_celonis_SalesOrderItem" AS "SalesOrderItem"
         LEFT JOIN "o_celonis_SalesOrderItemBlock" AS "SalesOrderItemBlock"
                   ON "SalesOrderItem"."ID" = "SalesOrderItemBlock"."SalesOrderItem_ID"
WHERE "SalesOrderItemBlock"."BlockType" = 'DeliveryBlock'
  AND "SalesOrderItemBlock"."ReleaseTime" IS NOT NULL
