SELECT
    COUNT(*) AS total_orders,
    SUM(order_amount) AS total_revenue,
    AVG(order_amount) AS average_order_value,
    MIN(order_amount) AS minimum_order_value,
    MAX(order_amount) AS maximum_order_value
FROM
    `customer360-mktg.customer360.fact_orders`;