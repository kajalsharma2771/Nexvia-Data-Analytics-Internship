{{ config(materialized='view') }}

SELECT
    product_id,
    product_name,
    category,
    subcategory,
    brand,
    unit_cost,
    unit_price
FROM `customer360-mktg.customer360.crm_products`