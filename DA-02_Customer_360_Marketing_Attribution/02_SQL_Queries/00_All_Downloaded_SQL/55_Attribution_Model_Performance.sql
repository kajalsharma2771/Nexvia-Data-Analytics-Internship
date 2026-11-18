SELECT
  attribution_model,
  COUNT(*) AS total_records,
  SUM(orders) AS total_credited_orders,
  ROUND(SUM(attributed_revenue), 2) AS total_attributed_revenue,
  ROUND(AVG(attributed_revenue), 2) AS avg_attributed_revenue
FROM
  `customer360-mktg.customer360.attribution_model_results`
GROUP BY
  attribution_model
ORDER BY
  total_attributed_revenue DESC;