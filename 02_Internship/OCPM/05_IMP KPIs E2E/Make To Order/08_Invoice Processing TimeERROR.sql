Invoice Processing Time :

AVG(
  DAYS_BETWEEN(
    "o_celonis_VendorAccountCreditItem"."DocumentDate",
    "o_celonis_VendorAccountCreditItem"."CreationTime"
  )
)
