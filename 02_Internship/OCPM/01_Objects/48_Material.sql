                      ****************************      MARA      *******************************

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
        END                                                                  AS "StockKeepingUnit",
    'SAP'                                                                    AS "SourceSystemType",
	<%=sourceSystem%>  || "MARA"."MANDT"                                     AS "SourceSystemInstance"
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


====================================================================================================================================================================


                      **********************        CDPOS        **********************


SELECT <%=sourceSystem%>  || 'Material_' || "CDPOS"."TABKEY" AS "ObjectID",
	<%=sourceSystem%>  || "CDPOS"."TABKEY" || "CDPOS"."TABNAME" || "CDPOS"."FNAME"
       || "CDPOS"."CHANGENR" || "CDPOS"."CHNGIND"            AS "ID",
       CAST("CDHDR"."UDATE" AS DATE)
            + CAST(TIMESTAMPDIFF(SECOND, CAST("CDHDR"."UTIME" AS DATE),
            "CDHDR"."UTIME") AS INTERVAL SECOND)             AS "Time",
       CASE
           WHEN "CDPOS"."FNAME" = 'MATKL' THEN 'MaterialGroup'
           WHEN "CDPOS"."FNAME" = 'MBRSH' THEN 'IndustrySector'
           WHEN "CDPOS"."FNAME" = 'MTART' THEN 'MaterialType'
           END                                               AS "Attribute",
       CASE
           WHEN "CDPOS"."VALUE_OLD" LIKE '%-' THEN CONCAT('-', REPLACE(LTRIM("CDPOS"."VALUE_OLD"), '-', ''))
           ELSE "CDPOS"."VALUE_OLD" END                      AS "OldValue",
       CASE
           WHEN "CDPOS"."VALUE_NEW" LIKE '%-' THEN CONCAT('-', REPLACE(LTRIM("CDPOS"."VALUE_NEW"), '-', ''))
           ELSE "CDPOS"."VALUE_NEW" END                      AS "NewValue",
       'User_' || "CDHDR"."MANDANT" || "CDHDR"."USERNAME"    AS "ChangedBy",
       "CDHDR"."TCODE"                                       AS "OperationType",
       "CDHDR"."CHANGENR"                                    AS "OperationID",
       CASE
           WHEN "USR02"."USTYP" IN ('B', 'C') THEN 'Automatic'
           ELSE 'Manual' END                                 AS "ExecutionType"
FROM "CDPOS" AS "CDPOS"
         LEFT JOIN "CDHDR" AS "CDHDR" ON
            "CDPOS"."MANDANT" = "CDHDR"."MANDANT"
            AND "CDPOS"."OBJECTCLAS" = "CDHDR"."OBJECTCLAS"
            AND "CDPOS"."OBJECTID" = "CDHDR"."OBJECTID"
            AND "CDPOS"."CHANGENR" = "CDHDR"."CHANGENR"
    AND "CDPOS"."OBJECTCLAS" = 'MATERIAL'
         LEFT JOIN "USR02" AS "USR02"
                   ON "CDHDR"."USERNAME" = "USR02"."BNAME"
                       AND "CDHDR"."MANDANT" = "USR02"."MANDT"
WHERE "CDPOS"."CHNGIND" = 'U'
  AND "CDPOS"."TABNAME" = 'MARA'
  AND "CDPOS"."FNAME" IN  ('MATKL', 'MBRSH', 'MTART')
  AND "CDPOS"."MANDANT" IS NOT NULL
  AND "CDHDR"."MANDANT" IS NOT NULL


