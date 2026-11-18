WITH customers AS (

    SELECT
        customer_id,
        customer_name,
        email,
        acquisition_channel
    FROM {{ ref('stg_crm_customers') }}

),

orders AS (

    SELECT
        customer_id,
        COUNT(DISTINCT order_id) AS total_orders,
        SUM(order_amount) AS total_revenue,
        MIN(order_date) AS first_order_date,
        MAX(order_date) AS last_order_date
    FROM {{ ref('stg_crm_orders') }}
    GROUP BY customer_id

)

SELECT
    c.customer_id,
    c.customer_name,
    c.email,
    c.acquisition_channel,
    COALESCE(o.total_orders, 0) AS total_orders,
    COALESCE(o.total_revenue, 0) AS total_revenue,
    o.first_order_date,
    o.last_order_date
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id