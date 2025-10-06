AVG(
            DAYS_BETWEEN(
                
                PU_FIRST("o_celonis_MaterialMasterPlant",
                    PU_FIRST("o_celonis_PurchaseOrderItem", "o_celonis_PurchaseOrderScheduleLine"."ItemDeliveryDate")
                ),
                
                PU_FIRST("o_celonis_MaterialMasterPlant",
                    PU_FIRST("o_celonis_PurchaseOrderItem","o_celonis_VendorConfirmation"."ConfirmationDeliveryDate" )
                )
            )
)
*
SUM(
  BIND("o_celonis_SalesOrderItem","o_celonis_SalesOrder"."NetAmount")
)* 0.05
