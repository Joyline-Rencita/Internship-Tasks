PO Creation to Vendor Delivery Cycle Time :

AVG(
  DAYS_BETWEEN(
    "o_celonis_PurchaseOrderItem"."CreationTime",
    "o_celonis_PurchaseOrderScheduleLine"."ItemDeliveryDate"
  )
)

  
AVG(      
  DAYS_BETWEEN(
    PU_FIRST("o_celonis_MaterialMasterPlant" , 
       BIND("o_celonis_PurchaseOrderItem", "o_celonis_PurchaseOrderItem"."CreationTime")
    ), 
    PU_FIRST("o_celonis_MaterialMasterPlant" , 
      PU_FIRST("o_celonis_PurchaseOrderItem", "o_celonis_PurchaseOrderScheduleLine"."ItemDeliveryDate")
    )
  )
)
