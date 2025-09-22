Cust Order Cycle Time :  Average time taken from Sales Order creation to Invoice posting.

  AVG(
  DAYS_BETWEEN(
    "o_celonis_SalesOrder"."CreationTime", 
    "o_celonis_CustomerInvoiceItem"."CreationTime"  
  )
)
  
--   ROUND(
--   AVG(
--     CASE
--       WHEN "o_celonis_SalesOrder"."RequestedDeliveryDate" IS NOT NULL
--        AND "o_celonis_SalesOrder"."CreationTime" IS NOT NULL
--        AND DAYS_BETWEEN(
--              "o_celonis_SalesOrder"."RequestedDeliveryDate",
--              "o_celonis_SalesOrder"."CreationTime"
--            ) >= 0
--       THEN DAYS_BETWEEN(
--              "o_celonis_SalesOrder"."RequestedDeliveryDate",
--              "o_celonis_SalesOrder"."CreationTime"
--            )
--     END
--   ),
--   1
-- )

Cust OTD Rate :    Percentage of customer deliveries completed on or before the requested delivery date.

AVG(
  CASE WHEN "o_celonis_Delivery"."DeliveryDate" <= "o_celonis_SalesOrder"."RequestedDeliveryDate"
  THEN 1.0   ELSE 0.0
  END
)


Cust OTIF Rate :    Percentage of customer orders delivered on time, complete, and without errors.
  
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


SO Backlog Val :    Total value of sales orders not yet fulfilled or invoiced.

SUM(
  CASE
    WHEN ISNULL("o_celonis_DeliveryItem"."SalesOrderItem_ID") = 1
    AND ISNULL("o_celonis_SalesOrderItem"."RejectionReason") = 1
    THEN "o_celonis_SalesOrderItem"."NetAmount"
    ELSE 0
  END
)


Avg Delivery Lead Time :  Average number of days between order creation and delivery to customer.

AVG(
  DAYS_BETWEEN(
    "o_celonis_Delivery"."ExpectedGoodsIssueDate",
    "o_celonis_SalesOrder"."CreationTime"
  )
) * 100


Invoices Paid On Time :  Percentage of customer invoices paid within agreed payment terms.
  COUNT(
  CASE
    WHEN "o_celonis_CustomerInvoice"."Customer_Invoice_TPT"   <= 
            CASE
              WHEN "o_celonis_CustomerInvoice"."PaymentTerms" = 'D016' THEN 30.0
              WHEN "o_celonis_CustomerInvoice"."PaymentTerms" = 'NT00' THEN 45.0
              WHEN "o_celonis_CustomerInvoice"."PaymentTerms" = 'NT45' THEN 45.0
              WHEN "o_celonis_CustomerInvoice"."PaymentTerms" = 'CRG2' THEN 60.0
              WHEN "o_celonis_CustomerInvoice"."PaymentTerms" = 'Z100' THEN 30.0
              WHEN "o_celonis_CustomerInvoice"."PaymentTerms" = '0001' THEN 30.0
              WHEN "o_celonis_CustomerInvoice"."PaymentTerms" = '0009' THEN 60.0
              ELSE 0.0
            END
    THEN "o_celonis_CustomerInvoice"."ID"
  END
)
/
COUNT(
  CASE
    WHEN "o_celonis_CustomerInvoice"."PaymentTerms" IS NOT NULL
    THEN "o_celonis_CustomerInvoice"."ID"
  END
)
* 100


