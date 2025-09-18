Cust Order Cycle Time :

  ROUND(
  AVG(
    CASE
      WHEN "o_celonis_SalesOrder"."RequestedDeliveryDate" IS NOT NULL
       AND "o_celonis_SalesOrder"."CreationTime" IS NOT NULL
       AND DAYS_BETWEEN(
             "o_celonis_SalesOrder"."RequestedDeliveryDate",
             "o_celonis_SalesOrder"."CreationTime"
           ) >= 0
      THEN DAYS_BETWEEN(
             "o_celonis_SalesOrder"."RequestedDeliveryDate",
             "o_celonis_SalesOrder"."CreationTime"
           )
    END
  ),
  1
)


Cust OTD Rate :

AVG(
  CASE WHEN "o_celonis_Delivery"."DeliveryDate" <= "o_celonis_SalesOrder"."RequestedDeliveryDate"
  THEN 1.0
  ELSE 0.0
  END
)


Cust OTIF Rate :
  
(
  COUNT(
    CASE
      WHEN "o_celonis_Delivery"."DeliveryDate" <= "o_celonis_SalesOrder"."RequestedDeliveryDate"
        AND "o_celonis_Delivery"."Customer_ID" = "o_celonis_SalesOrder"."Customer_ID"
        -- AND "o_celonis_Delivery"."SystemDeliveryNumber" = "o_celonis_SalesOrder"."SystemSalesOrderNumber"
      THEN "o_celonis_SalesOrder"."ID"
    END
  )
  /
  COUNT("o_celonis_SalesOrder"."ID")
)
