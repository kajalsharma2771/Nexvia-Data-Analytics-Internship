WITH customer_orders AS (
  SELECT
    customer_id,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(order_amount) AS total_revenue
  FROM
    `customer360-mktg.customer360.crm_orders`
  GROUP BY customer_id
)

SELECT
  CASE
    WHEN total_orders = 1 THEN 'One-Time Customers'
    ELSE 'Repeat Customers'
  END AS customer_type,

  COUNT(*) AS total_customers,
  SUM(total_orders) AS total_orders,
  SUM(total_revenue) AS total_revenue,
  ROUND(AVG(total_revenue), 2) AS avg_customer_revenue

FROM customer_orders

GROUP BY customer_type
ORDER BY total_customers DESC;