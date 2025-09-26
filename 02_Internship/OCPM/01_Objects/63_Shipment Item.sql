                    ******************************        VTTP      ***************************************


SELECT <%=sourceSystem%>  || 'ShipmentItem_' || "VTTP"."MANDT" || "VTTP"."TKNUM" || "VTTP"."TPNUM"   AS "ID",
       CAST("VTTP"."ERDAT" AS DATE) + CAST(TIMESTAMPDIFF(SECOND, CAST("VTTP"."ERZET" AS DATE),
            "VTTP"."ERZET") AS INTERVAL SECOND)                                                      AS "CreationTime",
	<%=sourceSystem%>  || 'Shipment_' || "VTTP"."MANDT" || "VTTP"."TKNUM"                            AS "Header",
	<%=sourceSystem%>  || 'User_' || "VTTP"."MANDT" || "VTTP"."ERNAM"                                AS "CreatedBy",
       CASE
           WHEN "USR02"."USTYP" IN ('B', 'C') THEN 'Automatic'
           ELSE 'Manual' END                                                                         AS "CreationExecutionType",
       'SAP'                                                                                       	 AS "SourceSystemType",
	<%=sourceSystem%>  || "VTTP"."MANDT"                                                             AS "SourceSystemInstance",
       CAST("VTTP"."TKNUM" AS VARCHAR(255))                                                        	 AS "SystemShipmentNumber",
       CAST("VTTP"."TPNUM" AS VARCHAR(255))                                                          AS "SystemShipmentItemNumber",
       CAST("VTTP"."TKNUM" AS VARCHAR(255))                                                          AS "DatabaseShipmentNumber",
       CAST("VTTP"."TPNUM" AS VARCHAR(255))                                                          AS "DatabaseShipmentItemNumber",
	<%=sourceSystem%>  || 'Delivery_' || "VTTP"."MANDT" || "VTTP"."VBELN"                            AS "Delivery"
FROM "VTTP" AS "VTTP"
         LEFT JOIN "USR02" AS "USR02"
                   ON "VTTP"."MANDT" = "USR02"."MANDT"
                       AND "VTTP"."ERNAM" = "USR02"."BNAME"
