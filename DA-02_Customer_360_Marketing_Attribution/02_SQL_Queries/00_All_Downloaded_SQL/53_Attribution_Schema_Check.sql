SELECT
  table_name,
  column_name,
  data_type
FROM
  `customer360-mktg.customer360.INFORMATION_SCHEMA.COLUMNS`
WHERE
  table_name IN (
    'crm_attribution',
    'attribution_model_results'
  )
ORDER BY
  table_name,
  ordinal_position;