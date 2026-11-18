SELECT
  COUNT(*) AS total_records,
  COUNT(DISTINCT spend_id) AS unique_spend_ids,
  COUNTIF(spend_amount IS NULL) AS missing_spend,
  ROUND(SUM(spend_amount), 2) AS total_marketing_spend,
  SUM(impressions) AS total_impressions,
  SUM(clicks) AS total_clicks,
  SUM(conversions) AS total_conversions
FROM `customer360-mktg.customer360.crm_marketing_spend`;