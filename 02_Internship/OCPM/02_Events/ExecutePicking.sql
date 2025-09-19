SELECT 'ExecutePicking' || '_' || "Delivery_Changes"."ID" AS "ID",
       "Delivery"."ID"                                    AS "Delivery",
       "Delivery_Changes"."Time"                          AS "Time",
       "Delivery_Changes"."ChangedBy"                     AS "ExecutedBy",
       "Delivery_Changes"."ExecutionType"                 AS "ExecutionType"
FROM "o_celonis_Delivery" AS "Delivery"
         LEFT JOIN "c_o_celonis_Delivery" AS "Delivery_Changes"
                   ON "Delivery"."ID" = "Delivery_Changes"."ObjectID"
                       AND CAST("Delivery_Changes"."Time" AS DATE) = CAST("Delivery"."PickingDate" AS DATE)
                       AND "Delivery_Changes"."Attribute" = 'PickingStatus'
                       AND "Delivery_Changes"."NewValue" = 'C'
WHERE "Delivery_Changes"."Time" IS NOT NULL
