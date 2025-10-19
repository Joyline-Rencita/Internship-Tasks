v_pl_status:

CASE 
    WHEN "EKPO"."LOEKZ" IS NOT NULL     THEN 'Deleted'
    WHEN "EKPO"."ELIKZ" IS NOT NULL     THEN 'Delivery Completed'
    WHEN KPI("v_pl_gr_qty") >= KPI("v_pl_req_qty")     THEN 'Fully Received - PO Open'
    WHEN KPI("v_pl_gr_qty") <= 0 OR KPI("v_pl_gr_qty") IS NULL 
    THEN 
        CASE 
            WHEN "EKPO"."SES" IS NULL THEN 'NO GR' 
            ELSE 'SES Available' 
        END
    WHEN KPI("v_pl_gr_qty") < KPI("v_pl_req_qty") AND KPI("v_pl_gr_qty") > 0     THEN 'Partially Received'
    ELSE 'Validate'
END
