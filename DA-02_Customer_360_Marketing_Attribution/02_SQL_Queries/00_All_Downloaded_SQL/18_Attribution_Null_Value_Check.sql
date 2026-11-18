SELECT
  COUNT(*) AS total_records,
  COUNTIF(attribution_model IS NULL) AS missing_model,
  COUNTIF(source IS NULL) AS missing_source,
  COUNTIF(campaign IS NULL) AS missing_campaign,
  COUNTIF(attributed_revenue IS NULL) AS missing_revenue
FROM
  `customer360-mktg.customer360.attribution_model_results`;