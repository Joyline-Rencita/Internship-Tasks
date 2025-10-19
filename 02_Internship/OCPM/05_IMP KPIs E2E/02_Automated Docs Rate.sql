COUNT(CASE WHEN "o_custom_TEMPSAPFinDocHead"."Classification" IN ('NON-MANUAL','ROBOTICS') THEN "o_custom_TEMPSAPFinDocHead"."Document Number" ELSE NULL END)/ COUNT("o_custom_TEMPSAPFinDocHead"."ID")
