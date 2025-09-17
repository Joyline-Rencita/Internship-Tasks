					***************************		CTE_Block		*******************************

WITH "CTE_JoinTable" AS (SELECT "CDPOS"."TABKEY"                       AS "JoinID",
                               CAST("CDHDR"."UDATE" AS DATE)
                                            + COALESCE(CAST(TIMESTAMPDIFF(SECOND, CAST("CDHDR"."UTIME" AS DATE), "CDHDR"."UTIME") AS INTERVAL SECOND),
                                            INTERVAL '86399' SECOND)   AS "JoinTime",
                               "CDHDR"."UDATE"                         AS "UDATE",
                               "CDHDR"."UTIME"                         AS "UTIME",
                               "CDPOS"."FNAME"                         AS "FNAME",
                               "CDPOS"."TABNAME"                       AS "TABNAME",
                               "CDPOS"."VALUE_NEW"                     AS "VALUE_NEW",
                               "CDPOS"."VALUE_OLD"                     AS "VALUE_OLD",
                               "CDHDR"."MANDANT" || "CDHDR"."USERNAME" AS "JoinUserID",
                               CASE
                                   WHEN "USR02"."USTYP" IN ('B', 'C')
                                       THEN 'Automatic'
                                   ELSE 'Manual'
                               END                                     AS "JoinExecutionType",
                               "CDHDR"."TCODE"                         AS "JoinOperationType",
                               "CDHDR"."CHANGENR"                      AS "JoinSystemNumber",
                               "CDPOS"."OBJECTCLAS"                    AS "OBJECTCLAS"
                        FROM "CDPOS" AS "CDPOS"
                             INNER JOIN "CDHDR" AS "CDHDR"
                                        ON "CDPOS"."MANDANT" = "CDHDR"."MANDANT"
                                            AND "CDPOS"."OBJECTCLAS" = "CDHDR"."OBJECTCLAS"
                                            AND "CDPOS"."OBJECTID" = "CDHDR"."OBJECTID"
                                            AND "CDPOS"."CHANGENR" = "CDHDR"."CHANGENR"
                                            AND "CDPOS"."CHNGIND" = 'U'
                                            AND "CDPOS"."TABNAME" = 'KNA1'
                                            AND "CDPOS"."FNAME" IN ('FAKSD', 'LIFSD')
                             LEFT JOIN "USR02" AS "USR02"
                                       ON "CDHDR"."MANDANT" = "USR02"."MANDT"
                                           AND "CDHDR"."USERNAME" = "USR02"."BNAME"),
    "CTE_Releases" AS (SELECT "JoinTable"."JoinID"                                                                                                    AS "ReleasesID",
                              "JoinTable"."JoinTime"                                                                                                  AS "ReleaseTime",
                              CASE
                                  WHEN "JoinTable"."FNAME" = 'FAKSD'
                                      THEN 'BillingBlock'
                                  WHEN "JoinTable"."FNAME" = 'LIFSD'
                                      THEN 'DeliveryBlock'
                              END                                                                                                                     AS "ReleaseType",
                              'Block to ' || "JoinTable"."VALUE_NEW"                                                                                  AS "ValueType",
                              "JoinTable"."VALUE_NEW"                                                                                                 AS "VALUE_NEW",
                              "JoinTable"."VALUE_OLD"                                                                                                 AS "VALUE_OLD",
                              "JoinTable"."JoinUserID"                                                                                                AS "ReleasedBy_ID",
                              "JoinTable"."JoinExecutionType"                                                                                         AS "ReleaseExecutionType",
                              "JoinTable"."JoinOperationType"                                                                                         AS "ReleaseOperationType",
                              "JoinTable"."JoinSystemNumber"                                                                                          AS "SystemReleaseNumber",
                              "JoinTable"."JoinID"                                                                                                    AS "CustomerID",
                              ROW_NUMBER()
                              OVER (PARTITION BY "JoinTable"."JoinID", "JoinTable"."FNAME" ORDER BY "JoinTable"."UDATE" ASC, "JoinTable"."UTIME" ASC) AS "ReleaseRN"
                       FROM "CTE_JoinTable" AS "JoinTable"
                       WHERE "JoinTable"."VALUE_OLD" IS NOT NULL
                         AND "JoinTable"."VALUE_NEW" IS NULL),
    "CTE_Changes" AS (SELECT "JoinTable"."JoinID"                   AS "ID",
                             "JoinTable"."JoinTime"                 AS "ChangeTime",
                             CASE
                                 WHEN "JoinTable"."FNAME" = 'FAKSD'
                                     THEN 'BillingBlock'
                                 WHEN "JoinTable"."FNAME" = 'LIFSD'
                                     THEN 'DeliveryBlock'
                             END                                    AS "ChangeType",
                             'Block to ' || "JoinTable"."VALUE_NEW" AS "ValueType",
                             "JoinTable"."VALUE_NEW"                AS "VALUE_NEW",
                             "JoinTable"."VALUE_OLD"                AS "VALUE_OLD",
                             "JoinTable"."JoinUserID"               AS "ChangeBy",
                             "JoinTable"."JoinExecutionType"        AS "ChangeExecutionType",
                             "JoinTable"."JoinOperationType"        AS "ChangeOperationType",
                             "JoinTable"."JoinSystemNumber"         AS "ChangeID",
                             "JoinTable"."JoinID"                   AS "CustomerID"
                      FROM "CTE_JoinTable" AS "JoinTable"
                      WHERE "JoinTable"."VALUE_OLD" IS NOT NULL
                        AND "JoinTable"."VALUE_NEW" IS NOT NULL),
    "CTE_BlockFromChangelog" AS (SELECT "JoinTable"."JoinID"                   AS "BlockID",
                                        "JoinTable"."JoinTime"                 AS "BlockTime",
                                        CASE
                                            WHEN "JoinTable"."FNAME" = 'FAKSD'
                                                THEN 'BillingBlock'
                                            WHEN "JoinTable"."FNAME" = 'LIFSD'
                                                THEN 'DeliveryBlock'
                                        END                                    AS "BlockType",
                                        'Block to ' || "JoinTable"."VALUE_NEW" AS "ValueType",
                                        "JoinTable"."VALUE_NEW"                AS "VALUE_NEW",
                                        "JoinTable"."VALUE_OLD"                AS "VALUE_OLD",
                                        "JoinTable"."JoinUserID"               AS "BlockedBy",
                                        "JoinTable"."JoinExecutionType"        AS "BlockExecutionType",
                                        "JoinTable"."JoinOperationType"        AS "BlockOperationType",
                                        "JoinTable"."JoinSystemNumber"         AS "SystemBlockNumber",
                                        "JoinTable"."JoinID"                   AS "CustomerID"
                                 FROM "CTE_JoinTable" AS "JoinTable"
                                 WHERE "JoinTable"."VALUE_OLD" IS NULL
                                   AND "JoinTable"."VALUE_NEW" IS NOT NULL),
    "CTE_ImplicitActiveBlock" AS (SELECT "KNA1"."MANDT" || "KNA1"."KUNNR" AS "BlockID",
                                         CAST("KNA1"."ERDAT" AS DATE)     AS "BlockTime",
                                         'BillingBlock'                   AS "BlockType",
                                         'Block to ' || "KNA1"."FAKSD"    AS "ValueType",
                                         "KNA1"."FAKSD"                   AS "VALUE_NEW",
                                         NULL                             AS "VALUE_OLD",
                                         "KNA1"."MANDT" || "KNA1"."ERNAM" AS "BlockedBy",
                                         CASE
                                             WHEN "USR02"."USTYP" IN ('B', 'C')
                                                 THEN 'Automatic'
                                             ELSE 'Manual'
                                         END                              AS "BlockExecutionType",
                                         NULL                             AS "BlockOperationType",
                                         '-1'                             AS "SystemBlockNumber",
                                         "KNA1"."MANDT" || "KNA1"."KUNNR" AS "CustomerID"
                                  FROM "KNA1" AS "KNA1"
                                       LEFT JOIN "CTE_BlockFromChangelog" AS "Block"
                                                 ON "Block"."BlockID" = "KNA1"."MANDT" || "KNA1"."KUNNR"
                                                     AND "Block"."BlockType" = 'BillingBlock'
                                       LEFT JOIN "CTE_Releases" AS "Releases"
                                                 ON "Releases"."ReleasesID" = "KNA1"."MANDT" || "KNA1"."KUNNR"
                                                     AND "Releases"."ReleaseType" = 'BillingBlock'
                                       LEFT JOIN "CTE_Changes" AS "Changes"
                                                 ON "Changes"."ID" = "KNA1"."MANDT" || "KNA1"."KUNNR"
                                                     AND "Changes"."ChangeType" = 'BillingBlock'
                                       LEFT JOIN "USR02" AS "USR02"
                                                 ON "KNA1"."MANDT" = "USR02"."MANDT"
                                                     AND "KNA1"."ERNAM" = "USR02"."BNAME"
                                  WHERE "Block"."BlockID" IS NULL
                                    AND "Changes"."ID" IS NULL
                                    AND "Releases"."ReleasesID" IS NULL
                                    AND "KNA1"."FAKSD" IS NOT NULL
                                  UNION
                                  SELECT "KNA1"."MANDT" || "KNA1"."KUNNR" AS "BlockID",
                                         CAST("KNA1"."ERDAT" AS DATE)     AS "BlockTime",
                                         'DeliveryBlock'                  AS "BlockType",
                                         'Block to ' || "KNA1"."LIFSD"    AS "ValueType",
                                         "KNA1"."LIFSD"                   AS "VALUE_NEW",
                                         NULL                             AS "VALUE_OLD",
                                         "KNA1"."MANDT" || "KNA1"."ERNAM" AS "BlockedBy",
                                         CASE
                                             WHEN "USR02"."USTYP" IN ('B', 'C')
                                                 THEN 'Automatic'
                                             ELSE 'Manual'
                                         END                              AS "BlockExecutionType",
                                         NULL                             AS "BlockOperationType",
                                         '-1'                             AS "SystemBlockNumber",
                                         "KNA1"."MANDT" || "KNA1"."KUNNR" AS "CustomerID"
                                  FROM "KNA1" AS "KNA1"
                                       LEFT JOIN "CTE_BlockFromChangelog" AS "Block"
                                                 ON "Block"."BlockID" = "KNA1"."MANDT" || "KNA1"."KUNNR"
                                                     AND "Block"."BlockType" = 'DeliveryBlock'
                                       LEFT JOIN "CTE_Releases" AS "Releases"
                                                 ON "Releases"."ReleasesID" = "KNA1"."MANDT" || "KNA1"."KUNNR"
                                                     AND "Releases"."ReleaseType" = 'DeliveryBlock'
                                       LEFT JOIN "CTE_Changes" AS "Changes"
                                                 ON "Changes"."ID" = "KNA1"."MANDT" || "KNA1"."KUNNR"
                                                     AND "Changes"."ChangeType" = 'DeliveryBlock'
                                       LEFT JOIN "USR02" AS "USR02"
                                                 ON "KNA1"."MANDT" = "USR02"."MANDT"
                                                     AND "KNA1"."ERNAM" = "USR02"."BNAME"
                                  WHERE "Block"."BlockID" IS NULL
                                    AND "Changes"."ID" IS NULL
                                    AND "Releases"."ReleasesID" IS NULL
                                    AND "KNA1"."LIFSD" IS NOT NULL),
    "CTE_FirstAction" AS (SELECT "JoinTable"."JoinID"        AS "BlockID",
                                 MIN("JoinTable"."JoinTime") AS "BlockTime",
                                 CASE
                                     WHEN "JoinTable"."FNAME" = 'FAKSD'
                                         THEN 'BillingBlock'
                                     WHEN "JoinTable"."FNAME" = 'LIFSD'
                                         THEN 'DeliveryBlock'
                                 END                         AS "BlockType"
                          FROM "CTE_JoinTable" AS "JoinTable"
                          GROUP BY "JoinTable"."JoinID", "JoinTable"."FNAME"),
    "CTE_ImplicitInactiveBlock" AS (SELECT "FirstAction"."BlockID"                                 AS "BlockID",
                                           CAST("KNA1"."ERDAT" AS DATE)                            AS "BlockTime",
                                           "FirstAction"."BlockType"                               AS "BlockType",
                                           'Block to '
                                               ||
                                           COALESCE("Changes"."VALUE_OLD", "Releases"."VALUE_OLD") AS "ValueType",
                                           COALESCE("Changes"."VALUE_OLD", "Releases"."VALUE_OLD") AS "VALUE_NEW",
                                           NULL                                                    AS "VALUE_OLD",
                                           "KNA1"."MANDT" || "KNA1"."ERNAM"                        AS "BlockedBy",
                                           CASE
                                               WHEN "USR02"."USTYP" IN ('B', 'C')
                                                   THEN 'Automatic'
                                               ELSE 'Manual'
                                           END                                                     AS "BlockExecutionType",
                                           NULL                                                    AS "BlockOperationType",
                                           '-1'                                                    AS "SystemBlockNumber",
                                           "KNA1"."MANDT" || "KNA1"."KUNNR"                        AS "CustomerID"
                                    FROM "CTE_FirstAction" AS "FirstAction"
                                         LEFT JOIN "CTE_Changes" AS "Changes"
                                                   ON "FirstAction"."BlockID" = "Changes"."ID"
                                                       AND "FirstAction"."BlockTime" = "Changes"."ChangeTime"
                                                       AND "FirstAction"."BlockType" = "Changes"."ChangeType"
                                         LEFT JOIN "CTE_Releases" AS "Releases"
                                                   ON "FirstAction"."BlockID" = "Releases"."ReleasesID"
                                                       AND "FirstAction"."BlockTime" = "Releases"."ReleaseTime"
                                                       AND "FirstAction"."BlockType" = "Releases"."ReleaseType"
                                         LEFT JOIN "KNA1" AS "KNA1"
                                                   ON "FirstAction"."BlockID" = "KNA1"."MANDT" || "KNA1"."KUNNR"
                                                       AND "FirstAction"."BlockType" IN
                                                           ('BillingBlock', 'DeliveryBlock')
                                         LEFT JOIN "USR02" AS "USR02"
                                                   ON "KNA1"."MANDT" = "USR02"."MANDT"
                                                       AND "KNA1"."ERNAM" = "USR02"."BNAME"
                                    WHERE ("Changes"."ID" IS NOT NULL
                                        OR "Releases"."ReleasesID" IS NOT NULL)),
    "CTE_ImplicitDuplicates" AS (
        SELECT "Inactive"."BlockID", "Inactive"."BlockTime", "Inactive"."BlockType"
        FROM "CTE_ImplicitInactiveBlock" AS "Inactive"
             LEFT JOIN "CTE_ImplicitActiveBlock" AS "Active"
                       ON "Inactive"."BlockID" = "Active"."BlockID"
                           AND "Inactive"."BlockTime" = "Active"."BlockTime"
                           AND "Inactive"."BlockType" = "Active"."BlockType"
        WHERE "Active"."BlockID" IS NOT NULL),
    "CTE_ImplicitActiveBlockNoDuplicates" AS (SELECT "Active".*
                                              FROM "CTE_ImplicitActiveBlock" AS "Active"
                                                   LEFT JOIN "CTE_ImplicitDuplicates" AS "Duplicates"
                                                             ON "Active"."BlockID" = "Duplicates"."BlockID"
                                                                 AND "Active"."BlockTime" = "Duplicates"."BlockTime"
                                                                 AND "Active"."BlockType" = "Duplicates"."BlockType"
                                              WHERE "Duplicates"."BlockID" IS NULL),
    "CTE_BlockNoRN"
        AS (SELECT "ImplicitActiveBlockNoDuplicates"."BlockID"            AS "BlockID",
                   "ImplicitActiveBlockNoDuplicates"."BlockTime"          AS "BlockTime",
                   "ImplicitActiveBlockNoDuplicates"."BlockType"          AS "BlockType",
                   "ImplicitActiveBlockNoDuplicates"."ValueType"          AS "ValueType",
                   "ImplicitActiveBlockNoDuplicates"."VALUE_NEW"          AS "VALUE_NEW",
                   "ImplicitActiveBlockNoDuplicates"."VALUE_OLD"          AS "VALUE_OLD",
                   "ImplicitActiveBlockNoDuplicates"."BlockedBy"          AS "BlockedBy",
                   "ImplicitActiveBlockNoDuplicates"."BlockExecutionType" AS "BlockExecutionType",
                   "ImplicitActiveBlockNoDuplicates"."BlockOperationType" AS "BlockOperationType",
                   "ImplicitActiveBlockNoDuplicates"."SystemBlockNumber"  AS "SystemBlockNumber",
                   "ImplicitActiveBlockNoDuplicates"."CustomerID"         AS "CustomerID"
            FROM "CTE_ImplicitActiveBlockNoDuplicates" AS "ImplicitActiveBlockNoDuplicates"
            UNION
            SELECT "ImplicitInactiveBlock"."BlockID"            AS "BlockID",
                   "ImplicitInactiveBlock"."BlockTime"          AS "BlockTime",
                   "ImplicitInactiveBlock"."BlockType"          AS "BlockType",
                   "ImplicitInactiveBlock"."ValueType"          AS "ValueType",
                   "ImplicitInactiveBlock"."VALUE_NEW"          AS "VALUE_NEW",
                   "ImplicitInactiveBlock"."VALUE_OLD"          AS "VALUE_OLD",
                   "ImplicitInactiveBlock"."BlockedBy"          AS "BlockedBy",
                   "ImplicitInactiveBlock"."BlockExecutionType" AS "BlockExecutionType",
                   "ImplicitInactiveBlock"."BlockOperationType" AS "BlockOperationType",
                   "ImplicitInactiveBlock"."SystemBlockNumber"  AS "SystemBlockNumber",
                   "ImplicitInactiveBlock"."CustomerID"         AS "CustomerID"
            FROM "CTE_ImplicitInactiveBlock" AS "ImplicitInactiveBlock"
            UNION
            SELECT "CTE_BlockFromChangelog"."BlockID"            AS "BlockID",
                   "CTE_BlockFromChangelog"."BlockTime"          AS "BlockTime",
                   "CTE_BlockFromChangelog"."BlockType"          AS "BlockType",
                   "CTE_BlockFromChangelog"."ValueType"          AS "ValueType",
                   "CTE_BlockFromChangelog"."VALUE_NEW"          AS "VALUE_NEW",
                   "CTE_BlockFromChangelog"."VALUE_OLD"          AS "VALUE_OLD",
                   "CTE_BlockFromChangelog"."BlockedBy"          AS "BlockedBy",
                   "CTE_BlockFromChangelog"."BlockExecutionType" AS "BlockExecutionType",
                   "CTE_BlockFromChangelog"."BlockOperationType" AS "BlockOperationType",
                   "CTE_BlockFromChangelog"."SystemBlockNumber"  AS "SystemBlockNumber",
                   "CTE_BlockFromChangelog"."CustomerID"         AS "CustomerID"
            FROM "CTE_BlockFromChangelog"),
    "CTE_Block" AS (SELECT *,
                           ROW_NUMBER()
                           OVER (PARTITION BY "CTE_BlockNoRN"."BlockID", "CTE_BlockNoRN"."BlockType" ORDER BY "CTE_BlockNoRN"."BlockTime" ASC) AS "BlockRN"
                    FROM "CTE_BlockNoRN")
