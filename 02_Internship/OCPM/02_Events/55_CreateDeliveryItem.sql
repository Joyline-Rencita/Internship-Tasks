                            ***********************           EVENT              ***************************

SELECT 'CreateDeliveryItem' || '_' || "DeliveryItem"."ID" AS "ID",
       "DeliveryItem"."ID"                                AS "DeliveryItem",
       "SalesOrderItem"."ID"                              AS "SalesOrderItem",
       "DeliveryItem"."CreationTime"                      AS "Time",
       "DeliveryItem"."CreatedBy_ID"                      AS "ExecutedBy",
       "DeliveryItem"."CreationExecutionType"             AS "ExecutionType",
       "DeliveryItem"."Delivery_ID"                       AS "Delivery"
FROM (SELECT "DeliveryItem"."ID"                    AS "ID",
             "DeliveryItem"."CreationTime"          AS "CreationTime",
             "DeliveryItem"."CreatedBy_ID"          AS "CreatedBy_ID",
             "DeliveryItem"."CreationExecutionType" AS "CreationExecutionType",
             "Delivery"."ID"                        AS "Delivery_ID",
             "DeliveryItem"."SalesOrderItem_ID"     AS "SalesOrderItem_ID"
      FROM (SELECT "DeliveryItem"."ID"                    AS "ID",
                   "DeliveryItem"."CreationTime"          AS "CreationTime",
                   "DeliveryItem"."CreatedBy_ID"          AS "CreatedBy_ID",
                   "DeliveryItem"."CreationExecutionType" AS "CreationExecutionType",
                   "DeliveryItem"."Header_ID"             AS "Header_ID",
                   "DeliveryItem"."SalesOrderItem_ID"     AS "SalesOrderItem_ID"
            FROM "o_celonis_DeliveryItem" AS "DeliveryItem"
            ORDER BY "DeliveryItem"."Header_ID") AS "DeliveryItem"
               LEFT JOIN "o_celonis_Delivery" AS "Delivery"
                         ON "DeliveryItem"."Header_ID" = "Delivery"."ID"
      ORDER BY "DeliveryItem"."SalesOrderItem_ID") AS "DeliveryItem"
         LEFT JOIN "o_celonis_SalesOrderItem" AS "SalesOrderItem"
                   ON "DeliveryItem"."SalesOrderItem_ID" = "SalesOrderItem"."ID"
WHERE "DeliveryItem"."CreationTime" IS NOT NULL
