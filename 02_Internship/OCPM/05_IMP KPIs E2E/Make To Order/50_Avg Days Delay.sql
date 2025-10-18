Avg Days Delay :

AVG(        
            DAYS_BETWEEN(
                
                PU_FIRST("o_celonis_MaterialMasterPlant",
                    PU_FIRST("o_celonis_PurchaseOrderItem","o_celonis_VendorConfirmation"."ConfirmationDeliveryDate" )
                ),
                
                PU_FIRST("o_celonis_MaterialMasterPlant",
                    PU_FIRST("o_celonis_PurchaseOrderItem", "o_celonis_PurchaseOrderScheduleLine"."ItemDeliveryDate")
                )
 ))
