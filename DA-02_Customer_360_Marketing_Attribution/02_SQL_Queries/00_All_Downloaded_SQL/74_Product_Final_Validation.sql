SELECT
  column_name,
  data_type
FROM `customer360-mktg.customer360.INFORMATION_SCHEMA.COLUMNS`
WHERE table_name = 'crm_products'
ORDER BY ordinal_position;