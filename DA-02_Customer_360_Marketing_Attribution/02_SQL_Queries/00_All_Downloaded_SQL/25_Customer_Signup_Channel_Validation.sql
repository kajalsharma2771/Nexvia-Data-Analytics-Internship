SELECT
  COUNT(*) AS total_customers,
  COUNTIF(signup_date IS NULL) AS missing_signup_dates,
  COUNTIF(acquisition_channel IS NULL) AS missing_channels,
  COUNT(DISTINCT acquisition_channel) AS unique_channels,
  MIN(signup_date) AS first_signup_date,
  MAX(signup_date) AS last_signup_date
FROM
  `customer360-mktg.customer360.crm_customers_import`;