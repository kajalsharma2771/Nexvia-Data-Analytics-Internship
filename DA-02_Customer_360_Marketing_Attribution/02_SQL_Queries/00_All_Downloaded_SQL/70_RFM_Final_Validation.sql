SELECT
  COUNT(*) AS total_customers,
  COUNT(DISTINCT customer_id) AS unique_customers,
  COUNTIF(customer_segment IS NULL) AS missing_segments
FROM `customer360-mktg.customer360.vw_customer_rfm`;