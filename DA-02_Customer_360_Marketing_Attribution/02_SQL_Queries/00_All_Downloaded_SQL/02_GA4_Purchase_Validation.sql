SELECT
    event_name,
    COUNT(*) AS total_events
FROM
    `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE
    _TABLE_SUFFIX BETWEEN '20201101' AND '20201107'
    AND event_name = 'purchase'
GROUP BY
    event_name;