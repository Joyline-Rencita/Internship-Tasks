One Time Vendors :

SUM(
  CASE 
    WHEN PU_COUNT("o_celonis_Vendor", "o_celonis_PurchaseOrder"."ID") = 1
    THEN 1 ELSE 0
  END
)
