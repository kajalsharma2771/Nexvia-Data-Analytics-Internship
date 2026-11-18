SELECT
  COUNT(*) AS total_orders,
  COUNTIF(order_date IS NULL) AS missing_order_dates,
  COUNTIF(order_status IS NULL) AS missing_order_status,
  COUNT(DISTINCT order_status) AS unique_order_statuses,
  MIN(order_date) AS first_order_date,
  MAX(order_date) AS last_order_date
FROM
  `customer360-mktg.customer360.crm_orders`;