                **************************   CTE_BLOCK   *****************************

WITH "CTE_BSEG_PRE"
         AS (SELECT "BSEG"."MANDT" || "BSEG"."BUKRS" || "BSEG"."BELNR" || "BSEG"."GJAHR" || "BSEG"."BUZEI" AS "TABKEY",
                    "KOART",
                    "SHKZG",
                    "ZLSPR"
             FROM "BSEG"
             WHERE "BSEG"."ZLSPR" IS NOT NULL
             ORDER BY "TABKEY"),
     "CTE_JoinTable" AS (SELECT "CDPOS"."TABKEY"                        AS "JoinID",
                                CAST("CDHDR"."UDATE" AS DATE)
                                            + COALESCE(CAST(TIMESTAMPDIFF(SECOND, CAST("CDHDR"."UTIME" AS DATE), "CDHDR"."UTIME") AS INTERVAL SECOND),
                                            INTERVAL '86399' SECOND)    AS "JoinTime",
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
                                    END                                 AS "JoinExecutionType",
                                "CDHDR"."TCODE"                         AS "JoinOperationType",
                                "CDHDR"."CHANGENR"                      AS "JoinSystemNumber",
                                "CDPOS"."OBJECTCLAS"                    AS "OBJECTCLAS"
                         FROM "CDPOS" AS "CDPOS"
                                  INNER JOIN "CDHDR" AS "CDHDR"
                                             ON "CDPOS"."MANDANT" = "CDHDR"."MANDANT"
                                                 AND "CDPOS"."OBJECTCLAS" = "CDHDR"."OBJECTCLAS"
                                                 AND "CDPOS"."OBJECTID" = "CDHDR"."OBJECTID"
                                                 AND "CDPOS"."CHANGENR" = "CDHDR"."CHANGENR"
                                                 AND "CDPOS"."OBJECTCLAS" = 'BELEG'
                                                 AND "CDPOS"."CHNGIND" = 'U'
                                                 AND "CDPOS"."TABNAME" = 'BSEG'
                                                 AND "CDPOS"."FNAME" = 'ZLSPR'
                                  LEFT JOIN "USR02" AS "USR02"
                                            ON "CDHDR"."MANDANT" = "USR02"."MANDT"
                                                AND "CDHDR"."USERNAME" = "USR02"."BNAME"),
     "CTE_Releases" AS (SELECT "JoinTable"."JoinID"                                                                               AS "ReleasesID",
                               "JoinTable"."JoinTime"                                                                             AS "ReleaseTime",
                               'PaymentBlock'                                                                                     AS "ReleaseType",
                               'Block to ' || "JoinTable"."VALUE_NEW"                                                             AS "ValueType",
                               "JoinTable"."VALUE_NEW"                                                                            AS "VALUE_NEW",
                               "JoinTable"."VALUE_OLD"                                                                            AS "VALUE_OLD",
                               "JoinTable"."JoinUserID"                                                                           AS "ReleasedBy_ID",
                               "JoinTable"."JoinExecutionType"                                                                    AS "ReleaseExecutionType",
                               "JoinTable"."JoinOperationType"                                                                    AS "ReleaseOperationType",
                               "JoinTable"."JoinSystemNumber"                                                                     AS "SystemReleaseNumber",
                               "JoinTable"."JoinID"                                                                               AS "VendorAccountCreditItemID",
                               ROW_NUMBER()
                               OVER (PARTITION BY "JoinTable"."JoinID" ORDER BY "JoinTable"."UDATE" ASC, "JoinTable"."UTIME" ASC) AS "ReleaseRN"
                        FROM "CTE_JoinTable" AS "JoinTable"
                        WHERE ("JoinTable"."VALUE_OLD" IS NOT NULL AND "JoinTable"."VALUE_NEW" IS NULL)),
     "CTE_Changes" AS (SELECT "JoinTable"."JoinID"                   		AS "ID",
                              "JoinTable"."JoinTime"                 		AS "ChangeTime",
                              'PaymentBlock'                         		AS "ChangeType",
                              'Block to ' || "JoinTable"."VALUE_NEW" 		AS "ValueType",
                              "JoinTable"."VALUE_NEW"                		AS "VALUE_NEW",
                              "JoinTable"."VALUE_OLD"                		AS "VALUE_OLD",
                              "JoinTable"."JoinUserID"               		AS "ChangeBy",
                              "JoinTable"."JoinExecutionType"        		AS "ChangeExecutionType",
                              "JoinTable"."JoinOperationType"        		AS "ChangeOperationType",
                              "JoinTable"."JoinSystemNumber"         		AS "ChangeID",
                              "JoinTable"."JoinID"                   		AS "VendorAccountCreditItemID"
                       FROM "CTE_JoinTable" AS "JoinTable"
                       WHERE "JoinTable"."VALUE_OLD" IS NOT NULL
                         AND "JoinTable"."VALUE_NEW" IS NOT NULL),
     "CTE_BlockFromChangelog" AS (SELECT "JoinTable"."JoinID"                   AS "BlockID",
                                         "JoinTable"."JoinTime"                 AS "BlockTime",
                                         'PaymentBlock'                         AS "BlockType",
                                         'Block to ' || "JoinTable"."VALUE_NEW" AS "ValueType",
                                         "JoinTable"."VALUE_NEW"                AS "VALUE_NEW",
                                         "JoinTable"."VALUE_OLD"                AS "VALUE_OLD",
                                         "JoinTable"."JoinUserID"               AS "BlockedBy",
                                         "JoinTable"."JoinExecutionType"        AS "BlockExecutionType",
                                         "JoinTable"."JoinOperationType"        AS "BlockOperationType",
                                         "JoinTable"."JoinSystemNumber"         AS "SystemBlockNumber",
                                         "JoinTable"."JoinID"                   AS "VendorAccountCreditItemID"
                                  FROM "CTE_JoinTable" AS "JoinTable"
                                  WHERE "JoinTable"."VALUE_OLD" IS NULL
                                    AND "JoinTable"."VALUE_NEW" IS NOT NULL),
     "CTE_ImplicitActiveBlock" AS (SELECT "BSEG"."MANDT" || "BSEG"."BUKRS" || "BSEG"."BELNR"
                                              || "BSEG"."GJAHR" || "BSEG"."BUZEI" AS "BlockID",
                                          CAST("BKPF"."CPUDT" AS DATE) + CAST(TIMESTAMPDIFF(SECOND, CAST("BKPF"."CPUTM" AS DATE),
                                              "BKPF"."CPUTM") AS INTERVAL SECOND) AS "BlockTime",
                                          'PaymentBlock'                          AS "BlockType",
                                          'Block to ' || "BSEG"."ZLSPR"           AS "ValueType",
                                          "BSEG"."ZLSPR"                          AS "VALUE_NEW",
                                          NULL                                    AS "VALUE_OLD",
                                          NULL                                    AS "BlockedBy",
                                          'Automatic'                             AS "BlockExecutionType",
                                          NULL                                    AS "BlockOperationType",
                                          '-1'                                    AS "SystemBlockNumber",
                                          "BSEG"."MANDT" || "BSEG"."BUKRS" || "BSEG"."BELNR"
                                              || "BSEG"."GJAHR"
                                              ||
                                          "BSEG"."BUZEI"                          AS "VendorAccountCreditItemID"
                                   FROM "BSEG" AS "BSEG"
                                            LEFT JOIN "BKPF" AS "BKPF"
                                                      ON "BSEG"."MANDT" = "BKPF"."MANDT"
                                                          AND "BSEG"."BUKRS" = "BKPF"."BUKRS"
                                                          AND "BSEG"."BELNR" = "BKPF"."BELNR"
                                                          AND "BSEG"."GJAHR" = "BKPF"."GJAHR"
                                            LEFT JOIN "CTE_BlockFromChangelog" 		AS "Block"
                                                      ON "Block"."BlockID"
                                                          = "BSEG"."MANDT" || "BSEG"."BUKRS" || "BSEG"."BELNR"
                                                             || "BSEG"."GJAHR" || "BSEG"."BUZEI"
                                            LEFT JOIN "CTE_Releases" AS "Releases"
                                                      ON "Releases"."ReleasesID"
                                                          = "BSEG"."MANDT" || "BSEG"."BUKRS" || "BSEG"."BELNR"
                                                             || "BSEG"."GJAHR" || "BSEG"."BUZEI"
                                            LEFT JOIN "CTE_Changes" AS "Changes"
                                                      ON "Changes"."ID"
                                                          = "BSEG"."MANDT" || "BSEG"."BUKRS" || "BSEG"."BELNR"
                                                             || "BSEG"."GJAHR" || "BSEG"."BUZEI"
                                   WHERE "Block"."BlockID" IS NULL
                                     AND "Changes"."ID" IS NULL
                                     AND "Releases"."ReleasesID" IS NULL
                                     AND "BSEG"."ZLSPR" IS NOT NULL
                                     AND "BSEG"."KOART" = 'K'
                                     AND "BSEG"."SHKZG" = 'H'),
     "CTE_FirstAction" AS (SELECT "JoinTable"."JoinID"        AS "BlockID",
                                  MIN("JoinTable"."JoinTime") AS "BlockTime"
                           FROM "CTE_JoinTable" AS "JoinTable"
                           GROUP BY "JoinTable"."JoinID"),
     "CTE_ImplicitInactiveBlock" AS (SELECT "FirstAction"."BlockID"                                 AS "BlockID",
                                            CAST("BKPF"."CPUDT" AS DATE) + CAST(TIMESTAMPDIFF(SECOND, CAST("BKPF"."CPUTM" AS DATE),
                                              "BKPF"."CPUTM") AS INTERVAL SECOND)                   AS "BlockTime",
                                            'PaymentBlock'                                          AS "BlockType",
                                            'Block to '
                                                ||
                                            COALESCE("Changes"."VALUE_OLD", "Releases"."VALUE_OLD") AS "ValueType",
                                            COALESCE("Changes"."VALUE_OLD", "Releases"."VALUE_OLD") AS "VALUE_NEW",
                                            NULL                                                    AS "VALUE_OLD",
                                            NULL                                                    AS "BlockedBy",
                                            'Automatic'                                             AS "BlockExecutionType",
                                            NULL                                                    AS "BlockOperationType",
                                            '-1'                                                    AS "SystemBlockNumber",
                                            "BSEG"."MANDT" || "BSEG"."BUKRS" || "BSEG"."BELNR"
                                                || "BSEG"."GJAHR"
                                                ||
                                            "BSEG"."BUZEI"                                          AS "VendorAccountCreditItemID"
                                     FROM "CTE_FirstAction" AS "FirstAction"
                                              LEFT JOIN "CTE_Changes" AS "Changes"
                                                        ON "FirstAction"."BlockID" = "Changes"."ID"
                                                            AND "FirstAction"."BlockTime"
                                                               = "Changes"."ChangeTime"
                                              LEFT JOIN "CTE_Releases" AS "Releases"
                                                        ON "FirstAction"."BlockID"
                                                               = "Releases"."ReleasesID"
                                                            AND "FirstAction"."BlockTime"
                                                               = "Releases"."ReleaseTime"
                                              LEFT JOIN "BSEG" AS "BSEG"
                                                        ON "FirstAction"."BlockID"
                                                            = "BSEG"."MANDT" || "BSEG"."BUKRS" || "BSEG"."BELNR"
                                                               || "BSEG"."GJAHR" || "BSEG"."BUZEI"
                                              LEFT JOIN "BKPF" AS "BKPF"
                                                        ON "BSEG"."MANDT" = "BKPF"."MANDT"
                                                            AND "BSEG"."BUKRS" = "BKPF"."BUKRS"
                                                            AND "BSEG"."BELNR" = "BKPF"."BELNR"
                                                            AND "BSEG"."GJAHR" = "BKPF"."GJAHR"
                                     WHERE ("Changes"."ID" IS NOT NULL
                                         OR "Releases"."ReleasesID" IS NOT NULL)
                                       AND "BSEG"."KOART" = 'K'
                                       AND "BSEG"."SHKZG" = 'H'),
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
                                                                      AND
                                                                     "Active"."BlockTime" = "Duplicates"."BlockTime"
                                                                      AND
                                                                     "Active"."BlockType" = "Duplicates"."BlockType"
                                               WHERE "Duplicates"."BlockID" IS NULL),
     "CTE_BlockNoRN"
         AS (SELECT "ImplicitActiveBlockNoDuplicates"."BlockID"                   AS "BlockID",
                    "ImplicitActiveBlockNoDuplicates"."BlockTime"                 AS "BlockTime",
                    "ImplicitActiveBlockNoDuplicates"."BlockType"                 AS "BlockType",
                    "ImplicitActiveBlockNoDuplicates"."ValueType"                 AS "ValueType",
                    "ImplicitActiveBlockNoDuplicates"."VALUE_NEW"                 AS "VALUE_NEW",
                    "ImplicitActiveBlockNoDuplicates"."VALUE_OLD"                 AS "VALUE_OLD",
                    "ImplicitActiveBlockNoDuplicates"."BlockedBy"                 AS "BlockedBy",
                    "ImplicitActiveBlockNoDuplicates"."BlockExecutionType"        AS "BlockExecutionType",
                    "ImplicitActiveBlockNoDuplicates"."BlockOperationType"        AS "BlockOperationType",
                    "ImplicitActiveBlockNoDuplicates"."SystemBlockNumber"         AS "SystemBlockNumber",
                    "ImplicitActiveBlockNoDuplicates"."VendorAccountCreditItemID" AS "VendorAccountCreditItemID"
             FROM "CTE_ImplicitActiveBlockNoDuplicates" AS "ImplicitActiveBlockNoDuplicates"
             UNION
             SELECT "ImplicitInactiveBlock"."BlockID"                   AS "BlockID",
                    "ImplicitInactiveBlock"."BlockTime"                 AS "BlockTime",
                    "ImplicitInactiveBlock"."BlockType"                 AS "BlockType",
                    "ImplicitInactiveBlock"."ValueType"                 AS "ValueType",
                    "ImplicitInactiveBlock"."VALUE_NEW"                 AS "VALUE_NEW",
                    "ImplicitInactiveBlock"."VALUE_OLD"                 AS "VALUE_OLD",
                    "ImplicitInactiveBlock"."BlockedBy"                 AS "BlockedBy",
                    "ImplicitInactiveBlock"."BlockExecutionType"        AS "BlockExecutionType",
                    "ImplicitInactiveBlock"."BlockOperationType"        AS "BlockOperationType",
                    "ImplicitInactiveBlock"."SystemBlockNumber"         AS "SystemBlockNumber",
                    "ImplicitInactiveBlock"."VendorAccountCreditItemID" AS "VendorAccountCreditItemID"
             FROM "CTE_ImplicitInactiveBlock" AS "ImplicitInactiveBlock"
             UNION
             SELECT "CTE_BlockFromChangelog"."BlockID"                   AS "BlockID",
                    "CTE_BlockFromChangelog"."BlockTime"                 AS "BlockTime",
                    "CTE_BlockFromChangelog"."BlockType"                 AS "BlockType",
                    "CTE_BlockFromChangelog"."ValueType"                 AS "ValueType",
                    "CTE_BlockFromChangelog"."VALUE_NEW"                 AS "VALUE_NEW",
                    "CTE_BlockFromChangelog"."VALUE_OLD"                 AS "VALUE_OLD",
                    "CTE_BlockFromChangelog"."BlockedBy"                 AS "BlockedBy",
                    "CTE_BlockFromChangelog"."BlockExecutionType"        AS "BlockExecutionType",
                    "CTE_BlockFromChangelog"."BlockOperationType"        AS "BlockOperationType",
                    "CTE_BlockFromChangelog"."SystemBlockNumber"         AS "SystemBlockNumber",
                    "CTE_BlockFromChangelog"."VendorAccountCreditItemID" AS "VendorAccountCreditItemID"
             FROM "CTE_BlockFromChangelog"),
     "CTE_Block" AS (SELECT *,
                            ROW_NUMBER()
                            OVER (PARTITION BY "CTE_BlockNoRN"."BlockID", "CTE_BlockNoRN"."BlockType" ORDER BY "CTE_BlockNoRN"."BlockTime" ASC) AS "BlockRN"
                     FROM "CTE_BlockNoRN"
                     ORDER BY "CTE_BlockNoRN"."BlockID")
