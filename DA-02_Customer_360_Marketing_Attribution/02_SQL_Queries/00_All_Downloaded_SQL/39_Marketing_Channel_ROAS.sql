WITH marketing_spend AS (
  SELECT
    channel,
    SUM(spend_amount) AS total_spend
  FROM
    `customer360-mktg.customer360.crm_marketing_spend`
  GROUP BY channel
),

attributed_revenue AS (
  SELECT
    source AS channel,
    SUM(attributed_revenue) AS total_revenue
  FROM
    `customer360-mktg.customer360.attribution_model_results`
  WHERE
    attribution_model = 'Last Touch'
  GROUP BY source
)

SELECT
  s.channel,
  s.total_spend,
  COALESCE(r.total_revenue, 0) AS attributed_revenue,
  ROUND(
    SAFE_DIVIDE(r.total_revenue, s.total_spend), 2
  ) AS roas
FROM marketing_spend s
LEFT JOIN attributed_revenue r
  ON s.channel = r.channel
ORDER BY roas DESC;