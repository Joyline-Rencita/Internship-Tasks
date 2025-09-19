SELECT 'ChangeVendorConfirmation' || '_' || "VendorConfirmation_Changes"."ID" AS "ID",
       "VendorConfirmation"."ID"                                              AS "VendorConfirmation",
       "VendorConfirmation_Changes"."Time"                                    AS "Time",
       "VendorConfirmation_Changes"."ChangedBy"                               AS "ExecutedBy",
       "VendorConfirmation_Changes"."Attribute"                               AS "ChangedAttribute",
       "VendorConfirmation_Changes"."ExecutionType"                           AS "ExecutionType",
       "VendorConfirmation_Changes"."OldValue"                                AS "OldValue",
       "VendorConfirmation_Changes"."NewValue"                                AS "NewValue"
FROM "o_celonis_VendorConfirmation" AS "VendorConfirmation"
         LEFT JOIN "c_o_celonis_VendorConfirmation" AS "VendorConfirmation_Changes"
                   ON "VendorConfirmation"."ID" = "VendorConfirmation_Changes"."ObjectID"
WHERE "VendorConfirmation_Changes"."Attribute" = 'ConfirmationDeliveryDate'
  AND "VendorConfirmation_Changes"."OldValue" IS NOT NULL
  AND "VendorConfirmation_Changes"."Time" IS NOT NULL
