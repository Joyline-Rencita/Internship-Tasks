SELECT 'PostGoodsReceipt' || '_' || "IncomingMaterialDocumentItem"."ID" AS "ID",
       "IncomingMaterialDocumentItem"."ID"                              AS "IncomingMaterialDocumentItem",
       "PurchaseOrderItem"."ID"                                         AS "PurchaseOrderItem",
       "IncomingMaterialDocumentItem"."CreationTime"                    AS "Time",
       "IncomingMaterialDocumentItem"."CreatedBy_ID"                    AS "ExecutedBy",
       "IncomingMaterialDocumentItem"."CreationExecutionType"           AS "ExecutionType"
FROM "o_celonis_IncomingMaterialDocumentItem" AS "IncomingMaterialDocumentItem"
         LEFT JOIN "o_celonis_PurchaseOrderItem" AS "PurchaseOrderItem"
                   ON "IncomingMaterialDocumentItem"."PurchaseOrderItem_ID" = "PurchaseOrderItem"."ID"
WHERE "IncomingMaterialDocumentItem"."MaterialTransactionType" = 'GoodsReceipt'
  AND "IncomingMaterialDocumentItem"."ReversedOutgoingGood_ID" IS NULL
  AND "IncomingMaterialDocumentItem"."CreationTime" IS NOT NULL
