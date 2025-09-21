SELECT 'CreateSalesOrderScheduleLine_' || "SalesOrderScheduleLine_Changes"."ID" AS "ID",
       "SalesOrderScheduleLine_ID"                                              AS "SalesOrderScheduleLine",
       "Time"                                                                   AS "Time",
       "ExecutedBy"                                                             AS "ExecutedBy",
       "ExecutionType"                                                          AS "ExecutionType",
       "SalesOrderItem"."ID"                                                    AS "SalesOrderItem"
FROM (SELECT "SalesOrderScheduleLine_Changes"."ID"            AS "ID",
             "SalesOrderScheduleLine_Changes"."ObjectID"      AS "SalesOrderScheduleLine_ID",
             "SalesOrderScheduleLine_Changes"."Time"          AS "Time",
             "SalesOrderScheduleLine_Changes"."ChangedBy"     AS "ExecutedBy",
             "SalesOrderScheduleLine_Changes"."ExecutionType" AS "ExecutionType",
             "SalesOrderScheduleLine"."SalesOrderItem_ID"     AS "SalesOrderItem_ID",
             "SalesOrderScheduleLine_Changes"."Attribute"     AS "Attribute"
      FROM "c_o_celonis_SalesOrderScheduleLine" AS "SalesOrderScheduleLine_Changes"
               LEFT JOIN "o_celonis_SalesOrderScheduleLine" AS "SalesOrderScheduleLine"
                         ON "SalesOrderScheduleLine_Changes"."ObjectID" = "SalesOrderScheduleLine"."ID"
      ORDER BY "SalesOrderScheduleLine"."SalesOrderItem_ID") AS "SalesOrderScheduleLine_Changes"
         LEFT JOIN "o_celonis_SalesOrderItem" AS "SalesOrderItem"
                   ON "SalesOrderScheduleLine_Changes"."SalesOrderItem_ID" = "SalesOrderItem"."ID"
WHERE "SalesOrderScheduleLine_Changes"."Attribute" = 'CreationTime'
  AND "SalesOrderScheduleLine_Changes"."Time" IS NOT NULL
