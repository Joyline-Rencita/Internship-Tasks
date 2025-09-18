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


