                  *************************************        EBAN        **********************************************

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
                       WHERE "CDPOS"."OBJECTCLAS" = 'BANF'
                         AND "CDPOS"."TABNAME" = 'EBAN'
                         AND "CDPOS"."FNAME" = 'KEY'
                         AND "CDPOS"."CHNGIND" = 'I')
SELECT <%=sourceSystem%>  || 'PurchaseRequisitionItem_' || "EBAN"."MANDT" || "EBAN"."BANFN" || "EBAN"."BNFPO" 		AS "ID",
       COALESCE(
            CAST("Changes"."UDATE" AS DATE)
            + CAST(TIMESTAMPDIFF(SECOND, CAST("Changes"."UTIME" AS DATE), "Changes"."UTIME") AS INTERVAL SECOND),
            CAST("EBAN"."BADAT" AS DATE) + INTERVAL '1' SECOND)                                               		AS "CreationTime",
	<%=sourceSystem%>  || 'User_' || "EBAN"."MANDT" || "EBAN"."ERNAM"                                            	AS "CreatedBy",
       CASE
           WHEN "EBAN"."ESTKZ" = 'B' AND "USR02"."USTYP" IS NULL THEN 'Automatic'
           WHEN "USR02"."USTYP" IN ('B', 'S', 'C') THEN 'Automatic'
           WHEN "USR02"."USTYP" = 'A' THEN 'Manual'
           END                                                                                                AS "CreationExecutionType",
       "EBAN"."LOEKZ"                                                                                         AS "DeletionIndicator",
       "EBAN"."AFNAM"                                                                                         AS "Requester",
	<%=sourceSystem%>  || 'Vendor_' || "EBAN"."MANDT" || "EBAN"."LIFNR"                                       AS "Vendor",
       "EBAN"."WAERS"                                                                                         AS "Currency",
       "EBAN"."PREIS" / COALESCE("EBAN"."PEINH", 1)                                                           AS "NetUnitPrice",
       "EBAN"."MENGE"                                                                                         AS "Quantity",
       "EBAN"."MEINS"                                                                                         AS "QuantityUnit",
       "EBAN"."STATU"                                                                                         AS "ProcessingStatus",
	<%=sourceSystem%>  || 'ContractItem_' || "EBAN"."MANDT" || "EBAN"."KONNR" || "EBAN"."KTPNR"                  AS "ContractItem",
	<%=sourceSystem%>  || 'Material_' || "EBAN"."MANDT" || "EBAN"."MATNR"                                        AS "Material",
	<%=sourceSystem%>  || 'MaterialMasterPlant_' || "EBAN"."MANDT" || "EBAN"."MATNR" || "EBAN"."WERKS"           AS "MaterialMasterPlant",
	<%=sourceSystem%>  || 'Plant_' || "EBAN"."MANDT" || "EBAN"."WERKS"                                           AS "Plant",
       "EBAN"."FRGKZ"                                                                                         AS "ReleaseIndicator",
       "T161U"."FKZTX"                                                                                        AS "ReleaseIndicatorText",
       "EBAN"."TXZ01"                                                                                         AS "ShortText",
       'SAP'                                                                                                  AS "SourceSystemType",
	<%=sourceSystem%>  || "EBAN"."MANDT"                                                                         AS "SourceSystemInstance",
       "EBAN"."BANFN"                                                                                         AS "SystemPurchaseRequisitionNumber",
       "EBAN"."BNFPO"                                                                                         AS "SystemPurchaseRequisitionItemNumber",
       "EBAN"."BANFN"                                                                                         AS "DatabasePurchaseRequisitionNumber",
       "EBAN"."BNFPO"                                                                                         AS "DatabasePurchaseRequisitionItemNumber"
FROM "EBAN" AS "EBAN"
         LEFT JOIN "CTE_Changes" AS "Changes"
                   ON "EBAN"."MANDT" = "Changes"."MANDANT"
                       AND "EBAN"."MANDT" || "EBAN"."BANFN" || "EBAN"."BNFPO" = "Changes"."TABKEY"
                       AND "Changes"."rn" = 1
         LEFT JOIN "T161U" AS "T161U"
                   ON "EBAN"."MANDT" = "T161U"."MANDT"
                       AND "EBAN"."FRGKZ" = "T161U"."FRGKZ"
                       AND "T161U"."SPRAS" = <%=LanguageKey%> 
         LEFT JOIN "USR02" AS "USR02"
                   ON "EBAN"."MANDT" = "USR02"."MANDT"
                       AND "EBAN"."ERNAM" = "USR02"."BNAME"
