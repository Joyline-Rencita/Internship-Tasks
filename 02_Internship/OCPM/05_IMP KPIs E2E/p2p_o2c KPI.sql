1. Cust Order Cycle Time :  Average time taken from Sales Order creation to Invoice posting.

AVG(                                                            --Invoice Posting Date - Sales Order Creation Date (in days)
  DAYS_BETWEEN(
    "o_celonis_SalesOrder"."CreationTime",
    PU_FIRST("o_celonis_Customer", "o_celonis_CustomerAccountCreditItem"."custom_InvoicePostingDate")
  ) 
)

2.Cust OTD Rate :    Percentage of customer deliveries completed on or before the requested delivery date.

AVG(
  CASE WHEN "o_celonis_Delivery"."DeliveryDate" <= "o_celonis_SalesOrder"."RequestedDeliveryDate"
  THEN 1.0   ELSE 0.0
  END
)

  Alternative Approach
(
  SUM(
    CASE 
      WHEN "o_celonis_Delivery"."DeliveryDate" <= "o_celonis_SalesOrder"."RequestedDeliveryDate"
      THEN 1.0
      ELSE 0.0
    END
  )
  /
  COUNT(
    "o_celonis_Delivery"."ID"
  )
) * 100


3.  Cust OTIF Rate :    Percentage of customer orders delivered on time, complete, and without errors.
  
(
  COUNT(
    CASE
      WHEN "o_celonis_Delivery"."DeliveryDate" <= "o_celonis_SalesOrder"."RequestedDeliveryDate"       -- On-time delivery check
        AND "o_celonis_Delivery"."Customer_ID" = "o_celonis_SalesOrder"."Customer_ID"                  -- Customer match
        AND "o_celonis_SalesOrderItem"."OrderedQuantity" = "o_celonis_DeliveryItem"."Quantity"         -- Complete delivery check: Delivered quantity >= Ordered quantity
      THEN "o_celonis_SalesOrder"."ID"
    END
  )
  /
  COUNT("o_celonis_SalesOrder"."ID")
) * 100

4. SO Backlog Val :    Total value of sales orders not yet fulfilled or invoiced.
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

5.  Avg Delivery Lead Time :  Average number of days between order creation and delivery to customer.

AVG(
  DAYS_BETWEEN(
    "o_celonis_Delivery"."ExpectedGoodsIssueDate",
    "o_celonis_SalesOrder"."CreationTime"
  )
) * 100


6.  Invoices Paid On Time :  Percentage of customer invoices paid within agreed payment terms.
  
(
  SUM(
    CASE 
      WHEN "o_celonis_VendorAccountCreditItem"."ClearingDate" <= "o_celonis_VendorAccountCreditItem"."BaseLineDate"
      THEN 1.0
      ELSE 0.0
    END
  )
  /
  COUNT(
    CASE 
      WHEN "o_celonis_VendorAccountCreditItem"."ClearingDate" IS NOT NULL THEN 1
    END
  )
) * 100


7. Credit Block Release Cycle Time : 
AVG(
  DAYS_BETWEEN ( "o_celonis_VendorAccountCreditItem"."CreationTime", "o_celonis_VendorAccountCreditItem"."ClearingDate" )
)


8. DPO (Days Payable Outstanding) :
  
SUM(
  CASE
    WHEN "o_celonis_VendorAccountCreditItem"."isRelevantAndCleared"= 0.0
    THEN 0.0
    ELSE DAYS_BETWEEN(ROUND_DAY("o_celonis_VendorAccountCreditItem"."BaseLineDate"), ROUND_DAY("o_celonis_VendorAccountCreditItem"."ClearingDate"))
      * "o_celonis_VendorAccountCreditItem"."ConvertedDocumentValue"
  END)
  /
  SUM(
    CASE
      WHEN "o_celonis_VendorAccountCreditItem"."isRelevantAndCleared" = 0.0
      THEN 0.0
      ELSE "o_celonis_VendorAccountCreditItem"."ConvertedDocumentValue"
    END)

  
9.  DSO (Days Sales Outstanding) :
  
(
  SUM(
    CASE
      WHEN "o_celonis_CustomerAccountCreditItem"."ClearingDate" IS NOT NULL
        AND "o_celonis_CustomerAccountCreditItem"."BaselineDate" IS NOT NULL
      THEN
        DAYS_BETWEEN("o_celonis_CustomerAccountCreditItem"."BaselineDate", "o_celonis_CustomerAccountCreditItem"."ClearingDate")
        * "o_celonis_CustomerAccountCreditItem"."Amount"
    END
  )
  /
  SUM("o_celonis_CustomerAccountCreditItem"."Amount")
)

10.   SO creation to Delivery CT:

AVG(
  DAYS_BETWEEN(
    "o_celonis_SalesOrder"."CreationTime",
    "o_celonis_Delivery"."DeliveryDate"
  )
)

