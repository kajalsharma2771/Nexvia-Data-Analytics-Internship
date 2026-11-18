SELECT
  COUNT(*) AS total_order_items,
  COUNTIF(p.product_id IS NOT NULL) AS matched_products,
  COUNTIF(p.product_id IS NULL) AS unmatched_products
FROM
  `customer360-mktg.customer360.crm_order_items` oi
LEFT JOIN
  `customer360-mktg.customer360.crm_products` p
ON
  oi.product_id = p.product_id;