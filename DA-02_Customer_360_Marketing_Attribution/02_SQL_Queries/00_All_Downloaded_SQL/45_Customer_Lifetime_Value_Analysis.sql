CREATE OR REPLACE VIEW
`customer360-mktg.customer360.vw_customer_clv` AS

SELECT
  customer_id,
  COUNT(DISTINCT order_id) AS total_orders,
  SUM(order_amount) AS lifetime_revenue,

  ROUND(
    AVG(order_amount), 2
  ) AS average_order_value,

  MIN(order_date) AS first_order_date,
  MAX(order_date) AS last_order_date,

  DATE_DIFF(
    MAX(order_date),
    MIN(order_date),
    DAY
  ) AS customer_lifespan_days,

  CASE
    WHEN SUM(order_amount) >= 60000 THEN 'High Value'
    WHEN SUM(order_amount) >= 35000 THEN 'Medium Value'
    ELSE 'Low Value'
  END AS clv_segment

FROM
  `customer360-mktg.customer360.crm_orders`

GROUP BY
  customer_id;