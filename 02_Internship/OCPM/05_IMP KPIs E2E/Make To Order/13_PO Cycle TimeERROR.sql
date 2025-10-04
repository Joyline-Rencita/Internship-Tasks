PO Cycle Time : 

CASE
  WHEN COUNT(
    CASE
      WHEN "o_celonis_PurchaseOrderItem"."CreationTime" IS NOT NULL
        AND "o_celonis_IncomingMaterialDocumentItem"."CreationTime" IS NOT NULL
      THEN 1
    END
  ) > 0
  THEN AVG(
    DAYS_BETWEEN(
      "o_celonis_IncomingMaterialDocumentItem"."CreationTime",
      "o_celonis_PurchaseOrderItem"."CreationTime"
    )
  )
  ELSE 0
END
