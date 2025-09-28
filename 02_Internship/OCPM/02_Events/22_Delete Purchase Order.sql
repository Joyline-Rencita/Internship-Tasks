              *********************    EVENT     **************************

SELECT 'DeletePurchaseOrder' || '_' || "PurchaseOrder_Changes"."ID" AS "ID",
       "PurchaseOrder"."ID"                                         AS "PurchaseOrder",
       "PurchaseOrder_Changes"."Time"                               AS "Time",
       "PurchaseOrder_Changes"."ChangedBy"                          AS "ExecutedBy",
       "PurchaseOrder_Changes"."ExecutionType"                      AS "ExecutionType"
FROM "o_celonis_PurchaseOrder" AS "PurchaseOrder"
         LEFT JOIN "c_o_celonis_PurchaseOrder" AS "PurchaseOrder_Changes"
                   ON "PurchaseOrder"."ID" = "PurchaseOrder_Changes"."ObjectID"
WHERE "PurchaseOrder_Changes"."Attribute" = 'DeletionIndicator'
  AND "PurchaseOrder_Changes"."NewValue" = 'L'
  AND "PurchaseOrder_Changes"."Time" IS NOT NULL
