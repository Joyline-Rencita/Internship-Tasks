Vendor OTIF :

(
  COUNT(
    CASE
      WHEN 
        PU_FIRST("o_celonis_PurchaseOrderItem", "o_celonis_VendorConfirmation"."ConfirmationDeliveryDate") 
          <= "o_celonis_PurchaseOrderScheduleLine"."ItemDeliveryDate"
        AND "o_celonis_PurchaseOrderItem"."Quantity" = "o_celonis_PurchaseOrderScheduleLine"."ScheduledQuantity"
      THEN "o_celonis_PurchaseOrderItem"."ID"
    END
  )
/
  COUNT(DISTINCT  "o_celonis_PurchaseOrderItem"."ID")
) 
* 100
