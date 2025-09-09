BUKRS Filter :

FILTER ISNULL ( 
  CASE WHEN "o_celonis_VendorAccountCreditItem"."ClearingDate" IS NULL
  then "o_custom_OpenInvoiceDeepdiveManualFile"."BUKRS"|| "o_custom_OpenInvoiceDeepdiveManualFile"."BELNR"||"o_custom_OpenInvoiceDeepdiveManualFile"."GJAHR"
    ||"o_custom_OpenInvoiceDeepdiveManualFile"."BUZEI"  
  end)  =  0;
