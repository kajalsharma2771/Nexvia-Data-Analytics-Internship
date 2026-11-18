SELECT
  COUNT(*) AS total_events,
  COUNT(DISTINCT event_id) AS unique_event_ids,
  COUNTIF(customer_id IS NULL) AS missing_customer_ids,
  COUNTIF(session_id IS NULL) AS missing_session_ids,
  COUNTIF(event_name IS NULL) AS missing_event_names,
  COUNT(DISTINCT event_name) AS unique_event_types
FROM `customer360-mktg.customer360.crm_web_events`;