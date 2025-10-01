COUNT( 
  CASE WHEN "o_celonis_VendorAccountCreditItem"."ClearingDate" IS NULL
      THEN "o_celonis_VendorAccountCreditItem"."ID" 
  END
)
