SELECT 'CreateVendorCreditMemo' || '_' || "VendorCreditMemo"."ID" AS "ID",
       "VendorCreditMemo"."ID"                                    AS "VendorCreditMemo",
       "VendorCreditMemo"."CreationTime"                          AS "Time",
       "VendorCreditMemo"."CreatedBy_ID"                          AS "ExecutedBy",
       "VendorCreditMemo"."CreationExecutionType"                 AS "ExecutionType"
FROM "o_celonis_VendorCreditMemo" AS "VendorCreditMemo"
WHERE "VendorCreditMemo"."CreationTime" IS NOT NULL

====================================================================================================================
