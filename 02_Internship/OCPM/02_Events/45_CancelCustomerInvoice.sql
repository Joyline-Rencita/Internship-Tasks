SELECT 'CancelCustomerInvoice' || '_' || "CustomerInvoiceCancellation"."ID" AS "ID",
       "CustomerInvoiceCancellation"."ID"                                   AS "CustomerInvoiceCancellation",
       "CustomerInvoiceCancellation"."CreationTime"                         AS "Time",
       "CustomerInvoiceCancellation"."CreatedBy_ID"                         AS "ExecutedBy",
       "CustomerInvoiceCancellation"."CreationExecutionType"                AS "ExecutionType"
FROM "o_celonis_CustomerInvoiceCancellation" AS "CustomerInvoiceCancellation"
WHERE "CustomerInvoiceCancellation"."CreationTime" IS NOT NULL


=======================================================================================================================================================================

                          Relationships ==>  Cancel Customer Invoice

SELECT DISTINCT "Event"."ID"  AS "ID",
                "Object"."ID" AS "CustomerInvoiceCancellationItems"
FROM "e_celonis_CancelCustomerInvoice" AS "Event"
         LEFT JOIN "o_celonis_CustomerInvoiceCancellation" AS "CustomerInvoiceCancellation"
                   ON "Event"."CustomerInvoiceCancellation_ID" = "CustomerInvoiceCancellation"."ID"
         LEFT JOIN "o_celonis_CustomerInvoiceCancellationItem" AS "Object"
                   ON "CustomerInvoiceCancellation"."ID" = "Object"."Header_ID"
WHERE TIMESTAMPDIFF(SECOND, "Event"."Time", "Object"."CreationTime") <= 5
  AND "Object"."ID" IS NOT NULL


=======================================================================================================================================================================

                          Relationships ==>  Cancel Customer Invoice 2

