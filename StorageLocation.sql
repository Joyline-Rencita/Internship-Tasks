                          ***********************            MARD          ******************************


SELECT

'StorageLoc_'  || COALESCE("MARD"."MANDT", '') || COALESCE("MARD"."MATNR", '') || COALESCE("MARD"."WERKS", '') 
               || COALESCE("MARD"."LGORT", '') AS "ID",
  "MARD"."MANDT" AS "Client",
  'Material_' || "MARD"."MANDT"|| "MARD"."MATNR" AS "Material",
  "MAKT"."MAKTX" AS "MaterialDesc",
  'Plant_' ||"MARD"."MANDT"|| "MARD"."WERKS" AS "Plant",
  "T001W"."NAME1" AS "PlantDesc",
  "MARD"."LGORT" AS "StorageLocation",
  "T001L"."LGOBE" AS "StorageLocDesc",
  "MARD"."ERSDA" AS "CreatedOn",
  "MARD"."LVORM" AS "DeletionFlag",
  "MARD"."PSTAT" AS "MaintenanceStatus",
  "MARD"."SPERR" AS "BlockedStock",
  "MARD"."LABST" AS "UnrestrictedStock",
  "MARD"."INSME" AS "QualityInspectionStock",
  "MARD"."UMLME" AS "StockInTransfer",
  "MARD"."SPEME" AS "SpecialStock",
  "MARD"."RETME" AS "ReturnStock",
  "MARD"."EINME" AS "StockInPurchaseOrder",
  "MARD"."LFGJA" AS "FiscalYear",
  "MARD"."LFMON" AS "FiscalMonth",
  'MaterialMasterPlant_' || "MARD"."MANDT" || "MARD"."MATNR" || "MARD"."WERKS" AS "MaterialMasterPlant"
  
FROM MARD

INNER JOIN "MAKT"
  ON  "MAKT"."MANDT" = "MARD"."MANDT"
  AND "MAKT"."MATNR" = "MARD"."MATNR"
  AND "MAKT"."SPRAS" = 'EN'          
INNER JOIN "T001W"
  ON  "T001W"."MANDT" = "MARD"."MANDT"
  AND "T001W"."WERKS" = "MARD"."WERKS"
INNER JOIN "T001L"
  ON  "T001L"."MANDT" = "MARD"."MANDT"
  AND "T001L"."WERKS" = "MARD"."WERKS"
  AND "T001L"."LGORT" = "MARD"."LGORT"

