SELECT 'ChangePurchaseRequisitionItem' || '_' || "PurchaseRequisitionItem_Changes"."ID" AS "ID",
       "PurchaseRequisitionItem"."ID"                                                   AS "PurchaseRequisitionItem",
       "PurchaseRequisitionItem_Changes"."Time"                                         AS "Time",
       "PurchaseRequisitionItem_Changes"."ChangedBy"                                    AS "ExecutedBy",
       "PurchaseRequisitionItem_Changes"."Attribute"                                    AS "ChangedAttribute",
       "PurchaseRequisitionItem_Changes"."ExecutionType"                                AS "ExecutionType",
       "PurchaseRequisitionItem_Changes"."OldValue"                                     AS "OldValue",
       "PurchaseRequisitionItem_Changes"."NewValue"                                     AS "NewValue"
FROM "o_celonis_PurchaseRequisitionItem" AS "PurchaseRequisitionItem"
         LEFT JOIN "c_o_celonis_PurchaseRequisitionItem" AS "PurchaseRequisitionItem_Changes"
                   ON "PurchaseRequisitionItem"."ID" = "PurchaseRequisitionItem_Changes"."ObjectID"
WHERE "PurchaseRequisitionItem_Changes"."Attribute" IN ('ReleaseIndicator')
  AND "PurchaseRequisitionItem_Changes"."Time" IS NOT NULL
