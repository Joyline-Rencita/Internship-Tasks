SELECT <%=sourceSystem%>  || 'Plant_' || "T001W"."MANDT" || "T001W"."WERKS" AS "ID",
    "T001W"."WERKS"                                                         AS "Number",
    "T001W"."NAME1"                                                         AS "Name",
    "T001W"."LAND1"                                                         AS "Country",
    "T005T"."LANDX"                                                         AS "CountryText",
    'SAP'                                                                   AS "SourceSystemType",
	<%=sourceSystem%>  || "T001W"."MANDT"                                      AS "SourceSystemInstance"
FROM "T001W" AS "T001W"
         LEFT JOIN "T005T" AS "T005T"
                   ON "T001W"."MANDT" = "T005T"."MANDT"
                       AND "T001W"."LAND1" = "T005T"."LAND1"
                       AND "T005T"."SPRAS" = <%=LanguageKey%> 
WHERE "T001W"."MANDT" IS NOT NULL
