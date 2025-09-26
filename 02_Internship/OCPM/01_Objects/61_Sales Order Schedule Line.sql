                **********************************        VBEP      *****************************************

SELECT <%=sourceSystem%>  || 'SalesOrderScheduleLine_' || "VBEP"."MANDT" || "VBEP"."VBELN" || "VBEP"."POSNR" || "VBEP"."ETENR" AS "ID",
    NULL                                                                                                                       AS "CreationTime",
	<%=sourceSystem%>  || NULL                                                                                                    AS "CreatedBy",
    NULL                                                                                                                       AS "CreationExecutionType",
	<%=sourceSystem%>  || 'SalesOrderItem_' || "VBEP"."MANDT" || "VBEP"."VBELN" || "VBEP"."POSNR"                                 AS "SalesOrderItem",
    'SAP'                                                                                                                      AS "SourceSystemType",
	<%=sourceSystem%>  || "VBEP"."MANDT"                                                                                          AS "SourceSystemInstance",
    "VBEP"."VBELN"                                                                                                             AS "SystemSalesOrderNumber",
    "VBEP"."POSNR"                                                                                                             AS "SystemSalesOrderItemNumber",
    "VBEP"."ETENR"                                                                                                             AS "SystemSalesOrderScheduleLineNumber",
    "VBEP"."VBELN"                                                                                                             AS "DatabaseSalesOrderNumber",
    "VBEP"."POSNR"                                                                                                             AS "DatabaseSalesOrderItemNumber",
    "VBEP"."ETENR"                                                                                                             AS "DatabaseSalesOrderScheduleLineNumber",
    "VBEP"."BMENG"                                                                                                             AS "ConfirmedQuantity",
    "VBEP"."MEINS"                                                                                                             AS "QuantityUnit",
    CASE
        WHEN "VBEP"."BMENG" > 0
            THEN CAST("VBEP"."EDATU" AS TIMESTAMP) END                                                                         AS "ConfirmedDeliveryDate",
    CAST("VBEP"."MBDAT" AS TIMESTAMP)                                                                                          AS "MaterialAvailabilityDate",
    CAST("VBEP"."WADAT" AS TIMESTAMP)                                                                                          AS "GoodsIssueDate"
FROM "VBEP" AS "VBEP"
         LEFT JOIN "VBAK" AS "VBAK"
                   ON "VBEP"."MANDT" = "VBAK"."MANDT"
                       AND "VBEP"."VBELN" = "VBAK"."VBELN"
WHERE "VBEP"."MANDT" IS NOT NULL
  AND "VBAK"."VBTYP" IN ('C', 'I')


===================================================================================================================================================================


                          ****************************        CDPOS      ***********************************


SELECT <%=sourceSystem%>  || 'SalesOrderScheduleLine_' || "CDPOS"."TABKEY" AS "ObjectID",
	<%=sourceSystem%>  || "CDPOS"."TABKEY" || "CDPOS"."TABNAME" || "CDPOS"."FNAME"
       || "CDPOS"."CHANGENR" || "CDPOS"."CHNGIND"                          AS "ID",
       CAST("CDHDR"."UDATE" AS DATE)
            + COALESCE(CAST(TIMESTAMPDIFF(SECOND, CAST("CDHDR"."UTIME" AS DATE),
            "CDHDR"."UTIME") AS INTERVAL SECOND), INTERVAL '86399' SECOND) AS "Time",
       CASE
           WHEN "CDPOS"."CHNGIND" = 'I' THEN 'CreationTime'
           WHEN "CDPOS"."CHNGIND" = 'D' THEN 'DeletionTime'
           END                                                             AS "Attribute",
       NULL                                                                AS "OldValue",
       NULL                                                                AS "NewValue",
        'User_' || "CDHDR"."MANDANT" || "CDHDR"."USERNAME"                 AS "ChangedBy",
       "CDHDR"."TCODE"                                                     AS "OperationType",
       "CDHDR"."CHANGENR"                                                  AS "OperationID",
       CASE
           WHEN "USR02"."USTYP" IN ('B', 'C') THEN 'Automatic'
           ELSE 'Manual' END                                               AS "ExecutionType"
