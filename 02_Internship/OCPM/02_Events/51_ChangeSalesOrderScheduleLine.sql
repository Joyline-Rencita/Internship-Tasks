SELECT 'ChangeSalesOrderScheduleLine' || '_' || "SalesOrderScheduleLine_Changes"."ID"        AS "ID",
       "SalesOrderScheduleLine"."ID"                                                         AS "SalesOrderScheduleLine",
       "SalesOrderScheduleLine_Changes"."Time"                                               AS "Time",
       "SalesOrderScheduleLine_Changes"."ChangedBy"                                          AS "ExecutedBy",
       "SalesOrderScheduleLine_Changes"."Attribute"                                          AS "ChangedAttribute",
       "SalesOrderScheduleLine_Changes"."ExecutionType"                                      AS "ExecutionType",
       "SalesOrderScheduleLine_Changes"."OldValue"                                           AS "OldValue",
       "SalesOrderScheduleLine_Changes"."NewValue"                                           AS "NewValue"
       
FROM "o_celonis_SalesOrderScheduleLine" AS "SalesOrderScheduleLine"
         LEFT JOIN "c_o_celonis_SalesOrderScheduleLine" AS "SalesOrderScheduleLine_Changes"
                   ON "SalesOrderScheduleLine"."ID" = "SalesOrderScheduleLine_Changes"."ObjectID"
                       AND "SalesOrderScheduleLine_Changes"."Attribute" IN
                           ('ConfirmedQuantity', 'ConfirmedDeliveryDate', 'MaterialAvailabilityDate')
WHERE "SalesOrderScheduleLine_Changes"."Time" IS NOT NULL
