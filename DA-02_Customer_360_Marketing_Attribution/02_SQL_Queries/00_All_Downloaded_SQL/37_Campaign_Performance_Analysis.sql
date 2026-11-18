SELECT
  c.campaign_id,
  c.campaign_name,
  c.channel,
  c.campaign_budget,
  COALESCE(SUM(m.spend_amount), 0) AS actual_spend,
  COALESCE(SUM(m.impressions), 0) AS impressions,
  COALESCE(SUM(m.clicks), 0) AS clicks,
  COALESCE(SUM(m.conversions), 0) AS conversions,

  ROUND(
    SAFE_DIVIDE(SUM(m.clicks) * 100, SUM(m.impressions)), 2
  ) AS ctr_percent,

  ROUND(
    SAFE_DIVIDE(SUM(m.spend_amount) * 100, c.campaign_budget), 2
  ) AS budget_utilization_percent

FROM
  `customer360-mktg.customer360.crm_campaigns` c

LEFT JOIN
  `customer360-mktg.customer360.crm_marketing_spend` m
ON
  c.campaign_name = m.campaign_name

GROUP BY
  c.campaign_id,
  c.campaign_name,
  c.channel,
  c.campaign_budget

ORDER BY
  actual_spend DESC;