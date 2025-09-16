SELECT 'CancelCustomerInvoice' || '_' || "CustomerInvoiceCancellation"."ID" AS "ID",
       "CustomerInvoiceCancellation"."ID"                                   AS "CustomerInvoiceCancellation",
       "CustomerInvoiceCancellation"."CreationTime"                         AS "Time",
       "CustomerInvoiceCancellation"."CreatedBy_ID"                         AS "ExecutedBy",
       "CustomerInvoiceCancellation"."CreationExecutionType"                AS "ExecutionType"
       
FROM "o_celonis_CustomerInvoiceCancellation" AS "CustomerInvoiceCancellation"
WHERE "CustomerInvoiceCancellation"."CreationTime" IS NOT NULL


=======================================================================================================================================================================

                          Relationships ==>  Cancel Customer Invoice

SELECT DISTINCT "Event"."ID"         AS "ID",
                "Object"."ID"        AS "CustomerInvoiceCancellationItems"
       
FROM "e_celonis_CancelCustomerInvoice" AS "Event"
         LEFT JOIN "o_celonis_CustomerInvoiceCancellation" AS "CustomerInvoiceCancellation"
                   ON "Event"."CustomerInvoiceCancellation_ID" = "CustomerInvoiceCancellation"."ID"
         LEFT JOIN "o_celonis_CustomerInvoiceCancellationItem" AS "Object"
                   ON "CustomerInvoiceCancellation"."ID" = "Object"."Header_ID"
WHERE TIMESTAMPDIFF(SECOND, "Event"."Time", "Object"."CreationTime") <= 5
  AND "Object"."ID" IS NOT NULL


=======================================================================================================================================================================

                          Relationships ==>  Cancel Customer Invoice 2

WITH "CTE_AUX" AS (SELECT "Event"."ID"  AS "ID",
                          "Object"."ID" AS "CustomerInvoiceItems_ID",
                          "Event"."Time",
                          "Object"."CreationTime"
                   FROM "e_celonis_CancelCustomerInvoice" AS "Event"
                            LEFT JOIN "o_celonis_CustomerInvoiceCancellation" AS "CustomerInvoiceCancellation"
                                      ON "Event"."CustomerInvoiceCancellation_ID" = "CustomerInvoiceCancellation"."ID"
                            LEFT JOIN "o_celonis_CustomerInvoiceCancellationItem" AS "CustomerInvoiceCancellationItem"
                                      ON "CustomerInvoiceCancellation"."ID"
                                         = "CustomerInvoiceCancellationItem"."Header_ID"
                            LEFT JOIN (SELECT *
                                       FROM "r_o_celonis_CustomerInvoiceCancellationItem__CustomerInvoiceItems"
                                       ORDER BY "CustomerInvoiceItems_ID") AS "CustomerInvoiceItem"
                                      ON "CustomerInvoiceCancellationItem"."ID" = "CustomerInvoiceItem"."ID"
                            LEFT JOIN (SELECT * FROM "o_celonis_CustomerInvoiceItem") AS "Object"
                                      ON "CustomerInvoiceItem"."CustomerInvoiceItems_ID" = "Object"."ID")
SELECT DISTINCT "ID"                      AS "ID",
                "CustomerInvoiceItems_ID" AS "CustomerInvoiceItems"
FROM "CTE_AUX" AS "AUX"
WHERE TIMESTAMPDIFF(SECOND, "Time", "CreationTime") <= 5
  AND "CustomerInvoiceItems_ID" IS NOT NULL
