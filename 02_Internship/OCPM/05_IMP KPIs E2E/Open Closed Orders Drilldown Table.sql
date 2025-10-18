Sales Order ID :
"o_celonis_SalesOrder"."ID"

SO Value :
"o_celonis_SalesOrder"."NetAmount"

Linked POs :
COUNT(
  CASE
    WHEN PU_FIRST("o_celonis_MaterialMasterPlant", "o_celonis_PurchaseOrderItem"."ID") IS NOT NULL
    THEN "o_celonis_SalesOrderItem"."ID"
    ELSE NULL
  END
)

Delivery Date(In-future/Today/passed) :
CASE
  WHEN "o_celonis_SalesOrder"."RequestedDeliveryDate" > TODAY() THEN 'Future'
  WHEN "o_celonis_SalesOrder"."RequestedDeliveryDate" = TODAY() THEN 'Today'
  WHEN "o_celonis_SalesOrder"."RequestedDeliveryDate" < TODAY() THEN 'Passed'
  ELSE 'Unknown'
END
