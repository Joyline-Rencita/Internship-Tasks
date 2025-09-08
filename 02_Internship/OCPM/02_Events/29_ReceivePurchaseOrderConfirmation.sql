SELECT 'ReceivePurchaseOrderConfirmation' || '_' || "PurchaseOrderItem_Changes"."ID" AS "ID",
       "PurchaseOrderItem"."ID"                                                      AS "PurchaseOrderItem",
       "PurchaseOrderItem_Changes"."Time"                                            AS "Time",
       "PurchaseOrderItem_Changes"."ChangedBy"                                       AS "ExecutedBy",
       "PurchaseOrderItem_Changes"."ExecutionType"                                   AS "ExecutionType"
FROM "o_celonis_PurchaseOrderItem" AS "PurchaseOrderItem"
         LEFT JOIN "c_o_celonis_PurchaseOrderItem" AS "PurchaseOrderItem_Changes"
                   ON "PurchaseOrderItem"."ID" = "PurchaseOrderItem_Changes"."ObjectID"
WHERE "PurchaseOrderItem_Changes"."Attribute" = 'OrderAcknowledgmentNumber'
  AND "PurchaseOrderItem_Changes"."OldValue" IS NULL
  AND "PurchaseOrderItem_Changes"."Time" IS NOT NULL
