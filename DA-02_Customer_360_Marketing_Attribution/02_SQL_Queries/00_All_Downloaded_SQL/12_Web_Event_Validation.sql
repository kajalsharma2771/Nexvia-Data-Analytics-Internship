SELECT
  COUNT(*) AS total_events,
  COUNT(DISTINCT event_id) AS unique_events,
  COUNT(DISTINCT customer_id) AS unique_customers,
  COUNT(DISTINCT session_id) AS unique_sessions,
  COUNTIF(event_name = 'purchase') AS purchase_events
FROM
  `customer360-mktg.customer360.crm_web_events`;