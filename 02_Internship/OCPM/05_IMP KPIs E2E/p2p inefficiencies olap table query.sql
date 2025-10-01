1. SO creation time :
  
  BIND("o_celonis_SalesOrderItem", "o_celonis_SalesOrder"."CreationTime")

2. PO Creation Time :

PU_FIRST("o_celonis_MaterialMasterPlant" ,  BIND("o_celonis_PurchaseOrderItem", "o_celonis_PurchaseOrder"."CreationTime") )

3. 
