SELECT
  table_type,
  COUNT(*) AS total_objects
FROM `customer360-mktg.customer360.INFORMATION_SCHEMA.TABLES`
GROUP BY table_type
ORDER BY table_type;