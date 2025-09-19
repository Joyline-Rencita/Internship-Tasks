SELECT 'ReleaseCustomerBillingBlock' || '_' || "CustomerBlock"."ID" AS "ID",
       "CustomerBlock"."ID"                                         AS "CustomerBlock",
       "Customer"."ID"                                              AS "Customer",
       "CustomerBlock"."ReleaseTime"                                AS "Time",
       "CustomerBlock"."ReleasedBy_ID"                              AS "ExecutedBy",
       "CustomerBlock"."ReleaseExecutionType"                       AS "ExecutionType",
       "CustomerBlock"."ReleaseReason"                              AS "OldValue",
       NULL                                                         AS "NewValue"
FROM "o_celonis_Customer" AS "Customer"
         LEFT JOIN "o_celonis_CustomerBlock" AS "CustomerBlock"
                   ON "Customer"."ID" = "CustomerBlock"."Customer_ID"
WHERE "CustomerBlock"."BlockType" = 'BillingBlock'
  AND "CustomerBlock"."ReleaseTime" IS NOT NULL
