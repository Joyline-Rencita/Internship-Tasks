SELECT 'CreateShipmentHeader' || '_' || "Shipment"."ID" AS "ID",
       "Shipment"."ID"                                  AS "Shipment",
       "Shipment"."CreationTime"                        AS "Time",
       "Shipment"."CreatedBy_ID"                        AS "ExecutedBy",
       "Shipment"."CreationExecutionType"               AS "ExecutionType"
FROM "o_celonis_Shipment" AS "Shipment"
WHERE "Shipment"."CreationTime" IS NOT NULL
