Vendor Not in Full Delivery :

AVG(
  CASE
    WHEN "o_celonis_PurchaseOrderScheduleLine"."GoodsReceivedQuantity" 
         < "o_celonis_PurchaseOrderScheduleLine"."ScheduledQuantity"
    THEN 1
    ELSE 0
  END
) * 100
