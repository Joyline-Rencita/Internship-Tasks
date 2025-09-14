SELECT 'ApproveSalesOrderItem' || '_' || "SalesOrderItem_Changes"."ID" AS "ID",
       "SalesOrderItem"."ID"                                           AS "SalesOrderItem",
       "SalesOrderItem_Changes"."Time"                                 AS "Time",
       "SalesOrderItem_Changes"."ChangedBy"                            AS "ExecutedBy",
       "SalesOrderItem_Changes"."ExecutionType"                        AS "ExecutionType"
FROM "o_celonis_SalesOrderItem" AS "SalesOrderItem"
         LEFT JOIN "c_o_celonis_SalesOrderItem" AS "SalesOrderItem_Changes"
                   ON "SalesOrderItem"."ID" = "SalesOrderItem_Changes"."ObjectID"
WHERE "SalesOrderItem_Changes"."Time" IS NOT NULL
  AND "SalesOrderItem_Changes"."Attribute" = 'DocumentStatus'
  AND "SalesOrderItem_Changes"."NewValue" = 'I0002'
