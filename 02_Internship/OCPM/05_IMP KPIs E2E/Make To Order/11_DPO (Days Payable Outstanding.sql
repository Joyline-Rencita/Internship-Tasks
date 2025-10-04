(
SUM(
  CASE
    WHEN "o_celonis_VendorAccountCreditItem"."isRelevantAndCleared"= 0.0
    THEN 0.0
    ELSE DAYS_BETWEEN(ROUND_DAY("o_celonis_VendorAccountCreditItem"."BaseLineDate"), ROUND_DAY("o_celonis_VendorAccountCreditItem"."ClearingDate"))
      * "o_celonis_VendorAccountCreditItem"."ConvertedDocumentValue"
  END)
  /
  SUM(
    CASE
      WHEN "o_celonis_VendorAccountCreditItem"."isRelevantAndCleared" = 0.0
      THEN 0.0
      ELSE "o_celonis_VendorAccountCreditItem"."ConvertedDocumentValue"
  END)
)
