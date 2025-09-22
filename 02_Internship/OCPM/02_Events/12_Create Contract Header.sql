                      *********************    EVENT     **************************

SELECT 'CreateContractHeader' || '_' || "Contract"."ID" AS "ID",
       "Contract"."ID"                                  AS "Contract",
       "Contract"."CreationTime"                        AS "Time",
       "Contract"."CreatedBy_ID"                        AS "ExecutedBy",
       "Contract"."CreationExecutionType"               AS "ExecutionType"
FROM "o_celonis_Contract" AS "Contract"
WHERE "Contract"."CreationTime" IS NOT NULL
