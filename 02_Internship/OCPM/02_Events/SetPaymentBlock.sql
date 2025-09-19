SELECT 'SetPaymentBlock' || '_' || "VendorAccountCreditItemBlock"."ID" AS "ID",
       "VendorAccountCreditItemBlock"."ID"                             AS "VendorAccountCreditItemBlock",
       "VendorAccountCreditItem"."ID"                                  AS "VendorAccountCreditItem",
       "VendorAccountCreditItemBlock"."CreationTime"                   AS "Time",
       "VendorAccountCreditItemBlock"."BlockedBy_ID"                   AS "ExecutedBy",
       "VendorAccountCreditItemBlock"."BlockExecutionType"             AS "ExecutionType"
FROM "o_celonis_VendorAccountCreditItem" AS "VendorAccountCreditItem"
         LEFT JOIN "o_celonis_VendorAccountCreditItemBlock" AS "VendorAccountCreditItemBlock"
                   ON "VendorAccountCreditItem"."ID" = "VendorAccountCreditItemBlock"."VendorAccountCreditItem_ID"
WHERE "VendorAccountCreditItemBlock"."BlockType" = 'PaymentBlock'
  AND "VendorAccountCreditItemBlock"."CreationTime" IS NOT NULL
