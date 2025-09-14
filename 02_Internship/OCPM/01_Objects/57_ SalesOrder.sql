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


