                             *********************    EVENT     **************************

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


======================================================================================================================================================================

                                 RELATIONSHIP -> PURCHASE ORDER ITEMS

SELECT DISTINCT "Event"."ID"  AS "ID",
                "Object"."ID" AS "PurchaseOrderItems"
FROM "e_celonis_CreatePurchaseRequisitionItem" AS "Event"
     LEFT JOIN "o_celonis_PurchaseRequisitionItem" AS "PurchaseRequisitionItem"
               ON "Event"."PurchaseRequisitionItem_ID" = "PurchaseRequisitionItem"."ID"
     LEFT JOIN "r_o_celonis_PurchaseRequisitionItem__PurchaseOrderItems" AS "r_PurchaseOrderItems"
               ON "PurchaseRequisitionItem"."ID" = "r_PurchaseOrderItems"."ID"
     LEFT JOIN "o_celonis_PurchaseOrderItem" AS "Object"
               ON "r_PurchaseOrderItems"."PurchaseOrderItems_ID" = "Object"."ID"
WHERE "Object"."ID" IS NOT NULL
