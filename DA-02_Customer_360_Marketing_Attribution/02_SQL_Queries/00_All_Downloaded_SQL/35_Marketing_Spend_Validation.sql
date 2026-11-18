SELECT
  COUNT(*) AS total_records,
  COUNT(DISTINCT spend_id) AS unique_spend_ids,
  COUNT(DISTINCT campaign_name) AS unique_campaigns,
  COUNT(DISTINCT channel) AS unique_channels,
  SUM(spend_amount) AS total_marketing_spend,
  SUM(impressions) AS total_impressions,
  SUM(clicks) AS total_clicks,
  SUM(conversions) AS total_conversions
FROM
  `customer360-mktg.customer360.crm_marketing_spend`;