FROM "CDPOS" AS "CDPOS"
         LEFT JOIN "CDHDR" AS "CDHDR"
                   ON "CDPOS"."MANDANT" = "CDHDR"."MANDANT"
                       AND "CDPOS"."OBJECTCLAS" = "CDHDR"."OBJECTCLAS"
                       AND "CDPOS"."OBJECTID" = "CDHDR"."OBJECTID"
                       AND "CDPOS"."CHANGENR" = "CDHDR"."CHANGENR"
                       AND "CDPOS"."OBJECTCLAS" = 'VERKBELEG'
         LEFT JOIN "USR02" AS "USR02"
                   ON "CDHDR"."MANDANT" = "USR02"."MANDT"
                       AND "CDHDR"."USERNAME" = "USR02"."BNAME"
WHERE "CDPOS"."MANDANT" IS NOT NULL
  AND "CDPOS"."TABNAME" = 'VBEP'
  AND "CDPOS"."FNAME" = 'KEY'
  AND "CDHDR"."MANDANT" IS NOT NULL


====================================================================================================================================================================


                      ****************************    VBEP    ********************************


WITH "CTE_Sorted_Changes" AS (SELECT "CDPOS"."MANDANT",
                                     "CDPOS"."TABNAME",
                                     "CDPOS"."TABKEY",
                                     CAST("CDHDR"."UDATE" AS DATE)
                                        + CAST(TIMESTAMPDIFF(SECOND, CAST("CDHDR"."UTIME" AS DATE),
                                        "CDHDR"."UTIME") AS INTERVAL SECOND)        AS "CHANGEDATE",
                                     LTRIM("CDPOS"."VALUE_OLD")                     AS "VALUE_OLD",
                                     LTRIM("CDPOS"."VALUE_NEW")                     AS "VALUE_NEW",
                                     ROW_NUMBER()
                                     OVER (PARTITION BY "CDPOS"."MANDANT", "CDPOS"."TABNAME", "CDPOS"."TABKEY"
                                         ORDER BY "CDHDR"."UDATE", "CDHDR"."UTIME") AS "rn"
                              FROM "CDPOS" AS "CDPOS"
                                       LEFT JOIN "CDHDR" AS "CDHDR"
                                                 ON "CDPOS"."MANDANT" = "CDHDR"."MANDANT"
                                                     AND "CDPOS"."OBJECTCLAS" = "CDHDR"."OBJECTCLAS"
                                                     AND "CDPOS"."OBJECTID" = "CDHDR"."OBJECTID"
                                                     AND "CDPOS"."CHANGENR" = "CDHDR"."CHANGENR"
                              WHERE "CDPOS"."MANDANT" IS NOT NULL
                                AND "CDPOS"."OBJECTCLAS" = 'VERKBELEG'
                                AND "CDPOS"."TABNAME" = 'VBEP'
                                AND "CDPOS"."FNAME" = 'BMENG'),
     "CTE_SalesOrderScheduleLine_LookUp" AS (SELECT "Current"."MANDANT",
                                                    "Current"."TABNAME",
                                                    "Current"."TABKEY",
                                                    "Current"."CHANGEDATE" AS "StartDate",
                                                    CASE
                                                        WHEN "Next"."rn" IS NULL
                                                            THEN CAST('9999-01-01 09:09:09' AS TIMESTAMP)
                                                        ELSE "Next"."CHANGEDATE"
                                                        END                AS "EndDate",
                                                    "Current"."VALUE_NEW"  AS "Value"
                                             FROM "CTE_Sorted_Changes" AS "Current"
                                                      LEFT JOIN "CTE_Sorted_Changes" AS "Next"
                                                                ON "Current"."MANDANT" = "Next"."MANDANT"
                                                                    AND "Current"."TABNAME" = "Next"."TABNAME"
                                                                    AND "Current"."TABKEY" = "Next"."TABKEY"
                                                                    AND "Current"."rn" + 1 = "Next"."rn"
                                             UNION ALL
                                             SELECT "Current"."MANDANT",
                                                    "Current"."TABNAME",
                                                    "Current"."TABKEY",
                                                    CAST('1970-01-01 00:00:00' AS TIMESTAMP) AS "StartDate",
                                                    "Current"."CHANGEDATE"                   AS "EndDate",
                                                    "Current"."VALUE_OLD"                    AS "Value"
                                             FROM "CTE_Sorted_Changes" AS "Current"
                                             WHERE "Current"."rn" = 1)
