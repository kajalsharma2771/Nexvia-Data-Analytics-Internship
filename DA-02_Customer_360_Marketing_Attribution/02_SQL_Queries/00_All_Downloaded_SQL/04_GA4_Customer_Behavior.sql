SELECT
    user_pseudo_id,
    COUNTIF(event_name = 'session_start') AS sessions,
    COUNTIF(event_name = 'view_item') AS product_views,
    COUNTIF(event_name = 'add_to_cart') AS add_to_cart_events,
    COUNTIF(event_name = 'purchase') AS purchases
FROM
    `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE
    _TABLE_SUFFIX BETWEEN '20201101' AND '20201107'
    AND user_pseudo_id IS NOT NULL
GROUP BY
    user_pseudo_id
ORDER BY
    purchases DESC,
    sessions DESC
LIMIT 20;