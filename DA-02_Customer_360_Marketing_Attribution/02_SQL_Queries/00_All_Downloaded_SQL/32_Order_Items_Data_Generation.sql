CREATE OR REPLACE TABLE
`customer360-mktg.customer360.crm_order_items` AS

WITH numbered_orders AS (
  SELECT
    order_id,
    ROW_NUMBER() OVER (ORDER BY order_id) AS rn
  FROM
    `customer360-mktg.customer360.crm_orders`
)

SELECT
  CONCAT('ITEM_', o.order_id) AS order_item_id,
  o.order_id,
  p.product_id,
  CAST(1 + MOD(o.rn - 1, 3) AS INT64) AS quantity,
  p.unit_price,
  CAST(0 AS NUMERIC) AS discount
FROM numbered_orders o
JOIN
  `customer360-mktg.customer360.crm_products` p
ON
  p.product_id = CONCAT(
    'PRD',
    FORMAT('%03d', MOD(o.rn - 1, 10) + 1)
  );