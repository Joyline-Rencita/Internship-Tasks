SELECT 'ReceiveAdvancedShipmentNotice' || '_' || "VendorConfirmation"."ID" AS "ID",
       "VendorConfirmation"."ID"                                           AS "VendorConfirmation",
       "PurchaseOrderItem"."ID"                                            AS "PurchaseOrderItem",
       "VendorConfirmation"."CreationTime"                                 AS "Time",
       "VendorConfirmation"."CreatedBy_ID"                                 AS "ExecutedBy",
       "VendorConfirmation"."CreationExecutionType"                        AS "ExecutionType"
FROM "o_celonis_VendorConfirmation" AS "VendorConfirmation"
         LEFT JOIN "o_celonis_PurchaseOrderItem" AS "PurchaseOrderItem"
                   ON "VendorConfirmation"."PurchaseOrderItem_ID" = "PurchaseOrderItem"."ID"
WHERE "VendorConfirmation"."CreationTime" IS NOT NULL
