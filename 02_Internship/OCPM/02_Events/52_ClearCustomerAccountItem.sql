SELECT 'ClearCustomerAccountItem' || '_' || "CustomerAccountClearingAssignment"."ID" AS "ID",
       "CustomerAccountClearingAssignment"."ID"                                      AS "CustomerAccountClearingAssignment",
       "CustomerAccountClearingAssignment"."CreationTime"                            AS "Time",
       "CustomerAccountClearingAssignment"."CreatedBy_ID"                            AS "ExecutedBy",
       "CustomerAccountClearingAssignment"."CreationExecutionType"                   AS "ExecutionType"
FROM "o_celonis_CustomerAccountClearingAssignment" AS "CustomerAccountClearingAssignment"
WHERE "CustomerAccountClearingAssignment"."CreationTime" IS NOT NULL

=======================================================================================================================================================================

