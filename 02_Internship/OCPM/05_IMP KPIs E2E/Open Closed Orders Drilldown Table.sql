Sales Order ID :
"o_celonis_SalesOrder"."ID"

SO Value :
"o_celonis_SalesOrder"."NetAmount"

Linked POs :
COUNT(
  CASE
    WHEN PU_FIRST("o_celonis_MaterialMasterPlant", "o_celonis_PurchaseOrderItem"."ID") IS NOT NULL
    THEN "o_celonis_SalesOrderItem"."ID"
    ELSE NULL
  END
)

Delivery Date(In-future/Today/passed) :
CASE
  WHEN "o_celonis_SalesOrder"."RequestedDeliveryDate" > TODAY() THEN 'Future'
  WHEN "o_celonis_SalesOrder"."RequestedDeliveryDate" = TODAY() THEN 'Today'
  WHEN "o_celonis_SalesOrder"."RequestedDeliveryDate" < TODAY() THEN 'Passed'
  ELSE 'Unknown'
END

Supplier :
PU_FIRST(
  "o_celonis_MaterialMasterPlant",
  BIND(
    "o_celonis_PurchaseOrderItem",
    "o_celonis_PurchaseOrder"."Vendor_ID"
  )
)

Materials :
PU_FIRST(
    "o_celonis_MaterialMasterPlant",
    BIND(
        "o_celonis_PurchaseOrderItem",
        "o_celonis_PurchaseOrderItem"."Material_ID" || ' - ' || "o_celonis_PurchaseOrderItem"."ShortText"
    )
)

Customer Orders At Risk / Not at Risk :
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

