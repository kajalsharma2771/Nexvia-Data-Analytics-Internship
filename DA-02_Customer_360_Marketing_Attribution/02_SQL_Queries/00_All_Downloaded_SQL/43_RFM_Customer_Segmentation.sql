CREATE OR REPLACE VIEW
`customer360-mktg.customer360.vw_customer_rfm` AS

WITH customer_metrics AS (
  SELECT
    customer_id,
    MAX(order_date) AS last_order_date,
    COUNT(DISTINCT order_id) AS frequency,
    SUM(order_amount) AS monetary
  FROM
    `customer360-mktg.customer360.crm_orders`
  GROUP BY customer_id
),

reference_date AS (
  SELECT DATE_ADD(MAX(order_date), INTERVAL 1 DAY) AS analysis_date
  FROM `customer360-mktg.customer360.crm_orders`
),

rfm_scores AS (
  SELECT
    m.customer_id,
    DATE_DIFF(r.analysis_date, m.last_order_date, DAY) AS recency,
    m.frequency,
    m.monetary,

    NTILE(5) OVER (
      ORDER BY DATE_DIFF(r.analysis_date, m.last_order_date, DAY) DESC
    ) AS recency_score,

    NTILE(5) OVER (
      ORDER BY m.frequency ASC
    ) AS frequency_score,

    NTILE(5) OVER (
      ORDER BY m.monetary ASC
    ) AS monetary_score

  FROM customer_metrics m
  CROSS JOIN reference_date r
)

SELECT
  *,
  CONCAT(
    CAST(recency_score AS STRING),
    CAST(frequency_score AS STRING),
    CAST(monetary_score AS STRING)
  ) AS rfm_segment,

  CASE
    WHEN recency_score >= 4
      AND frequency_score >= 4
      AND monetary_score >= 4
      THEN 'Champions'

    WHEN frequency_score >= 4
      THEN 'Loyal Customers'

    WHEN recency_score >= 4
      THEN 'Recent Customers'

    WHEN recency_score <= 2
      THEN 'At Risk'

    ELSE 'Regular Customers'
  END AS customer_segment

FROM rfm_scores;