          ****************************    VBAK    *****************************

SELECT <%=sourceSystem%>  || 'SalesOrder_' || "VBAK"."MANDT" || "VBAK"."VBELN" AS "ID",
    CAST("VBAK"."ERDAT" AS DATE)
            + CAST(TIMESTAMPDIFF(SECOND, CAST("VBAK"."ERZET" AS DATE),
            "VBAK"."ERZET") AS INTERVAL SECOND)                                AS "CreationTime",
	<%=sourceSystem%>  || 'User_' || "VBAK"."MANDT" || "VBAK"."ERNAM"             AS "CreatedBy",
    CASE
        WHEN "USR02"."USTYP" IN ('B', 'C') THEN 'Automatic'
        ELSE 'Manual' END                                                      AS "CreationExecutionType",
    "VBAK"."OBJNR"                                                             AS "ObjectNumber",
    "VBAK"."AUART"                                                             AS "SalesDocumentType",
    "TVAKT"."BEZEI"                                                            AS "SalesDocumentTypeText",
    "VBAK"."BUKRS_VF"                                                          AS "CompanyCode",
    "T001"."BUTXT"                                                             AS "CompanyCodeText",
	<%=sourceSystem%>  || 'Customer_' || "VBAK"."MANDT" || "VBAK"."KUNNR"         AS "Customer",
    "VBUK"."GBSTK"                                                             AS "OverallProcessingStatus",
    "VBUK"."BESTK"                                                             AS "OrderConfirmationStatus",
    "VBAK"."VSBED"                                                             AS "ShippingDetails",
    "TVSBT"."VTEXT"                                                            AS "ShippingDetailsText",
    CASE
        WHEN "VBKD"."INCO2" IS NOT NULL
            THEN "VBKD"."INCO1" || '_' || "VBKD"."INCO2"
        ELSE "VBKD"."INCO1" END                                                AS "FreightTerms",
    "VBKD"."ZTERM"                                                             AS "PaymentTerms",
    "VBAK"."VKORG"                                                             AS "SalesOrganization",
    "TVKOT"."VTEXT"                                                            AS "SalesOrganizationText",
    "VBAK"."VTWEG"                                                             AS "DistributionChannel",
    "TVTWT"."VTEXT"                                                            AS "DistributionChannelText",
    "VBAK"."VKBUR"                                                             AS "SalesOffice",
    "TVKBT"."BEZEI"                                                            AS "SalesOfficeText",
	<%=sourceSystem%>  || 'CustomerMasterCreditManagement_' || "VBAK"."MANDT" || "VBAK"."KUNNR"
    || "VBAK"."KKBER"                                                          AS "CreditManagement",
    "VBAK"."NETWR"                                                             AS "NetAmount",
    "VBAK"."WAERK"                                                             AS "Currency",
    "VBAK"."VBTYP"                                                             AS "DocumentCategory",
    "DD07T_VBTYP"."DDTEXT"                                                     AS "DocumentCategoryText",
    "VBAK"."VBELN"                                                             AS "SystemSalesOrderNumber",
    "VBAK"."VBELN"                                                             AS "DatabaseSalesOrderNumber",
    CAST("VBAK"."VDATU" AS TIMESTAMP)                                          AS "RequestedDeliveryDate",
    'SAP'                                                                      AS "SourceSystemType",
	<%=sourceSystem%>  || "VBAK"."MANDT"                                          AS "SourceSystemInstance",
    "VBAK"."BSTNK"                                                             AS "ExternalPurchaseOrderNumber",
    CAST("VBAK"."BSTDK" AS TIMESTAMP)                                          AS "ExternalPurchaseOrderDate"
