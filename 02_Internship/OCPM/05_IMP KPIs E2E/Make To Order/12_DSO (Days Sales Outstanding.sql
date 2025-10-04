 DSO (Days Sales Outstanding) :
  
(
  SUM(
    CASE
      WHEN "o_celonis_CustomerAccountCreditItem"."ClearingDate" IS NOT NULL
        AND "o_celonis_CustomerAccountCreditItem"."BaselineDate" IS NOT NULL
      THEN
        DAYS_BETWEEN("o_celonis_CustomerAccountCreditItem"."BaselineDate", "o_celonis_CustomerAccountCreditItem"."ClearingDate")
        * "o_celonis_CustomerAccountCreditItem"."Amount"
    END
  )
  /
  SUM("o_celonis_CustomerAccountCreditItem"."Amount")
)
