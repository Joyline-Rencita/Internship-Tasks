          *****************************       EVENT      ****************************

SELECT 'CreateSalesOrderHeader' || '_' || "SalesOrder"."ID" AS "ID",
       "SalesOrder"."ID"                                    AS "SalesOrder",
       "SalesOrder"."CreationTime"                          AS "Time",
       "SalesOrder"."CreatedBy_ID"                          AS "ExecutedBy",
       "SalesOrder"."CreationExecutionType"                 AS "ExecutionType"
FROM "o_celonis_SalesOrder" AS "SalesOrder"
WHERE "SalesOrder"."CreationTime" IS NOT NULL
