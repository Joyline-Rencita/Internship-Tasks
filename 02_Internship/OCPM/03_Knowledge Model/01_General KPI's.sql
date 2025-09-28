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

Invoices :
COUNT("r_o_celonis_VendorAccountClearingAssignment__VendorAccountCreditItems"."ID")


Invoices posted but not cleared -By Aging :
AVG(DAYS_BETWEEN ( "o_celonis_VendorAccountCreditItem"."BaseLineDate",TODAY()))


  
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

Invoices posted but not cleared -By Volume :
COUNT(DISTINCT CASE WHEN "o_custom_OpenInvoiceDeepdiveManualFile"."Status" = 'Invoices Posted but Not Cleared' and "o_celonis_VendorAccountCreditItem"."ClearingDate" iS NULL 
then "o_custom_OpenInvoiceDeepdiveManualFile"."BELNR"||"o_custom_OpenInvoiceDeepdiveManualFile"."BUKRS"||"o_custom_OpenInvoiceDeepdiveManualFile"."GJAHR" END)


Maximun Available Payment days :
-- ADD_DAYS("o_celonis_VendorAccountCreditItem"."BaseLineDate",CASE WHEN "o_celonis_VendorAccountCreditItem"."VendorPaymentDays3" > 0 THEN "o_celonis_VendorAccountCreditItem"."VendorPaymentDays3" WHEN
--   "o_celonis_VendorAccountCreditItem"."VendorPaymentDays2" > 0 THEN "o_celonis_VendorAccountCreditItem"."VendorPaymentDays2" WHEN
--   "o_celonis_VendorAccountCreditItem"."VendorPaymentDays1" > 0 THEN "o_celonis_VendorAccountCreditItem"."VendorPaymentDays1" ELSE 0 END) 

ROUND(CASE WHEN "o_celonis_VendorAccountCreditItem"."VendorPaymentDays3" > 0 THEN "o_celonis_VendorAccountCreditItem"."VendorPaymentDays3" WHEN
  "o_celonis_VendorAccountCreditItem"."VendorPaymentDays2" > 0 AND "o_celonis_VendorAccountCreditItem"."VendorPaymentDays3" = 0 THEN "o_celonis_VendorAccountCreditItem"."VendorPaymentDays2" WHEN
  "o_celonis_VendorAccountCreditItem"."VendorPaymentDays1" > 0 AND "o_celonis_VendorAccountCreditItem"."VendorPaymentDays3" = 0 AND "o_celonis_VendorAccountCreditItem"."VendorPaymentDays2" = 0
  THEN "o_celonis_VendorAccountCreditItem"."VendorPaymentDays1" ELSE 0 END)


Open Invoice By Value :
sum (CASE WHEN "o_celonis_VendorAccountCreditItem"."ClearingDate" IS NULL
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

Open Invoice Lines Avg Aging :
sum (CASE WHEN "o_celonis_VendorAccountCreditItem"."ClearingDate" IS NULL
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


Open Invoice Lines By Volume :
COUNT(
   CASE WHEN "o_celonis_VendorAccountCreditItem"."ClearingDate" IS NULL
        THEN "o_custom_OpenInvoiceDeepdiveManualFile"."ID"
   END
)


Past_due_days_v :
CASE WHEN ADD_DAYS ( "o_celonis_VendorAccountCreditItem"."BaseLineDate",
KPI("maximun_available_payment_days"))< TODAY() 
THEN DAYS_BETWEEN ( ADD_DAYS ( "o_celonis_VendorAccountCreditItem"."BaseLineDate",
KPI("maximun_available_payment_days")), TODAY()) END


past_due_values_result :
SUM (
  CASE
    WHEN "o_celonis_VendorAccountCreditItem"."ClearingDate" IS NULL
      AND ADD_DAYS("o_celonis_VendorAccountCreditItem"."BaseLineDate", KPI("maximun_available_payment_days")) < TODAY()
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

Ratio :
AVG(CASE WHEN {p1} THEN 1 ELSE 0 END)


Total Purchase OrderItems :
COUNT_TABLE("o_celonis_PurchaseOrderItem")


v_pl_req_qty :
"o_celonis_PurchaseOrderItem"."Quantity" * ((100 - TO_INT("o_celonis_PurchaseOrderItem"."ToleranceLimit"))/100)


Vendor Credit Items :
COUNT_TABLE ( "o_celonis_VendorAccountCreditItem" )

Vendor Debit Items :
COUNT_TABLE ( "o_celonis_VendorAccountDebitItem" )

25.  Sales Order :
count( "o_celonis_SalesOrder"."ID")

26.  Sales Order Items :
count( "o_celonis_SalesOrderItem"."ID")

27. Sales Order Value :
SUM("o_celonis_SalesOrderItem"."NetAmount")

28.  Purchase Order :
count("o_celonis_PurchaseOrder"."ID")

29. Purchase Order Item :
count("o_celonis_PurchaseOrderItem"."ID")

30. Purchase Order Value :
Sum("o_celonis_PurchaseOrderItem"."NetAmount")

