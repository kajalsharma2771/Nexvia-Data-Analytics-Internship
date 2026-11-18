SELECT
  COUNT(*) AS total_records,
  COUNT(DISTINCT attribution_model) AS total_models,
  COUNT(DISTINCT source) AS total_channels,
  SUM(attributed_revenue) AS total_attributed_revenue
FROM
  `customer360-mktg.customer360.attribution_model_results`;