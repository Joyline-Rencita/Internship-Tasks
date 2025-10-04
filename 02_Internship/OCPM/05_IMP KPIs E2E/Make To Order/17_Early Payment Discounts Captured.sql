Early Payment Discounts Captured :

100 * SUM(
    CASE 
        WHEN "o_celonis_VendorAccountCreditItem"."CashDiscountEligibleAmount" > 0
             AND "o_celonis_VendorAccountCreditItem"."CashDiscountTakenAmount" IS NOT NULL
        THEN "o_celonis_VendorAccountCreditItem"."CashDiscountTakenAmount"
        ELSE 0
    END
)
/
SUM(
    CASE 
        WHEN "o_celonis_VendorAccountCreditItem"."CashDiscountEligibleAmount" > 0
        THEN "o_celonis_VendorAccountCreditItem"."CashDiscountEligibleAmount"
        ELSE 0
    END
)
