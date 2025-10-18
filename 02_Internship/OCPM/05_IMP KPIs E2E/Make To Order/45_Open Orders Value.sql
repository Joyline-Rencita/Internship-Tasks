Open Orders Value :


SUM(
  CASE 
    WHEN ISNULL(PU_FIRST("o_celonis_SalesOrderItem", 
                         BIND("o_celonis_RelationshipCustomerInvoiceItem", 
                              BIND("o_celonis_DeliveryItem", "o_celonis_Delivery"."DeliveryDate")))
          ) = 1
    THEN "o_celonis_SalesOrderItem"."NetAmount"
    ELSE 0
  END
)
