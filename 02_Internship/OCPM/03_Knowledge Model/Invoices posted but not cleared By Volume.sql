Invoices posted but not cleared -By Volume :

COUNT( DISTINCT CASE 
    WHEN "o_custom_OpenInvoiceDeepdiveManualFile"."Status" = 'Invoices Posted but Not Cleared' 
    AND "o_celonis_VendorAccountCreditItem"."ClearingDate" iS NULL 
   THEN "o_custom_OpenInvoiceDeepdiveManualFile"."BELNR"||"o_custom_OpenInvoiceDeepdiveManualFile"."BUKRS"||"o_custom_OpenInvoiceDeepdiveManualFile"."GJAHR" 
  END
)