SELECT <%=sourceSystem%>  || 'VendorAccountCreditItemBlock_' || "Block"."BlockID" || '_' || "Block"."SystemBlockNumber" || '_'
           || "Block"."BlockType"                                                        AS "ID",
       "Block"."BlockTime"                                                               AS "CreationTime",
       COALESCE("Block"."BlockType", "Releases"."ReleaseType")                           AS "BlockType",
       "Block"."VALUE_NEW"                                                               AS "FirstBlockReason",
       CASE
           WHEN "Releases"."ReleaseType" IS NOT NULL
               THEN "Releases"."VALUE_NEW"
           ELSE COALESCE("BSEG"."ZLSPR", 'Data cut - no entry in BSEG')
           END                                                                           	AS "LatestBlockReason",
	<%=sourceSystem%>  || 'User_' || "Block"."BlockedBy"                                    AS "BlockedBy",
       "Block"."BlockExecutionType"                                                      	AS "BlockExecutionType",
       "Releases"."ReleaseTime"                                                          	AS "ReleaseTime",
       "Releases"."ReleaseType"                                                          	AS "ReleaseType",
       "Releases"."VALUE_OLD"                                                            	AS "ReleaseReason",
	<%=sourceSystem%>  || 'User_' || "Releases"."ReleasedBy_ID"                             AS "ReleasedBy",
       "Releases"."ReleaseExecutionType"                                                 	AS "ReleaseExecutionType",
	<%=sourceSystem%>  || 'VendorAccountCreditItem_' || "Block"."VendorAccountCreditItemID" AS "VendorAccountCreditItem",
       'SAP'                                                                             	AS "SourceSystemType"
