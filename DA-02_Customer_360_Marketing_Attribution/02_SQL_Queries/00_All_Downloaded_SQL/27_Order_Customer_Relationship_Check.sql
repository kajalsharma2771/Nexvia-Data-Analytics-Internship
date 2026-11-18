SELECT
  COUNT(*) AS total_orders,
  COUNTIF(c.customer_id IS NOT NULL) AS matched_orders,
  COUNTIF(c.customer_id IS NULL) AS unmatched_orders
FROM
  `customer360-mktg.customer360.crm_orders` o
LEFT JOIN
  `customer360-mktg.customer360.crm_customers_import` c
ON
  o.customer_id = c.customer_id;