SUM (
  CASE WHEN "o_celonis_VendorAccountCreditItem"."ClearingDate" IS not NULL
  THEN "o_celonis_VendorAccountCreditItem"."Amount" 
END)
