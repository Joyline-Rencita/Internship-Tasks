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
                         AND "CDPOS"."TABNAME" = 'EKPO'
                         AND "CDPOS"."FNAME" = 'KEY'
                         AND "CDPOS"."CHNGIND" = 'I')
SELECT <%=sourceSystem%>  || 'ContractItem_' || "EKPO"."MANDT" || "EKPO"."EBELN" || "EKPO"."EBELP" AS "ID",
       CAST("Changes"."UDATE" AS DATE)
            + CAST(TIMESTAMPDIFF(SECOND, CAST("Changes"."UTIME" AS DATE),
            "Changes"."UTIME") AS INTERVAL SECOND)                                                 AS "CreationTime",
	<%=sourceSystem%>  || 'User_' || "Changes"."MANDANT" || "Changes"."USERNAME"                      AS "CreatedBy",
       CASE
           WHEN "USR02"."USTYP" IN ('B', 'C') THEN 'Automatic'
           ELSE 'Manual' END                                                                       AS "CreationExecutionType",
       "EKPO"."LOEKZ"                                                                              AS "DeletionIndicator",
       "EKPO"."BUKRS"                                                                              AS "CompanyCode",
       "T001"."BUTXT"                                                                              AS "CompanyCodeText",
       "EKPO"."KTMNG"                                                                              AS "TargetQuantity",
       "EKPO"."MEINS"                                                                              AS "QuantityUnit",
       "EKPO"."ZWERT"                                                                              AS "DocumentOutlineAgreementTargetAmount",
       "EKPO"."NETPR" / COALESCE("EKPO"."PEINH", 1)                                                AS "NetUnitPrice",
       "EKPO"."TXZ01"                                                                              AS "ShortText",
       "EKKO"."WAERS"                                                                              AS "Currency",
       "EKKO"."ZTERM"                                                                              AS "PaymentTerms",
       CAST("EKKO"."KDATB" AS TIMESTAMP)                                                           AS "ValidityPeriodStartDate",
       CAST("EKKO"."KDATE" AS TIMESTAMP)                                                           AS "ValidityPeriodEndDate",
       'SAP'                                                                                       AS "SourceSystemType",
	<%=sourceSystem%>  || "EKPO"."MANDT"                                                              AS "SourceSystemInstance",
       "EKPO"."EBELN"                                                                              AS "SystemContractNumber",
       "EKPO"."EBELP"                                                                              AS "SystemContractItemNumber",
       "EKPO"."EBELN"                                                                              AS "DatabaseContractNumber",
       "EKPO"."EBELP"                                                                              AS "DatabaseContractItemNumber",
	<%=sourceSystem%>  || 'Contract_' || "EKPO"."MANDT" || "EKPO"."EBELN"                             AS "Header",
	<%=sourceSystem%>  || 'Material_' || "EKPO"."MANDT" || "EKPO"."MATNR"                             AS "Material",
	<%=sourceSystem%>  || 'MaterialMasterPlant_' || "EKPO"."MANDT" || "EKPO"."MATNR"
           || "EKPO"."WERKS"                                                                       AS "MaterialMasterPlant",
	<%=sourceSystem%>  || 'Plant_' || "EKPO"."MANDT" || "EKPO"."WERKS"                                AS "Plant",
	<%=sourceSystem%>  || 'Vendor_' || "EKKO"."MANDT" || "EKKO"."LIFNR"                               AS "Vendor",
	<%=sourceSystem%>  || 'VendorMasterCompanyCode_' || "EKKO"."MANDT"
       || "EKKO"."LIFNR" || "EKKO"."BUKRS"                                                         AS "VendorMasterCompanyCode"
FROM "EKPO" AS "EKPO"
         LEFT JOIN "EKKO" AS "EKKO"
                   ON "EKPO"."MANDT" = "EKKO"."MANDT"
                       AND "EKPO"."EBELN" = "EKKO"."EBELN"
         LEFT JOIN "CTE_Changes" AS "Changes"
                   ON "EKKO"."MANDT" = "Changes"."MANDANT"
                       AND "EKPO"."MANDT" || "EKPO"."EBELN" || "EKPO"."EBELP" = "Changes"."TABKEY"
                       AND "Changes"."rn" = 1
         LEFT JOIN "USR02" AS "USR02"
                   ON "Changes"."MANDANT" = "USR02"."MANDT"
                       AND "Changes"."USERNAME" = "USR02"."BNAME"
         LEFT JOIN "T001" AS "T001"
                   ON "EKPO"."MANDT" = "T001"."MANDT"
                       AND "EKPO"."BUKRS" = "T001"."BUKRS"
WHERE "EKPO"."MANDT" IS NOT NULL
  AND "EKPO"."BSTYP" = 'K'
