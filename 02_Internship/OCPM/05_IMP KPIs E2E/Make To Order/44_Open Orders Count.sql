Open Orders Count :

COUNT(
  CASE 
    WHEN ISNULL(PU_FIRST("o_celonis_SalesOrderItem", 
                         BIND("o_celonis_RelationshipCustomerInvoiceItem", 
                              BIND("o_celonis_DeliveryItem", "o_celonis_Delivery"."DeliveryDate")))
          ) = 1
    THEN BIND("o_celonis_SalesOrderItem", "o_celonis_SalesOrder"."ID")
  END
)
