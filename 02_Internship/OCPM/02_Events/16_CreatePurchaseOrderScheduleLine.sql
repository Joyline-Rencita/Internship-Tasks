SELECT 'CreatePurchaseOrderScheduleLine' || '_' || "PurchaseOrderScheduleLine_Changes"."ID" AS "ID",
       "PurchaseOrderScheduleLine_Changes"."ObjectID"                                       AS "PurchaseOrderScheduleLine",
       "PurchaseOrderScheduleLine_Changes"."Time"                                           AS "Time",
       "PurchaseOrderScheduleLine_Changes"."ChangedBy"                                      AS "ExecutedBy",
       "PurchaseOrderScheduleLine_Changes"."ExecutionType"                                  AS "ExecutionType",
       "PurchaseOrderItem"."ID"                                                             AS "PurchaseOrderItem"
FROM "c_o_celonis_PurchaseOrderScheduleLine" AS "PurchaseOrderScheduleLine_Changes"
         LEFT JOIN "o_celonis_PurchaseOrderScheduleLine" AS "PurchaseOrderScheduleLine"
                   ON "PurchaseOrderScheduleLine_Changes"."ObjectID" = "PurchaseOrderScheduleLine"."ID"
         LEFT JOIN "o_celonis_PurchaseOrderItem" AS "PurchaseOrderItem"
                   ON "PurchaseOrderScheduleLine"."PurchaseOrderItem_ID" = "PurchaseOrderItem"."ID"
WHERE "PurchaseOrderScheduleLine_Changes"."Attribute" = 'CreationTime'
  AND "PurchaseOrderScheduleLine_Changes"."Time" IS NOT NULL
