SELECT 'DeleteContract' || '_' || "Contract_Changes"."ID" AS "ID",
       "Contract"."ID"                                    AS "Contract",
       "Contract_Changes"."Time"                          AS "Time",
       "Contract_Changes"."ChangedBy"                     AS "ExecutedBy",
       "Contract_Changes"."ExecutionType"                 AS "ExecutionType"
FROM "o_celonis_Contract" AS "Contract"
         LEFT JOIN "c_o_celonis_Contract" AS "Contract_Changes"
                   ON "Contract"."ID" = "Contract_Changes"."ObjectID"
WHERE "Contract_Changes"."Attribute" = 'DeletionIndicator'
  AND "Contract_Changes"."NewValue" = 'L'
  AND "Contract_Changes"."Time" IS NOT NULL
