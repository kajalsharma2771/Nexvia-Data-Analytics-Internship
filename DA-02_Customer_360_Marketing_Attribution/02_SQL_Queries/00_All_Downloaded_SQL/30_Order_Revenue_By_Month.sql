SELECT
  FORMAT_DATE('%Y-%m', order_date) AS order_month,
  COUNT(DISTINCT order_id) AS total_orders,
  COUNT(DISTINCT customer_id) AS unique_customers,
  SUM(order_amount) AS monthly_revenue,
  AVG(order_amount) AS average_order_value
FROM
  `customer360-mktg.customer360.crm_orders`
GROUP BY
  order_month
ORDER BY
  order_month;