FROM "VBAK" AS "VBAK"
         LEFT JOIN "VBUK" AS "VBUK"
                   ON "VBAK"."MANDT" = "VBUK"."MANDT"
                       AND "VBAK"."VBELN" = "VBUK"."VBELN"
         LEFT JOIN "VBKD" AS "VBKD"
                   ON "VBAK"."MANDT" = "VBKD"."MANDT"
                       AND "VBAK"."VBELN" = "VBKD"."VBELN"
                       AND "VBKD"."POSNR" = '000000'
         LEFT JOIN "T001" AS "T001"
                   ON "VBAK"."MANDT" = "T001"."MANDT"
                       AND "VBAK"."BUKRS_VF" = "T001"."BUKRS"
         LEFT JOIN "TVAKT" AS "TVAKT"
                   ON "VBAK"."MANDT" = "TVAKT"."MANDT"
                       AND "VBAK"."AUART" = "TVAKT"."AUART"
                       AND "TVAKT"."SPRAS" = <%=LanguageKey%> 
         LEFT JOIN "TVKOT" AS "TVKOT"
                   ON "VBAK"."MANDT" = "TVKOT"."MANDT"
                       AND "VBAK"."VKORG" = "TVKOT"."VKORG"
                       AND "TVKOT"."SPRAS" = <%=LanguageKey%> 
         LEFT JOIN "TVTWT" AS "TVTWT"
                   ON "VBAK"."MANDT" = "TVTWT"."MANDT"
                       AND "VBAK"."VTWEG" = "TVTWT"."VTWEG"
                       AND "TVTWT"."SPRAS" = <%=LanguageKey%> 
         LEFT JOIN "TVKBT" AS "TVKBT"
                   ON "VBAK"."MANDT" = "TVKBT"."MANDT"
                       AND "VBAK"."VKBUR" = "TVKBT"."VKBUR"
                       AND "TVKBT"."SPRAS" = <%=LanguageKey%> 
         LEFT JOIN "TVAK" AS "TVAK"
                   ON "VBAK"."MANDT" = "TVAK"."MANDT"
                       AND "VBAK"."AUART" = "TVAK"."AUART"
         LEFT JOIN "DD07T" AS "DD07T_KLIMP"
                   ON "TVAK"."KLIMP" = "DD07T_KLIMP"."DOMVALUE_L"
                       AND "DD07T_KLIMP"."DOMNAME" = 'KLIMP'
                       AND "DD07T_KLIMP"."DDLANGUAGE" = <%=LanguageKey%> 
         LEFT JOIN "USR02" AS "USR02"
                   ON "VBAK"."MANDT" = "USR02"."MANDT"
                       AND "VBAK"."ERNAM" = "USR02"."BNAME"
         LEFT JOIN "DD07T" AS "DD07T_VBTYP"
                   ON "VBAK"."VBTYP" = "DD07T_VBTYP"."DOMVALUE_L"
                       AND "DD07T_VBTYP"."DOMNAME" = 'VBTYP'
                       AND "DD07T_VBTYP"."DDLANGUAGE" = <%=LanguageKey%> 
         LEFT JOIN "TVSBT" AS "TVSBT"
                   ON "VBAK"."MANDT" = "TVSBT"."MANDT"
                       AND "VBAK"."VSBED" = "TVSBT"."VSBED"
                       AND "TVSBT"."SPRAS" = <%=LanguageKey%> 
WHERE "VBAK"."MANDT" IS NOT NULL
  AND "VBAK"."VBTYP" IN ('C', 'I')

==================================================================================================================================================================


                    *************************        CDPOS      *****************************


SELECT <%=sourceSystem%>  || 'SalesOrder_' || "CDPOS"."TABKEY" AS "ObjectID",
	<%=sourceSystem%>  || "CDPOS"."TABKEY" || "CDPOS"."TABNAME" || "CDPOS"."FNAME"
       || "CDPOS"."CHANGENR" || "CDPOS"."CHNGIND"              AS "ID",
       CAST("CDHDR"."UDATE" AS DATE)
            + CAST(TIMESTAMPDIFF(SECOND, CAST("CDHDR"."UTIME" AS DATE),
            "CDHDR"."UTIME") AS INTERVAL SECOND)               AS "Time",
       CASE
           WHEN "CDPOS"."FNAME" = 'VDATU' THEN 'RequestedDeliveryDate'
           END                                                 AS "Attribute",
       CASE
           WHEN "CDPOS"."VALUE_OLD" LIKE '%-' THEN CONCAT('-', REPLACE(LTRIM("CDPOS"."VALUE_OLD"), '-', ''))
           ELSE "CDPOS"."VALUE_OLD" END                        AS "OldValue",
       CASE
           WHEN "CDPOS"."VALUE_NEW" LIKE '%-' THEN CONCAT('-', REPLACE(LTRIM("CDPOS"."VALUE_NEW"), '-', ''))
           ELSE "CDPOS"."VALUE_NEW" END                        AS "NewValue",
       'User_' || "CDHDR"."MANDANT" || "CDHDR"."USERNAME"      AS "ChangedBy",
       "CDHDR"."TCODE"                                         AS "OperationType",
       "CDHDR"."CHANGENR"                                      AS "OperationID",
       CASE
           WHEN "USR02"."USTYP" IN ('B', 'C') THEN 'Automatic'
           ELSE 'Manual' END                                   AS "ExecutionType"
FROM "CDPOS" AS "CDPOS"
         LEFT JOIN "CDHDR" AS "CDHDR" ON
    "CDPOS"."MANDANT" = "CDHDR"."MANDANT"
    AND "CDPOS"."OBJECTCLAS" = "CDHDR"."OBJECTCLAS"
    AND "CDPOS"."OBJECTID" = "CDHDR"."OBJECTID"
    AND "CDPOS"."CHANGENR" = "CDHDR"."CHANGENR"
        AND "CDPOS"."OBJECTCLAS" = 'VERKBELEG'
         LEFT JOIN "USR02" AS "USR02"
                   ON "CDHDR"."USERNAME" = "USR02"."BNAME"
                       AND "CDHDR"."MANDANT" = "USR02"."MANDT"
