SELECT 'crm_customers_import' AS table_name, COUNT(*) AS total_records
FROM `customer360-mktg.customer360.crm_customers_import`

UNION ALL
SELECT 'crm_orders', COUNT(*)
FROM `customer360-mktg.customer360.crm_orders`

UNION ALL
SELECT 'crm_order_items', COUNT(*)
FROM `customer360-mktg.customer360.crm_order_items`

UNION ALL
SELECT 'crm_products', COUNT(*)
FROM `customer360-mktg.customer360.crm_products`

UNION ALL
SELECT 'crm_marketing_spend', COUNT(*)
FROM `customer360-mktg.customer360.crm_marketing_spend`

UNION ALL
SELECT 'crm_campaigns', COUNT(*)
FROM `customer360-mktg.customer360.crm_campaigns`

UNION ALL
SELECT 'crm_web_events', COUNT(*)
FROM `customer360-mktg.customer360.crm_web_events`

UNION ALL
SELECT 'crm_attribution', COUNT(*)
FROM `customer360-mktg.customer360.crm_attribution`

UNION ALL
SELECT 'attribution_model_results', COUNT(*)
FROM `customer360-mktg.customer360.attribution_model_results`;