FROM "CTE_Block" AS "Block"
         LEFT JOIN "CTE_Releases" AS "Releases"
                   ON "Block"."BlockID" = "Releases"."ReleasesID"
                       AND "Block"."BlockRN" = "Releases"."ReleaseRN"
                       AND "Block"."BlockType" = "Releases"."ReleaseType"
         LEFT JOIN "CTE_BSEG_PRE" AS "BSEG"
                   ON "Block"."BlockID" = "BSEG"."TABKEY"
WHERE ("BSEG"."KOART" = 'K' AND "BSEG"."SHKZG" = 'H')
   OR ("BSEG"."KOART" IS NULL AND "BSEG"."SHKZG" IS NULL)



===================================================================================================================================================================


                     **************************************     CDPOS       ***********************************


WITH "CTE_BSEG_PRE"
         AS (SELECT "BSEG"."MANDT" || "BSEG"."BUKRS" || "BSEG"."BELNR" || "BSEG"."GJAHR" || "BSEG"."BUZEI" AS "TABKEY",
                    "KOART",
                    "SHKZG"
             FROM "BSEG" AS "BSEG"
             ORDER BY "TABKEY"),
     "CTE_JoinTable" AS (SELECT "CDPOS"."TABKEY"     AS "TABKEY",
                                "CDPOS"."MANDANT"    AS "MANDANT",
                                "CDPOS"."OBJECTCLAS" AS "OBJECTCLAS",
                                "CDPOS"."OBJECTID"   AS "OBJECTID",
                                "CDPOS"."FNAME"      AS "FNAME",
                                "CDPOS"."VALUE_NEW"  AS "VALUE_NEW",
                                "CDPOS"."VALUE_OLD"  AS "VALUE_OLD",
                                "CDPOS"."TABNAME"    AS "TABNAME",
                                "CDHDR"."UDATE"      AS "UDATE",
                                "CDHDR"."UTIME"      AS "UTIME",
                                "CDPOS"."CHNGIND"    AS "CHNGIND",
                                "CDHDR"."USERNAME"   AS "USERNAME",
                                "CDHDR"."TCODE"      AS "TCODE",
                                "CDHDR"."CHANGENR"   AS "CHANGENR",
                                "USR02"."USTYP"      AS "USTYP"
                         FROM "CDPOS" AS "CDPOS"
                                  INNER JOIN "CDHDR" AS "CDHDR"
                                             ON "CDPOS"."MANDANT" = "CDHDR"."MANDANT"
                                                 AND "CDPOS"."OBJECTCLAS" = "CDHDR"."OBJECTCLAS"
                                                 AND "CDPOS"."OBJECTID" = "CDHDR"."OBJECTID"
                                                 AND "CDPOS"."CHANGENR" = "CDHDR"."CHANGENR"
                                                 AND "CDPOS"."OBJECTCLAS" = 'BELEG'
                                                 AND "CDPOS"."CHNGIND" = 'U'
                                                 AND "CDPOS"."TABNAME" = 'BSEG'
                                                 AND "CDPOS"."FNAME" = 'ZLSPR'
                                  LEFT JOIN "USR02" AS "USR02"
                                            ON "CDHDR"."MANDANT" = "USR02"."MANDT"
                                                AND "CDHDR"."USERNAME" = "USR02"."BNAME"
                         ORDER BY "TABKEY"),
     "CTE_BlockFromChangelog" AS (SELECT 'VendorAccountCreditItemBlock_' || "JoinTable"."TABKEY" AS "BlockID",
                                         CAST("JoinTable"."UDATE" AS DATE)
                                            + COALESCE(CAST(TIMESTAMPDIFF(SECOND, CAST("JoinTable"."UTIME" AS DATE), "JoinTable"."UTIME") AS INTERVAL SECOND),
                                            INTERVAL '86399' SECOND)                             AS "BlockTime",
                                         'PaymentBlock'                                          AS "BlockType",
                                         'Block to ' || "JoinTable"."VALUE_NEW"                  AS "ValueType",
                                         CASE
                                             WHEN "JoinTable"."USTYP" IN ('B', 'C')
                                                 THEN 'Automatic'
                                             ELSE 'Manual'
                                             END                                                 AS "BlockExecutionType",
                                         "JoinTable"."TCODE"                                     AS "BlockOperationType",
                                         "JoinTable"."CHANGENR"                                  AS "SystemBlockNumber",
                                         'VendorAccountCreditItem_' || "JoinTable"."TABKEY"      AS "VendorAccountCreditItemID",
                                         "JoinTable"."MANDANT"                                   AS "MANDANT",
                                         "JoinTable"."OBJECTCLAS"                                AS "OBJECTCLAS",
                                         "JoinTable"."OBJECTID"                                  AS "OBJECTID",
                                         "JoinTable"."FNAME"                                     AS "FNAME"
                                  FROM "CTE_JoinTable" AS "JoinTable"
                                  WHERE "JoinTable"."VALUE_OLD" IS NULL
                                    AND "JoinTable"."VALUE_NEW" IS NOT NULL),
     "CTE_MinBlock" AS (
         SELECT "JoinTable"."CHANGENR"                     										AS "CHANGENR",
                "JoinTable"."TABKEY"                       										AS "TABKEY",
                MIN(TIMESTAMPDIFF(SECOND, "BlockFromChangelog"."BlockTime",
                       CAST("JoinTable"."UDATE" AS DATE)
                                + COALESCE(CAST(TIMESTAMPDIFF(SECOND, CAST("JoinTable"."UTIME" AS DATE), "JoinTable"."UTIME") AS INTERVAL SECOND),
                                INTERVAL '86399' SECOND))) 										AS "LatestBlockSelector"
         FROM "CTE_JoinTable" AS "JoinTable"
                  LEFT JOIN "CTE_BlockFromChangelog" 											AS "BlockFromChangelog"
                            ON "JoinTable"."MANDANT" = "BlockFromChangelog"."MANDANT"
                                AND "JoinTable"."OBJECTCLAS" = "BlockFromChangelog"."OBJECTCLAS"
                                AND "JoinTable"."OBJECTID" = "BlockFromChangelog"."OBJECTID"
                                AND
                               'VendorAccountCreditItemBlock_' || "JoinTable"."TABKEY" = "BlockFromChangelog"."BlockID"
                                AND CAST("JoinTable"."UDATE" AS DATE)
                                        + COALESCE(CAST(TIMESTAMPDIFF(SECOND, CAST("JoinTable"."UTIME" AS DATE), "JoinTable"."UTIME") AS INTERVAL SECOND),
                                        INTERVAL '86399' SECOND)
                                   >= "BlockFromChangelog"."BlockTime"
                                AND "JoinTable"."FNAME" = "BlockFromChangelog"."FNAME"
         GROUP BY "JoinTable"."CHANGENR", "JoinTable"."TABKEY")
