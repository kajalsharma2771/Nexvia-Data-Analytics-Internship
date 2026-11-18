WITH actual_revenue AS (
  SELECT
    SUM(order_amount) AS total_order_revenue
  FROM `customer360-mktg.customer360.crm_orders`
),

attribution_revenue AS (
  SELECT
    attribution_model,
    SUM(attributed_revenue) AS total_attributed_revenue
  FROM `customer360-mktg.customer360.attribution_model_results`
  GROUP BY attribution_model
)

SELECT
  a.attribution_model,
  r.total_order_revenue,
  a.total_attributed_revenue,

  ROUND(
    SAFE_DIVIDE(
      a.total_attributed_revenue,
      r.total_order_revenue
    ) * 100, 2
  ) AS attribution_coverage_percent,

  ROUND(
    r.total_order_revenue - a.total_attributed_revenue, 2
  ) AS revenue_difference

FROM attribution_revenue a
CROSS JOIN actual_revenue r
ORDER BY a.attribution_model;