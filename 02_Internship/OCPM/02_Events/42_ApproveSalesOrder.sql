SELECT 'ApproveSalesOrder' || '_' || "SalesOrder_Changes"."ID" AS "ID",
       "SalesOrder"."ID"                                       AS "SalesOrder",
       "SalesOrder_Changes"."Time"                             AS "Time",
       "SalesOrder_Changes"."ChangedBy"                        AS "ExecutedBy",
       "SalesOrder_Changes"."ExecutionType"                    AS "ExecutionType"
FROM "o_celonis_SalesOrder" AS "SalesOrder"
         LEFT JOIN "c_o_celonis_SalesOrder" AS "SalesOrder_Changes"
                   ON "SalesOrder"."ID" = "SalesOrder_Changes"."ObjectID"
WHERE "SalesOrder_Changes"."Attribute" = 'DocumentStatus'
  AND "SalesOrder_Changes"."NewValue" = 'I0002'
  AND "SalesOrder_Changes"."Time" IS NOT NULL