SELECT <%=sourceSystem%>  || 'VendorAccountCreditItemBlock_' || "JoinTable"."TABKEY" || '_'
           || COALESCE("BlockFromChangelog"."SystemBlockNumber", '-1') || '_'
           || CASE
                  WHEN "JoinTable"."FNAME" = 'ZLSPR'
                      THEN 'PaymentBlock'
           END                                                    AS "ObjectID",
	<%=sourceSystem%>  || "JoinTable"."TABKEY" || "JoinTable"."TABNAME" || "JoinTable"."FNAME"
           || "JoinTable"."CHANGENR" || "JoinTable"."CHNGIND"     AS "ID",
       CAST("JoinTable"."UDATE" AS DATE)
           + CAST(TIMESTAMPDIFF(SECOND, CAST("JoinTable"."UTIME" AS DATE),
           "JoinTable"."UTIME") AS INTERVAL SECOND)               AS "Time",
       'LatestBlockReason'                                        AS "Attribute",
       "JoinTable"."VALUE_OLD"                                    AS "OldValue",
       "JoinTable"."VALUE_NEW"                                    AS "NewValue",
       'User_' || "JoinTable"."MANDANT" || "JoinTable"."USERNAME" AS "ChangedBy",
       "JoinTable"."TCODE"                                        AS "OperationType",
       "JoinTable"."CHANGENR"                                     AS "OperationID",
       CASE
           WHEN "JoinTable"."USTYP" IN ('B', 'C')
               THEN 'Automatic'
           ELSE 'Manual'
           END                                                    AS "ExecutionType"
