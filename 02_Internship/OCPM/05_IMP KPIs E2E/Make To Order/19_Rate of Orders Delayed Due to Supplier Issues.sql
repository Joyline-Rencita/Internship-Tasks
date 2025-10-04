Orders Delayed Due to Supplier Issues :

ROUND(
  CASE
    WHEN COUNT(
          DISTINCT CASE WHEN "o_celonis_Delivery"."PickingDate" IS NOT NULL THEN "o_celonis_SalesOrder"."ID" END
         ) = 0 THEN 0
    ELSE 100 *
      COUNT(
        DISTINCT CASE
          WHEN "o_celonis_Delivery"."DeliveryDate" > "o_celonis_SalesOrder"."RequestedDeliveryDate"
               AND "o_celonis_Delivery"."PickingDate" > "o_celonis_SalesOrder"."RequestedDeliveryDate"
          THEN "o_celonis_SalesOrder"."ID"
        END
      )
      /
      COUNT(
        DISTINCT CASE WHEN "o_celonis_Delivery"."PickingDate" IS NOT NULL THEN "o_celonis_SalesOrder"."ID" END --not including the picking dates which are null
      )
  END,
  2
)
