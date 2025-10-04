Cust Order Cycle Time :  Average time taken from Sales Order creation to Invoice posting.

AVG(                                                            --Invoice Posting Date - Sales Order Creation Date (in days)
  DAYS_BETWEEN(
    "o_celonis_SalesOrder"."CreationTime",
    PU_FIRST("o_celonis_Customer", "o_celonis_CustomerAccountCreditItem"."custom_InvoicePostingDate")
  ) 
)
