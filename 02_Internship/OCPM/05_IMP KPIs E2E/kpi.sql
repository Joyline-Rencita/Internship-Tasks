Cust Order Cycle Time :  Average time taken from Sales Order creation to Invoice posting.

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


SO Backlog Val :

-- SUM(
--   CASE
--     WHEN "o_celonis_SalesOrderItem"."ProcessingStatus" != 'Completed'
--     AND "o_celonis_SalesOrderItem"."ProcessingStatus" != 'Invoiced'
--     THEN "o_celonis_SalesOrderItem"."NetAmount"
--     ELSE 0
--   END
-- )

SUM(
  CASE
    WHEN ISNULL("o_celonis_DeliveryItem"."SalesOrderItem_ID") = 1
    AND ISNULL("o_celonis_SalesOrderItem"."RejectionReason") = 1
    THEN "o_celonis_SalesOrderItem"."NetAmount"
    ELSE 0
  END
)


--     CORRECT QUERY WITH BLOCKAGE CONDITION
-- SUM(
--     CASE
--         WHEN "o_celonis_SalesOrderItem"."ProcessingStatus" != 'Completed'
--         AND "o_celonis_SalesOrderItem"."ProcessingStatus" != 'Invoiced'
--         AND (
--             ISNULL("o_celonis_SalesOrderBlock"."SalesOrder_ID") = 0
--             OR ISNULL("o_celonis_SalesOrderItemBlock"."SalesOrderItem_ID") = 0
--         )
--         THEN "o_celonis_SalesOrderItem"."NetAmount"
--         ELSE 0
--     END
-- )


Avg Delivery Lead Time :  Average number of days between order creation and delivery to customer.

AVG(
  DAYS_BETWEEN(
    "o_celonis_Delivery"."ExpectedGoodsIssueDate",
    "o_celonis_SalesOrder"."CreationTime"
  )
) * 100
