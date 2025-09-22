                      *********************    EVENT     **************************

SELECT 'ChangeVendorInvoice' || '_' || "VendorInvoice_Changes"."ID" AS "ID",
       "VendorInvoice"."ID"                                         AS "VendorInvoice",
       "VendorInvoice_Changes"."Time"                               AS "Time",
       "VendorInvoice_Changes"."ChangedBy"                          AS "ExecutedBy",
       "VendorInvoice_Changes"."Attribute"                          AS "ChangedAttribute",
       "VendorInvoice_Changes"."ExecutionType"                      AS "ExecutionType",
       "VendorInvoice_Changes"."OldValue"                           AS "OldValue",
       "VendorInvoice_Changes"."NewValue"                           AS "NewValue"
FROM "o_celonis_VendorInvoice" AS "VendorInvoice"
         LEFT JOIN "c_o_celonis_VendorInvoice" AS "VendorInvoice_Changes"
                   ON "VendorInvoice"."ID" = "VendorInvoice_Changes"."ObjectID"
WHERE "VendorInvoice_Changes"."Attribute" IN ('TaxCode', 'PaymentTerms')
  AND "VendorInvoice_Changes"."Time" IS NOT NULL
