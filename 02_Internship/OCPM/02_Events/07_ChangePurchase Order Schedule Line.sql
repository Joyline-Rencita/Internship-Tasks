SELECT 'ChangePurchaseOrderScheduleLine' || '_' || "PurchaseOrderScheduleLine_Changes"."ID" AS "ID",
       "PurchaseOrderScheduleLine_Changes"."ObjectID"                                       AS "PurchaseOrderScheduleLine",
       "PurchaseOrderScheduleLine_Changes"."Time"                                           AS "Time",
       "PurchaseOrderScheduleLine_Changes"."ChangedBy"                                      AS "ExecutedBy",
       "PurchaseOrderScheduleLine_Changes"."Attribute"                                      AS "ChangedAttribute",
       "PurchaseOrderScheduleLine_Changes"."ExecutionType"                                  AS "ExecutionType",
       "PurchaseOrderScheduleLine_Changes"."OldValue"                                       AS "OldValue",
       "PurchaseOrderScheduleLine_Changes"."NewValue"                                       AS "NewValue"
FROM "o_celonis_PurchaseOrderScheduleLine" AS "PurchaseOrderScheduleLine"
         LEFT JOIN "c_o_celonis_PurchaseOrderScheduleLine" AS "PurchaseOrderScheduleLine_Changes"
                   ON "PurchaseOrderScheduleLine"."ID" = "PurchaseOrderScheduleLine_Changes"."ObjectID"
WHERE "PurchaseOrderScheduleLine_Changes"."Attribute" = 'ItemDeliveryDate'
  AND "PurchaseOrderScheduleLine_Changes"."OldValue" IS NOT NULL
  AND "PurchaseOrderScheduleLine_Changes"."Time" IS NOT NULL
