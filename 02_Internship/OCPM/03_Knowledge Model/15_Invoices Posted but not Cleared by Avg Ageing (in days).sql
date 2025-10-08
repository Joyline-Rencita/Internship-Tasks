Invoices Posted but not Cleared by Avg Ageing (in days) :

AVG(
  DAYS_BETWEEN (("o_celonis_VendorAccountCreditItem"."BaseLineDate"),today())
)
