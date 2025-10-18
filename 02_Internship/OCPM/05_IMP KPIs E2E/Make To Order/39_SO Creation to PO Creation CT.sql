SO Creation to PO Creation Cycle Time :

AVG(
  DAYS_BETWEEN(
    PU_FIRST( "o_celonis_MaterialMasterPlant","o_celonis_SalesOrderItem"."CreationTime"),
    PU_FIRST("o_celonis_MaterialMasterPlant", "o_celonis_PurchaseOrderItem"."CreationTime")
    
  )
)


AVG(
  DATEDIFF(DD,
    PU_FIRST( "o_celonis_MaterialMasterPlant",BIND("o_celonis_SalesOrderItem","o_celonis_SalesOrder"."CreationTime")),
    PU_FIRST("o_celonis_MaterialMasterPlant",BIND("o_celonis_PurchaseOrderItem","o_celonis_PurchaseOrder"."CreationTime"))
    
  )
)
