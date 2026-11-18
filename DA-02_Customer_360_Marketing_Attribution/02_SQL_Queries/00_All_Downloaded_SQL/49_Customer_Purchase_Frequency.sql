WITH customer_frequency AS (
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
    WHEN total_orders >= 4 THEN 'Frequent Buyers'
    WHEN total_orders = 3 THEN 'Regular Buyers'
    WHEN total_orders = 2 THEN 'Occasional Buyers'
    ELSE 'One-Time Buyers'
  END AS purchase_frequency,

  COUNT(*) AS total_customers,
  SUM(total_orders) AS total_orders,
  SUM(total_revenue) AS total_revenue,
  ROUND(AVG(total_revenue), 2) AS avg_customer_revenue

FROM customer_frequency
GROUP BY purchase_frequency
ORDER BY total_customers DESC;