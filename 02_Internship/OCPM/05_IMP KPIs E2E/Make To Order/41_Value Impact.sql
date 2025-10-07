(avg(
            
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
  "o_celonis_SalesOrderItem"."NetAmount"
)* 0.05)/365
+(SUM(
  "o_celonis_SalesOrderItem"."NetAmount"
)*0.02)
