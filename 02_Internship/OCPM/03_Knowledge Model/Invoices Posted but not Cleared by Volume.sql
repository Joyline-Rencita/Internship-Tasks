COUNT (
  CASE WHEN "o_custom_OpenInvoiceDeepdiveManualFile"."STATUS" = 'Invoices Posted but Not Cleared' then
  
  "o_celonis_VendorAccountCreditItem"."ID" END)
