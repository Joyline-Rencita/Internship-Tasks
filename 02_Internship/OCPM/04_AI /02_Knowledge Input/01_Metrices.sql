# Invoices:

id : invoices_1
This KPI show the total number of invoices.
COUNT("o_celonis_VendorAccountCreditItem"."ID")

#Average Aging of Invoices :
  
id : average_aging_of_invoices
This average aging of invoices in days
AVG(
  CASE
    WHEN ROUND_DAY("o_celonis_VendorAccountCreditItem"."ClearingDate") IS NULL
    THEN DAYS_BETWEEN(
      ROUND_DAY("o_celonis_VendorAccountCreditItem"."BaseLineDate"),
      TODAY()
    )
  END
)

#Invoice Value :

id :  invoice_value
Invoice value associated with each invoice line item.
SUM("o_celonis_VendorAccountCreditItem"."Amount")
