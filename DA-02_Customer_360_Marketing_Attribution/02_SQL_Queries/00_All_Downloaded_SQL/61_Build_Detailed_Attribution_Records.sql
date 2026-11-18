CREATE OR REPLACE TABLE
`customer360-mktg.customer360.crm_attribution` AS

WITH matched_sessions AS (
  SELECT
    o.order_id,
    o.customer_id,
    o.order_date,
    o.order_amount,
    s.session_id,
    s.session_start,
    m.source AS channel,
    m.campaign_id,
    ROW_NUMBER() OVER (
      PARTITION BY o.order_id
      ORDER BY s.session_start ASC
    ) AS first_rank,
    ROW_NUMBER() OVER (
      PARTITION BY o.order_id
      ORDER BY s.session_start DESC
    ) AS last_rank,
    COUNT(*) OVER (
      PARTITION BY o.order_id
    ) AS touchpoint_count,
    POW(
      2,
      -TIMESTAMP_DIFF(
        TIMESTAMP(o.order_date),
        s.session_start,
        HOUR
      ) / 168.0
    ) AS decay_weight
  FROM `customer360-mktg.customer360.crm_orders` o
  JOIN `customer360-mktg.customer360.crm_customer_sessions` s
    ON o.customer_id = s.customer_id
    AND DATE(s.session_start) <= o.order_date
    AND DATE(s.session_start) >= DATE_SUB(
      o.order_date, INTERVAL 30 DAY
    )
  LEFT JOIN `customer360-mktg.customer360.session_campaign_mapping` m
    ON s.session_id = m.session_id
),

attribution_rows AS (
  SELECT
    order_id,
    customer_id,
    session_id,
    campaign_id,
    channel,
    'First Touch' AS attribution_model,
    DATE(session_start) AS attribution_date,
    order_amount AS attributed_revenue
  FROM matched_sessions
  WHERE first_rank = 1

  UNION ALL

  SELECT
    order_id,
    customer_id,
    session_id,
    campaign_id,
    channel,
    'Last Touch',
    DATE(session_start),
    order_amount
  FROM matched_sessions
  WHERE last_rank = 1

  UNION ALL

  SELECT
    order_id,
    customer_id,
    session_id,
    campaign_id,
    channel,
    'Linear',
    DATE(session_start),
    SAFE_DIVIDE(order_amount, touchpoint_count)
  FROM matched_sessions

  UNION ALL

  SELECT
    order_id,
    customer_id,
    session_id,
    campaign_id,
    channel,
    'Time Decay',
    DATE(session_start),
    SAFE_DIVIDE(
      order_amount * decay_weight,
      SUM(decay_weight) OVER (PARTITION BY order_id)
    )
  FROM matched_sessions
)

SELECT
  CONCAT(
    order_id, '_', session_id, '_', REPLACE(attribution_model, ' ', '_')
  ) AS attribution_id,
  customer_id,
  order_id,
  campaign_id,
  channel,
  attribution_model,
  attribution_date,
  CAST(attributed_revenue AS NUMERIC) AS attributed_revenue
FROM attribution_rows;