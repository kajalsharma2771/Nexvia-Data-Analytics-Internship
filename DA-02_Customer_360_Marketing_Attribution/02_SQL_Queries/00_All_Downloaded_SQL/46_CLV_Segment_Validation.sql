SELECT
  clv_segment,
  COUNT(*) AS total_customers,
  ROUND(SUM(lifetime_revenue), 2) AS total_revenue,
  ROUND(AVG(lifetime_revenue), 2) AS avg_lifetime_value,
  ROUND(AVG(average_order_value), 2) AS avg_order_value
FROM
  `customer360-mktg.customer360.vw_customer_clv`
GROUP BY
  clv_segment
ORDER BY
  avg_lifetime_value DESC;