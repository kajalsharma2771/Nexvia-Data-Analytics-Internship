
SELECT
    customer_id,
    customer_name,
    acquisition_channel,
    total_orders,
    total_revenue,
    first_order_date,
    last_order_date,
    average_order_value,
    days_since_last_order,
    customer_purchase_period_days
FROM {{ ref('int_crm_customer_behavior') }}
