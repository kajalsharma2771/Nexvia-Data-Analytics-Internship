SELECT
  COUNT(*) AS total_customers,
  COUNT(DISTINCT customer_id) AS unique_customers,
  COUNTIF(clv_segment IS NULL) AS missing_clv_segments,
  ROUND(SUM(lifetime_revenue), 2) AS total_lifetime_revenue
FROM `customer360-mktg.customer360.vw_customer_clv`;