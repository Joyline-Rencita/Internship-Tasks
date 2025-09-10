SELECT
    CAST(ROW_NUMBER() OVER (ORDER BY "EXCEPTION TYPE") AS VARCHAR(255)) AS "ID",
    "EXCEPTION TYPE"          AS "ExceptionType",
    "# OF INVOICES"           AS "OfInvoices",
    "_ EXCEPTION"             AS "Exception"
    
FROM "Exception_Type_Sheet1"
