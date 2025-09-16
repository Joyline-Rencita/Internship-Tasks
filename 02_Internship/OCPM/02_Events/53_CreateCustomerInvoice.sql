SELECT 'CreateCustomerInvoice' || '_' || "CustomerInvoice"."ID" AS "ID",
       "CustomerInvoice"."ID"                                   AS "CustomerInvoice",
       "CustomerInvoice"."CreationTime"                         AS "Time",
       "CustomerInvoice"."CreatedBy_ID"                         AS "ExecutedBy",
       "CustomerInvoice"."CreationExecutionType"                AS "ExecutionType"
FROM "o_celonis_CustomerInvoice" AS "CustomerInvoice"
WHERE "CustomerInvoice"."CreationTime" IS NOT NULL

=======================================================================================================================================================================

