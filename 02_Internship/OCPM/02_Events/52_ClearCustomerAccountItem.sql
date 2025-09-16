SELECT 'ClearCustomerAccountItem' || '_' || "CustomerAccountClearingAssignment"."ID"        AS "ID",
       "CustomerAccountClearingAssignment"."ID"                                             AS "CustomerAccountClearingAssignment",
       "CustomerAccountClearingAssignment"."CreationTime"                                   AS "Time",
       "CustomerAccountClearingAssignment"."CreatedBy_ID"                                   AS "ExecutedBy",
       "CustomerAccountClearingAssignment"."CreationExecutionType"                          AS "ExecutionType"
FROM "o_celonis_CustomerAccountClearingAssignment"        AS "CustomerAccountClearingAssignment"
WHERE "CustomerAccountClearingAssignment"."CreationTime" IS NOT NULL

=======================================================================================================================================================================

                            Relationships =>  CustomerAccountCreditItem

SELECT "Event"."ID"                                                   AS "ID",
       "Object"."ID"                                                  AS "CustomerAccountCreditItems"
FROM "e_celonis_ClearCustomerAccountItem"                             AS "Event"
         LEFT JOIN "o_celonis_CustomerAccountClearingAssignment"      AS "Clearing"
                   ON "Event"."CustomerAccountClearingAssignment_ID" = "Clearing"."ID"
         LEFT JOIN "r_o_celonis_CustomerAccountClearingAssignment__CustomerAccountCreditItems" AS "r_CreditItem"
                   ON "Clearing"."ID" = "r_CreditItem"."ID"
         LEFT JOIN "o_celonis_CustomerAccountCreditItem"               AS "Object"
                   ON "r_CreditItem"."CustomerAccountCreditItems_ID" = "Object"."ID"
WHERE "Object"."ID" IS NOT NULL

=======================================================================================================================================================================

                            Relationships =>  CustomerAccountDebitItem

SELECT DISTINCT "Event"."ID"                                            AS "ID",
                "Object"."ID"                                           AS "CustomerAccountDebitItems"
FROM "e_celonis_ClearCustomerAccountItem"                               AS "Event"
         LEFT JOIN "o_celonis_CustomerAccountClearingAssignment"        AS "Clearing"
                   ON "Event"."CustomerAccountClearingAssignment_ID" = "Clearing"."ID"
         LEFT JOIN "r_o_celonis_CustomerAccountClearingAssignment__CustomerAccountDebitItems" AS "r_DebitItem"
                   ON "Clearing"."ID" = "r_DebitItem"."ID"
         LEFT JOIN "o_celonis_CustomerAccountDebitItem"                 AS "Object"
                   ON "r_DebitItem"."CustomerAccountDebitItems_ID" = "Object"."ID"
WHERE "Object"."ID" IS NOT NULL
