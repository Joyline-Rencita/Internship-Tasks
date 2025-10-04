Supplier On-Time Delivery Rate :

100 * (
  COUNT (DISTINCT CASE
    WHEN "o_celonis_IncomingMaterialDocumentItem"."CreationTime" >= ADD_DAYS(TODAY(), -7)
    AND "o_celonis_IncomingMaterialDocumentItem"."ReversalFlag" = '0'
    THEN "o_celonis_IncomingMaterialDocumentItem"."Id"
  END)
  /
  COUNT (DISTINCT CASE
    WHEN "o_celonis_IncomingMaterialDocumentItem"."ReversalFlag" = '0'
    THEN "o_celonis_IncomingMaterialDocumentItem"."Id"
  END)
)
