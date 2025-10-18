Customer Order OTIF (At Risk/ Not At Risk) :

CASE
  WHEN (
    (PU_FIRST("o_celonis_SalesOrderItem",BIND("o_celonis_RelationshipCustomerInvoiceItem",BIND("o_celonis_DeliveryItem","o_celonis_Delivery"."DeliveryDate"))) IS NULL)
    OR  (PU_FIRST("o_celonis_SalesOrderItem",BIND("o_celonis_RelationshipCustomerInvoiceItem",BIND("o_celonis_DeliveryItem","o_celonis_Delivery"."DeliveryDate")))
       >  BIND("o_celonis_SalesOrderItem","o_celonis_SalesOrder"."RequestedDeliveryDate")
       AND "o_celonis_SalesOrderItem"."OrderedQuantity"  != PU_FIRST("o_celonis_SalesOrderItem",BIND("o_celonis_RelationshipCustomerInvoiceItem",BIND("o_celonis_DeliveryItem","o_celonis_DeliveryItem"."Quantity")))
       )  -- delivered late
  -- OR "o_celonis_Delivery"."Customer_ID" != "o_celonis_SalesOrder"."Customer_ID"
  )
  THEN 'At Risk'
  ELSE 'Not at Risk'
END
