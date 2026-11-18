SELECT
  attribution_model,
  SUM(orders) AS total_orders,
  ROUND(SUM(attributed_revenue), 2) AS total_attributed_revenue
FROM
  `customer360-mktg.customer360.attribution_model_results`
GROUP BY
  attribution_model
ORDER BY
  attribution_model;