WHERE "EBAN"."MANDT" IS NOT NULL
  AND "EBAN"."BSTYP" = 'B'


==================================================================================================================================================================


--                        **********************          CDPOS           ******************************

SELECT <%=sourceSystem%>  || 'PurchaseRequisitionItem_' || "CDPOS"."TABKEY" AS "ObjectID",
	<%=sourceSystem%>  || "CDPOS"."TABKEY" || "CDPOS"."TABNAME" || "CDPOS"."FNAME"
       || "CDPOS"."CHANGENR" || "CDPOS"."CHNGIND"                           AS "ID",
       CAST("CDHDR"."UDATE" AS DATE)
            + CAST(TIMESTAMPDIFF(SECOND, CAST("CDHDR"."UTIME" AS DATE),
            "CDHDR"."UTIME") AS INTERVAL SECOND)                            AS "Time",
       CASE
           WHEN "CDPOS"."FNAME" = 'FRGKZ' THEN 'ReleaseIndicator'
           WHEN "CDPOS"."FNAME" = 'LOEKZ' THEN 'DeletionIndicator'
           END                                                              AS "Attribute",
       CASE
           WHEN "CDPOS"."VALUE_OLD" LIKE '%-' THEN CONCAT('-', REPLACE(LTRIM("CDPOS"."VALUE_OLD"), '-', ''))
           ELSE "CDPOS"."VALUE_OLD"
           END                                                              AS "OldValue",
       CASE
           WHEN "CDPOS"."VALUE_NEW" LIKE '%-' THEN CONCAT('-', REPLACE(LTRIM("CDPOS"."VALUE_NEW"), '-', ''))
           ELSE "CDPOS"."VALUE_NEW"
           END                                                              AS "NewValue",
       'User_' || "CDHDR"."MANDANT" || "CDHDR"."USERNAME"                   AS "ChangedBy",
       "CDHDR"."TCODE"                                                      AS "OperationType",
       "CDHDR"."CHANGENR"                                                   AS "OperationID",
       CASE
           WHEN "USR02"."USTYP" IN ('B', 'C') THEN 'Automatic'
           ELSE 'Manual' END                                                AS "ExecutionType"
FROM "CDPOS" AS "CDPOS"
         LEFT JOIN "CDHDR" AS "CDHDR"
                   ON "CDPOS"."MANDANT" = "CDHDR"."MANDANT"
                       AND "CDPOS"."OBJECTCLAS" = "CDHDR"."OBJECTCLAS"
                       AND "CDPOS"."OBJECTID" = "CDHDR"."OBJECTID"
                       AND "CDPOS"."CHANGENR" = "CDHDR"."CHANGENR"
                       AND "CDPOS"."TABNAME" = 'EBAN'
                       AND "CDPOS"."CHNGIND" = 'U'
                       AND "CDPOS"."OBJECTCLAS" = 'BANF'
                       AND ("CDPOS"."FNAME" IN ('FRGKZ', 'LOEKZ')
                           OR "CDHDR"."TCODE" IN ('ME59', 'ME59N'))
         LEFT JOIN "EBAN" AS "EBAN"
                   ON "CDPOS"."TABKEY" = "EBAN"."MANDT" || "EBAN"."BANFN" || "EBAN"."BNFPO"
         LEFT JOIN "USR02" AS "USR02"
                   ON "CDHDR"."USERNAME" = "USR02"."BNAME"
                       AND "CDHDR"."MANDANT" = "USR02"."MANDT"
WHERE "EBAN"."BSTYP" = 'B'
  AND "CDPOS"."MANDANT" IS NOT NULL
  AND "CDHDR"."MANDANT" IS NOT NULL
  AND "EBAN"."MANDT" IS NOT NULL
