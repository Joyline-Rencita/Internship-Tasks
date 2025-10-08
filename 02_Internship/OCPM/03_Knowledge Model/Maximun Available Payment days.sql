Maximun Available Payment days :

-- ADD_DAYS("o_celonis_VendorAccountCreditItem"."BaseLineDate",CASE WHEN "o_celonis_VendorAccountCreditItem"."VendorPaymentDays3" > 0 THEN "o_celonis_VendorAccountCreditItem"."VendorPaymentDays3" WHEN
--   "o_celonis_VendorAccountCreditItem"."VendorPaymentDays2" > 0 THEN "o_celonis_VendorAccountCreditItem"."VendorPaymentDays2" WHEN
--   "o_celonis_VendorAccountCreditItem"."VendorPaymentDays1" > 0 THEN "o_celonis_VendorAccountCreditItem"."VendorPaymentDays1" ELSE 0 END) 

ROUND(
  CASE 
    WHEN "o_celonis_VendorAccountCreditItem"."VendorPaymentDays3" > 0 
        THEN "o_celonis_VendorAccountCreditItem"."VendorPaymentDays3" 
    WHEN  "o_celonis_VendorAccountCreditItem"."VendorPaymentDays2" > 0  AND "o_celonis_VendorAccountCreditItem"."VendorPaymentDays3" = 0 
        THEN "o_celonis_VendorAccountCreditItem"."VendorPaymentDays2" 
    WHEN "o_celonis_VendorAccountCreditItem"."VendorPaymentDays1" > 0 
        AND "o_celonis_VendorAccountCreditItem"."VendorPaymentDays3" = 0 
        AND "o_celonis_VendorAccountCreditItem"."VendorPaymentDays2" = 0
    THEN "o_celonis_VendorAccountCreditItem"."VendorPaymentDays1" 
  ELSE 0 
  END)
