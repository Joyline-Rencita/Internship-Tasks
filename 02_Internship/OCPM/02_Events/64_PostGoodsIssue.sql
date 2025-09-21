                      *********************    EVENT     **************************

SELECT 'PostGoodsIssue' || '_' || "OutgoingMaterialDocumentItem"."ID" AS "ID",
       "OutgoingMaterialDocumentItem"."ID"                            AS "OutgoingMaterialDocumentItem",
       "OutgoingMaterialDocumentItem"."CreationTime"                  AS "Time",
       "OutgoingMaterialDocumentItem"."CreatedBy_ID"                  AS "ExecutedBy",
       "OutgoingMaterialDocumentItem"."CreationExecutionType"         AS "ExecutionType"
FROM "o_celonis_OutgoingMaterialDocumentItem" AS "OutgoingMaterialDocumentItem"
WHERE "OutgoingMaterialDocumentItem"."MaterialTransactionType" = 'GoodsIssue'
  AND "OutgoingMaterialDocumentItem"."CreationTime" IS NOT NULL


======================================================================================================================================================================


                              RELATIONSHIPS ->  DELIVERY ITEMS
                        

SELECT 'PostGoodsIssue' || '_' || "OutgoingMaterialDocumentItem"."ID" AS "ID",
       "OutgoingMaterialDocumentItem"."ID"                            AS "OutgoingMaterialDocumentItem",
       "OutgoingMaterialDocumentItem"."CreationTime"                  AS "Time",
       "OutgoingMaterialDocumentItem"."CreatedBy_ID"                  AS "ExecutedBy",
       "OutgoingMaterialDocumentItem"."CreationExecutionType"         AS "ExecutionType"
FROM "o_celonis_OutgoingMaterialDocumentItem" AS "OutgoingMaterialDocumentItem"
WHERE "OutgoingMaterialDocumentItem"."MaterialTransactionType" = 'GoodsIssue'
  AND "OutgoingMaterialDocumentItem"."CreationTime" IS NOT NULL
