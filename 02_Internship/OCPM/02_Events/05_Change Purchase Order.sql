                      *********************    EVENT     **************************

SELECT 'ChangePurchaseOrder' || '_' || "PurchaseOrder_Changes"."ID" AS "ID",
       "PurchaseOrder"."ID"                                         AS "PurchaseOrder",
       "PurchaseOrder_Changes"."Time"                               AS "Time",
       "PurchaseOrder_Changes"."ChangedBy"                          AS "ExecutedBy",
       "PurchaseOrder_Changes"."Attribute"                          AS "ChangedAttribute",
       "PurchaseOrder_Changes"."ExecutionType"                      AS "ExecutionType",
       "PurchaseOrder_Changes"."OldValue"                           AS "OldValue",
       "PurchaseOrder_Changes"."NewValue"                           AS "NewValue"
FROM "o_celonis_PurchaseOrder" AS "PurchaseOrder"
         LEFT JOIN "c_o_celonis_PurchaseOrder" AS "PurchaseOrder_Changes"
                   ON "PurchaseOrder"."ID" = "PurchaseOrder_Changes"."ObjectID"
WHERE "PurchaseOrder_Changes"."Attribute" IN ('Vendor', 'Currency', 'PaymentTerms', 'ReleaseIndicator')
  AND "PurchaseOrder_Changes"."Time" IS NOT NULL
