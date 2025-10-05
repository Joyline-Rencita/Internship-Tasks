SO linked with POs :

count("o_celonis_SalesOrderItem"."ID")

COUNT(
  CASE
    WHEN PU_FIRST("o_celonis_MaterialMasterPlant", "o_celonis_PurchaseOrderItem"."ID") IS NOT NULL
    THEN "o_celonis_SalesOrderItem"."ID"
    ELSE NULL
  END
)
