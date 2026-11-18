SELECT
  COUNT(*) AS total_order_items,
  COUNT(DISTINCT order_item_id) AS unique_items,
  COUNT(DISTINCT order_id) AS unique_orders,
  COUNT(DISTINCT product_id) AS unique_products,
  SUM(quantity) AS total_quantity
FROM
  `customer360-mktg.customer360.crm_order_items`;