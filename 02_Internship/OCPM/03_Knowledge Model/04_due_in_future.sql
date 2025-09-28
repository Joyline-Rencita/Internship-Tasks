due_in_future :

CASE WHEN ADD_DAYS ( "o_celonis_VendorAccountCreditItem"."BaseLineDate",
KPI("maximun_available_payment_days")) > TODAY() --future
THEN DAYS_BETWEEN (TODAY(), ADD_DAYS ( "o_celonis_VendorAccountCreditItem"."BaseLineDate",
KPI("maximun_available_payment_days"))) 
END