FROM "CTE_JoinTable" AS "JoinTable"
         LEFT JOIN "CTE_BSEG_PRE" AS "BSEG"
                   ON "JoinTable"."TABKEY" = "BSEG"."TABKEY"
         LEFT JOIN "CTE_MinBlock" AS "MinBlock"
                   ON "JoinTable"."CHANGENR" = "MinBlock"."CHANGENR"
                       AND "JoinTable"."TABKEY" = "MinBlock"."TABKEY"
         LEFT JOIN "CTE_BlockFromChangelog" AS "BlockFromChangelog"
                   ON "JoinTable"."MANDANT" = "BlockFromChangelog"."MANDANT"
                       AND "JoinTable"."OBJECTCLAS" = "BlockFromChangelog"."OBJECTCLAS"
                       AND "JoinTable"."OBJECTID" = "BlockFromChangelog"."OBJECTID"
                       AND 'VendorAccountCreditItemBlock_' || "JoinTable"."TABKEY" = "BlockFromChangelog"."BlockID"
                       AND CAST("JoinTable"."UDATE" AS DATE)
                                + COALESCE(CAST(TIMESTAMPDIFF(SECOND, CAST("JoinTable"."UTIME" AS DATE), "JoinTable"."UTIME") AS INTERVAL SECOND),
                                INTERVAL '86399' SECOND)
                          >= "BlockFromChangelog"."BlockTime"
                       AND "JoinTable"."FNAME" = "BlockFromChangelog"."FNAME"
                       AND TIMESTAMPDIFF(SECOND, "BlockFromChangelog"."BlockTime",
                                CAST("JoinTable"."UDATE" AS DATE)
                                + COALESCE(CAST(TIMESTAMPDIFF(SECOND, CAST("JoinTable"."UTIME" AS DATE), "JoinTable"."UTIME") AS INTERVAL SECOND),
                                INTERVAL '86399' SECOND))
                          = "MinBlock"."LatestBlockSelector"
WHERE "JoinTable"."VALUE_OLD" IS NOT NULL
  AND "JoinTable"."VALUE_NEW" IS NOT NULL
  AND (("BSEG"."KOART" = 'K' AND "BSEG"."SHKZG" = 'H')
  OR ("BSEG"."KOART" IS NULL AND "BSEG"."SHKZG" IS NULL))
