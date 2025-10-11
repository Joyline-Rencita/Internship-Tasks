Total Invoices :

COUNT(
  DISTINCT 
  "o_celonis_VendorAccountCreditItem"."CompanyCode" || "o_celonis_VendorAccountCreditItem"."SystemAccountingDocumentNumber"
    ||  "o_celonis_VendorAccountCreditItem"."FiscalYear"
)
