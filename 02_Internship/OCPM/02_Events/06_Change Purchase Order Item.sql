SELECT 'ChangePurchaseOrderItem' || '_' || "PurchaseOrderItem_Changes"."ID" AS "ID",
       "PurchaseOrderItem"."ID"                                             AS "PurchaseOrderItem",
       "PurchaseOrderItem_Changes"."Time"                                   AS "Time",
       "PurchaseOrderItem_Changes"."ChangedBy"                              AS "ExecutedBy",
       "PurchaseOrderItem_Changes"."Attribute"                              AS "ChangedAttribute",
       "PurchaseOrderItem_Changes"."ExecutionType"                          AS "ExecutionType",
       "PurchaseOrderItem_Changes"."OldValue"                               AS "OldValue",
       "PurchaseOrderItem_Changes"."NewValue"                               AS "NewValue"
FROM "o_celonis_PurchaseOrderItem" AS "PurchaseOrderItem"
         LEFT JOIN "c_o_celonis_PurchaseOrderItem" AS "PurchaseOrderItem_Changes"
                   ON "PurchaseOrderItem"."ID" = "PurchaseOrderItem_Changes"."ObjectID"
WHERE "PurchaseOrderItem_Changes"."Attribute" IN ('Quantity', 'StorageLocation', 'DeliveryIndicator',
                                                  'FinalInvoiceIndicator', 'OutwardDeliveryIndicator',
                                                  'RejectionIndicator', 'SystemContractNumber',
                                                  'SystemContractItemNumber', 'ShortText', 'MaterialNumber',
                                                  'MaterialGroup', 'NetUnitPrice')
  AND "PurchaseOrderItem_Changes"."Time" IS NOT NULL
