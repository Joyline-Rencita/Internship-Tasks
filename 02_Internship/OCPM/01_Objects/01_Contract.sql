                   ********************************************        EKKO        *************************************************

WITH "CTE_Changes" AS (SELECT "CDPOS"."MANDANT",
                              "CDPOS"."TABKEY",
                              "CDHDR"."UDATE",
                              "CDHDR"."UTIME",
                              "CDHDR"."USERNAME",
                              ROW_NUMBER()
                              OVER (PARTITION BY "CDPOS"."TABKEY" ORDER BY "CDHDR"."UDATE" ASC, "CDHDR"."UTIME" DESC) AS "rn"
                       FROM "CDPOS" AS "CDPOS"
                                LEFT JOIN "CDHDR" AS "CDHDR"
                                          ON "CDPOS"."MANDANT" = "CDHDR"."MANDANT"
                                              AND "CDPOS"."CHANGENR" = "CDHDR"."CHANGENR"
                                              AND "CDPOS"."OBJECTCLAS" = "CDHDR"."OBJECTCLAS"
                                              AND "CDPOS"."OBJECTID" = "CDHDR"."OBJECTID"
                       WHERE "CDPOS"."OBJECTCLAS" = 'EINKBELEG'
                         AND "CDPOS"."TABNAME" = 'EKKO'
                         AND "CDPOS"."FNAME" = 'KEY'
                         AND "CDPOS"."CHNGIND" = 'I')
SELECT <%=sourceSystem%>  || 'Contract_' || "EKKO"."MANDT" || "EKKO"."EBELN"                       AS "ID",
       COALESCE(CAST("Changes"."UDATE" AS DATE)
            + CAST(TIMESTAMPDIFF(SECOND, CAST("Changes"."UTIME" AS DATE), "Changes"."UTIME") AS INTERVAL SECOND),
            CAST("EKKO"."AEDAT" AS TIMESTAMP))                                                     AS "CreationTime",
	<%=sourceSystem%>  || 'User_' || "EKKO"."MANDT" || COALESCE("Changes"."USERNAME", "EKKO"."ERNAM") AS "CreatedBy",
       "EKKO"."LOEKZ"                                                                              AS "DeletionIndicator",
       CASE
           WHEN "USR02"."USTYP" IN ('B', 'C') THEN 'Automatic'
           ELSE 'Manual' END                                                                       AS "CreationExecutionType",
       "EKKO"."ZTERM"                                                                              AS "PaymentTerms",
       CAST("EKKO"."KDATB" AS TIMESTAMP)                                                           AS "ValidityPeriodStartDate",
       CAST("EKKO"."KDATE" AS TIMESTAMP)                                                           AS "ValidityPeriodEndDate",
       'SAP'                                                                                       AS "SourceSystemType",
	<%=sourceSystem%>  || "EKKO"."MANDT"                                                              AS "SourceSystemInstance",
       "EKKO"."EBELN"                                                                              AS "SystemContractNumber",
       "EKKO"."EBELN"                                                                              AS "DatabaseContractNumber",
	<%=sourceSystem%>  || 'Vendor_' || "EKKO"."MANDT" || "EKKO"."LIFNR"                               AS "Vendor",
	<%=sourceSystem%>  || 'VendorMasterCompanyCode_' || "EKKO"."MANDT"
       || "EKKO"."LIFNR" || "EKKO"."BUKRS"                                                         AS "VendorMasterCompanyCode"
FROM "EKKO" AS "EKKO"
         LEFT JOIN "CTE_Changes" AS "Changes"
                   ON "EKKO"."MANDT" = "Changes"."MANDANT"
                       AND "EKKO"."MANDT" || "EKKO"."EBELN" = "Changes"."TABKEY"
                       AND "Changes"."rn" = 1
         LEFT JOIN "USR02" AS "USR02"
                   ON "EKKO"."MANDT" = "USR02"."MANDT"
                       AND COALESCE("Changes"."USERNAME", "EKKO"."ERNAM") = "USR02"."BNAME"
