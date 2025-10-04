 Invoices Blocked :

(
  SUM(
    CASE 
      WHEN "o_celonis_VendorInvoice"."PaymentBlock" IS NOT NULL THEN 1
      ELSE 0
    END
  )
  /
  COUNT_TABLE("o_celonis_VendorInvoice")
   
) * 100
