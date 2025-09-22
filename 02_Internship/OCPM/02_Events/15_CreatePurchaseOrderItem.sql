                      *********************    EVENT     **************************

SELECT 'CreatePurchaseOrderItem' || '_' || "PurchaseOrderItem"."ID" AS "ID",
       "PurchaseOrderItem"."ID"                                     AS "PurchaseOrderItem",
       "PurchaseOrder"."ID"                                         AS "PurchaseOrder",
       "PurchaseOrderItem"."CreationTime"                           AS "Time",
       "PurchaseOrderItem"."CreatedBy_ID"                           AS "ExecutedBy",
       "PurchaseOrderItem"."CreationExecutionType"                  AS "ExecutionType"
FROM "o_celonis_PurchaseOrderItem" AS "PurchaseOrderItem"
         LEFT JOIN "o_celonis_PurchaseOrder" AS "PurchaseOrder"
                   ON "PurchaseOrderItem"."Header_ID" = "PurchaseOrder"."ID"
WHERE "PurchaseOrderItem"."CreationTime" IS NOT NULL
