SELECT
  COUNT(*) AS total_records,
  COUNTIF(attribution_id IS NULL) AS missing_attribution_id,
  COUNTIF(customer_id IS NULL) AS missing_customer_id,
  COUNTIF(order_id IS NULL) AS missing_order_id,
  COUNTIF(channel IS NULL) AS missing_channel,
  COUNTIF(attribution_model IS NULL) AS missing_model,
  COUNTIF(attributed_revenue IS NULL) AS missing_revenue,
  COUNT(DISTINCT attribution_id) AS unique_attribution_ids
FROM `customer360-mktg.customer360.crm_attribution`;