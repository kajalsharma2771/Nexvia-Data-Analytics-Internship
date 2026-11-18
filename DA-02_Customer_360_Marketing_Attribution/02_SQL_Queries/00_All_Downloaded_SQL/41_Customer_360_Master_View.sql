CREATE OR REPLACE VIEW
`customer360-mktg.customer360.vw_customer_360` AS

WITH order_summary AS (
  SELECT
    customer_id,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(order_amount) AS total_revenue,
    AVG(order_amount) AS average_order_value,
    MIN(order_date) AS first_order_date,
    MAX(order_date) AS last_order_date
  FROM
    `customer360-mktg.customer360.crm_orders`
  GROUP BY customer_id
)

SELECT
  c.customer_id,
  c.first_name,
  c.last_name,
  c.email,
  c.signup_date,
  c.acquisition_channel,
  c.country,

  COALESCE(o.total_orders, 0) AS total_orders,
  COALESCE(o.total_revenue, 0) AS total_revenue,
  COALESCE(o.average_order_value, 0) AS average_order_value,
  o.first_order_date,
  o.last_order_date

FROM
  `customer360-mktg.customer360.crm_customers` c

LEFT JOIN order_summary o
  ON c.customer_id = o.customer_id;