SELECT <%=sourceSystem%>  || 'SalesOrderScheduleLine_' || "CDPOS"."TABKEY" AS "ObjectID",
	<%=sourceSystem%>  || "CDPOS"."TABKEY" || "CDPOS"."TABNAME" || "CDPOS"."FNAME"
       || "CDPOS"."CHANGENR" || "CDPOS"."CHNGIND"                          AS "ID",
       CAST("CDHDR"."UDATE" AS DATE)
            + CAST(TIMESTAMPDIFF(SECOND, CAST("CDHDR"."UTIME" AS DATE),
            "CDHDR"."UTIME") AS INTERVAL SECOND)                           AS "Time",
       CASE
           WHEN "CDPOS"."FNAME" = 'BMENG' AND CAST("SalesOrderScheduleLine_LookUp"."Value" AS DOUBLE) > 0
               THEN 'ConfirmedQuantity'
           WHEN "CDPOS"."FNAME" = 'EDATU' AND CAST("SalesOrderScheduleLine_LookUp"."Value" AS DOUBLE) > 0
               THEN 'ConfirmedDeliveryDate'
           WHEN "CDPOS"."FNAME" = 'MBDAT' THEN 'MaterialAvailabilityDate'
           END                                                             AS "Attribute",
       LTRIM("CDPOS"."VALUE_OLD")                                          AS "OldValue",
       LTRIM("CDPOS"."VALUE_NEW")                                          AS "NewValue",
       'User_' || "CDHDR"."MANDANT" || "CDHDR"."USERNAME"                  AS "ChangedBy",
       "CDHDR"."TCODE"                                                     AS "OperationType",
       "CDHDR"."CHANGENR"                                                  AS "OperationID",
       CASE
           WHEN "USR02"."USTYP" IN ('B', 'C') THEN 'Automatic'
           ELSE 'Manual' END                                               AS "ExecutionType"
FROM "VBEP" AS "VBEP"
         LEFT JOIN "CDPOS" AS "CDPOS"
                   ON "VBEP"."MANDT" = "CDPOS"."MANDANT"
                       AND "CDPOS"."OBJECTCLAS" = 'VERKBELEG'
                       AND "CDPOS"."TABNAME" = 'VBEP'
                       AND "VBEP"."MANDT" || "VBEP"."VBELN" || "VBEP"."POSNR" || "VBEP"."ETENR" = "CDPOS"."TABKEY"
                       AND "CDPOS"."FNAME" IN ('BMENG', 'EDATU', 'MBDAT')
         LEFT JOIN "CDHDR" AS "CDHDR"
                   ON "CDPOS"."MANDANT" = "CDHDR"."MANDANT"
                       AND "CDPOS"."OBJECTCLAS" = "CDHDR"."OBJECTCLAS"
                       AND "CDPOS"."OBJECTID" = "CDHDR"."OBJECTID"
                       AND "CDPOS"."CHANGENR" = "CDHDR"."CHANGENR"
         LEFT JOIN "CTE_SalesOrderScheduleLine_LookUp" AS "SalesOrderScheduleLine_LookUp"
                   ON "VBEP"."MANDT" = "SalesOrderScheduleLine_LookUp"."MANDANT"
                       AND "VBEP"."MANDT" || "VBEP"."VBELN" || "VBEP"."POSNR" || "VBEP"."ETENR"
                           = "SalesOrderScheduleLine_LookUp"."TABKEY"
                       AND CAST("CDHDR"."UDATE" AS DATE)
                                        + CAST(TIMESTAMPDIFF(SECOND, CAST("CDHDR"."UTIME" AS DATE),
                                        "CDHDR"."UTIME") AS INTERVAL SECOND)
                           > "SalesOrderScheduleLine_LookUp"."StartDate"
                       AND CAST("CDHDR"."UDATE" AS DATE)
                                        + CAST(TIMESTAMPDIFF(SECOND, CAST("CDHDR"."UTIME" AS DATE),
                                        "CDHDR"."UTIME") AS INTERVAL SECOND)
                           <= "SalesOrderScheduleLine_LookUp"."EndDate"
         LEFT JOIN "USR02" AS "USR02"
                   ON "CDHDR"."MANDANT" = "USR02"."MANDT"
                       AND "CDHDR"."USERNAME" = "USR02"."BNAME"
WHERE "VBEP"."MANDT" IS NOT NULL
  AND "CDPOS"."MANDANT" IS NOT NULL
