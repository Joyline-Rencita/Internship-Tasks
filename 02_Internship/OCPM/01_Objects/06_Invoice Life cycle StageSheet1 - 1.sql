SELECT
    CAST(ROW_NUMBER() OVER (ORDER BY "INVOICE LIFECYCLE STAGE") AS VARCHAR(255))        AS "ID",
    "INVOICE LIFECYCLE STAGE"                                                           AS "InvoiceLifecycleStage",
    "# OF INVOICES"                                                                     AS "OfInvoices",
    "INVOICE VALUE (IN MILLIONS)"                                                       AS "InvoiceValueinMillions"
    
FROM "Invoice_Lifecycle_Stage_Sheet1"
