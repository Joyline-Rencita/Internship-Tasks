Invoices posted but not cleared -By Value (in USD):

-- SUM(
--   CASE 
--     WHEN "o_celonis_VendorAccountCreditItem"."CreationExecutionType" = 'Posted'
--      AND "o_celonis_VendorAccountCreditItem"."ClearingDate" IS NULL 
--     THEN CURRENCY_CONVERT( "o_celonis_VendorAccountCreditItem"."Amount", FROM ("o_celonis_VendorAccountCreditItem"."Currency"), TO ('USD'), "o_celonis_VendorAccountCreditItem"."DocumentDate", "o_celonis_currencyconversion", 'M', 'ECC' ) END )

SUM(
  CASE 
    WHEN "o_custom_OpenInvoiceDeepdiveManualFile"."Status" = 'Invoices Posted but Not Cleared'
        AND "o_celonis_VendorAccountCreditItem"."ClearingDate" IS NULL
    THEN CURRENCY_CONVERT(
             "o_celonis_VendorAccountCreditItem"."Amount",
             FROM ("o_celonis_VendorAccountCreditItem"."Currency"),
             TO ('USD'),
             "o_celonis_VendorAccountCreditItem"."DocumentDate",
             "o_celonis_currencyconversion",
             'M',
             'ECC'
         )
  END
)
