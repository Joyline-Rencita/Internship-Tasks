SELECT 'ReverseGoodsReceipt' || '_' || "OutgoingMaterialDocumentItem"."ID" AS "ID",
       "OutgoingMaterialDocumentItem"."ID"                                 AS "OutgoingMaterialDocumentItem",
       "IncomingMaterialDocumentItem"."ID"                                 AS "IncomingMaterialDocumentItem",
       "OutgoingMaterialDocumentItem"."CreationTime"                       AS "Time",
       "OutgoingMaterialDocumentItem"."CreatedBy_ID"                       AS "ExecutedBy",
       "OutgoingMaterialDocumentItem"."CreationExecutionType"              AS "ExecutionType"
FROM "o_celonis_OutgoingMaterialDocumentItem" AS "OutgoingMaterialDocumentItem"
         LEFT JOIN "o_celonis_IncomingMaterialDocumentItem" AS "IncomingMaterialDocumentItem"
                   ON "OutgoingMaterialDocumentItem"."ReversedIncomingGood_ID" = "IncomingMaterialDocumentItem"."ID"
WHERE "OutgoingMaterialDocumentItem"."MaterialTransactionType" = 'ReverseGoodsReceipt'
  AND "OutgoingMaterialDocumentItem"."CreationTime" IS NOT NULL
