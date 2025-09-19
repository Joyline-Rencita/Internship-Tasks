                  **************************        EVENT    *********************************


SELECT 'CreateDeliveryHeader' || '_' || "Delivery"."ID" AS "ID",
       "Delivery"."ID"                                  AS "Delivery",
       "Delivery"."CreationTime"                        AS "Time",
       "Delivery"."CreatedBy_ID"                        AS "ExecutedBy",
       "Delivery"."CreationExecutionType"               AS "ExecutionType"
FROM "o_celonis_Delivery" AS "Delivery"
WHERE "Delivery"."CreationTime" IS NOT NULL


======================================================================================================================================================================


                                      RELATIONSHIPS ->   SALES ORDER ITEMS

