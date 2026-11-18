SELECT
  COUNT(DISTINCT user_pseudo_id) AS unique_users,
  COUNTIF(event_name = 'session_start') AS total_sessions,
  COUNTIF(event_name = 'purchase') AS purchase_events
FROM
  `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE
  _TABLE_SUFFIX BETWEEN '20201101' AND '20201107';