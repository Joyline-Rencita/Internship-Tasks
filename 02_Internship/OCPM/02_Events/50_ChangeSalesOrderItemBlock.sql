SELECT 'ChangeSalesOrderItemBlock' || '_' || "SalesOrderItemBlock_Changes"."ID" AS "ID",
       "SalesOrderItemBlock"."ID"                                               AS "SalesOrderItemBlock",
       "SalesOrderItemBlock_Changes"."Time"                                     AS "Time",
       "SalesOrderItemBlock_Changes"."ChangedBy"                                AS "ExecutedBy",
       "SalesOrderItemBlock_Changes"."Attribute"                                AS "ChangedAttribute",
       "SalesOrderItemBlock_Changes"."ExecutionType"                            AS "ExecutionType",
       "SalesOrderItemBlock_Changes"."OldValue"                                 AS "OldValue",
       "SalesOrderItemBlock_Changes"."NewValue"                                 AS "NewValue"
FROM "o_celonis_SalesOrderItem" AS "SalesOrderItem"
         LEFT JOIN "o_celonis_SalesOrderItemBlock" AS "SalesOrderItemBlock"
                   ON "SalesOrderItem"."ID" = "SalesOrderItemBlock"."SalesOrderItem_ID"
         LEFT JOIN "c_o_celonis_SalesOrderItemBlock" AS "SalesOrderItemBlock_Changes"
                   ON "SalesOrderItemBlock"."ID" = "SalesOrderItemBlock_Changes"."ObjectID"
WHERE "SalesOrderItemBlock_Changes"."Attribute" = 'LatestBlockReason'
  AND "SalesOrderItemBlock_Changes"."Time" IS NOT NULL
