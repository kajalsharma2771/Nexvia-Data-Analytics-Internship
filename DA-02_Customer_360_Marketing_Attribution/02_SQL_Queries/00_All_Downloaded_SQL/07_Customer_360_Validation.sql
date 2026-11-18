SELECT
    COUNT(*) AS total_customers,
    SUM(total_orders) AS total_orders,
    SUM(total_revenue) AS total_revenue,
    COUNTIF(total_orders = 0) AS customers_without_orders
FROM
    `customer360-mktg.customer360.mart_customer_360`;