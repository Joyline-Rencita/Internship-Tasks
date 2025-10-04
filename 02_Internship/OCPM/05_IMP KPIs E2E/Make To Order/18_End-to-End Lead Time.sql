End-to-End Lead Time :

AVG(
    DAYS_BETWEEN(
        "o_celonis_SalesOrder"."CreationTime",
        "o_celonis_Delivery"."DeliveryDate"
    )
)
