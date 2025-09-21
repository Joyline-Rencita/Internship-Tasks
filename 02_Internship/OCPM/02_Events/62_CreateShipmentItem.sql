SELECT 'CreateShipmentItem' || '_' || "ShipmentItem"."ID" AS "ID",
       "ShipmentItem"."ID"                                AS "ShipmentItem",
       "Delivery"."ID"                                    AS "Delivery",
       "ShipmentItem"."CreationTime"                      AS "Time",
       "ShipmentItem"."CreatedBy_ID"                      AS "ExecutedBy",
       "ShipmentItem"."CreationExecutionType"             AS "ExecutionType",
       "Shipment"."ID"                                    AS "Shipment"
FROM "o_celonis_ShipmentItem" AS "ShipmentItem"
         LEFT JOIN "o_celonis_Shipment" AS "Shipment"
                   ON "ShipmentItem"."Header_ID" = "Shipment"."ID"
         LEFT JOIN "o_celonis_Delivery" AS "Delivery"
                   ON "ShipmentItem"."Delivery_ID" = "Delivery"."ID"
WHERE "ShipmentItem"."CreationTime" IS NOT NULL
