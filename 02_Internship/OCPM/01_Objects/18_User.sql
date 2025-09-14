             **********************	 	 USR02		 *****************

WITH "CTE_ADRP_Latest" AS (SELECT "ADRP"."CLIENT",
                              "ADRP"."PERSNUMBER",
                              "ADRP"."NAME_FIRST",
                              "ADRP"."NAME_LAST",
                              ROW_NUMBER() OVER (PARTITION BY "ADRP"."CLIENT", "ADRP"."PERSNUMBER"
                                  ORDER BY "ADRP"."DATE_FROM", "ADRP"."NATION") 			AS "rn"
                       FROM "ADRP" AS "ADRP")
SELECT <%=sourceSystem%>  || 'User_' || "USR02"."MANDT" || "USR02"."BNAME" 					AS "ID",
       "USR02"."BNAME"                                                     					AS "DisplayName",
       "USR02"."USTYP"                                                     AS "Type",
       "ADRP_Latest"."NAME_FIRST"                                          AS "FirstName",
       "ADRP_Latest"."NAME_LAST"                                           AS "LastName",
       'SAP'                                                               AS "SourceSystemType",
	<%=sourceSystem%>  || "USR02"."MANDT"                                     AS "SourceSystemInstance"
FROM "USR02" AS "USR02"
         LEFT JOIN "USR21" AS "USR21"
                   ON "USR02"."MANDT" = "USR21"."MANDT"
                       AND "USR02"."BNAME" = "USR21"."BNAME"
         LEFT JOIN "CTE_ADRP_Latest" AS "ADRP_Latest"
                   ON "USR21"."MANDT" = "ADRP_Latest"."CLIENT"
                       AND "USR21"."PERSNUMBER" = "ADRP_Latest"."PERSNUMBER"
                       AND "ADRP_Latest"."rn" = '1'
WHERE "USR02"."MANDT" IS NOT NULL
