          ***************************        EVENT      ****************************

SELECT 'CreateCustomerInvoice' || '_' || "CustomerInvoice"."ID" AS "ID",
       "CustomerInvoice"."ID"                                   AS "CustomerInvoice",
       "CustomerInvoice"."CreationTime"                         AS "Time",
       "CustomerInvoice"."CreatedBy_ID"                         AS "ExecutedBy",
       "CustomerInvoice"."CreationExecutionType"                AS "ExecutionType"
FROM "o_celonis_CustomerInvoice" AS "CustomerInvoice"
WHERE "CustomerInvoice"."CreationTime" IS NOT NULL


=======================================================================================================================================================================


                                    RELATIONSHIPS ->    CUSTOMER INVOICE ITEMS

SELECT DISTINCT
                "Event"."ID"  AS "ID",
                "Object"."ID" AS "CustomerInvoiceItems"
FROM "e_celonis_CreateCustomerInvoice" AS "Event"
         LEFT JOIN (SELECT "Object"."Header_ID"    AS "Header_ID",
                           "Object"."ID"           AS "ID",
                           "Object"."CreationTime" AS "CreationTime"
                    FROM "o_celonis_CustomerInvoiceItem" AS "Object"
                    ORDER BY "Object"."Header_ID") AS "Object"
                   ON "Event"."CustomerInvoice_ID" = "Object"."Header_ID"
WHERE TIMESTAMPDIFF(SECOND, "Event"."Time", "Object"."CreationTime") <= 5
  AND "Object"."ID" IS NOT NULL



====================================================================================================================================================================


                                    RELATIONSHIPS ->    DELIVERY ITEMS


