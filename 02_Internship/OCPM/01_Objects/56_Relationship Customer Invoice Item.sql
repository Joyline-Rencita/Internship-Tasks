                      ****************************      CTE_UNION      ******************************

WITH
     "CTE_SalesOrderItem" AS (SELECT "S"."ID" AS "SalesOrderItem_ID"
                              FROM "o_celonis_SalesOrderItem" AS "S"),
     "CTE_DeliveryItem" AS (SELECT *
                            FROM (SELECT "S"."ID"                                                          AS "DeliveryItem_ID",
                                         "T"."SalesOrderItem_ID"                                           AS "DeliveryItem_SalesOrderItem_ID"
                                  FROM (SELECT "S"."ID",
                                               "S"."SalesOrderItem_ID"                                     AS "SalesOrderItem_ID"
                                        FROM "o_celonis_DeliveryItem" AS "S"
                                        ORDER BY 2) AS "S"
                                           LEFT JOIN "CTE_SalesOrderItem" AS "T"
                                                     ON "S"."SalesOrderItem_ID" = "T"."SalesOrderItem_ID")  AS "T"
                            ORDER BY 1),
     "CTE_CustomerInvoiceItem" AS (SELECT *
                                   FROM (SELECT "S"."ID"                                                     AS "CustomerInvoiceItem_ID",
                                                "T"."SalesOrderItem_ID"                                      AS "CustomerInvoiceItem_SalesOrderItem_ID"
                                         FROM (SELECT "S"."ID",
                                                      "S"."SalesOrderItem_ID" AS "SalesOrderItem_ID"
                                               FROM "o_celonis_CustomerInvoiceItem" AS "S"
                                               ORDER BY 2) AS "S"
                                                  LEFT JOIN "CTE_SalesOrderItem" AS "T"
                                                            ON "S"."SalesOrderItem_ID" = "T"."SalesOrderItem_ID") AS "T"
                                   ORDER BY 1),
     "CTE_CustomerInvoiceItem__DeliveryItems"
         AS (SELECT "S"."CustomerInvoiceItem_ID"                                                              AS "CustomerInvoiceItem_ID",
                    "R"."DeliveryItem_ID"                                                                     AS "CustomerInvoiceItem_DeliveryItems_ID"
             FROM (SELECT "S"."ID",
                          "S"."DeliveryItems_ID",
                          "L"."CustomerInvoiceItem_ID"
                        
                   FROM "r_o_celonis_CustomerInvoiceItem__DeliveryItems" AS "S"
                            INNER JOIN "CTE_CustomerInvoiceItem" AS "L"
                                       ON "S"."ID" = "L"."CustomerInvoiceItem_ID"
                   ORDER BY 2) AS "S"
                      INNER JOIN "CTE_DeliveryItem" AS "R"
                                 ON "S"."DeliveryItems_ID" = "R"."DeliveryItem_ID"),
     "CTE_OutgoingMaterialDocumentItem" AS (SELECT *
                                            FROM (SELECT "S"."OutgoingMaterialDocumentItem_ID",
                                                         "S"."OutgoingMaterialDocumentItem_DeliveryItem_ID",
                                                         "T"."SalesOrderItem_ID"                               AS "OutgoingMaterialDocumentItem_SalesOrderItem_ID"
                                                  FROM (SELECT "S"."ID"                                        AS "OutgoingMaterialDocumentItem_ID",
                                                               "T"."DeliveryItem_ID"                           AS "OutgoingMaterialDocumentItem_DeliveryItem_ID",
                                                               "S"."SalesOrderItem_ID"
                                                        FROM (SELECT "S"."ID",
                                                                     "S"."DeliveryItem_ID"                      AS "DeliveryItem_ID",
                                                                     "S"."SalesOrderItem_ID"                    AS "SalesOrderItem_ID"
                                                              FROM "o_celonis_OutgoingMaterialDocumentItem"     AS "S"
                                                              ORDER BY 2) AS "S"
                                                                 LEFT JOIN "CTE_DeliveryItem" AS "T"
                                                                           ON "S"."DeliveryItem_ID" = "T"."DeliveryItem_ID"
                                                        ORDER BY 3) AS "S"
                                                           LEFT JOIN "CTE_SalesOrderItem" AS "T"
                                                                     ON "S"."SalesOrderItem_ID" = "T"."SalesOrderItem_ID") AS "T"
                                            WHERE "T"."OutgoingMaterialDocumentItem_DeliveryItem_ID" IS NOT NULL
                                               OR "T"."OutgoingMaterialDocumentItem_SalesOrderItem_ID" IS NOT NULL),
     "CTE_DI_SOI" AS (SELECT "S"."ID"                                                                            AS "DeliveryItem_ID",
                             "S"."SalesOrderItem_ID"                                                             AS "DeliveryItem_SalesOrderItem_ID"
                      FROM "o_celonis_DeliveryItem"   AS "S"
                      WHERE "S"."SalesOrderItem_ID" IS NOT NULL),
     "CTE_INV_DI" AS (SELECT "S"."ID"                                                                            AS "CustomerInvoiceItem_ID",
                             "S"."DeliveryItems_ID"                                                              AS "CustomerInvoiceItem_DeliveryItems_ID"
                      FROM "r_o_celonis_CustomerInvoiceItem__DeliveryItems" AS "S"
                               INNER JOIN "CTE_CustomerInvoiceItem" AS "L"
                                          ON "S"."ID" = "L"."CustomerInvoiceItem_ID"),
     "CTE_OGM_DI" AS (SELECT "S"."ID"              AS "OutgoingMaterialDocumentItem_ID",
                             "S"."DeliveryItem_ID" AS "OutgoingMaterialDocumentItem_DeliveryItem_ID"
                      FROM "o_celonis_OutgoingMaterialDocumentItem" AS "S"
                      WHERE "S"."DeliveryItem_ID" IS NOT NULL),
     "CTE_OGM_SI" AS (SELECT "S"."ID",
                             "S"."SalesOrderItem_ID"
                      FROM "o_celonis_OutgoingMaterialDocumentItem" AS "S"
                      WHERE "S"."SalesOrderItem_ID" IS NOT NULL),
     "CTE_INV_SOI_ExDI" AS (SELECT "S"."ID"                AS "CustomerInvoiceItem_ID",
                                   "S"."SalesOrderItem_ID" AS "CustomerInvoiceItem_SalesOrderItem_ID"
                            FROM "o_celonis_CustomerInvoiceItem" AS "S"
                                     LEFT JOIN "CTE_INV_DI" AS "INV_DI" ON "S"."ID" = "INV_DI"."CustomerInvoiceItem_ID"
                            WHERE "S"."SalesOrderItem_ID" IS NOT NULL
                              AND "INV_DI"."CustomerInvoiceItem_ID" IS NULL),
     "CTE_OGM_SOI_ExDI" AS (SELECT "S"."ID"                AS "OutgoingMaterialDocumentItem_ID",
                                   "S"."SalesOrderItem_ID" AS "OutgoingMaterialDocumentItem_SalesOrderItem_ID"
                            FROM "CTE_OGM_SI" AS "S"
                                     LEFT JOIN "CTE_OGM_DI" AS "OMG_DI"
                                               ON "S"."ID" = "OMG_DI"."OutgoingMaterialDocumentItem_ID"
                            WHERE "OMG_DI"."OutgoingMaterialDocumentItem_ID" IS NULL),
     "CTE_OGM_DI_ExSOI" AS (SELECT "OMG_DI"."OutgoingMaterialDocumentItem_ID"              AS "OutgoingMaterialDocumentItem_ID",
                                   "OMG_DI"."OutgoingMaterialDocumentItem_DeliveryItem_ID" AS "OutgoingMaterialDocumentItem_DeliveryItem_ID"
                            FROM "CTE_OGM_DI" AS "OMG_DI"
                                     LEFT JOIN "CTE_OGM_SI" AS "S"
                                               ON "OMG_DI"."OutgoingMaterialDocumentItem_ID" = "S"."ID"
                            WHERE "S"."ID" IS NULL),
     "CTE_DI_ExSOI" AS (SELECT "S"."ID" AS "DeliveryItem_ID"
                        FROM "o_celonis_DeliveryItem" AS "S"
                        WHERE "S"."SalesOrderItem_ID" IS NULL),
     "CTE_OGM_DEL_AND_SOI" AS (SELECT "S"."ID"                AS "OutgoingMaterialDocumentItem_ID",
                                      "S"."DeliveryItem_ID"   AS "OutgoingMaterialDocumentItem_DeliveryItem_ID",
                                      "S"."SalesOrderItem_ID" AS "OutgoingMaterialDocumentItem_SalesOrderItem_ID"
                               FROM "o_celonis_OutgoingMaterialDocumentItem" AS "S"
                               WHERE "S"."DeliveryItem_ID" IS NOT NULL
                                 AND "S"."SalesOrderItem_ID" IS NOT NULL),
     "CTE_SOI_MULTI_DEL" AS (SELECT "DeliveryItem_SalesOrderItem_ID" AS "SalesOrderItem_ID"
                             FROM "CTE_DI_SOI"
                             GROUP BY "DeliveryItem_SalesOrderItem_ID"
                             HAVING COUNT(*) > 1
                             ORDER BY 1),
     "CTE_INV_DI_SOI" AS (SELECT "S"."ID"                                                  AS "CustomerInvoiceItem_ID",
                                 "S"."SalesOrderItem_ID"                                   AS "CustomerInvoiceItem_SalesOrderItem_ID",
                                 "INV_DI"."CustomerInvoiceItem_DeliveryItems_ID"           AS "CustomerInvoiceItem_DeliveryItems_ID"
                          FROM "o_celonis_CustomerInvoiceItem" AS "S"
                                   INNER JOIN "CTE_INV_DI" AS "INV_DI"
                                              ON "S"."ID" = "INV_DI"."CustomerInvoiceItem_ID"
                                                 AND "S"."SalesOrderItem_ID" IS NOT NULL),
     "CTE_L3" AS (SELECT "DI_SOI"."CustomerInvoiceItem_ID"                                AS "CustomerInvoiceItem_ID",
                         "DI_SOI"."DeliveryItem_ID"                                       AS "DeliveryItem_ID",
                         "SalesOrderItem"."SalesOrderItem_ID"                             AS "SalesOrderItem_ID",
                         "DI_SOI"."OutgoingMaterialDocumentItem_ID"                       AS "OutgoingMaterialDocumentItem_ID"
                  FROM (SELECT "INV_DI"."CustomerInvoiceItem_ID"          AS "CustomerInvoiceItem_ID",
                               "DI_SOI"."DeliveryItem_ID"                 AS "DeliveryItem_ID",
                               "DI_SOI"."DeliveryItem_SalesOrderItem_ID",
                               "OGM_DI"."OutgoingMaterialDocumentItem_ID" AS "OutgoingMaterialDocumentItem_ID"
                        FROM (SELECT *
                              FROM "CTE_INV_DI" AS "INV_DI"
                              ORDER BY "CustomerInvoiceItem_DeliveryItems_ID") AS "INV_DI"
                                 INNER JOIN "CTE_DI_SOI" AS "DI_SOI"
                                            ON "INV_DI"."CustomerInvoiceItem_DeliveryItems_ID"
                                               = "DI_SOI"."DeliveryItem_ID"
                                 INNER JOIN (SELECT *
                                             FROM "CTE_OGM_DI" AS "OGM_DI"
                                             ORDER BY "OGM_DI"."OutgoingMaterialDocumentItem_DeliveryItem_ID") AS "OGM_DI"
                                            ON "DI_SOI"."DeliveryItem_ID"
                                               = "OGM_DI"."OutgoingMaterialDocumentItem_DeliveryItem_ID"
                        ORDER BY "DI_SOI"."DeliveryItem_SalesOrderItem_ID") AS "DI_SOI"
                           INNER JOIN "CTE_SalesOrderItem" AS "SalesOrderItem"
                                      ON "DI_SOI"."DeliveryItem_SalesOrderItem_ID"
                                         = "SalesOrderItem"."SalesOrderItem_ID"
                  UNION ALL
                  SELECT "DI_SOI"."CustomerInvoiceItem_ID"          AS "CustomerInvoiceItem_ID",
                         "DI_SOI"."DeliveryItem_ID"                 AS "DeliveryItem_ID",
                         "DI_SOI"."SalesOrderItem_ID"               AS "SalesOrderItem_ID",
                         "OGM_DI"."OutgoingMaterialDocumentItem_ID" AS "OutgoingMaterialDocumentItem_ID"
                  FROM (SELECT "SalesOrderItem"."CustomerInvoiceItem_ID" AS "CustomerInvoiceItem_ID",
                               "DI_SOI"."DeliveryItem_ID"                AS "DeliveryItem_ID",
                               "SalesOrderItem"."SalesOrderItem_ID"      AS "SalesOrderItem_ID"
                        FROM (SELECT "INV_SOI"."CustomerInvoiceItem_ID"   AS "CustomerInvoiceItem_ID",
                                     "SalesOrderItem"."SalesOrderItem_ID" AS "SalesOrderItem_ID"
                              FROM (SELECT *
                                    FROM "CTE_INV_SOI_ExDI" AS "INV_SOI"
                                    ORDER BY "INV_SOI"."CustomerInvoiceItem_SalesOrderItem_ID") AS "INV_SOI"
                                       INNER JOIN "CTE_SalesOrderItem" AS "SalesOrderItem"
                                                  ON "INV_SOI"."CustomerInvoiceItem_SalesOrderItem_ID"
                                                     = "SalesOrderItem"."SalesOrderItem_ID") AS "SalesOrderItem"
                                 INNER JOIN (SELECT *
                                             FROM "CTE_DI_SOI" AS "DI_SOI"
                                             ORDER BY "DI_SOI"."DeliveryItem_SalesOrderItem_ID") AS "DI_SOI"
                                            ON "SalesOrderItem"."SalesOrderItem_ID"
                                               = "DI_SOI"."DeliveryItem_SalesOrderItem_ID"
                        ORDER BY "DI_SOI"."DeliveryItem_ID") AS "DI_SOI"
                           INNER JOIN (SELECT *
                                       FROM "CTE_OGM_DI" AS "OGM_DI"
                                       ORDER BY "OGM_DI"."OutgoingMaterialDocumentItem_DeliveryItem_ID") AS "OGM_DI"
                                      ON "DI_SOI"."DeliveryItem_ID"
                                         = "OGM_DI"."OutgoingMaterialDocumentItem_DeliveryItem_ID"
                  UNION ALL
                  SELECT "INV_DI"."CustomerInvoiceItem_ID"                AS "CustomerInvoiceItem_ID",
                         "DI_SOI"."DeliveryItem_ID"                       AS "DeliveryItem_ID",
                         "DI_SOI"."DeliveryItem_SalesOrderItem_ID"        AS "SalesOrderItem_ID",
                         "OGM_SOI_ExDI"."OutgoingMaterialDocumentItem_ID" AS "OutgoingMaterialDocumentItem_ID"
                  FROM "CTE_INV_DI" AS "INV_DI"
                           INNER JOIN "CTE_DI_SOI" AS "DI_SOI"
                                      ON "INV_DI"."CustomerInvoiceItem_DeliveryItems_ID" = "DI_SOI"."DeliveryItem_ID"
                           INNER JOIN "CTE_OGM_SOI_ExDI" AS "OGM_SOI_ExDI"
                                      ON "DI_SOI"."DeliveryItem_SalesOrderItem_ID"
                                         = "OGM_SOI_ExDI"."OutgoingMaterialDocumentItem_SalesOrderItem_ID"
                           LEFT JOIN "CTE_SOI_MULTI_DEL" AS "SOI_MULTI_DEL"
                                     ON "OGM_SOI_ExDI"."OutgoingMaterialDocumentItem_SalesOrderItem_ID"
                                        = "SOI_MULTI_DEL"."SalesOrderItem_ID"
                  WHERE "SOI_MULTI_DEL"."SalesOrderItem_ID" IS NULL
                  UNION ALL
                  SELECT "INV_SOI"."CustomerInvoiceItem_ID"          AS "CustomerInvoiceItem_ID",
                         "DI_SOI"."DeliveryItem_ID"                  AS "DeliveryItem_ID",
                         "SalesOrderItem"."SalesOrderItem_ID"        AS "SalesOrderItem_ID",
                         "OGM_SOI"."OutgoingMaterialDocumentItem_ID" AS "OutgoingMaterialDocumentItem_ID"
                  FROM (SELECT *
                        FROM "CTE_INV_SOI_ExDI" AS "INV_SOI"
                        ORDER BY "INV_SOI"."CustomerInvoiceItem_SalesOrderItem_ID") AS "INV_SOI"
                           INNER JOIN "CTE_SalesOrderItem" AS "SalesOrderItem"
                                      ON "INV_SOI"."CustomerInvoiceItem_SalesOrderItem_ID"
                                         = "SalesOrderItem"."SalesOrderItem_ID"
                           INNER JOIN (SELECT *
                                       FROM "CTE_DI_SOI" AS "DI_SOI"
                                       ORDER BY "DI_SOI"."DeliveryItem_SalesOrderItem_ID") AS "DI_SOI"
                                      ON "SalesOrderItem"."SalesOrderItem_ID"
                                         = "DI_SOI"."DeliveryItem_SalesOrderItem_ID"
                           INNER JOIN (SELECT *
                                       FROM "CTE_OGM_SOI_ExDI" AS "OGM_SOI"
                                       ORDER BY "OGM_SOI"."OutgoingMaterialDocumentItem_SalesOrderItem_ID") AS "OGM_SOI"
                                      ON "SalesOrderItem"."SalesOrderItem_ID"
                                         = "OGM_SOI"."OutgoingMaterialDocumentItem_SalesOrderItem_ID"
                  UNION ALL
                  SELECT "OGM_DI_SOI"."CustomerInvoiceItem_ID"          AS "CustomerInvoiceItem_ID",
                         "OGM_DI_SOI"."DeliveryItem_ID"                 AS "DeliveryItem_ID",
                         "SalesOrderItem"."SalesOrderItem_ID"           AS "SalesOrderItem_ID",
                         "OGM_DI_SOI"."OutgoingMaterialDocumentItem_ID" AS "OutgoingMaterialDocumentItem_ID"
                  FROM (SELECT "INV_DI"."CustomerInvoiceItem_ID"              AS "CustomerInvoiceItem_ID",
                               "DI_ExSOI"."DeliveryItem_ID"                   AS "DeliveryItem_ID",
                               "OGM_DI_SOI"."OutgoingMaterialDocumentItem_ID" AS "OutgoingMaterialDocumentItem_ID",
                               "OGM_DI_SOI"."OutgoingMaterialDocumentItem_SalesOrderItem_ID"
                        FROM (SELECT *
                              FROM "CTE_INV_DI" AS "INV_DI"
                              ORDER BY "INV_DI"."CustomerInvoiceItem_DeliveryItems_ID") AS "INV_DI"
                                 INNER JOIN "CTE_DI_ExSOI" AS "DI_ExSOI"
                                            ON "INV_DI"."CustomerInvoiceItem_DeliveryItems_ID"
                                               = "DI_ExSOI"."DeliveryItem_ID"
                                 INNER JOIN (SELECT *
                                             FROM "CTE_OGM_DEL_AND_SOI" AS "OGM_DI_SOI"
                                             ORDER BY "OGM_DI_SOI"."OutgoingMaterialDocumentItem_DeliveryItem_ID") AS "OGM_DI_SOI"
                                            ON "DI_ExSOI"."DeliveryItem_ID"
                                               = "OGM_DI_SOI"."OutgoingMaterialDocumentItem_DeliveryItem_ID"
                        ORDER BY "OGM_DI_SOI"."OutgoingMaterialDocumentItem_SalesOrderItem_ID") AS "OGM_DI_SOI"
                           INNER JOIN "CTE_SalesOrderItem" AS "SalesOrderItem"
                                      ON "OGM_DI_SOI"."OutgoingMaterialDocumentItem_SalesOrderItem_ID"
                                         = "SalesOrderItem"."SalesOrderItem_ID"
                  UNION ALL
                  SELECT "INV_DI_SOI"."CustomerInvoiceItem_ID"      AS "CustomerInvoiceItem_ID",
                         "DI_ExSOI"."DeliveryItem_ID"               AS "DeliveryItem_ID",
                         "SalesOrderItem"."SalesOrderItem_ID"       AS "SalesOrderItem_ID",
                         "OGM_DI"."OutgoingMaterialDocumentItem_ID" AS "OutgoingMaterialDocumentItem_ID"
                  FROM (SELECT *
                        FROM "CTE_INV_DI_SOI" AS "INV_DI_SOI"
                        ORDER BY "INV_DI_SOI"."CustomerInvoiceItem_SalesOrderItem_ID") AS "INV_DI_SOI"
                           INNER JOIN "CTE_DI_ExSOI" AS "DI_ExSOI"
                                      ON "INV_DI_SOI"."CustomerInvoiceItem_DeliveryItems_ID"
                                         = "DI_ExSOI"."DeliveryItem_ID"
                           INNER JOIN "CTE_OGM_DI_ExSOI" AS "OGM_DI"
                                      ON "DI_ExSOI"."DeliveryItem_ID"
                                         = "OGM_DI"."OutgoingMaterialDocumentItem_DeliveryItem_ID"
                           INNER JOIN "CTE_SalesOrderItem" AS "SalesOrderItem"
                                      ON "INV_DI_SOI"."CustomerInvoiceItem_SalesOrderItem_ID"
                                         = "SalesOrderItem"."SalesOrderItem_ID"),
     "CTE_L2" AS (SELECT NULL AS "CustomerInvoiceItem_ID",
                         "DeliveryItem_ID",
                         "SalesOrderItem_ID",
                         "OutgoingMaterialDocumentItem_ID"
                  FROM (SELECT *
                        FROM (SELECT "OutgoingMaterialDocumentItem"."OutgoingMaterialDocumentItem_DeliveryItem_ID" AS "DeliveryItem_ID",
                                     "DeliveryItem"."DeliveryItem_SalesOrderItem_ID"                               AS "SalesOrderItem_ID",
                                     "OutgoingMaterialDocumentItem"."OutgoingMaterialDocumentItem_ID"              AS "OutgoingMaterialDocumentItem_ID"
                              FROM (SELECT *
                                    FROM "CTE_OutgoingMaterialDocumentItem" AS "OutgoingMaterialDocumentItem"
                                    ORDER BY "OutgoingMaterialDocumentItem"."OutgoingMaterialDocumentItem_DeliveryItem_ID") AS "OutgoingMaterialDocumentItem"
                                       INNER JOIN "CTE_DeliveryItem" AS "DeliveryItem"
                                                  ON "OutgoingMaterialDocumentItem"."OutgoingMaterialDocumentItem_DeliveryItem_ID"
                                                     = "DeliveryItem"."DeliveryItem_ID"
                              WHERE "OutgoingMaterialDocumentItem"."OutgoingMaterialDocumentItem_DeliveryItem_ID" IS NOT NULL
                                AND "DeliveryItem"."DeliveryItem_SalesOrderItem_ID" IS NOT NULL
                                AND "OutgoingMaterialDocumentItem"."OutgoingMaterialDocumentItem_ID" IS NOT NULL
                              UNION
                              SELECT "CTE_OutgoingMaterialDocumentItem"."OutgoingMaterialDocumentItem_DeliveryItem_ID"   AS "DeliveryItem_ID",
                                     "CTE_OutgoingMaterialDocumentItem"."OutgoingMaterialDocumentItem_SalesOrderItem_ID" AS "SalesOrderItem_ID",
                                     "CTE_OutgoingMaterialDocumentItem"."OutgoingMaterialDocumentItem_ID"                AS "OutgoingMaterialDocumentItem_ID"
                              FROM "CTE_OutgoingMaterialDocumentItem"
                              WHERE "CTE_OutgoingMaterialDocumentItem"."OutgoingMaterialDocumentItem_DeliveryItem_ID" IS NOT NULL
                                AND "CTE_OutgoingMaterialDocumentItem"."OutgoingMaterialDocumentItem_SalesOrderItem_ID" IS NOT NULL
                                AND "CTE_OutgoingMaterialDocumentItem"."OutgoingMaterialDocumentItem_ID" IS NOT NULL) AS "d"
                        ORDER BY 1, 2, 3) AS "d"
                  WHERE NOT EXISTS (SELECT 1
                                    FROM (SELECT "DeliveryItem_ID",
                                                 "SalesOrderItem_ID",
                                                 "OutgoingMaterialDocumentItem_ID"
                                          FROM "CTE_L3" AS "p"
                                          ORDER BY 1, 2, 3) AS "p"
                                    WHERE "d"."DeliveryItem_ID" = "p"."DeliveryItem_ID"
                                      AND "d"."SalesOrderItem_ID" = "p"."SalesOrderItem_ID"
                                      AND "d"."OutgoingMaterialDocumentItem_ID"
                                          = "p"."OutgoingMaterialDocumentItem_ID")
                  UNION ALL
                  SELECT "CustomerInvoiceItem_ID",
                         NULL AS "DeliveryItem_ID",
                         "SalesOrderItem_ID",
                         "OutgoingMaterialDocumentItem_ID"
                  FROM (SELECT "CustomerInvoiceItem"."CustomerInvoiceItem_ID"                   AS "CustomerInvoiceItem_ID",
                               "CustomerInvoiceItem"."CustomerInvoiceItem_SalesOrderItem_ID"    AS "SalesOrderItem_ID",
                               "OutgoingMaterialDocumentItem"."OutgoingMaterialDocumentItem_ID" AS "OutgoingMaterialDocumentItem_ID"
                        FROM (
                              SELECT *
                              FROM "CTE_INV_SOI_ExDI" AS "INV_SOI_ExDI"
                              ORDER BY "INV_SOI_ExDI"."CustomerInvoiceItem_SalesOrderItem_ID") AS "CustomerInvoiceItem"
                                 INNER JOIN (SELECT *
                                             FROM "CTE_OGM_SOI_ExDI"
                                             ORDER BY "CTE_OGM_SOI_ExDI"."OutgoingMaterialDocumentItem_SalesOrderItem_ID") AS "OutgoingMaterialDocumentItem"
                                            ON "CustomerInvoiceItem"."CustomerInvoiceItem_SalesOrderItem_ID"
                                               = "OutgoingMaterialDocumentItem"."OutgoingMaterialDocumentItem_SalesOrderItem_ID"
                        WHERE "CustomerInvoiceItem"."CustomerInvoiceItem_ID" IS NOT NULL
                          AND "CustomerInvoiceItem"."CustomerInvoiceItem_SalesOrderItem_ID" IS NOT NULL
                          AND "OutgoingMaterialDocumentItem"."OutgoingMaterialDocumentItem_ID" IS NOT NULL
                        ORDER BY 1, 2, 3) AS "d"
                  WHERE NOT EXISTS (SELECT 1
                                    FROM (SELECT "CustomerInvoiceItem_ID",
                                                 "SalesOrderItem_ID",
                                                 "OutgoingMaterialDocumentItem_ID"
                                          FROM "CTE_L3" AS "p"
                                          ORDER BY 1, 2, 3) AS "p"
                                    WHERE "d"."CustomerInvoiceItem_ID" = "p"."CustomerInvoiceItem_ID"
                                      AND "d"."SalesOrderItem_ID" = "p"."SalesOrderItem_ID"
                                      AND "d"."OutgoingMaterialDocumentItem_ID"
                                          = "p"."OutgoingMaterialDocumentItem_ID")
                  UNION ALL
                  SELECT "CustomerInvoiceItem_ID",
                         "DeliveryItem_ID",
                         "SalesOrderItem_ID",
                         NULL AS "OutgoingMaterialDocumentItem_ID"
                  FROM (SELECT *
                        FROM (SELECT "CustomerInvoiceItem__DeliveryItems"."CustomerInvoiceItem_ID"               AS "CustomerInvoiceItem_ID",
                                     "CustomerInvoiceItem__DeliveryItems"."CustomerInvoiceItem_DeliveryItems_ID" AS "DeliveryItem_ID",
                                     "DeliveryItem"."DeliveryItem_SalesOrderItem_ID"                             AS "SalesOrderItem_ID"
                              FROM (SELECT *
                                    FROM "CTE_CustomerInvoiceItem__DeliveryItems"
                                    ORDER BY "CTE_CustomerInvoiceItem__DeliveryItems"."CustomerInvoiceItem_DeliveryItems_ID") AS "CustomerInvoiceItem__DeliveryItems"
                                       INNER JOIN "CTE_DeliveryItem" AS "DeliveryItem"
                                                  ON "CustomerInvoiceItem__DeliveryItems"."CustomerInvoiceItem_DeliveryItems_ID"
                                                     = "DeliveryItem"."DeliveryItem_ID"
                              WHERE "CustomerInvoiceItem__DeliveryItems"."CustomerInvoiceItem_ID" IS NOT NULL
                                AND "CustomerInvoiceItem__DeliveryItems"."CustomerInvoiceItem_DeliveryItems_ID" IS NOT NULL
                                AND "DeliveryItem"."DeliveryItem_SalesOrderItem_ID" IS NOT NULL
                              UNION
                              SELECT "CustomerInvoiceItem"."CustomerInvoiceItem_ID"                AS "CustomerInvoiceItem_ID",
                                     "DeliveryItem"."DeliveryItem_ID"                              AS "DeliveryItem_ID",
                                     "CustomerInvoiceItem"."CustomerInvoiceItem_SalesOrderItem_ID" AS "SalesOrderItem_ID"
                              FROM (SELECT *
                                    FROM "CTE_INV_SOI_ExDI" AS "CustomerInvoiceItem"
                                    ORDER BY "CustomerInvoiceItem"."CustomerInvoiceItem_SalesOrderItem_ID") AS "CustomerInvoiceItem"
                                       INNER JOIN (SELECT *
                                                   FROM "CTE_DeliveryItem"
                                                   ORDER BY "CTE_DeliveryItem"."DeliveryItem_SalesOrderItem_ID") AS "DeliveryItem"
                                                  ON "CustomerInvoiceItem"."CustomerInvoiceItem_SalesOrderItem_ID"
                                                     = "DeliveryItem"."DeliveryItem_SalesOrderItem_ID"
                              WHERE "CustomerInvoiceItem"."CustomerInvoiceItem_ID" IS NOT NULL
                                AND "DeliveryItem"."DeliveryItem_ID" IS NOT NULL
                                AND "CustomerInvoiceItem"."CustomerInvoiceItem_SalesOrderItem_ID" IS NOT NULL) AS "d"
                        ORDER BY 1, 2, 3) AS "d"
                  WHERE NOT EXISTS (SELECT 1
                                    FROM (SELECT "CustomerInvoiceItem_ID",
                                                 "DeliveryItem_ID",
                                                 "SalesOrderItem_ID"
                                          FROM "CTE_L3" AS "p"
                                          ORDER BY 1, 2, 3) AS "p"
                                    WHERE "d"."CustomerInvoiceItem_ID" = "p"."CustomerInvoiceItem_ID"
                                      AND "d"."DeliveryItem_ID" = "p"."DeliveryItem_ID"
                                      AND "d"."SalesOrderItem_ID" = "p"."SalesOrderItem_ID")
                  UNION ALL
                  SELECT "CustomerInvoiceItem_ID",
                         "DeliveryItem_ID",
                         NULL AS "SalesOrderItem_ID",
                         "OutgoingMaterialDocumentItem_ID"
                  FROM (SELECT
                               "CustomerInvoiceItem__DeliveryItems"."CustomerInvoiceItem_ID"               AS "CustomerInvoiceItem_ID",
                               "CustomerInvoiceItem__DeliveryItems"."CustomerInvoiceItem_DeliveryItems_ID" AS "DeliveryItem_ID",
                               "OutgoingMaterialDocumentItem"."OutgoingMaterialDocumentItem_ID"            AS "OutgoingMaterialDocumentItem_ID"
                        FROM (SELECT *
                              FROM "CTE_CustomerInvoiceItem__DeliveryItems"
                              ORDER BY "CTE_CustomerInvoiceItem__DeliveryItems"."CustomerInvoiceItem_DeliveryItems_ID") AS "CustomerInvoiceItem__DeliveryItems"
                                 INNER JOIN (SELECT *
                                             FROM "CTE_OutgoingMaterialDocumentItem"
                                             ORDER BY "CTE_OutgoingMaterialDocumentItem"."OutgoingMaterialDocumentItem_DeliveryItem_ID") AS "OutgoingMaterialDocumentItem"
                                            ON "CustomerInvoiceItem__DeliveryItems"."CustomerInvoiceItem_DeliveryItems_ID"
                                               = "OutgoingMaterialDocumentItem"."OutgoingMaterialDocumentItem_DeliveryItem_ID"
                        WHERE "CustomerInvoiceItem__DeliveryItems"."CustomerInvoiceItem_ID" IS NOT NULL
                          AND "CustomerInvoiceItem__DeliveryItems"."CustomerInvoiceItem_DeliveryItems_ID" IS NOT NULL
                          AND "OutgoingMaterialDocumentItem"."OutgoingMaterialDocumentItem_ID" IS NOT NULL
                        ORDER BY 1, 2, 3) AS "d"
                  WHERE NOT EXISTS (SELECT 1
                                    FROM (SELECT "CustomerInvoiceItem_ID",
                                                 "DeliveryItem_ID",
                                                 "OutgoingMaterialDocumentItem_ID"
                                          FROM "CTE_L3" AS "p"
                                          ORDER BY 1, 2, 3) AS "p"
                                    WHERE "d"."CustomerInvoiceItem_ID" = "p"."CustomerInvoiceItem_ID"
                                      AND "d"."DeliveryItem_ID" = "p"."DeliveryItem_ID"
                                      AND "d"."OutgoingMaterialDocumentItem_ID"
                                          = "p"."OutgoingMaterialDocumentItem_ID")),
     "CTE_L1" AS (SELECT "CTE_L3".*
                  FROM "CTE_L3"
                  UNION ALL
                  SELECT *
                  FROM "CTE_L2"
                  UNION ALL
                  SELECT "CustomerInvoiceItem_ID" AS "CustomerInvoiceItem_ID",
                         "DeliveryItem_ID"        AS "DeliveryItem_ID",
                         NULL                     AS "SalesOrderItem_ID",
                         NULL                     AS "OutgoingMaterialDocumentItem_ID"
                  FROM (SELECT "CustomerInvoiceItem_ID",
                               "CustomerInvoiceItem_DeliveryItems_ID" AS "DeliveryItem_ID"
                        FROM "CTE_CustomerInvoiceItem__DeliveryItems"
                        WHERE "CustomerInvoiceItem_ID" IS NOT NULL
                          AND "CustomerInvoiceItem_DeliveryItems_ID" IS NOT NULL
                        ORDER BY 1, 2) AS "q"
                  WHERE NOT EXISTS (SELECT 1
                                    FROM (SELECT "CustomerInvoiceItem_ID",
                                                 "DeliveryItem_ID"
                                          FROM "CTE_L3"
                                          WHERE "CustomerInvoiceItem_ID" IS NOT NULL
                                            AND "DeliveryItem_ID" IS NOT NULL
                                          ORDER BY 1, 2) AS "p"
                                    WHERE "q"."CustomerInvoiceItem_ID" = "p"."CustomerInvoiceItem_ID"
                                      AND "q"."DeliveryItem_ID" = "p"."DeliveryItem_ID")
                    AND NOT EXISTS (SELECT 1
                                    FROM (SELECT "CustomerInvoiceItem_ID",
                                                 "DeliveryItem_ID"
                                          FROM "CTE_L2"
                                          WHERE "CustomerInvoiceItem_ID" IS NOT NULL
                                            AND "DeliveryItem_ID" IS NOT NULL
                                          ORDER BY 1, 2) AS "p"
                                    WHERE "q"."CustomerInvoiceItem_ID" = "p"."CustomerInvoiceItem_ID"
                                      AND "q"."DeliveryItem_ID" = "p"."DeliveryItem_ID")
                  UNION ALL
                  SELECT "CustomerInvoiceItem_ID" AS "CustomerInvoiceItem_ID",
                         NULL                     AS "DeliveryItem_ID",
                         "SalesOrderItem_ID"      AS "SalesOrderItem_ID",
                         NULL                     AS "OutgoingMaterialDocumentItem_ID"
                  FROM (SELECT "CustomerInvoiceItem_ID",
                               "CustomerInvoiceItem_SalesOrderItem_ID" AS "SalesOrderItem_ID"
                        FROM "CTE_CustomerInvoiceItem"
                        WHERE "CustomerInvoiceItem_ID" IS NOT NULL
                          AND "CustomerInvoiceItem_SalesOrderItem_ID" IS NOT NULL
                        ORDER BY 1, 2) AS "q"
                  WHERE NOT EXISTS (SELECT 1
                                    FROM (SELECT "CustomerInvoiceItem_ID",
                                                 "SalesOrderItem_ID"
                                          FROM "CTE_L3"
                                          WHERE "CustomerInvoiceItem_ID" IS NOT NULL
                                            AND "SalesOrderItem_ID" IS NOT NULL
                                          ORDER BY 1, 2) AS "p"
                                    WHERE "q"."CustomerInvoiceItem_ID" = "p"."CustomerInvoiceItem_ID"
                                      AND "q"."SalesOrderItem_ID" = "p"."SalesOrderItem_ID")
                    AND NOT EXISTS (SELECT 1
                                    FROM (SELECT "CustomerInvoiceItem_ID",
                                                 "SalesOrderItem_ID"
                                          FROM "CTE_L2"
                                          WHERE "CustomerInvoiceItem_ID" IS NOT NULL
                                            AND "SalesOrderItem_ID" IS NOT NULL
                                          ORDER BY 1, 2) AS "p"
                                    WHERE "q"."CustomerInvoiceItem_ID" = "p"."CustomerInvoiceItem_ID"
                                      AND "q"."SalesOrderItem_ID" = "p"."SalesOrderItem_ID")
                  UNION ALL
                  SELECT NULL                AS "CustomerInvoiceItem_ID",
                         "DeliveryItem_ID"   AS "DeliveryItem_ID",
                         "SalesOrderItem_ID" AS "SalesOrderItem_ID",
                         NULL                AS "OutgoingMaterialDocumentItem_ID"
                  FROM (SELECT "DeliveryItem_ID",
                               "DeliveryItem_SalesOrderItem_ID" AS "SalesOrderItem_ID"
                        FROM "CTE_DeliveryItem"
                        WHERE "DeliveryItem_ID" IS NOT NULL
                          AND "DeliveryItem_SalesOrderItem_ID" IS NOT NULL
                        ORDER BY 1, 2) AS "q"
                  WHERE NOT EXISTS (SELECT 1
                                    FROM (SELECT "DeliveryItem_ID",
                                                 "SalesOrderItem_ID"
                                          FROM "CTE_L3"
                                          WHERE "DeliveryItem_ID" IS NOT NULL
                                            AND "SalesOrderItem_ID" IS NOT NULL
                                          ORDER BY 1, 2) AS "p"
                                    WHERE "q"."DeliveryItem_ID" = "p"."DeliveryItem_ID"
                                      AND "q"."SalesOrderItem_ID" = "p"."SalesOrderItem_ID")
                    AND NOT EXISTS (SELECT 1
                                    FROM (SELECT "DeliveryItem_ID",
                                                 "SalesOrderItem_ID"
                                          FROM "CTE_L2"
                                          WHERE "DeliveryItem_ID" IS NOT NULL
                                            AND "SalesOrderItem_ID" IS NOT NULL
                                          ORDER BY 1, 2) AS "p"
                                    WHERE "q"."DeliveryItem_ID" = "p"."DeliveryItem_ID"
                                      AND "q"."SalesOrderItem_ID" = "p"."SalesOrderItem_ID")
                  UNION ALL
                  SELECT NULL                              AS "CustomerInvoiceItem_ID",
                         "DeliveryItem_ID"                 AS "DeliveryItem_ID",
                         NULL                              AS "SalesOrderItem_ID",
                         "OutgoingMaterialDocumentItem_ID" AS "OutgoingMaterialDocumentItem_ID"
                  FROM (SELECT "OutgoingMaterialDocumentItem_ID",
                               "OutgoingMaterialDocumentItem_DeliveryItem_ID" AS "DeliveryItem_ID"
                        FROM "CTE_OutgoingMaterialDocumentItem"
                        WHERE "OutgoingMaterialDocumentItem_ID" IS NOT NULL
                          AND "OutgoingMaterialDocumentItem_DeliveryItem_ID" IS NOT NULL
                          AND "OutgoingMaterialDocumentItem_SalesOrderItem_ID" IS NULL
                        ORDER BY 1, 2) AS "q"
                  WHERE NOT EXISTS (SELECT 1
                                    FROM (SELECT "OutgoingMaterialDocumentItem_ID",
                                                 "DeliveryItem_ID"
                                          FROM "CTE_L3"
                                          WHERE "OutgoingMaterialDocumentItem_ID" IS NOT NULL
                                            AND "DeliveryItem_ID" IS NOT NULL
                                          ORDER BY 1, 2) AS "p"
                                    WHERE "q"."OutgoingMaterialDocumentItem_ID"
                                          = "p"."OutgoingMaterialDocumentItem_ID"
                                      AND "q"."DeliveryItem_ID" = "p"."DeliveryItem_ID")
                    AND NOT EXISTS (SELECT 1
                                    FROM (SELECT "OutgoingMaterialDocumentItem_ID",
                                                 "DeliveryItem_ID"
                                          FROM "CTE_L2"
                                          WHERE "OutgoingMaterialDocumentItem_ID" IS NOT NULL
                                            AND "DeliveryItem_ID" IS NOT NULL
                                          ORDER BY 1, 2) AS "p"
                                    WHERE "q"."OutgoingMaterialDocumentItem_ID"
                                          = "p"."OutgoingMaterialDocumentItem_ID"
                                      AND "q"."DeliveryItem_ID" = "p"."DeliveryItem_ID")
                  UNION ALL
                  SELECT NULL                              AS "CustomerInvoiceItem_ID",
                         NULL                              AS "DeliveryItem_ID",
                         "SalesOrderItem_ID"               AS "SalesOrderItem_ID",
                         "OutgoingMaterialDocumentItem_ID" AS "OutgoingMaterialDocumentItem_ID"
                  FROM (SELECT "OutgoingMaterialDocumentItem_ID",
                               "OutgoingMaterialDocumentItem_SalesOrderItem_ID" AS "SalesOrderItem_ID"
                        FROM "CTE_OutgoingMaterialDocumentItem"
                        WHERE "OutgoingMaterialDocumentItem_ID" IS NOT NULL
                          AND "OutgoingMaterialDocumentItem_SalesOrderItem_ID" IS NOT NULL
                          AND "OutgoingMaterialDocumentItem_DeliveryItem_ID" IS NULL
                        ORDER BY 1, 2) AS "q"
                  WHERE NOT EXISTS (SELECT 1
                                    FROM (SELECT "OutgoingMaterialDocumentItem_ID",
                                                 "SalesOrderItem_ID"
                                          FROM "CTE_L3"
                                          WHERE "OutgoingMaterialDocumentItem_ID" IS NOT NULL
                                            AND "SalesOrderItem_ID" IS NOT NULL
                                          ORDER BY 1, 2) AS "p"
                                    WHERE "q"."OutgoingMaterialDocumentItem_ID"
                                          = "p"."OutgoingMaterialDocumentItem_ID"
                                      AND "q"."SalesOrderItem_ID" = "p"."SalesOrderItem_ID")
                    AND NOT EXISTS (SELECT 1
                                    FROM (SELECT "OutgoingMaterialDocumentItem_ID",
                                                 "SalesOrderItem_ID"
                                          FROM "CTE_L2"
                                          WHERE "OutgoingMaterialDocumentItem_ID" IS NOT NULL
                                            AND "SalesOrderItem_ID" IS NOT NULL
                                          ORDER BY 1, 2) AS "p"
                                    WHERE "q"."OutgoingMaterialDocumentItem_ID"
                                          = "p"."OutgoingMaterialDocumentItem_ID"
                                      AND "q"."SalesOrderItem_ID" = "p"."SalesOrderItem_ID"))
SELECT CAST(DENSE_RANK()
            OVER (ORDER BY "t"."SalesOrderItem_ID", "t"."DeliveryItem_ID",
                "t"."OutgoingMaterialDocumentItem_ID", "t"."CustomerInvoiceItem_ID") AS VARCHAR(10)) AS "ID",
       "t"."CustomerInvoiceItem_ID"                                                                  AS "CustomerInvoiceItem",
       "t"."DeliveryItem_ID"                                                                         AS "DeliveryItem",
       "t"."OutgoingMaterialDocumentItem_ID"                                                         AS "OutgoingMaterialDocumentItem",
       "t"."SalesOrderItem_ID"                                                                       AS "SalesOrderItem"
                        
FROM "CTE_L1" AS "t"
