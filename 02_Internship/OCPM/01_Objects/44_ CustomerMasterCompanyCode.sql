              ***************************          KNB1      *******************************

SELECT <%=sourceSystem%>  || 'CustomerMasterCompanyCode_' || "KNB1"."MANDT" || "KNB1"."KUNNR" || "KNB1"."BUKRS" AS "ID",
       CAST("KNB1"."ERDAT" AS TIMESTAMP)                                                                        AS "CreationTime",
       'SAP'                                                                                                    AS "SourceSystemType",
	<%=sourceSystem%>  || "KNB1"."MANDT"                                                                           AS "SourceSystemInstance",
       "KNB1"."ZTERM"                                                                                           AS "PaymentTerms",
	<%=sourceSystem%>  || 'Customer_' || "KNB1"."MANDT" || "KNB1"."KUNNR"                                          AS "Customer"
FROM "KNB1" AS "KNB1"
WHERE "KNB1"."MANDT" IS NOT NULL
