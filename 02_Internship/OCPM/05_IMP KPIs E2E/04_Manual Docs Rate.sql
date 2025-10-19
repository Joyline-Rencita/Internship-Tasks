( ( COUNT(CASE WHEN "o_custom_TEMPSAPFinDocHead"."Classification" NOT IN ('NON-MANUAL','ROBOTICS')

THEN "o_custom_TEMPSAPFinDocHead"."Document Number"

ELSE NULL

END) )

/

( count("o_custom_TEMPSAPFinDocHead"."Document Number")

) )
