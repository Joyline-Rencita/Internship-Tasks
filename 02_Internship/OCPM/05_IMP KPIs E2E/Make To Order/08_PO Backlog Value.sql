PO Backlog Value :

SUM(
  CASE 
    WHEN "o_celonis_PurchaseOrderScheduleLine"."ItemDeliveryDate" is NULL
      AND "o_celonis_PurchaseOrderScheduleLine"."PurchaseOrderItem_ID" = "o_celonis_PurchaseOrderItem"."ID"
    THEN ( "o_celonis_PurchaseOrderItem"."NetAmount")
   END
)
