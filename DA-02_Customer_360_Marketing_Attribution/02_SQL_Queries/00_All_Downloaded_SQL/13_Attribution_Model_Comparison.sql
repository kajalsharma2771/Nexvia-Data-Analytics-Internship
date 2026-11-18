WITH base AS (
  SELECT
    o.order_id,
    o.order_amount,
    s.source,
    s.campaign,
    s.session_start,

    ROW_NUMBER() OVER (
      PARTITION BY o.order_id
      ORDER BY s.session_start
    ) AS first_rank,

    ROW_NUMBER() OVER (
      PARTITION BY o.order_id
      ORDER BY s.session_start DESC
    ) AS last_rank,

    COUNT(*) OVER (
      PARTITION BY o.order_id
    ) AS touch_count,

    TIMESTAMP_DIFF(
      TIMESTAMP(o.order_date),
      s.session_start,
      HOUR
    ) AS hours_before_order

  FROM `customer360-mktg.customer360.fact_orders` o
  JOIN `customer360-mktg.customer360.crm_customer_sessions` s
    ON o.customer_id = s.customer_id
    AND DATE(s.session_start) <= o.order_date
    AND DATE(s.session_start) >= DATE_SUB(
      o.order_date, INTERVAL 30 DAY
    )
),

weighted AS (
  SELECT
    *,
    POW(2, -hours_before_order / 168.0) AS touch_weight
  FROM base
),

final_data AS (
  SELECT
    *,
    SUM(touch_weight) OVER (
      PARTITION BY order_id
    ) AS total_weight
  FROM weighted
),

comparison AS (

  SELECT
    'First Touch' AS attribution_model,
    source,
    campaign,
    order_id,
    order_amount AS attributed_revenue
  FROM final_data
  WHERE first_rank = 1

  UNION ALL

  SELECT
    'Last Touch',
    source,
    campaign,
    order_id,
    order_amount
  FROM final_data
  WHERE last_rank = 1

  UNION ALL

  SELECT
    'Linear',
    source,
    campaign,
    order_id,
    order_amount / touch_count
  FROM final_data

  UNION ALL

  SELECT
    'Time Decay',
    source,
    campaign,
    order_id,
    order_amount * SAFE_DIVIDE(
      touch_weight, total_weight
    )
  FROM final_data
)

SELECT
  attribution_model,
  source,
  campaign,
  COUNT(DISTINCT order_id) AS orders,
  ROUND(SUM(attributed_revenue), 2) AS attributed_revenue

FROM comparison
GROUP BY
  attribution_model,
  source,
  campaign
ORDER BY
  attribution_model,
  attributed_revenue DESC;