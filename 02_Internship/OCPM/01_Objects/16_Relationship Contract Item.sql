                    *************************      CTE_UNION     **********************************


WITH "CTE_RCI" AS (
        SELECT "ContractItem"."ID"                                                      AS "ContractItem_ID",
               "PurchaseOrderItem"."ID"                                                 AS "PurchaseOrderItem_ID",
               "PurchaseRequisitionItem_JoinTable"."ID"                                 AS "PurchaseRequisitionItem_ID"
        FROM "o_celonis_PurchaseOrderItem"                                              AS "PurchaseOrderItem"
                 INNER JOIN "r_o_celonis_PurchaseRequisitionItem__PurchaseOrderItems"   AS "PurchaseRequisitionItem_JoinTable"
                            ON "PurchaseOrderItem"."ID"
                               = "PurchaseRequisitionItem_JoinTable"."PurchaseOrderItems_ID"
                 INNER JOIN "o_celonis_ContractItem"                                     AS "ContractItem"
                            ON "PurchaseOrderItem"."ContractItem_ID" = "ContractItem"."ID"
        UNION
        SELECT "ContractItem"."ID"                                                       AS "ContractItem_ID",
               "PurchaseRequisitionItem_JoinTable"."PurchaseOrderItems_ID"               AS "PurchaseOrderItem_ID",
               "PurchaseRequisitionItem_JoinTable"."ID"                                  AS "PurchaseRequisitionItem_ID"
        FROM "o_celonis_PurchaseRequisitionItem"                                         AS "PurchaseRequisitionItem"
                 INNER JOIN "r_o_celonis_PurchaseRequisitionItem__PurchaseOrderItems"    AS "PurchaseRequisitionItem_JoinTable"
                            ON "PurchaseRequisitionItem"."ID" = "PurchaseRequisitionItem_JoinTable"."ID"
                 INNER JOIN "o_celonis_ContractItem"                                     AS "ContractItem"
                            ON "PurchaseRequisitionItem"."ContractItem_ID" = "ContractItem"."ID"),
   "CTE_RCITE_1" AS (SELECT NULL                                                         AS "ContractItem_ID",
                              "PurchaseOrderItem"."ID"                                   AS "PurchaseOrderItem_ID",
                              "PurchaseRequisitionItem_JoinTable"."ID"                   AS "PurchaseRequisitionItem_ID"
                       FROM "o_celonis_PurchaseOrderItem"                                AS "PurchaseOrderItem"
                                INNER JOIN "r_o_celonis_PurchaseRequisitionItem__PurchaseOrderItems" AS "PurchaseRequisitionItem_JoinTable"
                                           ON "PurchaseOrderItem"."ID"
                                              = "PurchaseRequisitionItem_JoinTable"."PurchaseOrderItems_ID"
                       EXCEPT
                       SELECT NULL                                                        AS "ContractItem_ID",
                              "PurchaseOrderItem_ID"                                      AS "PurchaseOrderItem_ID",
                              "PurchaseRequisitionItem_ID"                                AS "PurchaseRequisitionItem_ID"
                       FROM "CTE_RCI"),
   "CTE_RCITE_2" AS (SELECT "ContractItem"."ID"                                           AS "ContractItem_ID",
                              "PurchaseOrderItem"."ID"                                    AS "PurchaseOrderItem_ID",
                              NULL                                                        AS "PurchaseRequisitionItem_ID"
                       FROM "o_celonis_PurchaseOrderItem"                                 AS "PurchaseOrderItem"
                                INNER JOIN "o_celonis_ContractItem"                       AS "ContractItem"
                                           ON "PurchaseOrderItem"."ContractItem_ID" = "ContractItem"."ID"
                       EXCEPT
                       SELECT "ContractItem_ID"                                            AS "ContractItem_ID",
                              "PurchaseOrderItem_ID"                                       AS "PurchaseOrderItem_ID",
                              NULL                                                         AS "PurchaseRequisitionItem_ID"
                       FROM "CTE_RCI"),
   "CTE_RCITE_3" AS (SELECT "ContractItem"."ID"                                            AS "ContractItem_ID",
                              NULL                                                         AS "PurchaseOrderItem_ID",
                              "PurchaseRequisitionItem"."ID"                               AS "PurchaseRequisitionItem_ID"
                       FROM "o_celonis_PurchaseRequisitionItem"                            AS "PurchaseRequisitionItem"
                                INNER JOIN "o_celonis_ContractItem"                        AS "ContractItem"
                                           ON "PurchaseRequisitionItem"."ContractItem_ID" = "ContractItem"."ID"
                       EXCEPT
                       SELECT "ContractItem_ID"                                            AS "ContractItem_ID",
                              NULL                                                         AS "PurchaseOrderItem_ID",
                              "PurchaseRequisitionItem_ID"                                 AS "PurchaseRequisitionItem_ID"
                       FROM "CTE_RCI"),
   "CTE_UNION" AS (SELECT "CTE_RCI"."ContractItem_ID"                                      AS "ContractItem_ID",
                            "CTE_RCI"."PurchaseOrderItem_ID"                               AS "PurchaseOrderItem_ID",
                            "CTE_RCI"."PurchaseRequisitionItem_ID"                         AS "PurchaseRequisitionItem_ID"
                      
                     FROM "CTE_RCI"
                     UNION ALL
                     SELECT "CTE_RCITE_1"."ContractItem_ID"                                AS "ContractItem_ID",
                            "CTE_RCITE_1"."PurchaseOrderItem_ID"                           AS "PurchaseOrderItem_ID",
                            "CTE_RCITE_1"."PurchaseRequisitionItem_ID"                     AS "PurchaseRequisitionItem_ID"
                     FROM "CTE_RCITE_1"
                     UNION ALL
                     SELECT "CTE_RCITE_2"."ContractItem_ID"            AS "ContractItem_ID",
                            "CTE_RCITE_2"."PurchaseOrderItem_ID"       AS "PurchaseOrderItem_ID",
                            "CTE_RCITE_2"."PurchaseRequisitionItem_ID" AS "PurchaseRequisitionItem_ID"
                     FROM "CTE_RCITE_2"
                     UNION ALL
                     SELECT "CTE_RCITE_3"."ContractItem_ID"            AS "ContractItem_ID",
                            "CTE_RCITE_3"."PurchaseOrderItem_ID"       AS "PurchaseOrderItem_ID",
                            "CTE_RCITE_3"."PurchaseRequisitionItem_ID" AS "PurchaseRequisitionItem_ID"
                     FROM "CTE_RCITE_3")
SELECT 'RelationshipContractItem'
           || CASE WHEN "UNION"."ContractItem_ID" IS NOT NULL THEN CONCAT('_', "UNION"."ContractItem_ID") ELSE '' END
           || CASE WHEN "UNION"."PurchaseOrderItem_ID" IS NOT NULL THEN CONCAT('_', "UNION"."PurchaseOrderItem_ID") ELSE '' END
           || CASE WHEN "UNION"."PurchaseRequisitionItem_ID" IS NOT NULL THEN CONCAT('_', "UNION"."PurchaseRequisitionItem_ID") ELSE '' END AS "ID",
       "UNION"."ContractItem_ID"                                                                                                            AS "ContractItem",
       "UNION"."PurchaseOrderItem_ID"                                                                                                       AS "PurchaseOrderItem",
       "UNION"."PurchaseRequisitionItem_ID"                                                                                                 AS "PurchaseRequisitionItem"
FROM "CTE_UNION" AS "UNION"

