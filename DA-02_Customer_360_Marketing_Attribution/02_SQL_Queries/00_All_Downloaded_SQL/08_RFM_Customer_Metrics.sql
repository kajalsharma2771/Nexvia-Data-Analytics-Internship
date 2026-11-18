SELECT
    customer_id,
    total_orders,
    total_revenue,
    latest_order_date,
    DATE_DIFF(
        CURRENT_DATE(),
        latest_order_date,
        DAY
    ) AS recency_days
FROM
    `customer360-mktg.customer360.mart_customer_360`
ORDER BY
    total_revenue DESC;