                *************************        EVENT       **************************

SELECT 'CreateSalesOrderItem' || '_' || "SalesOrderItem"."ID" AS "ID",
       "SalesOrderItem"."ID"                                  AS "SalesOrderItem",
       "SalesOrder"."ID"                                      AS "SalesOrder",
       "SalesOrderItem"."CreationTime"                        AS "Time",
       "SalesOrderItem"."CreatedBy_ID"                        AS "ExecutedBy",
       "SalesOrderItem"."CreationExecutionType"               AS "ExecutionType"
                  
FROM (SELECT "SalesOrderItem"."ID"                            AS ID,
             "SalesOrderItem"."Header_ID"                     AS HEADER_ID,
             "SalesOrderItem"."CreationTime"                  AS CREATIONTIME,
             "SalesOrderItem"."CreatedBy_ID"                  AS CREATEDBY_ID,
             "SalesOrderItem"."CreationExecutionType"         AS CREATIONEXECUTIONTYPE
      FROM "o_celonis_SalesOrderItem" AS "SalesOrderItem"
      ORDER BY "SalesOrderItem"."Header_ID") AS "SalesOrderItem"
         LEFT JOIN "o_celonis_SalesOrder" AS "SalesOrder"
                   ON "SalesOrderItem"."Header_ID" = "SalesOrder"."ID"
WHERE "SalesOrderItem"."CreationTime" IS NOT NULL


=====================================================================================================================================================================

                                    RELATIONSHIPS ->  QUOTATION ITEMS


SELECT DISTINCT
       "Event"."ID"  AS "ID",
       "Object"."ID" AS "QuotationItems"
FROM (SELECT "Event"."ID"                        AS "ID",
             "SalesOrderItem"."QuotationItem_ID" AS "QuotationItem_ID"
      FROM "e_celonis_CreateSalesOrderItem" AS "Event"
               LEFT JOIN "o_celonis_SalesOrderItem" AS "SalesOrderItem"
                         ON "Event"."SalesOrderItem_ID" = "SalesOrderItem"."ID"
      ORDER BY "SalesOrderItem"."QuotationItem_ID") AS "Event"
         LEFT JOIN "o_celonis_QuotationItem" AS "Object"
                   ON "Event"."QuotationItem_ID" = "Object"."ID"
WHERE "Object"."ID" IS NOT NULL

