SELECT
  order_status,
  COUNT(*) AS total_orders,
  SUM(order_amount) AS total_revenue
FROM
  `customer360-mktg.customer360.crm_orders`
GROUP BY
  order_status
ORDER BY
  total_orders DESC;