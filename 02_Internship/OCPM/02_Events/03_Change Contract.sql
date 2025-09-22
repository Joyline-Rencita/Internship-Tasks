                             *********************    EVENT     **************************

SELECT 'ChangeContract' || '_' || "Contract_Changes"."ID" AS "ID",
       "Contract"."ID"                                    AS "Contract",
       "Contract_Changes"."Time"                          AS "Time",
       "Contract_Changes"."ChangedBy"                     AS "ExecutedBy",
       "Contract_Changes"."Attribute"                     AS "ChangedAttribute",
       "Contract_Changes"."ExecutionType"                 AS "ExecutionType",
       "Contract_Changes"."OldValue"                      AS "OldValue",
       "Contract_Changes"."NewValue"                      AS "NewValue"
FROM "o_celonis_Contract" AS "Contract"
         LEFT JOIN "c_o_celonis_Contract" AS "Contract_Changes"
                   ON "Contract"."ID" = "Contract_Changes"."ObjectID"
WHERE "Contract_Changes"."Attribute" IN ('PaymentTerms', 'ValidityPeriodStartDate', 'ValidityPeriodEndDate')
  AND "Contract_Changes"."Time" IS NOT NULL
