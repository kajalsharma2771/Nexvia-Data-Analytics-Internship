SELECT
  channel,
  SUM(spend_amount) AS total_spend,
  SUM(impressions) AS impressions,
  SUM(clicks) AS clicks,
  SUM(conversions) AS conversions,

  ROUND(
    SAFE_DIVIDE(SUM(clicks) * 100, SUM(impressions)), 2
  ) AS ctr_percent,

  ROUND(
    SAFE_DIVIDE(SUM(conversions) * 100, SUM(clicks)), 2
  ) AS conversion_rate_percent,

  ROUND(
    SAFE_DIVIDE(SUM(spend_amount), SUM(clicks)), 2
  ) AS cpc,

  ROUND(
    SAFE_DIVIDE(SUM(spend_amount), SUM(conversions)), 2
  ) AS cost_per_conversion

FROM
  `customer360-mktg.customer360.crm_marketing_spend`

GROUP BY
  channel

ORDER BY
  total_spend DESC;