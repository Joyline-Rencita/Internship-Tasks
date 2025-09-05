SELECT
    CAST(ROW_NUMBER() OVER (ORDER BY "VALUE OPPORTUNITIES") AS VARCHAR(255)) AS "ID",
    "VALUE OPPORTUNITIES" AS "ValueOpportunities",
    "# INVOICES" AS "Invoices",
    "INVOICE VALUE (IN $ M)" AS "InvoiceValueinM"
FROM "Invoice_value_opportunities_Sheet1"
