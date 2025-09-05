--               *******************************************                   MARA                  ************************************************


SELECT <%=sourceSystem%>  || 'Material_' || "MARA"."MANDT" || "MARA"."MATNR" AS "ID",
    CAST("MARA"."ERSDA" AS TIMESTAMP)                                        AS "CreationTime",
    "MAKT"."MAKTX"                                                           AS "Name",
    "MARA"."MTART"                                                           AS "Type",
    "MARA"."MATKL"                                                           AS "Group",
    "T023T"."WGBEZ"                                                          AS "GroupText",
    "MARA"."PRDHA"                                                           AS "ProductHierarchy",
    "MARA"."MEINS"                                                           AS "BaseQuantityUnit",
    "MARA"."MATNR"                                                           AS "Number",
    CASE
        WHEN "T006"."DIMID" != 'AAAADL'
            THEN "T006D"."MSSIE"
        WHEN "T006"."DIMID" = 'AAAADL'
            THEN "MARM"."MEINH"
        END                                                                   AS "StockKeepingUnit",
    'SAP'                                                                     AS "SourceSystemType",
	<%=sourceSystem%>  || "MARA"."MANDT"                                        AS "SourceSystemInstance"
FROM "MARA" AS "MARA"
         LEFT JOIN "MAKT" AS "MAKT"
                   ON "MARA"."MANDT" = "MAKT"."MANDT"
                       AND "MARA"."MATNR" = "MAKT"."MATNR"
                       AND "MAKT"."SPRAS" = <%=LanguageKey%> 
         LEFT JOIN "T023T" AS "T023T"
                   ON "MARA"."MANDT" = "T023T"."MANDT"
                       AND "MARA"."MATKL" = "T023T"."MATKL"
                       AND "T023T"."SPRAS" = <%=LanguageKey%> 
         LEFT JOIN "T006" AS "T006"
                   ON "MARA"."MANDT" = "T006"."MANDT"
                       AND "MARA"."MEINS" = "T006"."MSEHI"
         LEFT JOIN "T006D" AS "T006D"
                   ON "T006"."MANDT" = "T006D"."MANDT"
                       AND "T006"."DIMID" = "T006D"."DIMID"
         LEFT JOIN "MARM" AS "MARM"
                   ON "MARA"."MANDT" = "MARM"."MANDT"
                       AND "MARA"."MATNR" = "MARM"."MATNR"
                       AND "MARM"."MEINH" = <%=SI-Unit%> 



--  ====================================================================================================================================================================



--                      ********************************                   CDPOS                    ***************************************


