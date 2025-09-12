/*
Please map the ID and additional attributes (see below for complete list) to finish the transformation
*/
SELECT
	-- Map the ID for your Object Type
	<%=sourceSystem%>  || 'Open_Invoice_Deepdive_Manual_File_' || "Open_Invoice_Deepdive_Manual_File"."MANDT" || "Open_Invoice_Deepdive_Manual_File"."BUKRS" ||
    "Open_Invoice_Deepdive_Manual_File"."BELNR" || "Open_Invoice_Deepdive_Manual_File"."GJAHR" || "Open_Invoice_Deepdive_Manual_File"."BUZEI"  	AS "ID",
	"COMPANYCODE" 																																AS "COMPANYCODE",
	"# INVOICES" 																									AS "Invoices",
	"INVOICE LINES" 																								AS "InvoiceLines",
	"INVOICE VALUE" 																								AS "InvoiceValue",
	"ID" 																											AS "OpenInvoiceDeepdiveManualFileID",
	"Open_Invoice_Deepdive_Manual_File"."MANDT" 																	AS "MANDT",
	"Open_Invoice_Deepdive_Manual_File"."BELNR" 																	AS "BELNR",
	"Open_Invoice_Deepdive_Manual_File"."BUZEI" 																	AS "BUZEI",
	"Open_Invoice_Deepdive_Manual_File"."GJAHR" 																	AS "GJAHR",
	"Open_Invoice_Deepdive_Manual_File"."BUKRS" 																	AS "BUKRS",
	"INVOICE LIFECYCLE STAGE" 																						AS "InvoiceLifecycleStage",
	"EXCEPTION TYPE" 																								AS "ExceptionType",
	"VALUE OPPUTUNITIES " 																							AS "ValueOpputunities",
	"STATUS" 																										AS "STATUS",
	"PAYMENT DAYS" 																									AS "PaymentDays",
    <%=sourceSystem%>  || 'VendorAccountCreditItem_' || "BSEG"."MANDT" || "BSEG"."BUKRS" || "BSEG"."BELNR" || "BSEG"."GJAHR"
           || "BSEG"."BUZEI" 																						AS "VendorAccountCreditItem"
	
FROM "Open_Invoice_Deepdive_Manual_File"
LEFT JOIN BSEG ON 
 "Open_Invoice_Deepdive_Manual_File"."MANDT" || "Open_Invoice_Deepdive_Manual_File"."BUKRS" ||
    "Open_Invoice_Deepdive_Manual_File"."BELNR" || "Open_Invoice_Deepdive_Manual_File"."GJAHR" || "Open_Invoice_Deepdive_Manual_File"."BUZEI" 
    = "BSEG"."MANDT" || "BSEG"."BUKRS" || "BSEG"."BELNR" || "BSEG"."GJAHR" || "BSEG"."BUZEI"

