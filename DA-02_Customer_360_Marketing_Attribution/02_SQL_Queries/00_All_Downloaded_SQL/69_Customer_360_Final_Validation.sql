SELECT
  COUNT(*) AS total_customers,
  COUNT(DISTINCT customer_id) AS unique_customers,
  SUM(total_orders) AS total_orders,
  ROUND(SUM(total_revenue), 2) AS total_revenue,
  ROUND(AVG(total_revenue), 2) AS average_customer_revenue
FROM `customer360-mktg.customer360.vw_customer_360`;