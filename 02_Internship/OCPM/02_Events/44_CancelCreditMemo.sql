SELECT 'CancelCreditMemo' || '_' || "CreditMemoCancellation"."ID" AS "ID",
       "CreditMemoCancellation"."ID"                              AS "CreditMemoCancellation",
       "CreditMemoCancellation"."CreationTime"                    AS "Time",
       "CreditMemoCancellation"."CreatedBy_ID"                    AS "ExecutedBy",
       "CreditMemoCancellation"."CreationExecutionType"           AS "ExecutionType"
FROM "o_celonis_CreditMemoCancellation" AS "CreditMemoCancellation"
WHERE "CreditMemoCancellation"."CreationTime" IS NOT NULL


======================================================================================================================================================================

                    	                Relationship =>  Cancel Credit Memo


SELECT DISTINCT
                "Event"."ID"  AS "ID",
                "Object"."ID" AS "CreditMemoItems"
FROM "e_celonis_CancelCreditMemo" AS "Event"
         LEFT JOIN "o_celonis_CreditMemoCancellationItem" AS "CreditMemoCancellationItem"
                   ON "Event"."CreditMemoCancellation_ID" = "CreditMemoCancellationItem"."Header_ID"
         LEFT JOIN "o_celonis_CreditMemoItem" AS "Object"
                   ON "CreditMemoCancellationItem"."CreditMemoItem_ID" = "Object"."ID"
WHERE TIMESTAMPDIFF(SECOND, "Event"."Time", "Object"."CreationTime") <= 5
  AND "Object"."ID" IS NOT NULL
