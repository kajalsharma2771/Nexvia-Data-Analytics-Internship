SELECT
  customer_segment,
  COUNT(*) AS total_customers,
  ROUND(AVG(recency), 0) AS avg_recency_days,
  ROUND(AVG(frequency), 2) AS avg_orders,
  ROUND(AVG(monetary), 2) AS avg_customer_spend
FROM
  `customer360-mktg.customer360.vw_customer_rfm`
GROUP BY
  customer_segment
ORDER BY
  total_customers DESC;