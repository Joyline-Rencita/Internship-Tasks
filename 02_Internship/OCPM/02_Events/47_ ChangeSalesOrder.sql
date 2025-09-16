SELECT 'ChangeSalesOrder' || '_' || "SalesOrder_Changes"."ID" AS "ID",
       "SalesOrder"."ID"                                      AS "SalesOrder",
       "SalesOrder_Changes"."Time"                            AS "Time",
       "SalesOrder_Changes"."ChangedBy"                       AS "ExecutedBy",
       "SalesOrder_Changes"."Attribute"                       AS "ChangedAttribute",
       "SalesOrder_Changes"."ExecutionType"                   AS "ExecutionType",
       "SalesOrder_Changes"."OldValue"                        AS "OldValue",
       "SalesOrder_Changes"."NewValue"                        AS "NewValue"
FROM "o_celonis_SalesOrder" AS "SalesOrder"
         LEFT JOIN "c_o_celonis_SalesOrder" AS "SalesOrder_Changes"
                   ON "SalesOrder"."ID" = "SalesOrder_Changes"."ObjectID"
                       AND "SalesOrder_Changes"."Attribute" IN
                           ('FreightTerms', 'PaymentTerms', 'RequestedDeliveryDate')
WHERE "SalesOrder_Changes"."Time" IS NOT NULL
