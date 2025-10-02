            *************************      PQL QUERIES FOR COLUMNS    ***********************


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
  
 COUNT(
  BIND("o_celonis_SalesOrderItem","o_celonis_SalesOrder"."ID")
)

6.  SO Value Affected :

SUM(
  BIND("o_celonis_SalesOrderItem","o_celonis_SalesOrder"."NetAmount")
)



7.  PO Affected :

COUNT(
  PU_FIRST("o_celonis_MaterialMasterPlant" , 
          BIND("o_celonis_PurchaseOrderItem", "o_celonis_PurchaseOrder"."ID")

  )
)
                       
8. PO Values Affected :

SUM(
  PU_FIRST("o_celonis_MaterialMasterPlant" , 
          BIND("o_celonis_PurchaseOrderItem", "o_celonis_PurchaseOrderItem"."NetAmount")

  )
)

9.  Inefficiencies :

CASE

  WHEN DAYS_BETWEEN(
      BIND("o_celonis_SalesOrderItem", "o_celonis_SalesOrder"."CreationTime"),
      PU_FIRST("o_celonis_MaterialMasterPlant" ,BIND("o_celonis_PurchaseOrderItem", "o_celonis_PurchaseOrder"."CreationTime")
      )
    ) > 3
    THEN 'Delayed PO Creation'

  WHEN 
     PU_FIRST("o_celonis_MaterialMasterPlant" , 
            PU_FIRST("o_celonis_PurchaseOrderItem",  "o_celonis_VendorConfirmation"."ConfirmationDeliveryDate"  )
        )       >
      PU_FIRST("o_celonis_MaterialMasterPlant" , 
            PU_FIRST("o_celonis_PurchaseOrderItem",  "o_celonis_PurchaseOrderScheduleLine"."ItemDeliveryDate"  )
        )
          
      THEN 'Vendor Late Delivery'

  WHEN PU_FIRST("o_celonis_MaterialMasterPlant" , 
            PU_FIRST("o_celonis_PurchaseOrderItem", "o_celonis_PurchaseOrderScheduleLine"."GoodsReceivedQuantity")
        )                      < 
        PU_FIRST("o_celonis_MaterialMasterPlant" , 
            PU_FIRST("o_celonis_PurchaseOrderItem", "o_celonis_PurchaseOrderScheduleLine"."ScheduledQuantity")
        )
  THEN 'Vendor not in Full Delivery'

  WHEN PU_FIRST("o_celonis_MaterialMasterPlant" , 
          BIND("o_celonis_PurchaseOrderItem","o_celonis_PurchaseOrderItem"."ContractItem_ID")  
      ) IS NULL
  THEN 'Non Contract Suppliers'

--   WHEN PU_COUNT("o_celonis_Vendor", "o_celonis_PurchaseOrder"."ID") = 1
--     THEN 'One Time Vendors'

END
