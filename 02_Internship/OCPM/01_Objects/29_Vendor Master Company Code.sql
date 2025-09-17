                      ******************************      LFB1        ***************************************

						  
SELECT <%=sourceSystem%>  || 'VendorMasterCompanyCode_' || "LFB1"."MANDT" || "LFB1"."LIFNR" || "LFB1"."BUKRS" 	AS "ID",
    CAST(CONCAT(CAST("LFB1"."ERDAT" AS VARCHAR), ' 00:00:01') AS TIMESTAMP)                                   	AS "CreationTime",
    "LFB1"."ZTERM"                                                                                            	AS "PaymentTerms",
	<%=sourceSystem%>  || 'Vendor_' || "LFB1"."MANDT" || "LFB1"."LIFNR"                                         AS "Vendor",
    'SAP'                                                                                                     	AS "SourceSystemType",
	<%=sourceSystem%>  || "LFB1"."MANDT"                                                                        AS "SourceSystemInstance"
FROM "LFB1" AS "LFB1"
WHERE "LFB1"."MANDT" IS NOT NULL
