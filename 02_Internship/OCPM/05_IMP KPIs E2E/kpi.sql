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

