                      *********************    EVENT     **************************

SELECT 'ChangeVendorCreditMemo' || '_' || "VendorCreditMemo_Changes"."ID" AS "ID",
       "VendorCreditMemo"."ID"                                            AS "VendorCreditMemo",
       "VendorCreditMemo_Changes"."Time"                                  AS "Time",
       "VendorCreditMemo_Changes"."ChangedBy"                             AS "ExecutedBy",
       "VendorCreditMemo_Changes"."Attribute"                             AS "ChangedAttribute",
       "VendorCreditMemo_Changes"."ExecutionType"                         AS "ExecutionType",
       "VendorCreditMemo_Changes"."OldValue"                              AS "OldValue",
       "VendorCreditMemo_Changes"."NewValue"                              AS "NewValue"
FROM "o_celonis_VendorCreditMemo" AS "VendorCreditMemo"
         LEFT JOIN "c_o_celonis_VendorCreditMemo" AS "VendorCreditMemo_Changes"
                   ON "VendorCreditMemo"."ID" = "VendorCreditMemo_Changes"."ObjectID"
WHERE "VendorCreditMemo_Changes"."Attribute" IN ('TaxCode', 'PaymentTerms')
  AND "VendorCreditMemo_Changes"."Time" IS NOT NULL
