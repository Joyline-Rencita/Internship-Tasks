Cust OTIF Rate :    Percentage of customer orders delivered on time, complete, and without errors.
  
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


  Alternative Approach While Multiple Tables are Involved :

AVG(
  CASE
      WHEN BIND("o_celonis_RelationshipCustomerInvoiceItem", "o_celonis_Delivery"."DeliveryDate") <=  
            BIND("o_celonis_RelationshipCustomerInvoiceItem", "o_celonis_SalesOrder"."RequestedDeliveryDate")
        AND "o_celonis_Delivery"."Customer_ID" = "o_celonis_SalesOrder"."Customer_ID"
        AND "o_celonis_SalesOrderItem"."OrderedQuantity" = "o_celonis_DeliveryItem"."Quantity"
      THEN 'Yes'
      ELSE 'No'
END
)
