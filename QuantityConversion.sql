          **************************   MARA     *******************************

SELECT DISTINCT <%=sourceSystem%> 
    || CASE
           WHEN "T006"."DIMID" != 'AAAADL'
               THEN 'QuantityConversion_' || "MARA"."MANDT" || "MARA"."MATNR" || "MARA"."MEINS" || "T006D"."MSSIE"
           WHEN "T006"."DIMID" = 'AAAADL'
               THEN 'QuantityConversion_' || "MARA"."MANDT" || "MARA"."MATNR" || "MARA"."MEINS" || "MARM"."MEINH"
           END                        AS "ID",
       "MARA"."MATNR"                 AS "MaterialNumber",
       "MARA"."MATNR"                 AS "ConversionQualifier",
       "MARA"."MEINS"                 AS "FromUnit",
       CASE
           WHEN "T006"."DIMID" != 'AAAADL'
               THEN "T006D"."MSSIE"
           WHEN "T006"."DIMID" = 'AAAADL'
               THEN "MARM"."MEINH"
           END                        AS "ToUnit",
       CASE
           WHEN "T006"."DIMID" != 'AAAADL'
               THEN "T006"."ZAEHL" / "T006"."NENNR" * POWER(10, "T006"."EXP10")
           WHEN "T006"."DIMID" = 'AAAADL'
               THEN "MARM"."UMREN" / "MARM"."UMREZ"
           END                        AS "Rate",
       "T006"."DIMID"                 AS "ConversionDimension",
       'SAP'                          AS "SourceSystemType",
	<%=sourceSystem%>  || "MARA"."MANDT" AS "SourceSystemInstance"
FROM "MARA" AS "MARA"
         LEFT JOIN "T006" AS "T006"
                   ON "MARA"."MANDT" = "T006"."MANDT"
                       AND "MARA"."MEINS" = "T006"."MSEHI"
         LEFT JOIN "T006D" AS "T006D"
                   ON "T006"."MANDT" = "T006D"."MANDT"
                       AND "T006"."DIMID" = "T006D"."DIMID"
         LEFT JOIN "MARM" AS "MARM"
                   ON "MARA"."MANDT" = "MARM"."MANDT"
                       AND "MARA"."MATNR" = "MARM"."MATNR"
WHERE "T006"."MANDT" IS NOT NULL
  AND "MARM"."MANDT" IS NOT NULL
