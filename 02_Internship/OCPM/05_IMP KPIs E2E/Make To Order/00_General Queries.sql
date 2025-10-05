Sales Order :
count( "o_celonis_SalesOrder"."ID")

Sales Order Items :
count( "o_celonis_SalesOrderItem"."ID")

Sales Order Value :
SUM("o_celonis_SalesOrderItem"."NetAmount")

Purchase Order :
count("o_celonis_PurchaseOrder"."ID")

Purchase Order Item :
count("o_celonis_PurchaseOrderItem"."ID")

Purchase Order Value :
Sum("o_celonis_PurchaseOrderItem"."NetAmount")

