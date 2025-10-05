COUNT(
  CASE
    WHEN "o_celonis_PurchaseOrderScheduleLine"."ItemDeliveryDate" < today()
         AND COALESCE("o_celonis_PurchaseOrderScheduleLine"."GoodsReceivedQuantity", 0) < 
             "o_celonis_PurchaseOrderScheduleLine"."ScheduledQuantity"
    THEN "o_celonis_PurchaseOrderScheduleLine"."Id"
  END
) 
                            OR
COUNT(
  CASE
    WHEN "o_celonis_PurchaseOrderScheduleLine"."ItemDeliveryDate" < TODAY()
         AND COALESCE("o_celonis_PurchaseOrderScheduleLine"."GoodsReceivedQuantity", 0) <
             "o_celonis_PurchaseOrderScheduleLine"."ScheduledQuantity"
         AND COALESCE("o_celonis_PurchaseOrderItem"."custom_DeliveryCompletedIndicator", '') != 'X'
    THEN DAYS_BETWEEN("o_celonis_PurchaseOrderScheduleLine"."ItemDeliveryDate", TODAY())
  END
)
