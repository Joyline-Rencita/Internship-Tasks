                      *****************************         EKKO      ******************************

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
SELECT <%=sourceSystem%>  || 'PurchaseOrder_' || "EKKO"."MANDT" || "EKKO"."EBELN"                        AS "ID",
       COALESCE(
            CAST("Changes"."UDATE" AS DATE)
            + CAST(TIMESTAMPDIFF(SECOND, CAST("Changes"."UTIME" AS DATE),
            "Changes"."UTIME") AS INTERVAL SECOND),
            CAST("EKKO"."AEDAT" AS DATE) + INTERVAL '1' SECOND)                                          AS "CreationTime",
	<%=sourceSystem%>  || 'User_' || "EKKO"."MANDT" || COALESCE("Changes"."USERNAME", "EKKO"."ERNAM")      AS "CreatedBy",
       CASE
           WHEN "USR02"."USTYP" IN ('B', 'C') THEN 'Automatic'
           ELSE 'Manual' END                                                                             AS "CreationExecutionType",
       "EKKO"."LOEKZ"                                                                                    AS "DeletionIndicator",
	<%=sourceSystem%>  || 'Vendor_' || "EKKO"."MANDT" || "EKKO"."LIFNR"                                    AS "Vendor",
	<%=sourceSystem%>  || 'VendorMasterCompanyCode_' || "EKKO"."MANDT" || "EKKO"."LIFNR" || "EKKO"."BUKRS" AS "VendorMasterCompanyCode",
       "EKKO"."WAERS"                                                                                    AS "Currency",
       "EKKO"."ZTERM"                                                                                    AS "PaymentTerms",
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
	<%=sourceSystem%>  || "EKKO"."MANDT"                                                                  AS "SourceSystemInstance"
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


==================================================================================================================================================================


