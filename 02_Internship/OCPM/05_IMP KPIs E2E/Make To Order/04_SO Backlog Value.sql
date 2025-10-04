SO Backlog Val :    Total value of sales orders not yet fulfilled or invoiced.
-- Condition 1: Sum NetAmount for Sales Order Items that are NOT delivered
SUM(
  CASE                         -- If there is NO matching SalesOrderItem_ID in DeliveryItem, it means NOT delivered
    WHEN ISNULL("o_celonis_DeliveryItem"."SalesOrderItem_ID") = 1 THEN "o_celonis_SalesOrderItem"."NetAmount"
    ELSE 0
  END
)
+
-- Condition 2: Sum NetAmount for Sales Order Items that are NOT invoiced
SUM(
  CASE                        -- If there is NO matching SalesOrderItem_ID in CustomerInvoiceItem, it means NOT invoiced
    WHEN ISNULL("o_celonis_CustomerInvoiceItem"."SalesOrderItem_ID") = 1 THEN "o_celonis_SalesOrderItem"."NetAmount"
    ELSE 0
  END
)
