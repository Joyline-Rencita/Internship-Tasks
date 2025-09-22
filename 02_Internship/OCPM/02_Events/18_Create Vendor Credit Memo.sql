

SELECT 'CreateVendorCreditMemo' || '_' || "VendorCreditMemo"."ID" AS "ID",
       "VendorCreditMemo"."ID"                                    AS "VendorCreditMemo",
       "VendorCreditMemo"."CreationTime"                          AS "Time",
       "VendorCreditMemo"."CreatedBy_ID"                          AS "ExecutedBy",
       "VendorCreditMemo"."CreationExecutionType"                 AS "ExecutionType"
FROM "o_celonis_VendorCreditMemo" AS "VendorCreditMemo"
WHERE "VendorCreditMemo"."CreationTime" IS NOT NULL

====================================================================================================================


SELECT DISTINCT
       "Event"."ID"  AS "ID",
       "Object"."ID" AS "IncomingMaterialDocumentItems"
FROM "e_celonis_CreateVendorCreditMemo" AS "Event"
         LEFT JOIN "o_celonis_VendorCreditMemo" AS "VendorCreditMemo"
                   ON "Event"."VendorCreditMemo_ID" = "VendorCreditMemo"."ID"
         LEFT JOIN "o_celonis_VendorCreditMemoItem" AS "VendorCreditMemoItem"
                   ON "VendorCreditMemo"."ID" = "VendorCreditMemoItem"."Header_ID"
         LEFT JOIN "o_celonis_PurchaseOrderItem" AS "PurchaseOrderItem"
                   ON "VendorCreditMemoItem"."PurchaseOrderItem_ID" = "PurchaseOrderItem"."ID"
         LEFT JOIN "o_celonis_IncomingMaterialDocumentItem" AS "Object"
                   ON "PurchaseOrderItem"."ID" = "Object"."PurchaseOrderItem_ID"
WHERE "Object"."ID" IS NOT NULL
