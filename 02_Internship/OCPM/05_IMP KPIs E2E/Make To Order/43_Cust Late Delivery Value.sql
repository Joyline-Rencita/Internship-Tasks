Cust Late Delivery Value :

SUM(
  CASE 
    WHEN BIND("o_celonis_SalesOrderItem", "o_celonis_SalesOrder"."RequestedDeliveryDate") <
           PU_FIRST("o_celonis_SalesOrderItem", 
                  BIND("o_celonis_RelationshipCustomerInvoiceItem", 
                       BIND("o_celonis_DeliveryItem", "o_celonis_Delivery"."DeliveryDate"))
        )
    THEN "o_celonis_SalesOrderItem"."NetAmount"
    ELSE 0
  END
)
