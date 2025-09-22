                      *********************    EVENT     **************************

SELECT 'CreatePurchaseOrderHeader' || '_' || "PurchaseOrder"."ID" AS "ID",
       "PurchaseOrder"."ID"                                       AS "PurchaseOrder",
       "PurchaseOrder"."CreationTime"                             AS "Time",
       "PurchaseOrder"."CreatedBy_ID"                             AS "ExecutedBy",
       "PurchaseOrder"."CreationExecutionType"                    AS "ExecutionType"
FROM "o_celonis_PurchaseOrder" AS "PurchaseOrder"
WHERE "PurchaseOrder"."CreationTime" IS NOT NULL