10 :  PO creation to Delivery CT :

AVG(
  DAYS_BETWEEN(
    BIND("o_celonis_RelationshipCustomerInvoiceItem", "o_celonis_Delivery"."DeliveryDate"),
    PU_FIRST("o_celonis_MaterialMasterPlant", "o_celonis_PurchaseOrderItem"."CreationTime")
  )
)


11.  Not Received (Past Due)  p2p

COUNT(
  CASE
    WHEN "o_celonis_PurchaseOrderScheduleLine"."ItemDeliveryDate" < today()
         AND COALESCE("o_celonis_PurchaseOrderScheduleLine"."GoodsReceivedQuantity", 0) < 
             "o_celonis_PurchaseOrderScheduleLine"."ScheduledQuantity"
    THEN "o_celonis_PurchaseOrderScheduleLine"."Id"
  END
) 

12.  Not Delivered(Past due)  o2c :

COUNT(
  CASE
  WHEN "o_celonis_SalesOrder"."RequestedDeliveryDate" < TODAY()
  AND "o_celonis_Delivery"."DeliveryDate" IS NULL
  THEN DAYS_BETWEEN("o_celonis_SalesOrder"."RequestedDeliveryDate", TODAY())
END
)

13.  Vendor OTIF :

(
  COUNT(
    CASE
      WHEN 
        PU_FIRST("o_celonis_PurchaseOrderItem", "o_celonis_VendorConfirmation"."ConfirmationDeliveryDate") 
          <= "o_celonis_PurchaseOrderScheduleLine"."ItemDeliveryDate"
        AND "o_celonis_PurchaseOrderItem"."Quantity" = "o_celonis_PurchaseOrderScheduleLine"."ScheduledQuantity"
      THEN "o_celonis_PurchaseOrderItem"."ID"
    END
  )
/
  COUNT(DISTINCT  "o_celonis_PurchaseOrderItem"."ID")
) 
* 100


14.  SO linked with POs :

count("o_celonis_SalesOrderItem"."ID")

15 . SO linked with POs in Value :

SUM ( "o_celonis_SalesOrderItem"."NetAmount" )

16. PO Backlog Value :

SUM(
  CASE WHEN "o_celonis_PurchaseOrderScheduleLine"."ItemDeliveryDate" is null
  AND "o_celonis_PurchaseOrderScheduleLine"."PurchaseOrderItem_ID" = "o_celonis_PurchaseOrderItem"."ID"
  THEN ( "o_celonis_PurchaseOrderItem"."NetAmount")
   END
)

17.    Supplier On-Time Delivery :




  

18.  Invoice Processing Time :     correction needed

AVG(
  DAYS_BETWEEN(
    "o_celonis_VendorAccountCreditItem"."DocumentDate",
    "o_celonis_VendorAccountCreditItem"."CreationTime"
  )
)


19.   Invoices Blocked :

100 * (
  SUM(
    CASE 
      WHEN "o_celonis_VendorInvoice"."PaymentBlock" IS NOT NULL THEN 1
      ELSE 0
    END
  )
  /
  COUNT_TABLE("o_celonis_VendorInvoice")
)

20. First-Time-Right PO Rate:

100 * (
  COUNT(DISTINCT
    CASE
      WHEN "o_celonis_PurchaseOrderItem"."ChangeDate" IS NULL
           AND ("o_celonis_PurchaseOrderItem"."DeletionIndicator" IS NULL
                OR "o_celonis_PurchaseOrderItem"."DeletionIndicator" = '')
      THEN "o_celonis_PurchaseOrderItem"."Header_ID"
    END
  )
  /
  COUNT(DISTINCT "o_celonis_PurchaseOrderItem"."Header_ID")
)

21.  Open Receivables Overdue :

CASE
  WHEN SUM("o_celonis_VendorAccountCreditItem"."Amount") = 0 THEN 0
  ELSE
  (
    -- 100 * (
      SUM(
        CASE 
          WHEN "o_celonis_VendorAccountCreditItem"."DueDate" < Today()
               AND "o_celonis_VendorAccountCreditItem"."ClearingDate" IS NULL
          THEN "o_celonis_VendorAccountCreditItem"."Amount"
          ELSE 0
        END
      )
      /
      SUM("o_celonis_VendorAccountCreditItem"."Amount")
    )
END

22. Orders Delayed Due to Supplier Issues :

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


23. Orders Delayed Due to Internal Issues Rate :

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


24.  PO Backlog Value :

SUM(
  CASE WHEN "o_celonis_PurchaseOrderScheduleLine"."ItemDeliveryDate" is null
  AND "o_celonis_PurchaseOrderScheduleLine"."PurchaseOrderItem_ID" = "o_celonis_PurchaseOrderItem"."ID"
  THEN ( "o_celonis_PurchaseOrderItem"."NetAmount")
   END
)

25.  Sales Order :
count( "o_celonis_SalesOrder"."ID")

26.  
