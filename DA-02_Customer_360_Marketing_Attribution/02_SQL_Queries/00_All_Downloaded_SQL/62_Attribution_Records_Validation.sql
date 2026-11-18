SELECT
  attribution_model,
  COUNT(*) AS attribution_records,
  COUNT(DISTINCT order_id) AS unique_orders,
  COUNT(DISTINCT customer_id) AS unique_customers,
  COUNT(DISTINCT campaign_id) AS unique_campaigns,
  ROUND(SUM(attributed_revenue), 2) AS total_attributed_revenue
FROM `customer360-mktg.customer360.crm_attribution`
GROUP BY attribution_model
ORDER BY attribution_model;