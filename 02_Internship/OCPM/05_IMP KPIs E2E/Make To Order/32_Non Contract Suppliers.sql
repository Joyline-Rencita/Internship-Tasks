 Non Contract Suppliers :

(
  COUNT(
    CASE
      WHEN "o_celonis_PurchaseOrderItem"."ContractItem_ID" IS NULL
      THEN "o_celonis_PurchaseOrderItem"."ID"
    END
  )
/
  COUNT(DISTINCT "o_celonis_PurchaseOrderItem"."ID")
) * 100
