WITH base AS (
  SELECT
    o.order_id,
    o.order_amount,
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
    POW(
      2,
      -TIMESTAMP_DIFF(
        TIMESTAMP(o.order_date),
        s.session_start,
        HOUR
      ) / 168.0
    ) AS touch_weight
  FROM `customer360-mktg.customer360.fact_orders` o
  JOIN `customer360-mktg.customer360.crm_customer_sessions` s
    ON o.customer_id = s.customer_id
    AND DATE(s.session_start) <= o.order_date
    AND DATE(s.session_start) >= DATE_SUB(
      o.order_date, INTERVAL 30 DAY
    )
),
allocated AS (
  SELECT
    *,
    SUM(touch_weight) OVER (
      PARTITION BY order_id
    ) AS total_weight
  FROM base
),
results AS (
  SELECT 'First Touch' AS model, order_amount AS revenue
  FROM allocated WHERE first_rank = 1

  UNION ALL

  SELECT 'Last Touch', order_amount
  FROM allocated WHERE last_rank = 1

  UNION ALL

  SELECT 'Linear', order_amount / touch_count
  FROM allocated

  UNION ALL

  SELECT 'Time Decay',
    order_amount * SAFE_DIVIDE(touch_weight, total_weight)
  FROM allocated
)
SELECT
  model,
  ROUND(SUM(revenue), 2) AS total_attributed_revenue
FROM results
GROUP BY model
ORDER BY model;