SO linked with POs :

  
count("o_celonis_SalesOrderItem"."ID")

COUNT(
  CASE
    WHEN PU_FIRST("o_celonis_MaterialMasterPlant", "o_celonis_PurchaseOrderItem"."ID") IS NOT NULL
    THEN "o_celonis_SalesOrderItem"."ID"
    ELSE NULL
  END
)

COUNT( DISTINCT
  BIND("o_celonis_SalesOrderItem","o_celonis_SalesOrder"."ID")
)

COUNT(
  CASE
    WHEN PU_FIRST("o_celonis_MaterialMasterPlant", BIND( "o_celonis_PurchaseOrderItem","o_celonis_PurchaseOrder"."ID")) IS NOT NULL
    THEN BIND("o_celonis_SalesOrderItem", "o_celonis_SalesOrder"."ID")
    ELSE NULL
  END
)