WHERE "CDPOS"."CHNGIND" = 'U'
  AND "CDPOS"."TABNAME" = 'VBAK'
  AND "CDPOS"."FNAME" IN ('VDATU')
  AND "CDPOS"."MANDANT" IS NOT NULL
  AND "CDHDR"."MANDANT" IS NOT NULL

=================================================================================================================================================================


							***************************		JCDS		*******************************


SELECT <%=sourceSystem%>  || 'SalesOrder_' || "VBAK"."MANDT" || "VBAK"."VBELN"                     AS "ObjectID",
	<%=sourceSystem%>  || "VBAK"."VBELN" || "JCDS"."MANDT" || "JCDS"."OBJNR"
       || "JCDS"."STAT" || "JCDS"."CHGNR"                                                          AS "ID",
       CAST("JCDS"."UDATE" AS DATE)
            + CAST(TIMESTAMPDIFF(SECOND, CAST("JCDS"."UTIME" AS DATE),
            "JCDS"."UTIME") AS INTERVAL SECOND)                                                    AS "Time",
       'DocumentStatus'                                                                            AS "Attribute",
       LAG("JCDS"."STAT", 1, NULL)
       OVER (PARTITION BY "JCDS"."OBJNR", "JCDS"."STAT"
           ORDER BY "JCDS"."OBJNR", "JCDS"."STAT", "JCDS"."CHGNR", "JCDS"."UDATE", "JCDS"."UTIME") AS "OldValue",
       "JCDS"."STAT"                                                                               AS "NewValue",
       'User_' || "JCDS"."USNAM"                                                                   AS "ChangedBy",
       "JCDS"."CDTCODE"                                                                            AS "OperationType",
       CAST("JCDS"."CHGNR" AS VARCHAR)                                                             AS "OperationID",
       CASE
           WHEN "USR02"."USTYP" IN ('B', 'C') THEN 'Automatic'
           ELSE 'Manual' END                                                                       AS "ExecutionType"
FROM "JCDS" AS "JCDS"
         LEFT JOIN "VBAK" AS "VBAK"
                   ON "JCDS"."OBJNR" = "VBAK"."OBJNR"
         LEFT JOIN "USR02" AS "USR02"
                   ON "JCDS"."USNAM" = "USR02"."BNAME"
                       AND "JCDS"."MANDT" = "USR02"."MANDT"
WHERE "VBAK"."VBTYP" IN ('C', 'I')
  AND "JCDS"."INACT" IS NULL
  AND "JCDS"."UDATE" IS NOT NULL
  AND "JCDS"."MANDT" IS NOT NULL
  AND "VBAK"."MANDT" IS NOT NULL


===================================================================================================================================================================


									******************************		VBAK 1		**********************************


SELECT <%=sourceSystem%>  || 'SalesOrder_' || "VBAK"."MANDT" || "VBAK"."VBELN" AS "ObjectID",
	<%=sourceSystem%>  || "NAST"."MANDT" || "NAST"."KAPPL" || "NAST"."OBJKY"
       || "NAST"."KSCHL" || "NAST"."SPRAS" || COALESCE("NAST"."PARNR", '')
       || COALESCE("NAST"."PARVW", '') || "NAST"."ERDAT" || "NAST"."ERUHR"     AS "ID",
       CAST("NAST"."DATVR" AS DATE)
            + CAST(TIMESTAMPDIFF(SECOND, CAST("NAST"."UHRVR" AS DATE),
            "NAST"."UHRVR") AS INTERVAL SECOND)                                AS "Time",
       CASE
           WHEN "NAST"."KSCHL" = 'BA00' THEN 'SendOrderConfirmation'
           END                                                                 AS "Attribute",
       NULL                                                                    AS "OldValue",
       NULL                                                                    AS "NewValue",
       'User_' || "NAST"."MANDT" || "NAST"."USNAM"                             AS "ChangedBy",
       "NAST"."TCODE"                                                          AS "OperationType",
       NULL                                                                    AS "OperationID",
       CASE
           WHEN "USR02"."USTYP" IN ('B', 'C') THEN 'Automatic'
           ELSE 'Manual' END                                                   AS "ExecutionType"
FROM "VBAK" AS "VBAK"
         LEFT JOIN "NAST" AS "NAST"
                   ON "VBAK"."VBELN" = "NAST"."OBJKY"
                       AND "VBAK"."MANDT" = "NAST"."MANDT"
                       AND "NAST"."DATVR" IS NOT NULL
                       AND "NAST"."KAPPL" = 'V1'
                       AND "NAST"."KSCHL" IN ('BA00')
         LEFT JOIN "USR02" AS "USR02"
                   ON "NAST"."MANDT" = "USR02"."MANDT"
                       AND "NAST"."USNAM" = "USR02"."BNAME"
WHERE "VBAK"."MANDT" IS NOT NULL
  AND "NAST"."MANDT" IS NOT NULL
