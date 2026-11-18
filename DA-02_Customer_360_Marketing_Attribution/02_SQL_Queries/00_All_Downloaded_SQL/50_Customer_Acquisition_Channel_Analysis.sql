SELECT
  c.acquisition_channel,
  COUNT(DISTINCT c.customer_id) AS total_customers,
  COUNT(DISTINCT o.order_id) AS total_orders,
  COALESCE(SUM(o.order_amount), 0) AS total_revenue,

  ROUND(
    SAFE_DIVIDE(
      SUM(o.order_amount),
      COUNT(DISTINCT c.customer_id)
    ), 2
  ) AS revenue_per_customer

FROM
  `customer360-mktg.customer360.crm_customers_import` c

LEFT JOIN
  `customer360-mktg.customer360.crm_orders` o
ON
  c.customer_id = o.customer_id

GROUP BY
  c.acquisition_channel

ORDER BY
  total_revenue DESC;