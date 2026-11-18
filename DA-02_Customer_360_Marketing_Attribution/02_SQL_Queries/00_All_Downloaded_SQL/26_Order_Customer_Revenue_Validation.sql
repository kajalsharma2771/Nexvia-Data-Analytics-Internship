SELECT
  COUNT(*) AS total_orders,
  COUNT(DISTINCT order_id) AS unique_orders,
  COUNT(DISTINCT customer_id) AS unique_customers,
  COUNTIF(customer_id IS NULL) AS missing_customer_ids,
  COUNTIF(order_amount IS NULL) AS missing_order_amounts,
  SUM(order_amount) AS total_revenue
FROM
  `customer360-mktg.customer360.crm_orders`;