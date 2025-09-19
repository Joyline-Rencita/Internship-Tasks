                  *****************************        EVENT       **********************************
                    

SELECT 'CreateDeliveryHeader' || '_' || "Delivery"."ID" AS "ID",
       "Delivery"."ID"                                  AS "Delivery",
       "Delivery"."CreationTime"                        AS "Time",
       "Delivery"."CreatedBy_ID"                        AS "ExecutedBy",
       "Delivery"."CreationExecutionType"               AS "ExecutionType"
FROM "o_celonis_Delivery" AS "Delivery"
WHERE "Delivery"."CreationTime" IS NOT NULL


=======================================================================================================================================================================


                                        RELATIONSHIPS ->  SALES ORDER ITEMS

SELECT DISTINCT
                "Event"."ID"  AS "ID",
                "Object"."ID" AS "SalesOrderItems"
FROM (SELECT "Event"."ID"                       AS "ID",
             "DeliveryItem"."SalesOrderItem_ID" AS "SalesOrderItem_ID",
             "Event"."Time"                     AS "Time"
      FROM "e_celonis_CreateDeliveryHeader" AS "Event"
               LEFT JOIN (SELECT "Header_ID"         AS "Header_ID",
                                 "SalesOrderItem_ID" AS "SalesOrderItem_ID"
                          FROM "o_celonis_DeliveryItem" AS "DeliveryItem"
                          ORDER BY "DeliveryItem"."Header_ID") AS "DeliveryItem"
                         ON "Event"."Delivery_ID" = "DeliveryItem"."Header_ID"
      ORDER BY "DeliveryItem"."SalesOrderItem_ID") AS "Event"
         LEFT JOIN "o_celonis_SalesOrderItem" AS "Object" ON "Event"."SalesOrderItem_ID" = "Object"."ID"
      WHERE TIMESTAMPDIFF(SECOND, "Event"."Time", "Object"."CreationTime") <= 5
        AND "Object"."ID" IS NOT NULL
