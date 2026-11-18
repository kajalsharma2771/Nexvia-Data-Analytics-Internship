
-- Intermediate model: CRM Order Details

SELECT
    oi.order_item_id,
    oi.order_id,
    o.customer_id,
    o.order_date,
    oi.product_id,
    p.product_name,
    p.category,
    oi.quantity,
    oi.unit_price,
    p.unit_cost,

    oi.quantity * oi.unit_price AS item_revenue,

    oi.quantity * p.unit_cost AS item_cost,

    (oi.quantity * oi.unit_price) -
    (oi.quantity * p.unit_cost) AS item_profit

FROM {{ ref('stg_crm_order_items') }} AS oi

LEFT JOIN {{ ref('stg_crm_orders') }} AS o
    ON oi.order_id = o.order_id

LEFT JOIN {{ ref('stg_crm_products') }} AS p
    ON oi.product_id = p.product_id
