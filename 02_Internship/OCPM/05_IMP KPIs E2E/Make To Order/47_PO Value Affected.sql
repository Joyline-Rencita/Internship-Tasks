PO Value Affected :

SUM(
  PU_FIRST("o_celonis_MaterialMasterPlant" , "o_celonis_PurchaseOrderItem"."NetAmount")
)
