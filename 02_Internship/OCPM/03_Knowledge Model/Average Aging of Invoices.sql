Average Aging of Invoices : 

AVG(
  CASE
    WHEN ROUND_DAY("o_celonis_VendorAccountCreditItem"."ClearingDate") IS NULL
    THEN DAYS_BETWEEN(
      ROUND_DAY("o_celonis_VendorAccountCreditItem"."BaseLineDate"),
      TODAY()
    )
  END
)