WHERE "EKKO"."MANDT" IS NOT NULL
  AND "EKKO"."BSTYP" = 'K'



 =====================================================================================================================================================================



              ****************************************          CDPOS          ********************************************


SELECT <%=sourceSystem%>  || 'Contract_' || "CDPOS"."TABKEY" AS "ObjectID",
	<%=sourceSystem%>  || "CDPOS"."TABKEY" || "CDPOS"."TABNAME" || "CDPOS"."FNAME"
       || "CDPOS"."CHANGENR"
       || "CDPOS"."CHNGIND"                                  AS "ID",
       CAST("CDHDR"."UDATE" AS DATE)
            + CAST(TIMESTAMPDIFF(SECOND, CAST("CDHDR"."UTIME" AS DATE),
            "CDHDR"."UTIME") AS INTERVAL SECOND)             AS "Time",
       CASE
           WHEN "CDPOS"."FNAME" = 'KDATB' THEN 'ValidityPeriodStartDate'
           WHEN "CDPOS"."FNAME" = 'KDATE' THEN 'ValidityPeriodEndDate'
           WHEN "CDPOS"."FNAME" = 'LOEKZ' THEN 'DeletionIndicator'
           WHEN "CDPOS"."FNAME" = 'ZTERM' THEN 'PaymentTerms'
           END                                               AS "Attribute",
       CASE
           WHEN "CDPOS"."VALUE_OLD" LIKE '%-' THEN CONCAT('-', REPLACE(LTRIM("CDPOS"."VALUE_OLD"), '-', ''))
           ELSE "CDPOS"."VALUE_OLD"
           END                                               AS "OldValue",
       CASE
           WHEN "CDPOS"."VALUE_NEW" LIKE '%-' THEN CONCAT('-', REPLACE(LTRIM("CDPOS"."VALUE_NEW"), '-', ''))
           ELSE "CDPOS"."VALUE_NEW"
           END                                               AS "NewValue",
       'User_' || "CDHDR"."MANDANT" || "CDHDR"."USERNAME"    AS "ChangedBy",
       "CDHDR"."TCODE"                                       AS "OperationType",
       "CDHDR"."CHANGENR"                                    AS "OperationID",
       CASE
           WHEN "USR02"."USTYP" IN ('B', 'C') THEN 'Automatic'
           ELSE 'Manual' END                                 AS "ExecutionType"
FROM "CDPOS" AS "CDPOS"
         LEFT JOIN "CDHDR" AS "CDHDR"
                   ON "CDPOS"."MANDANT" = "CDHDR"."MANDANT"
                       AND "CDPOS"."OBJECTCLAS" = "CDHDR"."OBJECTCLAS"
                       AND "CDPOS"."OBJECTID" = "CDHDR"."OBJECTID"
                       AND "CDPOS"."CHANGENR" = "CDHDR"."CHANGENR"
                       AND "CDPOS"."TABNAME" = 'EKKO'
                       AND "CDPOS"."CHNGIND" = 'U'
                       AND "CDPOS"."FNAME" IN ('KDATB', 'KDATE', 'LOEKZ', 'ZTERM')
                       AND "CDPOS"."OBJECTCLAS" = 'EINKBELEG'
         LEFT JOIN "EKKO" AS "EKKO"
                   ON "CDPOS"."TABKEY" = "EKKO"."MANDT" || "EKKO"."EBELN"
                       AND "EKKO"."BSTYP" = 'K'
         LEFT JOIN "USR02" AS "USR02"
                   ON "CDHDR"."USERNAME" = "USR02"."BNAME"
                       AND "CDHDR"."MANDANT" = "USR02"."MANDT"
WHERE "CDPOS"."MANDANT" IS NOT NULL
  AND "CDHDR"."MANDANT" IS NOT NULL
  AND "EKKO"."MANDT" IS NOT NULL

