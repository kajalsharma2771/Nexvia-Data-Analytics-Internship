SELECT
    COUNT(*) AS total_orders,
    COUNT(DISTINCT o.customer_id) AS unique_customers,
    COUNTIF(c.customer_id IS NULL) AS unmatched_customers
FROM
    `customer360-mktg.customer360.fact_orders` o
LEFT JOIN
    `customer360-mktg.customer360.dim_customers` c
ON
    o.customer_id = c.customer_id;