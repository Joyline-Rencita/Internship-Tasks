SO Creation to PO Creation Cycle Time :

AVG(
  DAYS_BETWEEN(
    PU_FIRST( "o_celonis_MaterialMasterPlant","o_celonis_SalesOrderItem"."CreationTime"),
    PU_FIRST("o_celonis_MaterialMasterPlant", "o_celonis_PurchaseOrderItem"."CreationTime")
    
  )
)
