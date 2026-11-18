SELECT
  table_name,
  table_type,
  creation_time
FROM
  `customer360-mktg.customer360.INFORMATION_SCHEMA.TABLES`
ORDER BY
  table_type,
  table_name;