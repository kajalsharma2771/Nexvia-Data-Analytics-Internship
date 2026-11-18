SELECT
  (SELECT COUNT(*)
   FROM `customer360-mktg.customer360.crm_customers_import`)
    AS total_customers,

  (SELECT COUNT(*)
   FROM `customer360-mktg.customer360.crm_orders`)
    AS total_orders,

  (SELECT ROUND(SUM(order_amount), 2)
   FROM `customer360-mktg.customer360.crm_orders`)
    AS total_revenue,

  (SELECT COUNT(*)
   FROM `customer360-mktg.customer360.crm_products`)
    AS total_products,

  (SELECT ROUND(SUM(spend_amount), 2)
   FROM `customer360-mktg.customer360.crm_marketing_spend`)
    AS total_marketing_spend,

  (SELECT COUNT(*)
   FROM `customer360-mktg.customer360.crm_attribution`)
    AS attribution_records,

  (SELECT COUNT(*)
   FROM `customer360-mktg.customer360.crm_web_events`)
    AS total_web_events;