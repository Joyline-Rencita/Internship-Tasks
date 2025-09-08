SELECT 'RestorePurchaseRequisitionItem' || '_' || "PurchaseRequisitionItem_Changes"."ID" AS "ID",
       "PurchaseRequisitionItem"."ID"                                                    AS "PurchaseRequisitionItem",
       "PurchaseRequisitionItem_Changes"."Time"                                          AS "Time",
       "PurchaseRequisitionItem_Changes"."ChangedBy"                                     AS "ExecutedBy",
       "PurchaseRequisitionItem_Changes"."ExecutionType"                                 AS "ExecutionType"
FROM "o_celonis_PurchaseRequisitionItem" AS "PurchaseRequisitionItem"
         LEFT JOIN "c_o_celonis_PurchaseRequisitionItem" AS "PurchaseRequisitionItem_Changes"
                   ON "PurchaseRequisitionItem"."ID" = "PurchaseRequisitionItem_Changes"."ObjectID"
WHERE "PurchaseRequisitionItem_Changes"."Attribute" = 'DeletionIndicator'
  AND "PurchaseRequisitionItem_Changes"."OldValue" = 'L'
  AND "PurchaseRequisitionItem_Changes"."Time" IS NOT NULL
