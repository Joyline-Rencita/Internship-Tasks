WITH "CTE_Changes" AS (
    SELECT "Delivery_Changes"."ObjectID",
           "Delivery_Changes"."NewValue",
           "Delivery_Changes"."ChangedBy",
           "Delivery_Changes"."ExecutionType",
           ROW_NUMBER() OVER (PARTITION BY "Delivery_Changes"."ObjectID" ORDER BY "Delivery_Changes"."Time" DESC) AS "rn"
    FROM "c_o_celonis_Delivery" AS "Delivery_Changes"
    WHERE "Delivery_Changes"."Attribute" = 'ProofOfDeliveryDate'
    )
SELECT 'SignProofOfDelivery' || '_' || "Delivery"."ID" AS "ID",
       "Delivery"."ID"                                 AS "Delivery",
       "Delivery"."ProofOfDeliveryDate"                AS "Time",
       "Delivery_Changes"."ChangedBy"                  AS "ExecutedBy",
       "Delivery_Changes"."ExecutionType"              AS "ExecutionType"
FROM "o_celonis_Delivery" AS "Delivery"
         LEFT JOIN "CTE_Changes" AS "Delivery_Changes"
                   ON "Delivery"."ID" = "Delivery_Changes"."ObjectID"
                       AND REPLACE(LEFT(CAST("Delivery"."ProofOfDeliveryDate" AS VARCHAR(255)), 10), '-', '')
                               = "Delivery_Changes"."NewValue"
                       AND "Delivery_Changes"."rn" = '1'
WHERE "Delivery"."ProofOfDeliveryDate" IS NOT NULL
