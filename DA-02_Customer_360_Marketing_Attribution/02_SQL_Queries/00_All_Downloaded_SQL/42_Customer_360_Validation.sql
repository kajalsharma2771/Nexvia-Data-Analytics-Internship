SELECT
  COUNT(*) AS total_customers,
  COUNT(DISTINCT customer_id) AS unique_customers,
  SUM(total_orders) AS total_orders,
  SUM(total_revenue) AS total_revenue,
  ROUND(AVG(total_revenue), 2) AS avg_customer_revenue
FROM
  `customer360-mktg.customer360.vw_customer_360`;