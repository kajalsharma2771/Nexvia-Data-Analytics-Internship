{{ config(materialized='view') }}

SELECT
    order_item_id,
    order_id,
    product_id,
    quantity,
    unit_price,
    discount
FROM `customer360-mktg.customer360.crm_order_items`