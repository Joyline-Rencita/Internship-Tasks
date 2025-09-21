SELECT 'SetCustomerBillingBlock' || '_' || "CustomerBlock"."ID" AS "ID",
       "CustomerBlock"."ID"                                     AS "CustomerBlock",
       "Customer"."ID"                                          AS "Customer",
       "CustomerBlock"."CreationTime"                           AS "Time",
       "CustomerBlock"."BlockedBy_ID"                           AS "ExecutedBy",
       "CustomerBlock"."BlockExecutionType"                     AS "ExecutionType",
       NULL                                                     AS "OldValue",
       "CustomerBlock"."FirstBlockReason"                       AS "NewValue"
FROM "o_celonis_Customer" AS "Customer"
         LEFT JOIN "o_celonis_CustomerBlock" AS "CustomerBlock"
                   ON "Customer"."ID" = "CustomerBlock"."Customer_ID"
WHERE "CustomerBlock"."BlockType" = 'BillingBlock'
  AND "CustomerBlock"."CreationTime" IS NOT NULL
