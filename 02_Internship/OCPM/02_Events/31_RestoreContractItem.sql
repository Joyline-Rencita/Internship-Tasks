SELECT 'RestoreContractItem' || '_' || "ContractItem_Changes"."ID" AS "ID",
       "ContractItem"."ID"                                         AS "ContractItem",
       "ContractItem_Changes"."Time"                               AS "Time",
       "ContractItem_Changes"."ChangedBy"                          AS "ExecutedBy",
       "ContractItem_Changes"."ExecutionType"                      AS "ExecutionType"
FROM "o_celonis_ContractItem" AS "ContractItem"
         LEFT JOIN "c_o_celonis_ContractItem" AS "ContractItem_Changes"
                   ON "ContractItem"."ID" = "ContractItem_Changes"."ObjectID"
WHERE "ContractItem_Changes"."Attribute" = 'DeletionIndicator'
  AND "ContractItem_Changes"."OldValue" = 'L'
  AND "ContractItem_Changes"."Time" IS NOT NULL
