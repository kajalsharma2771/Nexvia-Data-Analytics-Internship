SELECT
  COUNT(*) AS total_customers,
  COUNT(DISTINCT customer_id) AS unique_customers,
  COUNTIF(email IS NULL) AS missing_emails
FROM
  `customer360-mktg.customer360.crm_customers_import`;