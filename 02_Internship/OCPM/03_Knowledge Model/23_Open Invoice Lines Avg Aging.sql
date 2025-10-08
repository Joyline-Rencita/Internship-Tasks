Open Invoice Lines Avg Aging :
  
SUM (CASE WHEN "o_celonis_VendorAccountCreditItem"."ClearingDate" IS NULL
  THEN CURRENCY_CONVERT(
             "o_celonis_VendorAccountCreditItem"."Amount",
             FROM ("o_celonis_VendorAccountCreditItem"."Currency"),
             TO ('USD'),
             "o_celonis_VendorAccountCreditItem"."DocumentDate",
             "o_celonis_currencyconversion",
             'M',
             'ECC' 
           )
  END
)
