SELECT
  campaign_name,
  channel,
  SUM(spend_amount) AS total_spend,
  SUM(clicks) AS total_clicks,
  SUM(conversions) AS total_conversions,

  ROUND(
    SAFE_DIVIDE(SUM(conversions) * 100, SUM(clicks)), 2
  ) AS conversion_rate_percent,

  ROUND(
    SAFE_DIVIDE(SUM(spend_amount), SUM(conversions)), 2
  ) AS cost_per_conversion

FROM
  `customer360-mktg.customer360.crm_marketing_spend`

GROUP BY
  campaign_name,
  channel

ORDER BY
  cost_per_conversion ASC;