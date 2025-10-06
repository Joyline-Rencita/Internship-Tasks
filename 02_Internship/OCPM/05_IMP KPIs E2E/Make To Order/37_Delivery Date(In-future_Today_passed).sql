CASE
  WHEN "o_celonis_SalesOrder"."RequestedDeliveryDate" > TODAY() THEN 'Future'
  WHEN "o_celonis_SalesOrder"."RequestedDeliveryDate" = TODAY() THEN 'Today'
  WHEN "o_celonis_SalesOrder"."RequestedDeliveryDate" < TODAY() THEN 'Passed'
  ELSE 'Unknown'
END
