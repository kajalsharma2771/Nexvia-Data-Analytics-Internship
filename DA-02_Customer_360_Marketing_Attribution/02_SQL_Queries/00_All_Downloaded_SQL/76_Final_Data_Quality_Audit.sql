SELECT
  'Customers' AS data_area,
  COUNT(*) AS total_records,
  COUNTIF(customer_id IS NULL) AS missing_ids
FROM `customer360-mktg.customer360.crm_customers_import`

UNION ALL

SELECT
  'Orders',
  COUNT(*),
  COUNTIF(order_id IS NULL)
FROM `customer360-mktg.customer360.crm_orders`

UNION ALL

SELECT
  'Products',
  COUNT(*),
  COUNTIF(product_id IS NULL)
FROM `customer360-mktg.customer360.crm_products`

UNION ALL

SELECT
  'Marketing Spend',
  COUNT(*),
  COUNTIF(spend_id IS NULL)
FROM `customer360-mktg.customer360.crm_marketing_spend`

UNION ALL

SELECT
  'Attribution',
  COUNT(*),
  COUNTIF(attribution_id IS NULL)
FROM `customer360-mktg.customer360.crm_attribution`

UNION ALL

SELECT
  'Web Events',
  COUNT(*),
  COUNTIF(event_id IS NULL)
FROM `customer360-mktg.customer360.crm_web_events`

ORDER BY data_area;