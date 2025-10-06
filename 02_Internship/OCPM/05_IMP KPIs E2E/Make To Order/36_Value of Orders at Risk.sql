

SUM(
  CASE
    WHEN
      PU_FIRST(
        "o_celonis_MaterialMasterPlant",
        BIND(
          "o_celonis_SalesOrderItem",
          "o_celonis_SalesOrder"."RequestedDeliveryDate"
        ),
        ORDER BY "o_celonis_SalesOrder"."RequestedDeliveryDate" ASC
      ) <= ADD_DAYS(TODAY(),7)
      AND
      PU_FIRST(
        "o_celonis_MaterialMasterPlant",
        PU_FIRST(
          "o_celonis_PurchaseOrderItem",
          "o_celonis_PurchaseOrderScheduleLine"."ItemDeliveryDate",
          ORDER BY "o_celonis_PurchaseOrderScheduleLine"."ItemDeliveryDate" ASC
        )
      ) < TODAY()
    THEN "o_celonis_SalesOrder"."NetAmount"
  END
)
