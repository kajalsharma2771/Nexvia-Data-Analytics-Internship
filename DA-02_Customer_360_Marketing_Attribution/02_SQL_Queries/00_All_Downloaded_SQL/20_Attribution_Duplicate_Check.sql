SELECT
  attribution_model,
  source,
  campaign,
  COUNT(*) AS duplicate_count
FROM
  `customer360-mktg.customer360.attribution_model_results`
GROUP BY
  attribution_model,
  source,
  campaign
HAVING
  COUNT(*) > 1;