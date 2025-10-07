Sales Order :
count( "o_celonis_SalesOrder"."ID")

Sales Order Items :
count( "o_celonis_SalesOrderItem"."ID")

Sales Order Value :
SUM("o_celonis_SalesOrderItem"."NetAmount")

Purchase Order :
count("o_celonis_PurchaseOrder"."ID")

COUNT( DISTINCT PU_FIRST("o_celonis_MaterialMasterPlant" , 
          BIND("o_celonis_PurchaseOrderItem","o_celonis_PurchaseOrder"."ID")
))

Purchase Order Item :
count("o_celonis_PurchaseOrderItem"."ID")

Purchase Order Value :
Sum("o_celonis_PurchaseOrderItem"."NetAmount")

Week :
YEAR("o_celonis_SalesOrder"."CreationTime") || '-' || CALENDAR_WEEK("o_celonis_SalesOrder"."CreationTime")

Month :
MONTH("o_celonis_SalesOrder"."CreationTime")

Year :
YEAR("o_celonis_SalesOrder"."CreationTime")
