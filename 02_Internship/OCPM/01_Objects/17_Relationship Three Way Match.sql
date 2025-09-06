WITH "CTE_RTWM" AS (
    SELECT "IncomingMatDocItem"."ID" AS "IncomingMaterialDocumentItem_ID",
           "POItem"."ID"             AS "PurchaseOrderItem_ID",
           "VendInvItem"."ID"        AS "VendorInvoiceItem_ID"
    FROM "o_celonis_IncomingMaterialDocumentItem" AS "IncomingMatDocItem"
             INNER JOIN "o_celonis_VendorInvoiceItem" AS "VendInvItem"
                        ON "IncomingMatDocItem"."ID" = "VendInvItem"."IncomingMaterialDocumentItem_ID"
             INNER JOIN "o_celonis_PurchaseOrderItem" AS "POItem"
                        ON "VendInvItem"."PurchaseOrderItem_ID" = "POItem"."ID"
    UNION
    SELECT "IncomingMatDocItem"."ID" AS "IncomingMaterialDocumentItem_ID",
           "POItem"."ID"             AS "PurchaseOrderItem_ID",
           "VendInvItem"."ID"        AS "VendorInvoiceItem_ID"
    FROM "o_celonis_IncomingMaterialDocumentItem" AS "IncomingMatDocItem"
             INNER JOIN "o_celonis_PurchaseOrderItem" AS "POItem"
                        ON "IncomingMatDocItem"."PurchaseOrderItem_ID" = "POItem"."ID"
             INNER JOIN "o_celonis_VendorInvoiceItem" AS "VendInvItem"
                        ON "POItem"."ID" = "VendInvItem"."PurchaseOrderItem_ID"
    WHERE "VendInvItem"."IncomingMaterialDocumentItem_ID" IS NULL
      AND "POItem"."InvoiceAfterGoodsReceiptIndicator" IS NULL),
   "CTE_RTWM_1" AS (SELECT "IncomingMatDocItem"."ID" AS "IncomingMaterialDocumentItem_ID",
                             NULL                    AS "PurchaseOrderItem_ID",
                             "VendInvItem"."ID"      AS "VendorInvoiceItem_ID"
                      FROM "o_celonis_IncomingMaterialDocumentItem" AS "IncomingMatDocItem"
                               INNER JOIN "o_celonis_VendorInvoiceItem" AS "VendInvItem"
                                          ON "IncomingMatDocItem"."ID" = "VendInvItem"."IncomingMaterialDocumentItem_ID"
                      EXCEPT
                      SELECT "IncomingMaterialDocumentItem_ID" AS "IncomingMaterialDocumentItem_ID",
                             NULL                              AS "PurchaseOrderItem_ID",
                             "VendorInvoiceItem_ID"            AS "VendorInvoiceItem_ID"
                      FROM "CTE_RTWM"),
   "CTE_RTWM_2" AS (SELECT NULL                 AS "IncomingMaterialDocumentItem_ID",
                             "POItem"."ID"      AS "PurchaseOrderItem_ID",
                             "VendInvItem"."ID" AS "VendorInvoiceItem_ID"
                      FROM "o_celonis_VendorInvoiceItem" AS "VendInvItem"
                               INNER JOIN "o_celonis_PurchaseOrderItem" AS "POItem"
                                          ON "VendInvItem"."PurchaseOrderItem_ID" = "POItem"."ID"
                      WHERE "VendInvItem"."IncomingMaterialDocumentItem_ID" IS NULL
                        AND "POItem"."InvoiceAfterGoodsReceiptIndicator" IS NULL
                      EXCEPT
                      SELECT NULL                   AS "IncomingMaterialDocumentItem_ID",
                             "PurchaseOrderItem_ID" AS "PurchaseOrderItem_ID",
                             "VendorInvoiceItem_ID" AS "VendorInvoiceItem_ID"
                      FROM "CTE_RTWM"),
   "CTE_RTWM_3" AS (SELECT "IncomingMatDocItem"."ID" AS "IncomingMaterialDocumentItem_ID",
                             "POItem"."ID"           AS "PurchaseOrderItem_ID",
                             NULL                    AS "VendorInvoiceItem_ID"
                      FROM "o_celonis_IncomingMaterialDocumentItem" AS "IncomingMatDocItem"
                               INNER JOIN "o_celonis_PurchaseOrderItem" AS "POItem"
                                          ON "IncomingMatDocItem"."PurchaseOrderItem_ID" = "POItem"."ID"
                      EXCEPT
                      SELECT "IncomingMaterialDocumentItem_ID" AS "IncomingMaterialDocumentItem_ID",
                             "PurchaseOrderItem_ID"            AS "PurchaseOrderItem_ID",
                             NULL                              AS "VendorInvoiceItem_ID"
                      FROM "CTE_RTWM"),
   "CTE_UNION" AS (SELECT "CTE_RTWM"."IncomingMaterialDocumentItem_ID" AS "IncomingMaterialDocumentItem_ID",
                            "CTE_RTWM"."PurchaseOrderItem_ID"          AS "PurchaseOrderItem_ID",
                            "CTE_RTWM"."VendorInvoiceItem_ID"          AS "VendorInvoiceItem_ID"
                     FROM "CTE_RTWM"
                     UNION ALL
                     SELECT "CTE_RTWM_1"."IncomingMaterialDocumentItem_ID" AS "IncomingMaterialDocumentItem_ID",
                            "CTE_RTWM_1"."PurchaseOrderItem_ID"            AS "PurchaseOrderItem_ID",
                            "CTE_RTWM_1"."VendorInvoiceItem_ID"            AS "VendorInvoiceItem_ID"
                     FROM "CTE_RTWM_1"
                     UNION ALL
                     SELECT "CTE_RTWM_2"."IncomingMaterialDocumentItem_ID" AS "IncomingMaterialDocumentItem_ID",
                            "CTE_RTWM_2"."PurchaseOrderItem_ID"            AS "PurchaseOrderItem_ID",
                            "CTE_RTWM_2"."VendorInvoiceItem_ID"            AS "VendorInvoiceItem_ID"
                     FROM "CTE_RTWM_2"
                     UNION ALL
                     SELECT "CTE_RTWM_3"."IncomingMaterialDocumentItem_ID" AS "IncomingMaterialDocumentItem_ID",
                            "CTE_RTWM_3"."PurchaseOrderItem_ID"            AS "PurchaseOrderItem_ID",
                            "CTE_RTWM_3"."VendorInvoiceItem_ID"            AS "VendorInvoiceItem_ID"
                     FROM "CTE_RTWM_3")
SELECT 'RelationshipCustomerClearing'
           || CASE WHEN "UNION"."IncomingMaterialDocumentItem_ID" IS NOT NULL THEN CONCAT('_', "UNION"."IncomingMaterialDocumentItem_ID") ELSE '' END
           || CASE WHEN "UNION"."PurchaseOrderItem_ID" IS NOT NULL THEN CONCAT('_', "UNION"."PurchaseOrderItem_ID") ELSE '' END
           || CASE WHEN "UNION"."VendorInvoiceItem_ID" IS NOT NULL THEN CONCAT('_', "UNION"."VendorInvoiceItem_ID") ELSE '' END AS "ID",
       "UNION"."IncomingMaterialDocumentItem_ID"                                                                                AS "IncomingMaterialDocumentItem",
       "UNION"."PurchaseOrderItem_ID"                                                                                           AS "PurchaseOrderItem",
       "UNION"."VendorInvoiceItem_ID"                                                                                           AS "VendorInvoiceItem"
FROM "CTE_UNION" AS "UNION"
