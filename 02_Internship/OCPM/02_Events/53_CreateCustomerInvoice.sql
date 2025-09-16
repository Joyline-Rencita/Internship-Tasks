SELECT 'CreateCustomerInvoice' || '_' || "CustomerInvoice"."ID"        AS "ID",
       "CustomerInvoice"."ID"                                          AS "CustomerInvoice",
       "CustomerInvoice"."CreationTime"                                AS "Time",
       "CustomerInvoice"."CreatedBy_ID"                                AS "ExecutedBy",
       "CustomerInvoice"."CreationExecutionType"                       AS "ExecutionType"
       
FROM "o_celonis_CustomerInvoice"        AS "CustomerInvoice"
WHERE "CustomerInvoice"."CreationTime" IS NOT NULL

=======================================================================================================================================================================

                                          Relationships =>   Customer Invoice Items

SELECT DISTINCT
                "Event"."ID"                              AS "ID",
                "Object"."ID"                             AS "CustomerInvoiceItems"
       
FROM "e_celonis_CreateCustomerInvoice" AS "Event"
       
         LEFT JOIN (SELECT "Object"."Header_ID"           AS "Header_ID",
                           "Object"."ID"                  AS "ID",
                           "Object"."CreationTime"        AS "CreationTime"
                    FROM "o_celonis_CustomerInvoiceItem"  AS "Object"
                    ORDER BY "Object"."Header_ID")        AS "Object"
                   ON "Event"."CustomerInvoice_ID" = "Object"."Header_ID"
WHERE TIMESTAMPDIFF(SECOND, "Event"."Time", "Object"."CreationTime") <= 5
  AND "Object"."ID" IS NOT NULL


======================================================================================================================================================================

                                          Relationships =>   Delivery Items


SELECT DISTINCT
       "Event"."ID"  AS "ID",
       "Object"."ID" AS "DeliveryItems"
FROM (SELECT "Event"."ID"               AS "ID",
             "Event"."Time"             AS "Time",
             "CustomerInvoiceItem"."ID" AS "CustomerInvoiceItem_Id"
      FROM "e_celonis_CreateCustomerInvoice" AS "Event"
               LEFT JOIN (SELECT "Object"."Header_ID"    AS "Header_ID",
                                 "Object"."ID"           AS "ID",
                                 "Object"."CreationTime" AS "CreationTime"
                          FROM "o_celonis_CustomerInvoiceItem" AS "Object"
                          ORDER BY "Object"."Header_ID") AS "CustomerInvoiceItem"
                         ON "Event"."CustomerInvoice_ID" = "CustomerInvoiceItem"."Header_ID"
      ORDER BY "CustomerInvoiceItem"."ID") AS "Event"
         LEFT JOIN (SELECT "CustomerInvoiceItem_DeliveryItems"."ID" AS "CustomerInvoiceItem_DeliveryItems_ID",
                           "Object"."CreationTime"                  AS "CreationTime",
                           "Object"."ID"                            AS "ID"
                    FROM (SELECT "CustomerInvoiceItem_DeliveryItems"."ID"               AS "ID",
                                 "CustomerInvoiceItem_DeliveryItems"."DeliveryItems_ID" AS "DeliveryItems_ID"
                          FROM "r_o_celonis_CustomerInvoiceItem__DeliveryItems" AS "CustomerInvoiceItem_DeliveryItems"
                          ORDER BY "CustomerInvoiceItem_DeliveryItems"."DeliveryItems_ID") AS "CustomerInvoiceItem_DeliveryItems"
                             LEFT JOIN "o_celonis_DeliveryItem" AS "Object"
                                       ON "CustomerInvoiceItem_DeliveryItems"."DeliveryItems_ID" = "Object"."ID"
                    ORDER BY "CustomerInvoiceItem_DeliveryItems"."ID") AS "Object"
                   ON "Event"."CustomerInvoiceItem_Id" = "Object"."CustomerInvoiceItem_DeliveryItems_ID"
WHERE TIMESTAMPDIFF(SECOND, "Event"."Time", "Object"."CreationTime") <= 5
  AND "Object"."ID" IS NOT NULL

====================================================================================================================================================================

                                          Relationships =>   Customer Invoice Items

SELECT DISTINCT
                "Event"."ID"  AS "ID",
                "Object"."ID" AS "SalesOrderItems"
FROM (SELECT "Event"."ID"                                     AS "ID",
             "Event"."Time"                                   AS "Time",
             "CustomerInvoiceItem_Header"."SalesOrderItem_ID" AS "SalesOrderItem_ID"
      FROM "e_celonis_CreateCustomerInvoice" AS "Event"
               LEFT JOIN (SELECT "Object"."Header_ID"         AS "Header_ID",
                                 "Object"."SalesOrderItem_ID" AS "SalesOrderItem_ID"
                          FROM "o_celonis_CustomerInvoiceItem" AS "Object"
                          ORDER BY "Object"."Header_ID") AS "CustomerInvoiceItem_Header"
                         ON "Event"."CustomerInvoice_ID" = "CustomerInvoiceItem_Header"."Header_ID"
      ORDER BY "CustomerInvoiceItem_Header"."SalesOrderItem_ID") AS "Event"
         LEFT JOIN "o_celonis_SalesOrderItem" AS "Object"
                   ON "Event"."SalesOrderItem_ID" = "Object"."ID"
WHERE TIMESTAMPDIFF(SECOND, "Event"."Time", "Object"."CreationTime") <= 5
  AND "Object"."ID" IS NOT NULL
