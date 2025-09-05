--                     ******************************                 EKKO            ***********************************

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
SELECT <%=sourceSystem%>  || 'PurchaseOrder_' || "EKKO"."MANDT" || "EKKO"."EBELN"                       AS "ID",
       COALESCE(
            CAST("Changes"."UDATE" AS DATE)
            + CAST(TIMESTAMPDIFF(SECOND, CAST("Changes"."UTIME" AS DATE),
            "Changes"."UTIME") AS INTERVAL SECOND),
            CAST("EKKO"."AEDAT" AS DATE) + INTERVAL '1' SECOND)                                         AS "CreationTime",
	<%=sourceSystem%>  || 'User_' || "EKKO"."MANDT" || COALESCE("Changes"."USERNAME", "EKKO"."ERNAM")      AS "CreatedBy",
       CASE
           WHEN "USR02"."USTYP" IN ('B', 'C') THEN 'Automatic'
           ELSE 'Manual' END                                                                            AS "CreationExecutionType",
       "EKKO"."LOEKZ"                                                                                   AS "DeletionIndicator",
	<%=sourceSystem%>  || 'Vendor_' || "EKKO"."MANDT" || "EKKO"."LIFNR"                                    AS "Vendor",
	<%=sourceSystem%>  || 'VendorMasterCompanyCode_' || "EKKO"."MANDT" || "EKKO"."LIFNR" || "EKKO"."BUKRS" AS "VendorMasterCompanyCode",
       "EKKO"."WAERS"                                                                                   AS "Currency",
       "EKKO"."ZTERM"                                                                                   AS "PaymentTerms",
	<%=sourceSystem%>  || 'User_' || "EKKO"."MANDT" || COALESCE("Changes"."USERNAME", "EKKO"."ERNAM")      AS "ApprovedBy",
       CASE
           WHEN "EKKO"."FRGZU" IS NULL THEN 0
           WHEN "EKKO"."FRGZU" = 'X' THEN 1
           WHEN "EKKO"."FRGZU" = 'XX' THEN 2
           WHEN "EKKO"."FRGZU" = 'XXX' THEN 3
           WHEN "EKKO"."FRGZU" = 'XXXX' THEN 4
           WHEN "EKKO"."FRGZU" = 'XXXXX' THEN 5
           WHEN "EKKO"."FRGZU" = 'XXXXXX' THEN 6
           WHEN "EKKO"."FRGZU" = 'XXXXXXX' THEN 7
           WHEN "EKKO"."FRGZU" = 'XXXXXXXX' THEN 8
           END                                                                                          AS "ApprovalLevel",
       "EKKO"."FRGSX"                                                                                   AS "ReleaseStrategy",
       "EKKO"."ZBD1T"                                                                                   AS "PaymentDays1",
       "EKKO"."ZBD2T"                                                                                   AS "PaymentDays2",
       "EKKO"."ZBD3T"                                                                                   AS "PaymentDays3",
       "EKKO"."ZBD1P"                                                                                   AS "CashDiscountPercentage1",
       "EKKO"."ZBD2P"                                                                                   AS "CashDiscountPercentage2",
       "EKKO"."BSART"                                                                                   AS "PurchasingDocumentType",
       "T161T"."BATXT"                                                                                  AS "PurchasingDocumentTypeText",
       "EKKO"."BUKRS"                                                                                   AS "CompanyCode",
       "T001"."BUTXT"                                                                                   AS "CompanyCodeText",
       "EKKO"."RESWK"                                                                                   AS "SupplyingPlant",
       "EKKO"."FRGGR"                                                                                   AS "ReleaseGroup",
       "EKKO"."EKORG"                                                                                   AS "PurchasingOrganization",
       "T024E"."EKOTX"                                                                                  AS "PurchasingOrganizationText",
       "EKKO"."FRGKE"                                                                                   AS "ReleaseIndicator",
       "EKKO"."STATU"                                                                                   AS "PurchaseDocumentStatus",
       "EKKO"."BSTYP"                                                                                   AS "PurchasingDocumentCategory",
       "EKKO"."EBELN"                                                                                   AS "SystemPurchaseOrderNumber",
       "EKKO"."EBELN"                                                                                   AS "DatabasePurchaseOrderNumber",
       'SAP'                                                                                            AS "SourceSystemType",
	<%=sourceSystem%>  || "EKKO"."MANDT"                                                                   AS "SourceSystemInstance"
