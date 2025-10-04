Open Receivables Overdue :

CASE
  WHEN SUM("o_celonis_VendorAccountCreditItem"."Amount") = 0 THEN 0
  ELSE
  (
      SUM(
        CASE 
          WHEN "o_celonis_VendorAccountCreditItem"."DueDate" < Today()
               AND "o_celonis_VendorAccountCreditItem"."ClearingDate" IS NULL
          THEN "o_celonis_VendorAccountCreditItem"."Amount"
          ELSE 0
        END
      )
      /
      SUM("o_celonis_VendorAccountCreditItem"."Amount")
    )
END
