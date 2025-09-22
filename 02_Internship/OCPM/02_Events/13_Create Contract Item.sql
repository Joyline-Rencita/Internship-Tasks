                      *********************    EVENT     **************************

SELECT 'CreateContractItem' || '_' || "ContractItem"."ID" AS "ID",
       "ContractItem"."ID"                                AS "ContractItem",
       "ContractItem"."CreationTime"                      AS "Time",
       "ContractItem"."CreatedBy_ID"                      AS "ExecutedBy",
       "ContractItem"."CreationExecutionType"             AS "ExecutionType",
       "Contract"."ID"                                    AS "Contract"
FROM "o_celonis_ContractItem" AS "ContractItem"
         LEFT JOIN "o_celonis_Contract" AS "Contract"
                   ON "ContractItem"."Header_ID" = "Contract"."ID"
WHERE "ContractItem"."CreationTime" IS NOT NULL
