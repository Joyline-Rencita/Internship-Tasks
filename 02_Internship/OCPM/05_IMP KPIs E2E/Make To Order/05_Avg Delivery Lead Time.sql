Avg Delivery Lead Time :  Average number of days between order creation and delivery to customer.

AVG(
  DAYS_BETWEEN(
    "o_celonis_Delivery"."ExpectedGoodsIssueDate",
    "o_celonis_SalesOrder"."CreationTime"
  )
) * 100
