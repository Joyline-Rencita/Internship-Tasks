SELECT 'SendPurchaseOrderOverdueNotice' || '_' || "PurchaseOrder_Changes"."ID" AS "ID",
       "PurchaseOrder_Changes"."ObjectID"                                      AS "PurchaseOrder",
       "PurchaseOrder_Changes"."Time"                                          AS "Time",
       "PurchaseOrder_Changes"."ChangedBy"                                     AS "ExecutedBy",
       "PurchaseOrder_Changes"."ExecutionType"                                 AS "ExecutionType"
FROM "o_celonis_PurchaseOrder" AS "PurchaseOrder"
         LEFT JOIN "c_o_celonis_PurchaseOrder" AS "PurchaseOrder_Changes"
                   ON "PurchaseOrder"."ID" = "PurchaseOrder_Changes"."ObjectID"
WHERE "PurchaseOrder_Changes"."Attribute" = 'SendOverdueNotice'
  AND "PurchaseOrder_Changes"."Time" IS NOT NULL
