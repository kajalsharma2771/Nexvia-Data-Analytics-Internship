SELECT
  attribution_model,
  ROUND(SUM(attributed_revenue), 2) AS attributed_revenue,
  COUNT(DISTINCT order_id) AS unique_orders,
  COUNT(*) AS attribution_records
FROM `customer360-mktg.customer360.crm_attribution`
GROUP BY attribution_model
ORDER BY attribution_model;