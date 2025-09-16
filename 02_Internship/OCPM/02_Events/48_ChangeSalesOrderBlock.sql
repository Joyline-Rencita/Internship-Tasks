SELECT 'ChangeSalesOrderBlock' || '_' || "SalesOrderBlock_Changes"."ID"        AS "ID",
       "SalesOrderBlock"."ID"                                                  AS "SalesOrderBlock",
       "SalesOrderBlock_Changes"."Time"                                        AS "Time",
       "SalesOrderBlock_Changes"."ChangedBy"                                   AS "ExecutedBy",
       "SalesOrderBlock_Changes"."Attribute"                                   AS "ChangedAttribute",
       "SalesOrderBlock_Changes"."ExecutionType"                               AS "ExecutionType",
       "SalesOrderBlock_Changes"."OldValue"                                    AS "OldValue",
       "SalesOrderBlock_Changes"."NewValue"                                    AS "NewValue"
       
FROM "o_celonis_SalesOrder" AS "SalesOrder"
         LEFT JOIN "o_celonis_SalesOrderBlock" AS "SalesOrderBlock"
                   ON "SalesOrder"."ID" = "SalesOrderBlock"."SalesOrder_ID"
         LEFT JOIN "c_o_celonis_SalesOrderBlock" AS "SalesOrderBlock_Changes"
                   ON "SalesOrderBlock"."ID" = "SalesOrderBlock_Changes"."ObjectID"
WHERE "SalesOrderBlock_Changes"."Attribute" = 'LatestBlockReason'
  AND "SalesOrderBlock_Changes"."Time" IS NOT NULL
