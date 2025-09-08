SELECT 'CreateVendorInvoice' || '_' || "VendorInvoice"."ID" AS "ID",
       "VendorInvoice"."ID"                                 AS "VendorInvoice",
       "VendorInvoice"."CreationTime"                       AS "Time",
       "VendorInvoice"."CreatedBy_ID"                       AS "ExecutedBy",
       "VendorInvoice"."CreationExecutionType"              AS "ExecutionType"
FROM "o_celonis_VendorInvoice" AS "VendorInvoice"
WHERE "VendorInvoice"."CreationTime" IS NOT NULL

========================================================================================================================================================

SELECT DISTINCT "Event"."ID"  AS "ID",
                "Object"."ID" AS "IncomingMaterialDocumentItems"
FROM "e_celonis_CreateVendorInvoice" AS "Event"
         LEFT JOIN "o_celonis_VendorInvoice" AS "VendorInvoice"
                   ON "Event"."VendorInvoice_ID" = "VendorInvoice"."ID"
         LEFT JOIN "o_celonis_VendorInvoiceItem" AS "VendorInvoiceItem"
                   ON "VendorInvoice"."ID" = "VendorInvoiceItem"."Header_ID"
         LEFT JOIN "o_celonis_PurchaseOrderItem" AS "PurchaseOrderItem"
                   ON "VendorInvoiceItem"."PurchaseOrderItem_ID" = "PurchaseOrderItem"."ID"
         LEFT JOIN "o_celonis_IncomingMaterialDocumentItem" AS "Object"
                   ON "PurchaseOrderItem"."ID" = "Object"."PurchaseOrderItem_ID"
WHERE "Object"."ID" IS NOT NULL
