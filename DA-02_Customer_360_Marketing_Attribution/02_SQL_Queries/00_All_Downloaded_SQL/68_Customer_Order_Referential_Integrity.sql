SELECT
  'Orders with missing customers' AS validation_check,
  COUNT(*) AS failed_records
FROM `customer360-mktg.customer360.crm_orders` o
LEFT JOIN `customer360-mktg.customer360.crm_customers_import` c
  ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL

UNION ALL

SELECT
  'Order items with missing orders',
  COUNT(*)
FROM `customer360-mktg.customer360.crm_order_items` i
LEFT JOIN `customer360-mktg.customer360.crm_orders` o
  ON i.order_id = o.order_id
WHERE o.order_id IS NULL

UNION ALL

SELECT
  'Order items with missing products',
  COUNT(*)
FROM `customer360-mktg.customer360.crm_order_items` i
LEFT JOIN `customer360-mktg.customer360.crm_products` p
  ON i.product_id = p.product_id
WHERE p.product_id IS NULL;