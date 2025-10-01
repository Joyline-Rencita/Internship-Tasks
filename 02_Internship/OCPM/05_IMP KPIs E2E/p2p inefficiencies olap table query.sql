1. SO creation time :
  
  BIND("o_celonis_SalesOrderItem", "o_celonis_SalesOrder"."CreationTime")

2. PO Creation Time :

  PU_FIRST("o_celonis_MaterialMasterPlant" ,  
    BIND("o_celonis_PurchaseOrderItem", "o_celonis_PurchaseOrder"."CreationTime") 
  )

3. Goods Scheduled Qty :

  PU_FIRST("o_celonis_MaterialMasterPlant" ,  
    PU_FIRST("o_celonis_PurchaseOrderItem", "o_celonis_PurchaseOrderScheduleLine"."ScheduledQuantity")
  )

4. Goods Received Qty :

  PU_FIRST("o_celonis_MaterialMasterPlant" , 
    PU_FIRST("o_celonis_PurchaseOrderItem", "o_celonis_PurchaseOrderScheduleLine"."GoodsReceivedQuantity")
  )

5.  SO Affected :
  
  BIND("o_celonis_SalesOrderItem","o_celonis_SalesOrder"."ID")

6.  SO Value Affected :

  BIND("o_celonis_SalesOrderItem","o_celonis_SalesOrder"."NetAmount")

7.  SO Value Affected :

