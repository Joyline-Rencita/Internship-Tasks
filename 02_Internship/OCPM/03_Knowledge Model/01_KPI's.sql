# Invoices :
COUNT("o_celonis_VendorAccountCreditItem"."ID")

#Average Aging of Invoices :
AVG(
  CASE
    WHEN ROUND_DAY("o_celonis_VendorAccountCreditItem"."ClearingDate") IS NULL
    THEN DAYS_BETWEEN(
      ROUND_DAY("o_celonis_VendorAccountCreditItem"."BaseLineDate"),
      TODAY()
    )
  END
)

# avg_past_due_days_v :
AVG (KPI("past_due_date"))

# count_table_currencyconversion
Count_Table("o_celonis_CurrencyConversion")

