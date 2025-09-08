SELECT 'DeletePurchaseOrderScheduleLine' || '_' || "PurchaseOrderScheduleLine_Changes"."ID" AS "ID",
       "PurchaseOrderScheduleLine_Changes"."ObjectID"                                       AS "PurchaseOrderScheduleLine",
       "PurchaseOrderScheduleLine_Changes"."Time"                                           AS "Time",
       "PurchaseOrderScheduleLine_Changes"."ChangedBy"                                      AS "ExecutedBy",
       "PurchaseOrderScheduleLine_Changes"."ExecutionType"                                  AS "ExecutionType"
FROM "c_o_celonis_PurchaseOrderScheduleLine" AS "PurchaseOrderScheduleLine_Changes"
WHERE "PurchaseOrderScheduleLine_Changes"."Attribute" = 'DeletionTime'
  AND "PurchaseOrderScheduleLine_Changes"."Time" IS NOT NULL
