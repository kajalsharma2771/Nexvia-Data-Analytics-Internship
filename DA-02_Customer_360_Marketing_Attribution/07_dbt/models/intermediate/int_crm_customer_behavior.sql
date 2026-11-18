SELECT
    customer_id,
    customer_name,
    acquisition_channel,
    total_orders,
    total_revenue,
    first_order_date,
    last_order_date,

    SAFE_DIVIDE(total_revenue, total_orders) AS average_order_value,

    DATE_DIFF(
        CURRENT_DATE(),
        last_order_date,
        DAY
    ) AS days_since_last_order,

    DATE_DIFF(
        last_order_date,
        first_order_date,
        DAY
    ) AS customer_purchase_period_days

FROM {{ ref('int_crm_customer_summary') }}