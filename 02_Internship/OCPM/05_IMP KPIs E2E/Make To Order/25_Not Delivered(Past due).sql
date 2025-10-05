Not Delivered(Past due)  o2c :

COUNT(
  CASE
  WHEN "o_celonis_SalesOrder"."RequestedDeliveryDate" < TODAY()
  AND "o_celonis_Delivery"."DeliveryDate" IS NULL
  THEN DAYS_BETWEEN("o_celonis_SalesOrder"."RequestedDeliveryDate", TODAY())
END
)

                            OR
  
COUNT(
  CASE
    WHEN "o_celonis_SalesOrder"."RequestedDeliveryDate" < TODAY()
         AND COALESCE(
           BIND("o_celonis_RelationshipCustomerInvoiceItem", 
           "o_celonis_OutgoingMaterialDocumentItem"."custom_DeliveryCompletedIndicator"), '') != 'X'
    THEN DAYS_BETWEEN("o_celonis_SalesOrder"."RequestedDeliveryDate", TODAY())
  END
)
