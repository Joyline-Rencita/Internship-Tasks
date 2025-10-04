Orders Delayed Due to Internal Issues :

(
  COUNT(
    DISTINCT CASE
      WHEN "o_celonis_Delivery"."DeliveryDate" > "o_celonis_SalesOrder"."RequestedDeliveryDate"
      THEN "o_celonis_SalesOrder"."ID"
    END
  )
  /
  COUNT(DISTINCT "o_celonis_SalesOrder"."ID")
)*100
