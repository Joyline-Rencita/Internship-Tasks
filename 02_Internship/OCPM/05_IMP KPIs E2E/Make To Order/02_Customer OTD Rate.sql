Cust OTD Rate :    Percentage of customer deliveries completed on or before the requested delivery date.

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


  Alternative Approach  While Multiple Tables are Involved :

AVG(
  CASE 
      WHEN 
       BIND("o_celonis_RelationshipCustomerInvoiceItem", "o_celonis_Delivery"."DeliveryDate") 
            <=       
          BIND("o_celonis_RelationshipCustomerInvoiceItem", "o_celonis_SalesOrder"."RequestedDeliveryDate")
      THEN 'Yes'
      ELSE 'No'
  END
)
