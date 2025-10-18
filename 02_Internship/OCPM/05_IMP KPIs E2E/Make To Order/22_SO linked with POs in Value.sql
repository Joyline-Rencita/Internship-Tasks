SO linked with POs in Value :

SUM ( "o_celonis_SalesOrderItem"."NetAmount" )

SUM(
  CASE
    WHEN PU_FIRST("o_celonis_MaterialMasterPlant", "o_celonis_PurchaseOrderItem"."ID") IS NOT NULL
    THEN "o_celonis_SalesOrderItem"."NetAmount"
    ELSE NULL
  END
)


SUM(
  CASE
    WHEN PU_FIRST("o_celonis_MaterialMasterPlant",BIND( "o_celonis_PurchaseOrderItem","o_celonis_PurchaseOrder"."ID")) IS NOT NULL
    THEN "o_celonis_SalesOrderItem"."NetAmount"
    ELSE NULL
  END
)

