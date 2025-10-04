First-Time-Right PO :

100 * (
  COUNT(DISTINCT
    CASE
      WHEN "o_celonis_PurchaseOrderItem"."ChangeDate" IS NULL
           AND ("o_celonis_PurchaseOrderItem"."DeletionIndicator" IS NULL
                OR "o_celonis_PurchaseOrderItem"."DeletionIndicator" = '')
      THEN "o_celonis_PurchaseOrderItem"."Header_ID"
    END
  )
  /
  COUNT(DISTINCT "o_celonis_PurchaseOrderItem"."Header_ID")
)
