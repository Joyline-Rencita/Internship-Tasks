             ***********************           EVENT              ***************************

SELECT 'CreateQuotationItem' || '_' || "QuotationItem"."ID" AS "ID",
       "QuotationItem"."ID"                                 AS "QuotationItem",
       "QuotationItem"."CreationTime"                       AS "Time",
       "QuotationItem"."CreatedBy_ID"                       AS "ExecutedBy",
       "QuotationItem"."CreationExecutionType"              AS "ExecutionType",
       "Quotation"."ID"                                     AS "Quotation"
FROM "o_celonis_QuotationItem" AS "QuotationItem"
         LEFT JOIN "o_celonis_Quotation" AS "Quotation"
                   ON "QuotationItem"."Header_ID" = "Quotation"."ID"
WHERE "QuotationItem"."CreationTime" IS NOT NULL
