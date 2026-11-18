SELECT
  COUNT(*) AS total_products,
  COUNT(DISTINCT product_id) AS unique_products,
  COUNT(DISTINCT category) AS unique_categories,
  MIN(unit_price) AS minimum_price,
  MAX(unit_price) AS maximum_price
FROM
  `customer360-mktg.customer360.crm_products`;