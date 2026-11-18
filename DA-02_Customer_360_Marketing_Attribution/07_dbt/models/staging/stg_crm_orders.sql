
{{ config(materialized='view') }}

SELECT
    order_id,
    customer_id,
    order_date,
    order_amount,
    order_status,
    payment_method
FROM `customer360-mktg.customer360.crm_orders`
