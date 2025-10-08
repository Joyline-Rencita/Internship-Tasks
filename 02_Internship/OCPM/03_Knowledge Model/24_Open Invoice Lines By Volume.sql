Open Invoice Lines By Volume :
  
COUNT(
   CASE WHEN "o_celonis_VendorAccountCreditItem"."ClearingDate" IS NULL
        THEN "o_custom_OpenInvoiceDeepdiveManualFile"."ID"
   END
)
