COUNT(
  CASE WHEN "o_custom_OpenInvoiceDeepdiveManualFile"."STATUS" = 'Invoice Not Posted' then
  
  "o_celonis_VendorAccountCreditItem"."ID" END)
