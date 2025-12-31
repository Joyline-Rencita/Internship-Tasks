'*********************************************************        CASE 1        *************************************************************'

WITH SO_QTY AS (
    SELECT
        VBAP.VBELN        AS SO_VBELN,
        VBAP.POSNR        AS SO_POSNR,
        VBAP.MATNR        AS MATERIAL,
        VBAP.WERKS        AS SO_PLANT,
        SUM(VBEP.WMENG)   AS REQ_QTY
    FROM VBAP
    INNER JOIN VBEP
        ON VBAP.VBELN = VBEP.VBELN
        AND VBAP.POSNR = VBEP.POSNR
    GROUP BY  VBAP.VBELN, VBAP.POSNR, VBAP.MATNR, VBAP.WERKS 
),

PLANT_STOCK AS (
    SELECT
        MARD.MATNR,
        MARD.WERKS,
        SUM(MARD.LABST) AS PLANT_STOCK
    FROM MARD
    GROUP BY  MARD.MATNR, MARD.WERKS
)
 
SELECT
    S.SO_VBELN,  S.SO_POSNR,  S.MATERIAL,  S.SO_PLANT,  S.REQ_QTY,
    COALESCE(P.PLANT_STOCK, 0) AS PLANT_STOCK
FROM SO_QTY S

LEFT JOIN PLANT_STOCK P
    ON S.MATERIAL = P.MATNR
   AND S.SO_PLANT = P.WERKS
WHERE COALESCE(P.PLANT_STOCK, 0) > S.REQ_QTY  --  Sufficient stock at primary plant
 
-- WHERE COALESCE(P.PLANT_STOCK, 0) < S.REQ_QTY;  --    inefficient stock in Primary plant


'#####################################################################################################################################################'

'***************************************************        CASE 2       *****************************************************'

WITH SO_QTY AS (
    SELECT
        VBAP.VBELN        AS SO_VBELN,
        VBAP.POSNR        AS SO_POSNR,
        VBAP.MATNR        AS MATERIAL,
        VBAP.WERKS        AS PRIMARY_PLANT,
        SUM(VBEP.WMENG)   AS REQ_QTY
    FROM VBAP
    INNER JOIN VBEP
        ON VBAP.VBELN = VBEP.VBELN
       AND VBAP.POSNR = VBEP.POSNR
    GROUP BY VBAP.VBELN, VBAP.POSNR, VBAP.MATNR, VBAP.WERKS
),
PLANT_STOCK AS (
    SELECT
        MARD.MATNR,
        MARD.WERKS,
        SUM(MARD.LABST) AS STOCK_QTY
    FROM MARD
    GROUP BY MARD.MATNR, MARD.WERKS
),
PRIMARY_STOCK AS (
    SELECT
        MATNR,
        WERKS,
        SUM(LABST) AS PRIMARY_PLANT_STOCK
    FROM MARD
    GROUP BY MATNR, WERKS
)
SELECT
    SO.SO_VBELN,
    SO.SO_POSNR,
    SO.MATERIAL,
    SO.PRIMARY_PLANT,
    SO.REQ_QTY,
    COALESCE(PST.PRIMARY_PLANT_STOCK, 0) AS PRIMARY_PLANT_STOCK,
    PS.WERKS AS SECONDARY_PLANT,
    PS.STOCK_QTY AS SECONDARY_PLANT_STOCK
 
FROM SO_QTY SO
 
LEFT JOIN PRIMARY_STOCK PST
       ON PST.MATNR = SO.MATERIAL
      AND PST.WERKS = SO.PRIMARY_PLANT
 
INNER JOIN PLANT_STOCK PS
        ON PS.MATNR = SO.MATERIAL
       AND PS.WERKS <> SO.PRIMARY_PLANT
 
WHERE
    COALESCE(PST.PRIMARY_PLANT_STOCK, 0) < SO.REQ_QTY
    AND PS.STOCK_QTY > 0
 
ORDER BY SO.SO_VBELN, SO.SO_POSNR, PS.WERKS;



'#####################################################################################################################################################'

'********************************************************        CASE 3       ************************************************************'

SELECT
  VBAP.VBELN AS SO_VBELN,                     -- Sales Order
  VBAP.POSNR AS SO_POSNR,                     -- SO Item
  VBAP.MATNR AS MATERIAL,                     -- Material
  VBAP.WERKS AS PRIMARY_PLANT,                -- SO Delivering Plant
  EKKO.LIFNR AS VENDOR,                       -- PO Vendor
  EKPO.EBELN AS PO_NUMBER,                    -- Purchase Order
 
  -- Requested Quantity
  SUM(COALESCE(CAST(VBEP.WMENG AS DECIMAL(15,3)), 0)) AS REQ_QTY,
 
  -- Primary Plant Stock
  SUM(CASE WHEN MARD.WERKS = VBAP.WERKS
           THEN COALESCE(CAST(MARD.LABST AS DECIMAL(15,3)), 0)
           ELSE 0 END) AS PRIMARY_PLANT_STOCK,
 
  -- Secondary Plant Code
  CASE WHEN MARD.WERKS <> VBAP.WERKS THEN MARD.WERKS END AS SECONDARY_PLANT,
 
  -- Secondary Plant Stock
  SUM(CASE WHEN MARD.WERKS <> VBAP.WERKS
           THEN COALESCE(CAST(MARD.LABST AS DECIMAL(15,3)), 0)
           ELSE 0 END) AS SECONDARY_PLANT_STOCK,
 
  -- PO Quantity for same plant + material
  SUM(CASE WHEN EKPO.MATNR = VBAP.MATNR
            AND EKPO.WERKS = VBAP.WERKS
           THEN COALESCE(CAST(EKPO.MENGE AS DECIMAL(15,3)), 0)
           ELSE 0 END) AS PO_TOTAL_QTY
 
