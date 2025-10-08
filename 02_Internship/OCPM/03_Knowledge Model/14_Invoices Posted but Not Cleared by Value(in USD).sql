Invoices Posted but Not Cleared by Value(in USD) :

SUM(
  CASE WHEN "o_custom_OpenInvoiceDeepdiveManualFile"."STATUS" = 'Invoices Posted but Not Cleared' 
  THEN "o_celonis_VendorAccountCreditItem"."Amount" 
END
)
