SELECT
  table_name,
  column_name,
  data_type
FROM `customer360-mktg.customer360.INFORMATION_SCHEMA.COLUMNS`
WHERE table_name IN (
  'crm_customer_sessions',
  'crm_orders',
  'session_campaign_mapping',
  'crm_campaigns'
)
ORDER BY
  table_name,
  ordinal_position;