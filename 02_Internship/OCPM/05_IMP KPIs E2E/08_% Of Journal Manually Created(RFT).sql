COUNT(CASE WHEN "o_custom_JournalReport"."Status"='OK' THEN "o_custom_JournalReport"."ID" ELSE NULL END)
/ 
(COUNT(CASE WHEN "o_custom_JournalReport"."Status"='OK' THEN "o_custom_JournalReport"."ID" ELSE NULL END) 
+ 
COUNT(DISTINCT CASE WHEN "o_custom_JournalReport"."Status"='RV' THEN "o_custom_JournalReport"."ID" ELSE NULL END) 
+ 
COUNT(DISTINCT CASE WHEN "o_custom_JournalReport"."Status"='RE' THEN "o_custom_JournalReport"."ID" ELSE NULL END))