FROM VBAP JOIN VBEP
  ON VBEP.VBELN = VBAP.VBELN  AND VBEP.POSNR = VBAP.POSNR
 
LEFT JOIN MARD  ON MARD.MATNR = VBAP.MATNR
LEFT JOIN EKPO  ON EKPO.MATNR = VBAP.MATNR
LEFT JOIN EKKO  ON EKKO.EBELN = EKPO.EBELN                  -- Vendor join
 
GROUP BY VBAP.VBELN, VBAP.POSNR, VBAP.MATNR, VBAP.WERKS,  EKKO.LIFNR, EKPO.EBELN, MARD.WERKS
 
HAVING
  -- Primary stock insufficient
  SUM(CASE WHEN MARD.WERKS = VBAP.WERKS
           THEN COALESCE(CAST(MARD.LABST AS DECIMAL(15,3)), 0)
           ELSE 0 END)
  < SUM(COALESCE(CAST(VBEP.WMENG AS DECIMAL(15,3)), 0))
 
AND
  -- Even combined stock insufficient
  (
    SUM(CASE WHEN MARD.WERKS = VBAP.WERKS
             THEN COALESCE(CAST(MARD.LABST AS DECIMAL(15,3)), 0)
             ELSE 0 END)
    +
    SUM(CASE WHEN MARD.WERKS <> VBAP.WERKS
             THEN COALESCE(CAST(MARD.LABST AS DECIMAL(15,3)), 0)
             ELSE 0 END)
  )
  < SUM(COALESCE(CAST(VBEP.WMENG AS DECIMAL(15,3)), 0))
AND
  -- PO exists → procurement started
  SUM(CASE WHEN EKPO.MATNR = VBAP.MATNR
            AND EKPO.WERKS = VBAP.WERKS
           THEN COALESCE(CAST(EKPO.MENGE AS DECIMAL(15,3)), 0)
           ELSE 0 END) > 0
 ORDER BY SO_VBELN, SO_POSNR, SECONDARY_PLANT;


'#####################################################################################################################################################'

'********************************             CASE 2          ********************************'

WITH SO_QTY AS (
    SELECT
        SOI.ID                          AS SOI_ID,
        SOI.Material_ID                 AS Material_ID,
        SOI.Plant_ID                    AS Primary_Plant_ID,
        /* If no schedule lines exist, use OrderedQuantity */
        COALESCE(SUM(SOSL.ConfirmedQuantity), SOI.OrderedQuantity) AS Req_Qty
    FROM <%=BUSINESS_GRAPH%>."o_celonis_SalesOrderItem" SOI
    LEFT JOIN <%=BUSINESS_GRAPH%>."o_celonis_SalesOrderScheduleLine" SOSL
           ON SOSL.SalesOrderItem_ID = SOI.ID
    GROUP BY
        SOI.ID,
        SOI.Material_ID,
        SOI.Plant_ID,
        SOI.OrderedQuantity
),

/* Aggregate available stock per Material + Plant from StorageLocation */
PLANT_STOCK AS (
    SELECT
        SL.Material    AS Material_ID,
        SL.Plant       AS Plant_ID,
        /* UnrestrictedStock is STRING → cast to FLOAT; treat null/blank as 0 */
        SUM(
            COALESCE(CAST(NULLIF(SL.UnrestrictedStock, '') AS FLOAT), 0.0)
        ) AS Stock_Qty
    FROM <%=BUSINESS_GRAPH%>."o_custom_StorageLocation" SL
    GROUP BY SL.Material, SL.Plant
),

/* Mirror of PLANT_STOCK for primary plant join (kept separate to match your original structure) */
PRIMARY_STOCK AS (
    SELECT
        Material_ID,
        Plant_ID,
        Stock_Qty AS Primary_Plant_Stock
    FROM PLANT_STOCK
)

SELECT
    SO.SOI_ID                                  AS ID,
    SO.Material_ID,
    SO.Primary_Plant_ID,
    SO.Req_Qty,
    COALESCE(PST.Primary_Plant_Stock, 0)       AS Primary_Plant_Stock,
    PS.Plant_ID                                AS Secondary_Plant_ID,
    PS.Stock_Qty                               AS Secondary_Plant_Stock
FROM SO_QTY SO
LEFT JOIN PRIMARY_STOCK PST
       ON PST.Material_ID = SO.Material_ID
      AND PST.Plant_ID    = SO.Primary_Plant_ID
INNER JOIN PLANT_STOCK PS
        ON PS.Material_ID = SO.Material_ID
       AND PS.Plant_ID   <> SO.Primary_Plant_ID
WHERE
    COALESCE(PST.Primary_Plant_Stock, 0) < SO.Req_Qty
    AND PS.Stock_Qty > 0
ORDER BY
    SO.SOI_ID,
    PS.Plant_ID;


