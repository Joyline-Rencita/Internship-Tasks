Invoices :
COUNT("o_celonis_VendorAccountCreditItem"."ID")

Average Aging of Invoices :
AVG(
  CASE
    WHEN ROUND_DAY("o_celonis_VendorAccountCreditItem"."ClearingDate") IS NULL
    THEN DAYS_BETWEEN(
      ROUND_DAY("o_celonis_VendorAccountCreditItem"."BaseLineDate"),
      TODAY()
    )
  END
)

avg_past_due_days_v :
AVG (KPI("past_due_date"))

count_table_currencyconversion :
Count_Table("o_celonis_CurrencyConversion")

count_exceptiontypesheet1 :
COUNT_TABLE("o_custom_ExceptionTypeSheet1")

count_table_invoice_value_opportunities_sheet1 :
Count_Table("o_custom_InvoiceValueOpportunitiesSheet1")

count_table_invoicelifecyclestagesheet1 :
Count_Table("o_custom_InvoiceLifecycleStageSheet1")

count_table_vendorinvoiceitem :
Count_Table("o_celonis_VendorInvoiceItem")

due_in_future :
CASE WHEN ADD_DAYS ( "o_celonis_VendorAccountCreditItem"."BaseLineDate",
KPI("maximun_available_payment_days")) > TODAY() --future
THEN DAYS_BETWEEN (TODAY(), ADD_DAYS ( "o_celonis_VendorAccountCreditItem"."BaseLineDate",
KPI("maximun_available_payment_days"))) 
END

filtered_count :
COUNT(CASE WHEN {p1} THEN 0 ELSE NULL END)

Incoming Material Document Items :
COUNT_TABLE("o_celonis_IncomingMaterialDocumentItem")

Invoice Not Posted Avg Aging :
AVG(DAYS_BETWEEN (("o_celonis_VendorAccountCreditItem"."BaseLineDate"),today()))

Invoice Not Posted By Value :
SUM("o_celonis_VendorAccountCreditItem"."Amount")

Invoice Not Posted By Volume :
COUNT_TABLE("o_celonis_IncomingMaterialDocumentItem")

Invoice Not Posted Count :
COUNT(
   CASE WHEN "o_custom_OpenInvoiceDeepdiveManualFile"."STATUS" = 'Invoice Not Posted'
        THEN "o_custom_OpenInvoiceDeepdiveManualFile"."ID"
   END
)


Invoice Value :
SUM("o_celonis_VendorAccountCreditItem"."Amount")











