Customer Order OTIF (At Risk / Not At Risk) : 

CASE
  WHEN (
    "o_celonis_Delivery"."DeliveryDate" IS NULL
    OR "o_celonis_Delivery"."DeliveryDate" > "o_celonis_SalesOrder"."RequestedDeliveryDate"
    OR "o_celonis_Delivery"."Customer_ID" != "o_celonis_SalesOrder"."Customer_ID"
    OR "o_celonis_SalesOrderItem"."OrderedQuantity" != "o_celonis_DeliveryItem"."Quantity"
  )
  THEN 'At Risk'
  ELSE 'Not at Risk'
END
