SELECT 'RestoreSalesOrderItem' || '_' || "SalesOrderItem_Changes"."ID" AS "ID",
       "SalesOrderItem"."ID"                                           AS "SalesOrderItem",
       "SalesOrderItem_Changes"."Time"                                 AS "Time",
       "SalesOrderItem_Changes"."ChangedBy"                            AS "ExecutedBy",
       "SalesOrderItem_Changes"."ExecutionType"                        AS "ExecutionType"
FROM "o_celonis_SalesOrderItem" AS "SalesOrderItem"
         LEFT JOIN "c_o_celonis_SalesOrderItem" AS "SalesOrderItem_Changes"
                   ON "SalesOrderItem"."ID" = "SalesOrderItem_Changes"."ObjectID"
                       AND "SalesOrderItem_Changes"."Attribute" IN
                           ('RejectionReason')
  WHERE "SalesOrderItem_Changes"."OldValue" IS NOT NULL
  AND "SalesOrderItem_Changes"."NewValue" IS NULL
  AND "SalesOrderItem_Changes"."Time" IS NOT NULL
