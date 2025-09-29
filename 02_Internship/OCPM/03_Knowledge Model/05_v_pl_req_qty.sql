v_pl_req_qty :
"o_celonis_PurchaseOrderItem"."Quantity" * ((100 - TO_INT("o_celonis_PurchaseOrderItem"."ToleranceLimit"))/100)
