SELECT
  COUNT(*) AS total_records,
  COUNT(DISTINCT attribution_model) AS total_models,
  COUNT(DISTINCT source) AS total_channels,
  SUM(credited_orders) AS total_credited_orders,
  ROUND(SUM(attributed_revenue), 2) AS total_attributed_revenue
FROM
  `customer360-mktg.customer360.vw_attribution_summary`;