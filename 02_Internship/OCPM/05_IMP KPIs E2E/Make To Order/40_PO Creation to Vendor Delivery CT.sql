PO Creation to Vendor Delivery Cycle Time :

AVG(
  DAYS_BETWEEN(
    "o_celonis_PurchaseOrderItem"."CreationTime",
    "o_celonis_PurchaseOrderScheduleLine"."ItemDeliveryDate"
  )
)
