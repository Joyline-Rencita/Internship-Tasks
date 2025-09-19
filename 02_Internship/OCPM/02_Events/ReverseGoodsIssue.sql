SELECT 'ReverseGoodsIssue' || '_' || "IncomingMaterialDocumentItem"."ID" AS "ID",
       "IncomingMaterialDocumentItem"."ID"                               AS "IncomingMaterialDocumentItem",
       "OutgoingMaterialDocumentItem"."ID"                               AS "OutgoingMaterialDocumentItem",
       "IncomingMaterialDocumentItem"."CreationTime"                     AS "Time",
       "IncomingMaterialDocumentItem"."CreatedBy_ID"                     AS "ExecutedBy",
       "IncomingMaterialDocumentItem"."CreationExecutionType"            AS "ExecutionType"
FROM "o_celonis_IncomingMaterialDocumentItem" AS "IncomingMaterialDocumentItem"
         LEFT JOIN "o_celonis_OutgoingMaterialDocumentItem" AS "OutgoingMaterialDocumentItem"
                   ON "IncomingMaterialDocumentItem"."ReversedOutgoingGood_ID" = "OutgoingMaterialDocumentItem"."ID"
WHERE "IncomingMaterialDocumentItem"."MaterialTransactionType" = 'ReverseGoodsIssue'
  AND "IncomingMaterialDocumentItem"."CreationTime" IS NOT NULL
