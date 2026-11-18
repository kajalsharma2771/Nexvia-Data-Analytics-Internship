CREATE OR REPLACE VIEW
  `customer360-mktg.customer360.vw_attribution_summary` AS

SELECT
  attribution_model,
  source,
  campaign,
  SUM(orders) AS credited_orders,
  ROUND(SUM(attributed_revenue), 2) AS attributed_revenue
FROM
  `customer360-mktg.customer360.attribution_model_results`
GROUP BY
  attribution_model,
  source,
  campaign;