SELECT 'SendSalesOrderConfirmation' || '_' || "SalesOrder_Changes"."ID" AS "ID",
       "SalesOrder_Changes"."ObjectID"                                  AS "SalesOrder",
       "SalesOrder_Changes"."Time"                                      AS "Time",
       "SalesOrder_Changes"."ChangedBy"                                 AS "ExecutedBy",
       "SalesOrder_Changes"."ExecutionType"                             AS "ExecutionType"
FROM "o_celonis_SalesOrder" AS "SalesOrder"
         LEFT JOIN "c_o_celonis_SalesOrder" AS "SalesOrder_Changes"
                   ON "SalesOrder"."ID" = "SalesOrder_Changes"."ObjectID"
WHERE "SalesOrder_Changes"."Attribute" = 'SendOrderConfirmation'
  AND "SalesOrder_Changes"."Time" IS NOT NULL
