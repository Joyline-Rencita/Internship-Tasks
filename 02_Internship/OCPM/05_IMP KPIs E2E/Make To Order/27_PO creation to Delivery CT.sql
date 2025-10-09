PO creation to Delivery CT :

AVG(
  DAYS_BETWEEN(
    "o_celonis_PurchaseOrderItem"."CreationTime",
    "o_celonis_PurchaseOrderScheduleLine"."ItemDeliveryDate"
    
  )
)  

                    p2p connecting o2c. but not recommended
AVG(
  DAYS_BETWEEN(
    BIND("o_celonis_RelationshipCustomerInvoiceItem", "o_celonis_Delivery"."DeliveryDate"),
    PU_FIRST("o_celonis_MaterialMasterPlant", "o_celonis_PurchaseOrderItem"."CreationTime")
  )
)
