Past_due_days_v :
  
CASE WHEN ADD_DAYS ( "o_celonis_VendorAccountCreditItem"."BaseLineDate",
KPI("maximun_available_payment_days"))< TODAY() 
THEN DAYS_BETWEEN ( ADD_DAYS ( "o_celonis_VendorAccountCreditItem"."BaseLineDate",
KPI("maximun_available_payment_days")), TODAY()) END
