WITH customer_cohorts AS (
  SELECT
    customer_id,
    DATE_TRUNC(signup_date, MONTH) AS cohort_month
  FROM
    `customer360-mktg.customer360.crm_customers_import`
),

monthly_activity AS (
  SELECT DISTINCT
    customer_id,
    DATE_TRUNC(order_date, MONTH) AS activity_month
  FROM
    `customer360-mktg.customer360.crm_orders`
),

cohort_data AS (
  SELECT
    c.cohort_month,
    DATE_DIFF(
      a.activity_month,
      c.cohort_month,
      MONTH
    ) AS months_since_signup,
    a.customer_id
  FROM customer_cohorts c
  JOIN monthly_activity a
    ON c.customer_id = a.customer_id
  WHERE a.activity_month >= c.cohort_month
),

cohort_size AS (
  SELECT
    cohort_month,
    COUNT(DISTINCT customer_id) AS total_cohort_customers
  FROM customer_cohorts
  GROUP BY cohort_month
)

SELECT
  d.cohort_month,
  d.months_since_signup,
  s.total_cohort_customers,
  COUNT(DISTINCT d.customer_id) AS active_customers,

  ROUND(
    SAFE_DIVIDE(
      COUNT(DISTINCT d.customer_id) * 100,
      s.total_cohort_customers
    ), 2
  ) AS retention_rate_percent

FROM cohort_data d
JOIN cohort_size s
  ON d.cohort_month = s.cohort_month

GROUP BY
  d.cohort_month,
  d.months_since_signup,
  s.total_cohort_customers

ORDER BY
  d.cohort_month,
  d.months_since_signup;