Invoices Paid On Time : 

(
  SUM(
    CASE 
      WHEN "o_celonis_VendorAccountCreditItem"."ClearingDate" <= "o_celonis_VendorAccountCreditItem"."BaseLineDate"
      THEN 1.0
      ELSE 0.0
    END
  )
  /
  COUNT(
    CASE 
      WHEN "o_celonis_VendorAccountCreditItem"."ClearingDate" IS NOT NULL THEN 1
    END
  )
) * 100