FROM "EKKO" AS "EKKO"
         LEFT JOIN "CTE_Changes" AS "Changes"
                   ON "EKKO"."MANDT" = "Changes"."MANDANT"
                       AND "EKKO"."MANDT" || "EKKO"."EBELN" = "Changes"."TABKEY"
                       AND "Changes"."rn" = 1
         LEFT JOIN "T161T" AS "T161T"
                   ON "EKKO"."MANDT" = "T161T"."MANDT"
                       AND "EKKO"."BSART" = "T161T"."BSART"
                       AND "EKKO"."BSTYP" = "T161T"."BSTYP"
                       AND "T161T"."SPRAS" = <%=LanguageKey%> 
         LEFT JOIN "T001" AS "T001"
                   ON "EKKO"."MANDT" = "T001"."MANDT"
                       AND "EKKO"."BUKRS" = "T001"."BUKRS"
         LEFT JOIN "T024E" AS "T024E"
                   ON "EKKO"."MANDT" = "T024E"."MANDT"
                       AND "EKKO"."EKORG" = "T024E"."EKORG"
         LEFT JOIN "USR02" AS "USR02"
                   ON "EKKO"."MANDT" = "USR02"."MANDT"
                       AND COALESCE("Changes"."USERNAME", "EKKO"."ERNAM") = "USR02"."BNAME"
WHERE "EKKO"."MANDT" IS NOT NULL
  AND "EKKO"."BSTYP" = 'F'



-- ====================================================================================================================================================================




--                ****************************        CDPOS       ***********************************


