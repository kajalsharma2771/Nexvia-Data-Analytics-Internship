SELECT
  COUNT(*) AS total_records,
  COUNTIF(attributed_revenue < 0) AS negative_revenue_records,
  COUNTIF(attributed_revenue = 0) AS zero_revenue_records,
  MIN(attributed_revenue) AS minimum_revenue,
  MAX(attributed_revenue) AS maximum_revenue
FROM
  `customer360-mktg.customer360.attribution_model_results`;