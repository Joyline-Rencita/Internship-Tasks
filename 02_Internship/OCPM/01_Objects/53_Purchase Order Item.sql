                  ***********************      EKPO      ***************************

WITH "CTE_Changes_EKPO" AS (SELECT "CDPOS"."MANDANT",
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
                             AND "CDPOS"."CHNGIND" = 'I'),
    "CTE_Changes_EKKO" AS (SELECT "CDPOS"."MANDANT",
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
SELECT <%=sourceSystem%>  || 'PurchaseOrderItem_' || "EKPO"."MANDT" || "EKPO"."EBELN" || "EKPO"."EBELP" ``AS "ID",
       COALESCE(
            CAST("Changes_EKPO"."UDATE" AS DATE) + CAST(TIMESTAMPDIFF(SECOND, CAST("Changes_EKPO"."UTIME" AS DATE), "Changes_EKPO"."UTIME") AS INTERVAL SECOND),
            CAST("Changes_EKKO"."UDATE" AS DATE) + CAST(TIMESTAMPDIFF(SECOND, CAST("Changes_EKKO"."UTIME" AS DATE), "Changes_EKKO"."UTIME") AS INTERVAL SECOND),
            CAST("EKKO"."AEDAT" AS DATE) + INTERVAL '1' SECOND)                                         	AS "CreationTime",
       "EKPO"."LOEKZ"                                                                                   	AS "DeletionIndicator",
	<%=sourceSystem%>  || 'User_' || "EKPO"."MANDT" || COALESCE("Changes_EKPO"."USERNAME", "Changes_EKKO"."USERNAME",
                                             "EKKO"."ERNAM")                                            	AS "CreatedBy",
       CASE
           WHEN "USR02"."USTYP" IN ('B', 'C') THEN 'Automatic'
           ELSE 'Manual' END                                                                            	AS "CreationExecutionType",
	<%=sourceSystem%>  || 'PurchaseOrder_' || "EKPO"."MANDT" || "EKPO"."EBELN"                             	AS "Header",
       "EKPO"."NETWR"                                                                                   	AS "NetAmount",
       "EKPO"."NETPR" / COALESCE("EKPO"."PEINH", 1)                                                     	AS "NetUnitPrice",
       "EKPO"."MENGE"                                                                                   	AS "Quantity",
       "EKPO"."MEINS"                                                                                   	AS "QuantityUnit",
	<%=sourceSystem%>  || 'ContractItem_' || "EKPO"."MANDT" || "EKPO"."KONNR" || "EKPO"."KTPNR"            	AS "ContractItem",
	<%=sourceSystem%>  || 'MaterialMasterPlant_' || "EKPO"."MANDT" || "EKPO"."MATNR"
       || "EKPO"."WERKS"                                                                                	AS "MaterialMasterPlant",
	<%=sourceSystem%>  || 'Material_' || "EKPO"."MANDT" || "EKPO"."MATNR"                                  	AS "Material",
       "EKPO"."TXZ01"                                                                                   	AS "ShortText",
       "EKPO"."WEPOS"                                                                                   	AS "GoodsReceiptIndicator",
       "EKPO"."BUKRS"                                                                                   	AS "CompanyCode",
       "T001"."BUTXT"                                                                                   	AS "CompanyCodeText",
       "EKPO"."BPRME"                                                                                   	AS "ExternalQuantityUnit",
       CAST("EKPO"."DPDAT" AS TIMESTAMP)                                                                	AS "DownPaymentDueDate",
	<%=sourceSystem%>  || 'User_' || "EKPO"."AFNAM"                                                        	AS "RequestedBy",
       "EKPO"."REPOS"                                                                                   	AS "InvoiceReceiptIndicator",
       CAST("EKPO"."AEDAT" AS TIMESTAMP)                                                                	AS "ChangeDate",
	<%=sourceSystem%>  || 'Plant_' || "EKPO"."MANDT" || "EKPO"."WERKS"                                     	AS "Plant",
       "EKPO"."KONNR"                                                                                   	AS "SystemContractNumber",
       "EKPO"."KTPNR"                                                                                   	AS "SystemContractItemNumber",
       "EKPO"."EBELN"                                                                                   	AS "SystemPurchaseOrderNumber",
       "EKPO"."EBELP"                                                                                   	AS "SystemPurchaseOrderItemNumber",
       "EKPO"."KONNR"                                                                                   	AS "DatabaseContractNumber",
       "EKPO"."KTPNR"                                                                                   	AS "DatabaseContractItemNumber",
       "EKPO"."EBELN"                                                                                   	AS "DatabasePurchaseOrderNumber",
       "EKPO"."EBELP"                                                                                   	AS "DatabasePurchaseOrderItemNumber",
       "EKKO"."WAERS"                                                                                   	AS "Currency",
       'SAP'                                                                                            	AS "SourceSystemType",
	<%=sourceSystem%>  || "EKPO"."MANDT"                                                                   	AS "SourceSystemInstance",
       "T161T"."BATXT"                                                                                  	AS "PurchasingDocumentType",
       CAST("EKPO"."UEBTO" AS VARCHAR(255))                                                             	AS "ToleranceLimit",
       "EKPO"."WEBRE"                                                                                   	AS "InvoiceAfterGoodsReceiptIndicator"
FROM "EKPO" AS "EKPO"
         LEFT JOIN "EKKO" AS "EKKO"
                   ON "EKPO"."MANDT" = "EKKO"."MANDT"
                       AND "EKPO"."EBELN" = "EKKO"."EBELN"
         LEFT JOIN "CTE_Changes_EKPO" AS "Changes_EKPO"
                   ON "EKKO"."MANDT" = "Changes_EKPO"."MANDANT"
                       AND "EKPO"."MANDT" || "EKPO"."EBELN" || "EKPO"."EBELP" = "Changes_EKPO"."TABKEY"
                       AND "Changes_EKPO"."rn" = 1
         LEFT JOIN "CTE_Changes_EKKO" AS "Changes_EKKO"
                   ON "EKKO"."MANDT" = "Changes_EKKO"."MANDANT"
                       AND "EKKO"."MANDT" || "EKKO"."EBELN" = "Changes_EKKO"."TABKEY"
                       AND "Changes_EKKO"."rn" = 1
         LEFT JOIN "T001" AS "T001"
                   ON "EKPO"."MANDT" = "T001"."MANDT"
                       AND "EKPO"."BUKRS" = "T001"."BUKRS"
         LEFT JOIN "USR02" AS "USR02"
                   ON "EKKO"."MANDT" = "USR02"."MANDT"
                       AND COALESCE("Changes_EKPO"."USERNAME", "Changes_EKKO"."USERNAME", "EKKO"."ERNAM") = "USR02"."BNAME"
         LEFT JOIN "T024E" AS "T024E"
                   ON "EKKO"."MANDT" = "T024E"."MANDT"
                       AND "EKKO"."EKORG" = "T024E"."EKORG"
         LEFT JOIN "T161T" AS "T161T"
                   ON "EKKO"."MANDT" = "T161T"."MANDT"
                       AND "EKKO"."BSART" = "T161T"."BSART"
                       AND "EKKO"."BSTYP" = "T161T"."BSTYP"
                       AND "T161T"."SPRAS" = <%=LanguageKey%> 
WHERE "EKPO"."MANDT" IS NOT NULL
  AND "EKPO"."BSTYP" = 'F'


===================================================================================================================================================================


                              **********************        CDPOS      *************************


SELECT <%=sourceSystem%>  || 'PurchaseOrderItem_' || "CDPOS"."TABKEY" AS "ObjectID",
	<%=sourceSystem%>  || "CDPOS"."TABKEY" || "CDPOS"."TABNAME" || "CDPOS"."FNAME"
       || "CDPOS"."CHANGENR" || "CDPOS"."CHNGIND"                     AS "ID",
       CAST("CDHDR"."UDATE" AS DATE)
            + CAST(TIMESTAMPDIFF(SECOND, CAST("CDHDR"."UTIME" AS DATE),
            "CDHDR"."UTIME") AS INTERVAL SECOND)                      AS "Time",
       CASE
           WHEN "CDPOS"."FNAME" = 'ABSKZ' THEN 'RejectionIndicator'
           WHEN "CDPOS"."FNAME" = 'EGLKZ' THEN 'OutwardDeliveryIndicator'
           WHEN "CDPOS"."FNAME" = 'ELIKZ' THEN 'DeliveryIndicator'
           WHEN "CDPOS"."FNAME" = 'EREKZ' THEN 'FinalInvoiceIndicator'
           WHEN "CDPOS"."FNAME" = 'LGORT' THEN 'StorageLocation'
           WHEN "CDPOS"."FNAME" = 'LOEKZ' THEN 'DeletionIndicator'
           WHEN "CDPOS"."FNAME" = 'MATKL' THEN 'MaterialGroup'
           WHEN "CDPOS"."FNAME" = 'MATNR' THEN 'MaterialNumber'
           WHEN "CDPOS"."FNAME" = 'MENGE' THEN 'Quantity'
           WHEN "CDPOS"."FNAME" = 'NETPR' THEN 'NetUnitPrice'
           WHEN "CDPOS"."FNAME" = 'LABNR' THEN 'OrderAcknowledgmentNumber'
           WHEN "CDPOS"."FNAME" = 'KONNR' THEN 'SystemContractNumber'
           WHEN "CDPOS"."FNAME" = 'KTPNR' THEN 'SystemContractItemNumber'
           WHEN "CDPOS"."FNAME" = 'TXZ01' THEN 'ShortText'
           END                                                        AS "Attribute",
       CASE
           WHEN "CDPOS"."VALUE_OLD" LIKE '%-' THEN CONCAT('-', REPLACE(LTRIM("CDPOS"."VALUE_OLD"), '-', ''))
           ELSE "CDPOS"."VALUE_OLD"
           END                                                        AS "OldValue",
       CASE
           WHEN "CDPOS"."VALUE_NEW" LIKE '%-' THEN CONCAT('-', REPLACE(LTRIM("CDPOS"."VALUE_NEW"), '-', ''))
           ELSE "CDPOS"."VALUE_NEW"
           END                                                        AS "NewValue",
       'User_' || "CDHDR"."MANDANT" || "CDHDR"."USERNAME"             AS "ChangedBy",
       "CDHDR"."TCODE"                                                AS "OperationType",
       "CDHDR"."CHANGENR"                                             AS "OperationID",
       CASE
           WHEN "USR02"."USTYP" IN ('B', 'C') THEN 'Automatic'
           ELSE 'Manual' END                                          AS "ExecutionType"
FROM "CDPOS" AS "CDPOS"
         LEFT JOIN "CDHDR" AS "CDHDR"
                   ON "CDPOS"."MANDANT" = "CDHDR"."MANDANT"
                       AND "CDPOS"."OBJECTCLAS" = "CDHDR"."OBJECTCLAS"
                       AND "CDPOS"."OBJECTID" = "CDHDR"."OBJECTID"
                       AND "CDPOS"."CHANGENR" = "CDHDR"."CHANGENR"
                       AND "CDPOS"."CHNGIND" = 'U'
                       AND "CDPOS"."TABNAME" = 'EKPO'
                       AND "CDPOS"."OBJECTCLAS" = 'EINKBELEG'
         LEFT JOIN "USR02" AS "USR02"
                   ON "CDHDR"."USERNAME" = "USR02"."BNAME"
                       AND "CDHDR"."MANDANT" = "USR02"."MANDT"
WHERE "CDPOS"."FNAME" IN ('ABSKZ', 'EGLKZ', 'ELIKZ', 'EREKZ', 'LABNR', 'LGORT', 'LOEKZ', 'MATKL', 'MATNR', 'MENGE',
                          'NETPR', 'KONNR', 'KTPNR', 'TXZ01')
  AND "CDPOS"."MANDANT" IS NOT NULL
  AND "CDHDR"."MANDANT" IS NOT NULL


==================================================================================================================================================================


                    RELATIONSHIPS :  RECOMMENDED MATERIAL CONTRACT ITEMS  -> EKPO(2)

WITH "CTE_TMP_MaterialContractItem" AS
         (SELECT "EKPO"."MANDT" || "EKPO"."EBELN" || "EKPO"."EBELP"    AS "ID",
                 "EKPO"."MANDT",
                 "EKPO"."WERKS",
                 "EKKO"."WAERS",
                 "EKPO"."MATNR",
                 ROW_NUMBER() OVER (PARTITION BY "EKPO"."MANDT", "EKPO"."WERKS", "EKKO"."WAERS", "EKPO"."MATNR"
                     ORDER BY "EKKO"."KDATE" DESC, "EKPO"."NETPR" ASC) AS "rn"
          FROM "EKPO" AS "EKPO"
                   LEFT JOIN "EKKO" AS "EKKO"
                             ON "EKPO"."MANDT" = "EKKO"."MANDT"
                                 AND "EKPO"."EBELN" = "EKKO"."EBELN"
          WHERE "EKPO"."BSTYP" = 'K')
SELECT <%=sourceSystem%>  || 'PurchaseOrderItem_' || "EKPO"."MANDT" || "EKPO"."EBELN" || "EKPO"."EBELP" AS "ID",
	<%=sourceSystem%>  || 'ContractItem_' || "MaterialContractItem"."ID"                                   AS "RecommendedMaterialContractItems"
FROM "EKPO" AS "EKPO"
         LEFT JOIN "EKKO" AS "EKKO"
                   ON "EKPO"."MANDT" = "EKKO"."MANDT"
                       AND "EKPO"."EBELN" = "EKKO"."EBELN"
         LEFT JOIN "CTE_TMP_MaterialContractItem" AS "MaterialContractItem"
                    ON "EKPO"."WERKS" = "MaterialContractItem"."WERKS"
                        AND "EKKO"."WAERS" = "MaterialContractItem"."WAERS"
                        AND "EKPO"."MATNR" = "MaterialContractItem"."MATNR"
                        AND "MaterialContractItem"."rn" < 6
WHERE "EKPO"."BSTYP" = 'F'
  AND "EKPO"."MANDT" IS NOT NULL
  AND "MaterialContractItem"."MANDT" IS NOT NULL


================================================================================================================================================================
								
								RELATIONSHIPS :  RECOMMENDED MATERIAL CONTRACT ITEMS  -> EKPO(1)


WITH "CTE_TMP_MaterialContract" AS
         (SELECT "EKPO"."MANDT" || "EKPO"."EBELN"                      		AS "ID",
                 "EKPO"."MANDT",
                 "EKPO"."WERKS",
                 "EKKO"."WAERS",
                 "EKPO"."MATNR",
                 ROW_NUMBER() OVER (PARTITION BY "EKPO"."MANDT", "EKPO"."WERKS", "EKKO"."WAERS", "EKPO"."MATNR"
                     ORDER BY "EKKO"."KDATE" DESC, "EKPO"."NETPR" ASC) AS "rn"
          FROM "EKPO" AS "EKPO"
                   LEFT JOIN "EKKO" AS "EKKO"
                             ON "EKPO"."MANDT" = "EKKO"."MANDT"
                                 AND "EKPO"."EBELN" = "EKKO"."EBELN"
          WHERE "EKPO"."BSTYP" = 'K')
SELECT DISTINCT <%=sourceSystem%>  || 'PurchaseOrderItem_' || "EKPO"."MANDT" || "EKPO"."EBELN" || "EKPO"."EBELP" AS "ID",
	<%=sourceSystem%>  || 'Contract_' || "TMP_MaterialContract"."ID"         AS "RecommendedMaterialContracts"
FROM "EKPO" AS "EKPO"
         LEFT JOIN "EKKO" 	AS "EKKO"
                   ON "EKPO"."MANDT" = "EKKO"."MANDT"
                       AND "EKPO"."EBELN" = "EKKO"."EBELN"
         LEFT JOIN "CTE_TMP_MaterialContract" 		AS "TMP_MaterialContract"
                    ON "EKPO"."WERKS" = "TMP_MaterialContract"."WERKS"
                        AND "EKKO"."WAERS" = "TMP_MaterialContract"."WAERS"
                        AND "EKPO"."MATNR" = "TMP_MaterialContract"."MATNR"
                        AND "TMP_MaterialContract"."rn" < 6
WHERE "EKPO"."BSTYP" = 'F'
  AND "EKPO"."MANDT" IS NOT NULL
  AND "TMP_MaterialContract"."MANDT" IS NOT NULL