SELECT <%=sourceSystem%>  || 'CustomerBlock_' || "Block"."BlockID" || '_' || "Block"."SystemBlockNumber" || '_'
           || "Block"."BlockType"                              AS "ID",
       "Block"."BlockTime"                                     AS "CreationTime",
       COALESCE("Block"."BlockType", "Releases"."ReleaseType") AS "BlockType",
       "Block"."VALUE_NEW"                                     AS "FirstBlockReason",
       CASE
           WHEN "Releases"."ReleaseType" IS NOT NULL
               THEN "Releases"."VALUE_NEW"
           WHEN "Block"."BlockType" = 'BillingBlock'
               THEN COALESCE("KNA1"."FAKSD", 'Data cut - no entry in KNA1')
           WHEN "Block"."BlockType" = 'DeliveryBlock'
               THEN COALESCE("KNA1"."LIFSD", 'Data cut - no entry in KNA1')
       END                                                     AS "LatestBlockReason",
       CASE
           WHEN "Releases"."ReleaseType" IS NOT NULL
               THEN "Releases"."VALUE_NEW"
           WHEN "Block"."BlockType" = 'BillingBlock'
               THEN "TVFST"."VTEXT"
           WHEN "Block"."BlockType" = 'DeliveryBlock'
               THEN "TVLST"."VTEXT"
       END                                                     AS "LatestBlockReasonText",
	<%=sourceSystem%>  || 'User_' || "Block"."BlockedBy"          AS "BlockedBy",
       "Block"."BlockExecutionType"                            AS "BlockExecutionType",
       "Releases"."ReleaseTime"                                AS "ReleaseTime",
       "Releases"."ReleaseType"                                AS "ReleaseType",
       "Releases"."VALUE_OLD"                                  AS "ReleaseReason",
	<%=sourceSystem%>  || 'User_' || "Releases"."ReleasedBy_ID"   AS "ReleasedBy",
       "Releases"."ReleaseExecutionType"                       AS "ReleaseExecutionType",
	<%=sourceSystem%>  || 'Customer_' || "Block"."CustomerID"     AS "Customer",
       'SAP'                                                   AS "SourceSystemType"
FROM "CTE_Block" AS "Block"
     LEFT JOIN "CTE_Releases" AS "Releases"
               ON "Block"."BlockID" = "Releases"."ReleasesID"
                   AND "Block"."BlockRN" = "Releases"."ReleaseRN"
                   AND "Block"."BlockType" = "Releases"."ReleaseType"
     LEFT JOIN "KNA1" AS "KNA1"
               ON "Block"."BlockID" = "KNA1"."MANDT" || "KNA1"."KUNNR"
                   AND ("KNA1"."FAKSD" IS NOT NULL
                       OR "KNA1"."LIFSD" IS NOT NULL)
     LEFT JOIN "TVLST" AS "TVLST"
               ON "KNA1"."MANDT" = "TVLST"."MANDT"
                   AND "KNA1"."LIFSD" = "TVLST"."LIFSP"
                   AND "TVLST"."SPRAS" = <%=LanguageKey%> 
     LEFT JOIN "TVFST" AS "TVFST"
               ON "KNA1"."MANDT" = "TVFST"."MANDT"
                   AND "KNA1"."FAKSD" = "TVFST"."FAKSP"
                   AND "TVFST"."SPRAS" = <%=LanguageKey%> 
