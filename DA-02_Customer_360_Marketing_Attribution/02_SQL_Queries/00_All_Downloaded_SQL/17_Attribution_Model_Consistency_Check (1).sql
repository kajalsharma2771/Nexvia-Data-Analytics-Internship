SELECT
  attribution_model,
  ROUND(SUM(attributed_revenue), 2) AS total_attributed_revenue,
  COUNT(*) AS total_records
FROM
  `customer360-mktg.customer360.attribution_model_results`
GROUP BY
  attribution_model
ORDER BY
  attribution_model;