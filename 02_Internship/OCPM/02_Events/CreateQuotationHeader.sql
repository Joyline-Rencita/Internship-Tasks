SELECT 'CreateQuotationHeader' || '_' || "Quotation"."ID" AS "ID",
       "Quotation"."ID"                                   AS "Quotation",
       "Quotation"."CreationTime"                         AS "Time",
       "Quotation"."CreatedBy_ID"                         AS "ExecutedBy",
       "Quotation"."CreationExecutionType"                AS "ExecutionType"
FROM "o_celonis_Quotation" AS "Quotation"
WHERE "Quotation"."CreationTime" IS NOT NULL
