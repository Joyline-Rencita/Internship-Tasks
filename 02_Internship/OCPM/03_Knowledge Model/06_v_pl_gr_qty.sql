v_pl_gr_qty:

CASE 
    WHEN PU_SUM(
             "EKPO",
             CASE 
                 WHEN "EKBE"."VGABE" = 1 AND "EKBE"."SHKZG" = 'S' THEN "EKBE"."MENGE"
                 WHEN "EKBE"."VGABE" = 1 AND "EKBE"."SHKZG" = 'H' 
                      AND "EKBE"."BWART" IN ('102', '122') THEN "EKBE"."MENGE" * (-1)
             END
         ) IS NULL 
    THEN 0.0
    ELSE PU_SUM(
             "EKPO",
             CASE 
                 WHEN "EKBE"."VGABE" = 1 AND "EKBE"."SHKZG" = 'S' THEN "EKBE"."MENGE"
                 WHEN "EKBE"."VGABE" = 1 AND "EKBE"."SHKZG" = 'H' 
                      AND "EKBE"."BWART" IN ('102', '122') THEN "EKBE"."MENGE" * (-1)
             END
         )
END
