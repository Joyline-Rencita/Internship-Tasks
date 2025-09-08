SELECT 'CreatePurchaseRequisitionItem' || '_' || "PurchaseRequisition"."ID" AS "ID",
       "PurchaseRequisition"."ID"                                           AS "PurchaseRequisitionItem",
       "ContractItem"."ID"                                                  AS "ContractItem",
       "PurchaseRequisition"."CreationTime"                                 AS "Time",
       "PurchaseRequisition"."CreatedBy_ID"                                 AS "ExecutedBy",
       "PurchaseRequisition"."CreationExecutionType"                        AS "ExecutionType"
FROM "o_celonis_PurchaseRequisitionItem" AS "PurchaseRequisition"
         LEFT JOIN "o_celonis_ContractItem" AS "ContractItem"
                   ON "PurchaseRequisition"."ContractItem_ID" = "ContractItem"."ID"
WHERE "PurchaseRequisition"."CreationTime" IS NOT NULL
