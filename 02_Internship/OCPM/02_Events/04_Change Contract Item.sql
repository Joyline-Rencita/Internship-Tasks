SELECT 'ChangeContractItem' || '_' || "ContractItem_Changes"."ID" AS "ID",
       "ContractItem"."ID"                                        AS "ContractItem",
       "ContractItem_Changes"."Time"                              AS "Time",
       "ContractItem_Changes"."ChangedBy"                         AS "ExecutedBy",
       "ContractItem_Changes"."Attribute"                         AS "ChangedAttribute",
       "ContractItem_Changes"."ExecutionType"                     AS "ExecutionType",
       "ContractItem_Changes"."OldValue"                          AS "OldValue",
       "ContractItem_Changes"."NewValue"                          AS "NewValue"
FROM "o_celonis_ContractItem" AS "ContractItem"
         LEFT JOIN "c_o_celonis_ContractItem" AS "ContractItem_Changes"
                   ON "ContractItem"."ID" = "ContractItem_Changes"."ObjectID"
WHERE "ContractItem_Changes"."Attribute" IN ('TargetQuantity', 'DocumentOutlineAgreementTargetAmount',
                                             'NetUnitPrice', 'EffectiveContractItemValue')
  AND "ContractItem_Changes"."Time" IS NOT NULL