SELECT <%=sourceSystem%>  || 'PurchaseOrder_' || "CDPOS"."TABKEY" AS "ObjectID",
	<%=sourceSystem%>  || "CDPOS"."TABKEY" || "CDPOS"."TABNAME" || "CDPOS"."FNAME"
       || "CDPOS"."CHANGENR" || "CDPOS"."CHNGIND"                 AS "ID",
       CAST("CDHDR"."UDATE" AS DATE)
            + CAST(TIMESTAMPDIFF(SECOND, CAST("CDHDR"."UTIME" AS DATE),
            "CDHDR"."UTIME") AS INTERVAL SECOND)                  AS "Time",
       CASE
           WHEN "CDPOS"."FNAME" = 'FRGKE' THEN 'ReleaseIndicator'
           WHEN "CDPOS"."FNAME" = 'FRGZU' THEN 'ApprovalLevel'
           WHEN "CDPOS"."FNAME" = 'LIFNR' THEN 'Vendor'
           WHEN "CDPOS"."FNAME" = 'LOEKZ' THEN 'DeletionIndicator'
           WHEN "CDPOS"."FNAME" = 'WAERS' THEN 'Currency'
           WHEN "CDPOS"."FNAME" = 'ZTERM' THEN 'PaymentTerms'
           END                                                    AS "Attribute",
       CASE
           WHEN "CDPOS"."FNAME" = 'FRGZU' THEN
               CASE
                   WHEN TRIM("CDPOS"."VALUE_OLD") IS NULL THEN '0'
                   WHEN TRIM("CDPOS"."VALUE_OLD") = 'X' THEN '1'
                   WHEN TRIM("CDPOS"."VALUE_OLD") = 'XX' THEN '2'
                   WHEN TRIM("CDPOS"."VALUE_OLD") = 'XXX' THEN '3'
                   WHEN TRIM("CDPOS"."VALUE_OLD") = 'XXXX' THEN '4'
                   WHEN TRIM("CDPOS"."VALUE_OLD") = 'XXXXX' THEN '5'
                   WHEN TRIM("CDPOS"."VALUE_OLD") = 'XXXXXX' THEN '6'
                   WHEN TRIM("CDPOS"."VALUE_OLD") = 'XXXXXXX' THEN '7'
                   WHEN TRIM("CDPOS"."VALUE_OLD") = 'XXXXXXXX' THEN '8'
                   END
           WHEN "CDPOS"."VALUE_OLD" LIKE '%-' THEN CONCAT('-', REPLACE(LTRIM("CDPOS"."VALUE_OLD"), '-', ''))
           ELSE "CDPOS"."VALUE_OLD"
           END                                                    AS "OldValue",
       CASE
           WHEN "CDPOS"."FNAME" = 'FRGZU' THEN
               CASE
                   WHEN TRIM("CDPOS"."VALUE_NEW") IS NULL THEN '0'
                   WHEN TRIM("CDPOS"."VALUE_NEW") = 'X' THEN '1'
                   WHEN TRIM("CDPOS"."VALUE_NEW") = 'XX' THEN '2'
                   WHEN TRIM("CDPOS"."VALUE_NEW") = 'XXX' THEN '3'
                   WHEN TRIM("CDPOS"."VALUE_NEW") = 'XXXX' THEN '4'
                   WHEN TRIM("CDPOS"."VALUE_NEW") = 'XXXXX' THEN '5'
                   WHEN TRIM("CDPOS"."VALUE_NEW") = 'XXXXXX' THEN '6'
                   WHEN TRIM("CDPOS"."VALUE_NEW") = 'XXXXXXX' THEN '7'
                   WHEN TRIM("CDPOS"."VALUE_NEW") = 'XXXXXXXX' THEN '8'
                   END
           WHEN "CDPOS"."VALUE_NEW" LIKE '%-' THEN CONCAT('-', REPLACE(LTRIM("CDPOS"."VALUE_NEW"), '-', ''))
           ELSE "CDPOS"."VALUE_NEW"
           END                                                    AS "NewValue",
       'User_' || "CDHDR"."MANDANT" || "CDHDR"."USERNAME"         AS "ChangedBy",
       "CDHDR"."TCODE"                                            AS "OperationType",
       "CDHDR"."CHANGENR"                                         AS "OperationID",
       CASE
           WHEN "USR02"."USTYP" IN ('B', 'C') THEN 'Automatic'
           ELSE 'Manual' END                                      AS "ExecutionType"
FROM "CDPOS" AS "CDPOS"
         LEFT JOIN "CDHDR" AS "CDHDR"
                   ON "CDPOS"."MANDANT" = "CDHDR"."MANDANT"
                       AND "CDPOS"."OBJECTCLAS" = "CDHDR"."OBJECTCLAS"
                       AND "CDPOS"."OBJECTID" = "CDHDR"."OBJECTID"
                       AND "CDPOS"."CHANGENR" = "CDHDR"."CHANGENR"
                       AND "CDPOS"."TABNAME" = 'EKKO'
                       AND "CDPOS"."CHNGIND" = 'U'
                       AND "CDPOS"."FNAME" IN ('FRGKE', 'FRGZU', 'LIFNR', 'LOEKZ', 'WAERS', 'ZTERM')
                       AND "CDPOS"."OBJECTCLAS" = 'EINKBELEG'
         LEFT JOIN "EKKO" AS "EKKO"
                   ON "CDPOS"."TABKEY" = "EKKO"."MANDT" || "EKKO"."EBELN"
         LEFT JOIN "USR02" AS "USR02"
                   ON "CDHDR"."USERNAME" = "USR02"."BNAME"
                       AND "CDHDR"."MANDANT" = "USR02"."MANDT"
WHERE "EKKO"."BSTYP" = 'F'
  AND "CDPOS"."MANDANT" IS NOT NULL
  AND "CDHDR"."MANDANT" IS NOT NULL
  AND "EKKO"."MANDT" IS NOT NULL
