-- Customer 360 and Marketing Attribution Platform
-- Consolidated backup of 77 SQL files


-- ==================== 01_GA4_Event_Validation.sql ====================
SELECT
    event_name,
    COUNT(*) AS total_events
FROM
    `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE
    _TABLE_SUFFIX BETWEEN '20201101' AND '20201107'
    AND event_name = 'purchase'
GROUP BY
    event_name;

-- ==================== 02_GA4_Purchase_Validation.sql ====================
SELECT
    event_name,
    COUNT(*) AS total_events
FROM
    `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE
    _TABLE_SUFFIX BETWEEN '20201101' AND '20201107'
    AND event_name = 'purchase'
GROUP BY
    event_name;

-- ==================== 03_GA4_User_Session_Metrics.sql ====================
SELECT
  COUNT(DISTINCT user_pseudo_id) AS unique_users,
  COUNTIF(event_name = 'session_start') AS total_sessions,
  COUNTIF(event_name = 'purchase') AS purchase_events
FROM
  `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE
  _TABLE_SUFFIX BETWEEN '20201101' AND '20201107';

-- ==================== 04_GA4_Customer_Behavior.sql ====================
SELECT
    user_pseudo_id,
    COUNTIF(event_name = 'session_start') AS sessions,
    COUNTIF(event_name = 'view_item') AS product_views,
    COUNTIF(event_name = 'add_to_cart') AS add_to_cart_events,
    COUNTIF(event_name = 'purchase') AS purchases
FROM
    `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE
    _TABLE_SUFFIX BETWEEN '20201101' AND '20201107'
    AND user_pseudo_id IS NOT NULL
GROUP BY
    user_pseudo_id
ORDER BY
    purchases DESC,
    sessions DESC
LIMIT 20;

-- ==================== 05_Order_Customer_Validation.sql ====================
SELECT
    COUNT(*) AS total_orders,
    COUNT(DISTINCT o.customer_id) AS unique_customers,
    COUNTIF(c.customer_id IS NULL) AS unmatched_customers
FROM
    `customer360-mktg.customer360.fact_orders` o
LEFT JOIN
    `customer360-mktg.customer360.dim_customers` c
ON
    o.customer_id = c.customer_id;

-- ==================== 06_Order_Revenue_Validation.sql ====================
SELECT
    COUNT(*) AS total_orders,
    SUM(order_amount) AS total_revenue,
    AVG(order_amount) AS average_order_value,
    MIN(order_amount) AS minimum_order_value,
    MAX(order_amount) AS maximum_order_value
FROM
    `customer360-mktg.customer360.fact_orders`;

-- ==================== 07_Customer_360_Validation.sql ====================
SELECT
    COUNT(*) AS total_customers,
    SUM(total_orders) AS total_orders,
    SUM(total_revenue) AS total_revenue,
    COUNTIF(total_orders = 0) AS customers_without_orders
FROM
    `customer360-mktg.customer360.mart_customer_360`;

-- ==================== 08_RFM_Customer_Metrics.sql ====================
SELECT
    customer_id,
    total_orders,
    total_revenue,
    latest_order_date,
    DATE_DIFF(
        CURRENT_DATE(),
        latest_order_date,
        DAY
    ) AS recency_days
FROM
    `customer360-mktg.customer360.mart_customer_360`
ORDER BY
    total_revenue DESC;

-- ==================== 09_Customer_Segment_Summary.sql ====================
SELECT
    CASE
        WHEN r_score >= 4 AND f_score >= 4 AND m_score >= 4
            THEN 'Champions'
        WHEN r_score >= 3 AND f_score >= 3
            THEN 'Loyal Customers'
        WHEN r_score >= 4 AND f_score <= 2
            THEN 'New Customers'
        WHEN r_score <= 2 AND f_score >= 3
            THEN 'At Risk'
        ELSE 'Needs Attention'
    END AS customer_segment,
    COUNT(*) AS total_customers,
    ROUND(SUM(total_revenue), 2) AS total_revenue
FROM
    `customer360-mktg.customer360.rfm_customer_scores`
GROUP BY
    customer_segment
ORDER BY
    total_customers DESC;

-- ==================== 10_Marketing_Channel_Analysis.sql ====================
SELECT
    channel,
    COUNT(*) AS total_campaigns,
    SUM(campaign_budget) AS total_budget,
    ROUND(AVG(campaign_budget), 2) AS average_budget
FROM
    `customer360-mktg.customer360.crm_campaigns`
GROUP BY
    channel
ORDER BY
    total_budget DESC;

-- ==================== 11_Campaign_Performance_Analysis..sql ====================
SELECT
    c.campaign_id,
    c.campaign_name,
    c.channel,
    c.campaign_budget,
    s.spend_amount,
    s.impressions,
    s.clicks,
    s.conversions,

    ROUND(
        SAFE_DIVIDE(s.clicks * 100, s.impressions), 2
    ) AS ctr_percent,

    ROUND(
        SAFE_DIVIDE(s.conversions * 100, s.clicks), 2
    ) AS conversion_rate_percent,

    ROUND(
        SAFE_DIVIDE(s.spend_amount, s.clicks), 2
    ) AS cost_per_click,

    ROUND(
        SAFE_DIVIDE(s.spend_amount, s.conversions), 2
    ) AS cost_per_acquisition

FROM
    `customer360-mktg.customer360.crm_campaigns` c

LEFT JOIN
    `customer360-mktg.customer360.crm_marketing_spend` s
ON
    c.campaign_name = s.campaign_name

ORDER BY
    s.spend_amount DESC;

-- ==================== 12_Web_Event_Validation.sql ====================
SELECT
  COUNT(*) AS total_events,
  COUNT(DISTINCT event_id) AS unique_events,
  COUNT(DISTINCT customer_id) AS unique_customers,
  COUNT(DISTINCT session_id) AS unique_sessions,
  COUNTIF(event_name = 'purchase') AS purchase_events
FROM
  `customer360-mktg.customer360.crm_web_events`;

-- ==================== 13_Attribution_Model_Comparison.sql ====================
WITH base AS (
  SELECT
    o.order_id,
    o.order_amount,
    s.source,
    s.campaign,
    s.session_start,

    ROW_NUMBER() OVER (
      PARTITION BY o.order_id
      ORDER BY s.session_start
    ) AS first_rank,

    ROW_NUMBER() OVER (
      PARTITION BY o.order_id
      ORDER BY s.session_start DESC
    ) AS last_rank,

    COUNT(*) OVER (
      PARTITION BY o.order_id
    ) AS touch_count,

    TIMESTAMP_DIFF(
      TIMESTAMP(o.order_date),
      s.session_start,
      HOUR
    ) AS hours_before_order

  FROM `customer360-mktg.customer360.fact_orders` o
  JOIN `customer360-mktg.customer360.crm_customer_sessions` s
    ON o.customer_id = s.customer_id
    AND DATE(s.session_start) <= o.order_date
    AND DATE(s.session_start) >= DATE_SUB(
      o.order_date, INTERVAL 30 DAY
    )
),

weighted AS (
  SELECT
    *,
    POW(2, -hours_before_order / 168.0) AS touch_weight
  FROM base
),

final_data AS (
  SELECT
    *,
    SUM(touch_weight) OVER (
      PARTITION BY order_id
    ) AS total_weight
  FROM weighted
),

comparison AS (

  SELECT
    'First Touch' AS attribution_model,
    source,
    campaign,
    order_id,
    order_amount AS attributed_revenue
  FROM final_data
  WHERE first_rank = 1

  UNION ALL

  SELECT
    'Last Touch',
    source,
    campaign,
    order_id,
    order_amount
  FROM final_data
  WHERE last_rank = 1

  UNION ALL

  SELECT
    'Linear',
    source,
    campaign,
    order_id,
    order_amount / touch_count
  FROM final_data

  UNION ALL

  SELECT
    'Time Decay',
    source,
    campaign,
    order_id,
    order_amount * SAFE_DIVIDE(
      touch_weight, total_weight
    )
  FROM final_data
)

SELECT
  attribution_model,
  source,
  campaign,
  COUNT(DISTINCT order_id) AS orders,
  ROUND(SUM(attributed_revenue), 2) AS attributed_revenue

FROM comparison
GROUP BY
  attribution_model,
  source,
  campaign
ORDER BY
  attribution_model,
  attributed_revenue DESC;

-- ==================== 14_Attribution_Revenue_Validation.sql ====================
WITH base AS (
  SELECT
    o.order_id,
    o.order_amount,
    s.session_start,
    ROW_NUMBER() OVER (
      PARTITION BY o.order_id
      ORDER BY s.session_start
    ) AS first_rank,
    ROW_NUMBER() OVER (
      PARTITION BY o.order_id
      ORDER BY s.session_start DESC
    ) AS last_rank,
    COUNT(*) OVER (
      PARTITION BY o.order_id
    ) AS touch_count,
    POW(
      2,
      -TIMESTAMP_DIFF(
        TIMESTAMP(o.order_date),
        s.session_start,
        HOUR
      ) / 168.0
    ) AS touch_weight
  FROM `customer360-mktg.customer360.fact_orders` o
  JOIN `customer360-mktg.customer360.crm_customer_sessions` s
    ON o.customer_id = s.customer_id
    AND DATE(s.session_start) <= o.order_date
    AND DATE(s.session_start) >= DATE_SUB(
      o.order_date, INTERVAL 30 DAY
    )
),
allocated AS (
  SELECT
    *,
    SUM(touch_weight) OVER (
      PARTITION BY order_id
    ) AS total_weight
  FROM base
),
results AS (
  SELECT 'First Touch' AS model, order_amount AS revenue
  FROM allocated WHERE first_rank = 1

  UNION ALL

  SELECT 'Last Touch', order_amount
  FROM allocated WHERE last_rank = 1

  UNION ALL

  SELECT 'Linear', order_amount / touch_count
  FROM allocated

  UNION ALL

  SELECT 'Time Decay',
    order_amount * SAFE_DIVIDE(touch_weight, total_weight)
  FROM allocated
)
SELECT
  model,
  ROUND(SUM(revenue), 2) AS total_attributed_revenue
FROM results
GROUP BY model
ORDER BY model;

-- ==================== 15_Attribution_Revenue_Summary.sql ====================
SELECT
  attribution_model,
  SUM(orders) AS total_orders,
  ROUND(SUM(attributed_revenue), 2) AS total_attributed_revenue
FROM
  `customer360-mktg.customer360.attribution_model_results`
GROUP BY
  attribution_model
ORDER BY
  attribution_model;

-- ==================== 16_Attribution_Data_Quality_Check.sql ====================
SELECT
  COUNT(*) AS total_records,
  COUNT(DISTINCT attribution_model) AS total_models,
  COUNT(DISTINCT source) AS total_channels,
  SUM(attributed_revenue) AS total_attributed_revenue
FROM
  `customer360-mktg.customer360.attribution_model_results`;

-- ==================== 17_Attribution_Model_Consistency_Check (1).sql ====================
SELECT
  attribution_model,
  ROUND(SUM(attributed_revenue), 2) AS total_attributed_revenue,
  COUNT(*) AS total_records
FROM
  `customer360-mktg.customer360.attribution_model_results`
GROUP BY
  attribution_model
ORDER BY
  attribution_model;

-- ==================== 18_Attribution_Null_Value_Check.sql ====================
SELECT
  COUNT(*) AS total_records,
  COUNTIF(attribution_model IS NULL) AS missing_model,
  COUNTIF(source IS NULL) AS missing_source,
  COUNTIF(campaign IS NULL) AS missing_campaign,
  COUNTIF(attributed_revenue IS NULL) AS missing_revenue
FROM
  `customer360-mktg.customer360.attribution_model_results`;

-- ==================== 19_Attribution_Revenue_Validation.sql ====================
SELECT
  COUNT(*) AS total_records,
  COUNTIF(attributed_revenue < 0) AS negative_revenue_records,
  COUNTIF(attributed_revenue = 0) AS zero_revenue_records,
  MIN(attributed_revenue) AS minimum_revenue,
  MAX(attributed_revenue) AS maximum_revenue
FROM
  `customer360-mktg.customer360.attribution_model_results`;

-- ==================== 20_Attribution_Duplicate_Check.sql ====================
SELECT
  attribution_model,
  source,
  campaign,
  COUNT(*) AS duplicate_count
FROM
  `customer360-mktg.customer360.attribution_model_results`
GROUP BY
  attribution_model,
  source,
  campaign
HAVING
  COUNT(*) > 1;

-- ==================== 21_Attribution_Summary_View.sql ====================
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

-- ==================== 22_Attribution_View_Validation.sql ====================
SELECT
  COUNT(*) AS total_records,
  COUNT(DISTINCT attribution_model) AS total_models,
  COUNT(DISTINCT source) AS total_channels,
  SUM(credited_orders) AS total_credited_orders,
  ROUND(SUM(attributed_revenue), 2) AS total_attributed_revenue
FROM
  `customer360-mktg.customer360.vw_attribution_summary`;

-- ==================== 23_BigQuery_Dataset_Inventory.sql ====================
SELECT
  table_name,
  table_type
FROM
  `customer360-mktg.customer360.INFORMATION_SCHEMA.TABLES`
ORDER BY
  table_name;

-- ==================== 24_Customer_Master_Validation.sql ====================
SELECT
  COUNT(*) AS total_customers,
  COUNT(DISTINCT customer_id) AS unique_customers,
  COUNTIF(email IS NULL) AS missing_emails
FROM
  `customer360-mktg.customer360.crm_customers_import`;

-- ==================== 25_Customer_Signup_Channel_Validation.sql ====================
SELECT
  COUNT(*) AS total_customers,
  COUNTIF(signup_date IS NULL) AS missing_signup_dates,
  COUNTIF(acquisition_channel IS NULL) AS missing_channels,
  COUNT(DISTINCT acquisition_channel) AS unique_channels,
  MIN(signup_date) AS first_signup_date,
  MAX(signup_date) AS last_signup_date
FROM
  `customer360-mktg.customer360.crm_customers_import`;

-- ==================== 26_Order_Customer_Revenue_Validation.sql ====================
SELECT
  COUNT(*) AS total_orders,
  COUNT(DISTINCT order_id) AS unique_orders,
  COUNT(DISTINCT customer_id) AS unique_customers,
  COUNTIF(customer_id IS NULL) AS missing_customer_ids,
  COUNTIF(order_amount IS NULL) AS missing_order_amounts,
  SUM(order_amount) AS total_revenue
FROM
  `customer360-mktg.customer360.crm_orders`;

-- ==================== 27_Order_Customer_Relationship_Check.sql ====================
SELECT
  COUNT(*) AS total_orders,
  COUNTIF(c.customer_id IS NOT NULL) AS matched_orders,
  COUNTIF(c.customer_id IS NULL) AS unmatched_orders
FROM
  `customer360-mktg.customer360.crm_orders` o
LEFT JOIN
  `customer360-mktg.customer360.crm_customers_import` c
ON
  o.customer_id = c.customer_id;

-- ==================== 28_Order_Date_Status_Validation.sql ====================
SELECT
  COUNT(*) AS total_orders,
  COUNTIF(order_date IS NULL) AS missing_order_dates,
  COUNTIF(order_status IS NULL) AS missing_order_status,
  COUNT(DISTINCT order_status) AS unique_order_statuses,
  MIN(order_date) AS first_order_date,
  MAX(order_date) AS last_order_date
FROM
  `customer360-mktg.customer360.crm_orders`;

-- ==================== 29_Order_Status_Distribution.sql ====================
SELECT
  order_status,
  COUNT(*) AS total_orders,
  SUM(order_amount) AS total_revenue
FROM
  `customer360-mktg.customer360.crm_orders`
GROUP BY
  order_status
ORDER BY
  total_orders DESC;

-- ==================== 30_Order_Revenue_By_Month.sql ====================
SELECT
  FORMAT_DATE('%Y-%m', order_date) AS order_month,
  COUNT(DISTINCT order_id) AS total_orders,
  COUNT(DISTINCT customer_id) AS unique_customers,
  SUM(order_amount) AS monthly_revenue,
  AVG(order_amount) AS average_order_value
FROM
  `customer360-mktg.customer360.crm_orders`
GROUP BY
  order_month
ORDER BY
  order_month;

-- ==================== 31_Product_Master_Validation.sql ====================
SELECT
  COUNT(*) AS total_products,
  COUNT(DISTINCT product_id) AS unique_products,
  COUNT(DISTINCT category) AS unique_categories,
  MIN(unit_price) AS minimum_price,
  MAX(unit_price) AS maximum_price
FROM
  `customer360-mktg.customer360.crm_products`;

-- ==================== 32_Order_Items_Data_Generation.sql ====================
CREATE OR REPLACE TABLE
`customer360-mktg.customer360.crm_order_items` AS

WITH numbered_orders AS (
  SELECT
    order_id,
    ROW_NUMBER() OVER (ORDER BY order_id) AS rn
  FROM
    `customer360-mktg.customer360.crm_orders`
)

SELECT
  CONCAT('ITEM_', o.order_id) AS order_item_id,
  o.order_id,
  p.product_id,
  CAST(1 + MOD(o.rn - 1, 3) AS INT64) AS quantity,
  p.unit_price,
  CAST(0 AS NUMERIC) AS discount
FROM numbered_orders o
JOIN
  `customer360-mktg.customer360.crm_products` p
ON
  p.product_id = CONCAT(
    'PRD',
    FORMAT('%03d', MOD(o.rn - 1, 10) + 1)
  );

-- ==================== 33_Order_Items_Validation.sql ====================
SELECT
  COUNT(*) AS total_order_items,
  COUNT(DISTINCT order_item_id) AS unique_items,
  COUNT(DISTINCT order_id) AS unique_orders,
  COUNT(DISTINCT product_id) AS unique_products,
  SUM(quantity) AS total_quantity
FROM
  `customer360-mktg.customer360.crm_order_items`;

-- ==================== 34_Product_Order_Item_Relationship_Check.sql ====================
SELECT
  COUNT(*) AS total_order_items,
  COUNTIF(p.product_id IS NOT NULL) AS matched_products,
  COUNTIF(p.product_id IS NULL) AS unmatched_products
FROM
  `customer360-mktg.customer360.crm_order_items` oi
LEFT JOIN
  `customer360-mktg.customer360.crm_products` p
ON
  oi.product_id = p.product_id;

-- ==================== 35_Marketing_Spend_Validation.sql ====================
SELECT
  COUNT(*) AS total_records,
  COUNT(DISTINCT spend_id) AS unique_spend_ids,
  COUNT(DISTINCT campaign_name) AS unique_campaigns,
  COUNT(DISTINCT channel) AS unique_channels,
  SUM(spend_amount) AS total_marketing_spend,
  SUM(impressions) AS total_impressions,
  SUM(clicks) AS total_clicks,
  SUM(conversions) AS total_conversions
FROM
  `customer360-mktg.customer360.crm_marketing_spend`;

-- ==================== 36_Marketing_Channel_Performance.sql ====================
SELECT
  channel,
  SUM(spend_amount) AS total_spend,
  SUM(impressions) AS impressions,
  SUM(clicks) AS clicks,
  SUM(conversions) AS conversions,

  ROUND(
    SAFE_DIVIDE(SUM(clicks) * 100, SUM(impressions)), 2
  ) AS ctr_percent,

  ROUND(
    SAFE_DIVIDE(SUM(conversions) * 100, SUM(clicks)), 2
  ) AS conversion_rate_percent,

  ROUND(
    SAFE_DIVIDE(SUM(spend_amount), SUM(clicks)), 2
  ) AS cpc,

  ROUND(
    SAFE_DIVIDE(SUM(spend_amount), SUM(conversions)), 2
  ) AS cost_per_conversion

FROM
  `customer360-mktg.customer360.crm_marketing_spend`

GROUP BY
  channel

ORDER BY
  total_spend DESC;

-- ==================== 37_Campaign_Performance_Analysis.sql ====================
SELECT
  c.campaign_id,
  c.campaign_name,
  c.channel,
  c.campaign_budget,
  COALESCE(SUM(m.spend_amount), 0) AS actual_spend,
  COALESCE(SUM(m.impressions), 0) AS impressions,
  COALESCE(SUM(m.clicks), 0) AS clicks,
  COALESCE(SUM(m.conversions), 0) AS conversions,

  ROUND(
    SAFE_DIVIDE(SUM(m.clicks) * 100, SUM(m.impressions)), 2
  ) AS ctr_percent,

  ROUND(
    SAFE_DIVIDE(SUM(m.spend_amount) * 100, c.campaign_budget), 2
  ) AS budget_utilization_percent

FROM
  `customer360-mktg.customer360.crm_campaigns` c

LEFT JOIN
  `customer360-mktg.customer360.crm_marketing_spend` m
ON
  c.campaign_name = m.campaign_name

GROUP BY
  c.campaign_id,
  c.campaign_name,
  c.channel,
  c.campaign_budget

ORDER BY
  actual_spend DESC;

-- ==================== 38_Campaign_Conversion_Efficiency.sql ====================
SELECT
  campaign_name,
  channel,
  SUM(spend_amount) AS total_spend,
  SUM(clicks) AS total_clicks,
  SUM(conversions) AS total_conversions,

  ROUND(
    SAFE_DIVIDE(SUM(conversions) * 100, SUM(clicks)), 2
  ) AS conversion_rate_percent,

  ROUND(
    SAFE_DIVIDE(SUM(spend_amount), SUM(conversions)), 2
  ) AS cost_per_conversion

FROM
  `customer360-mktg.customer360.crm_marketing_spend`

GROUP BY
  campaign_name,
  channel

ORDER BY
  cost_per_conversion ASC;

-- ==================== 39_Marketing_Channel_ROAS.sql ====================
WITH marketing_spend AS (
  SELECT
    channel,
    SUM(spend_amount) AS total_spend
  FROM
    `customer360-mktg.customer360.crm_marketing_spend`
  GROUP BY channel
),

attributed_revenue AS (
  SELECT
    source AS channel,
    SUM(attributed_revenue) AS total_revenue
  FROM
    `customer360-mktg.customer360.attribution_model_results`
  WHERE
    attribution_model = 'Last Touch'
  GROUP BY source
)

SELECT
  s.channel,
  s.total_spend,
  COALESCE(r.total_revenue, 0) AS attributed_revenue,
  ROUND(
    SAFE_DIVIDE(r.total_revenue, s.total_spend), 2
  ) AS roas
FROM marketing_spend s
LEFT JOIN attributed_revenue r
  ON s.channel = r.channel
ORDER BY roas DESC;

-- ==================== 40_Marketing_Channel_ROI.sql ====================
WITH marketing_spend AS (
  SELECT
    channel,
    SUM(spend_amount) AS total_spend
  FROM
    `customer360-mktg.customer360.crm_marketing_spend`
  GROUP BY channel
),

attributed_revenue AS (
  SELECT
    source AS channel,
    SUM(attributed_revenue) AS total_revenue
  FROM
    `customer360-mktg.customer360.attribution_model_results`
  WHERE
    attribution_model = 'Last Touch'
  GROUP BY source
)

SELECT
  s.channel,
  s.total_spend,
  COALESCE(r.total_revenue, 0) AS attributed_revenue,

  ROUND(
    SAFE_DIVIDE(
      COALESCE(r.total_revenue, 0) - s.total_spend,
      s.total_spend
    ) * 100, 2
  ) AS roi_percent

FROM marketing_spend s
LEFT JOIN attributed_revenue r
  ON s.channel = r.channel
ORDER BY roi_percent DESC;

-- ==================== 41_Customer_360_Master_View.sql ====================
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

-- ==================== 42_Customer_360_Validation.sql ====================
SELECT
  COUNT(*) AS total_customers,
  COUNT(DISTINCT customer_id) AS unique_customers,
  SUM(total_orders) AS total_orders,
  SUM(total_revenue) AS total_revenue,
  ROUND(AVG(total_revenue), 2) AS avg_customer_revenue
FROM
  `customer360-mktg.customer360.vw_customer_360`;

-- ==================== 43_RFM_Customer_Segmentation.sql ====================
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

-- ==================== 44_RFM_Segment_Validation.sql ====================
SELECT
  customer_segment,
  COUNT(*) AS total_customers,
  ROUND(AVG(recency), 0) AS avg_recency_days,
  ROUND(AVG(frequency), 2) AS avg_orders,
  ROUND(AVG(monetary), 2) AS avg_customer_spend
FROM
  `customer360-mktg.customer360.vw_customer_rfm`
GROUP BY
  customer_segment
ORDER BY
  total_customers DESC;

-- ==================== 45_Customer_Lifetime_Value_Analysis.sql ====================
CREATE OR REPLACE VIEW
`customer360-mktg.customer360.vw_customer_clv` AS

SELECT
  customer_id,
  COUNT(DISTINCT order_id) AS total_orders,
  SUM(order_amount) AS lifetime_revenue,

  ROUND(
    AVG(order_amount), 2
  ) AS average_order_value,

  MIN(order_date) AS first_order_date,
  MAX(order_date) AS last_order_date,

  DATE_DIFF(
    MAX(order_date),
    MIN(order_date),
    DAY
  ) AS customer_lifespan_days,

  CASE
    WHEN SUM(order_amount) >= 60000 THEN 'High Value'
    WHEN SUM(order_amount) >= 35000 THEN 'Medium Value'
    ELSE 'Low Value'
  END AS clv_segment

FROM
  `customer360-mktg.customer360.crm_orders`

GROUP BY
  customer_id;

-- ==================== 46_CLV_Segment_Validation.sql ====================
SELECT
  clv_segment,
  COUNT(*) AS total_customers,
  ROUND(SUM(lifetime_revenue), 2) AS total_revenue,
  ROUND(AVG(lifetime_revenue), 2) AS avg_lifetime_value,
  ROUND(AVG(average_order_value), 2) AS avg_order_value
FROM
  `customer360-mktg.customer360.vw_customer_clv`
GROUP BY
  clv_segment
ORDER BY
  avg_lifetime_value DESC;

-- ==================== 47_Customer_Cohort_Analysis.sql ====================
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

-- ==================== 48_Repeat_Customer_Analysis.sql ====================
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

-- ==================== 49_Customer_Purchase_Frequency.sql ====================
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

-- ==================== 50_Customer_Acquisition_Channel_Analysis.sql ====================
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

-- ==================== 51_BigQuery_Table_View_Inventory.sql ====================
SELECT
  table_name,
  table_type,
  creation_time
FROM
  `customer360-mktg.customer360.INFORMATION_SCHEMA.TABLES`
ORDER BY
  table_type,
  table_name;

-- ==================== 52_Core_Table_Record_Count_Validation.sql ====================
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

-- ==================== 53_Attribution_Schema_Check.sql ====================
SELECT
  table_name,
  column_name,
  data_type
FROM
  `customer360-mktg.customer360.INFORMATION_SCHEMA.COLUMNS`
WHERE
  table_name IN (
    'crm_attribution',
    'attribution_model_results'
  )
ORDER BY
  table_name,
  ordinal_position;

-- ==================== 54_Attribution_Results_Preview.sql ====================
SELECT *
FROM
  `customer360-mktg.customer360.attribution_model_results`
LIMIT 10;

-- ==================== 55_Attribution_Model_Performance.sql ====================
SELECT
  attribution_model,
  COUNT(*) AS total_records,
  SUM(orders) AS total_credited_orders,
  ROUND(SUM(attributed_revenue), 2) AS total_attributed_revenue,
  ROUND(AVG(attributed_revenue), 2) AS avg_attributed_revenue
FROM
  `customer360-mktg.customer360.attribution_model_results`
GROUP BY
  attribution_model
ORDER BY
  total_attributed_revenue DESC;

-- ==================== 56_Attribution_Revenue_Reconciliation.sql ====================
WITH actual_revenue AS (
  SELECT
    SUM(order_amount) AS total_order_revenue
  FROM `customer360-mktg.customer360.crm_orders`
),

attribution_revenue AS (
  SELECT
    attribution_model,
    SUM(attributed_revenue) AS total_attributed_revenue
  FROM `customer360-mktg.customer360.attribution_model_results`
  GROUP BY attribution_model
)

SELECT
  a.attribution_model,
  r.total_order_revenue,
  a.total_attributed_revenue,

  ROUND(
    SAFE_DIVIDE(
      a.total_attributed_revenue,
      r.total_order_revenue
    ) * 100, 2
  ) AS attribution_coverage_percent,

  ROUND(
    r.total_order_revenue - a.total_attributed_revenue, 2
  ) AS revenue_difference

FROM attribution_revenue a
CROSS JOIN actual_revenue r
ORDER BY a.attribution_model;

-- ==================== 57_Attribution_Source_Schema_Check.sql ====================
SELECT
  table_name,
  column_name,
  data_type
FROM `customer360-mktg.customer360.INFORMATION_SCHEMA.COLUMNS`
WHERE table_name IN (
  'crm_customer_sessions',
  'crm_orders',
  'session_campaign_mapping',
  'crm_campaigns',
  'crm_attribution'
)
ORDER BY table_name, ordinal_position;

-- ==================== 58_Attribution_Source_Details.sql ====================
SELECT
  table_name,
  column_name,
  data_type
FROM `customer360-mktg.customer360.INFORMATION_SCHEMA.COLUMNS`
WHERE table_name IN (
  'crm_customer_sessions',
  'crm_orders',
  'session_campaign_mapping',
  'crm_campaigns'
)
ORDER BY
  table_name,
  ordinal_position;

-- ==================== 59_CRM_Orders_Column_Verification.sql ====================
SELECT
  column_name,
  data_type
FROM `customer360-mktg.customer360.INFORMATION_SCHEMA.COLUMNS`
WHERE table_name = 'crm_orders'
ORDER BY ordinal_position;

-- ==================== 60_Attribution_Order_Session_Preview.sql ====================
SELECT
  o.order_id,
  o.customer_id,
  o.order_date,
  o.order_amount,
  s.session_id,
  s.session_start,
  m.source,
  m.medium,
  m.campaign_id
FROM `customer360-mktg.customer360.crm_orders` AS o
INNER JOIN `customer360-mktg.customer360.crm_customer_sessions` AS s
  ON o.customer_id = s.customer_id
  AND DATE(s.session_start) <= o.order_date
  AND DATE(s.session_start) >= DATE_SUB(o.order_date, INTERVAL 30 DAY)
LEFT JOIN `customer360-mktg.customer360.session_campaign_mapping` AS m
  ON s.session_id = m.session_id
ORDER BY
  o.order_date,
  o.order_id,
  s.session_start;

-- ==================== 61_Build_Detailed_Attribution_Records.sql ====================
CREATE OR REPLACE TABLE
`customer360-mktg.customer360.crm_attribution` AS

WITH matched_sessions AS (
  SELECT
    o.order_id,
    o.customer_id,
    o.order_date,
    o.order_amount,
    s.session_id,
    s.session_start,
    m.source AS channel,
    m.campaign_id,
    ROW_NUMBER() OVER (
      PARTITION BY o.order_id
      ORDER BY s.session_start ASC
    ) AS first_rank,
    ROW_NUMBER() OVER (
      PARTITION BY o.order_id
      ORDER BY s.session_start DESC
    ) AS last_rank,
    COUNT(*) OVER (
      PARTITION BY o.order_id
    ) AS touchpoint_count,
    POW(
      2,
      -TIMESTAMP_DIFF(
        TIMESTAMP(o.order_date),
        s.session_start,
        HOUR
      ) / 168.0
    ) AS decay_weight
  FROM `customer360-mktg.customer360.crm_orders` o
  JOIN `customer360-mktg.customer360.crm_customer_sessions` s
    ON o.customer_id = s.customer_id
    AND DATE(s.session_start) <= o.order_date
    AND DATE(s.session_start) >= DATE_SUB(
      o.order_date, INTERVAL 30 DAY
    )
  LEFT JOIN `customer360-mktg.customer360.session_campaign_mapping` m
    ON s.session_id = m.session_id
),

attribution_rows AS (
  SELECT
    order_id,
    customer_id,
    session_id,
    campaign_id,
    channel,
    'First Touch' AS attribution_model,
    DATE(session_start) AS attribution_date,
    order_amount AS attributed_revenue
  FROM matched_sessions
  WHERE first_rank = 1

  UNION ALL

  SELECT
    order_id,
    customer_id,
    session_id,
    campaign_id,
    channel,
    'Last Touch',
    DATE(session_start),
    order_amount
  FROM matched_sessions
  WHERE last_rank = 1

  UNION ALL

  SELECT
    order_id,
    customer_id,
    session_id,
    campaign_id,
    channel,
    'Linear',
    DATE(session_start),
    SAFE_DIVIDE(order_amount, touchpoint_count)
  FROM matched_sessions

  UNION ALL

  SELECT
    order_id,
    customer_id,
    session_id,
    campaign_id,
    channel,
    'Time Decay',
    DATE(session_start),
    SAFE_DIVIDE(
      order_amount * decay_weight,
      SUM(decay_weight) OVER (PARTITION BY order_id)
    )
  FROM matched_sessions
)

SELECT
  CONCAT(
    order_id, '_', session_id, '_', REPLACE(attribution_model, ' ', '_')
  ) AS attribution_id,
  customer_id,
  order_id,
  campaign_id,
  channel,
  attribution_model,
  attribution_date,
  CAST(attributed_revenue AS NUMERIC) AS attributed_revenue
FROM attribution_rows;

-- ==================== 62_Attribution_Records_Validation.sql ====================
SELECT
  attribution_model,
  COUNT(*) AS attribution_records,
  COUNT(DISTINCT order_id) AS unique_orders,
  COUNT(DISTINCT customer_id) AS unique_customers,
  COUNT(DISTINCT campaign_id) AS unique_campaigns,
  ROUND(SUM(attributed_revenue), 2) AS total_attributed_revenue
FROM `customer360-mktg.customer360.crm_attribution`
GROUP BY attribution_model
ORDER BY attribution_model;

-- ==================== 63_Attribution_Data_Quality_Check.sql ====================
SELECT
  COUNT(*) AS total_records,
  COUNTIF(attribution_id IS NULL) AS missing_attribution_id,
  COUNTIF(customer_id IS NULL) AS missing_customer_id,
  COUNTIF(order_id IS NULL) AS missing_order_id,
  COUNTIF(channel IS NULL) AS missing_channel,
  COUNTIF(attribution_model IS NULL) AS missing_model,
  COUNTIF(attributed_revenue IS NULL) AS missing_revenue,
  COUNT(DISTINCT attribution_id) AS unique_attribution_ids
FROM `customer360-mktg.customer360.crm_attribution`;

-- ==================== 64_Final_Attribution_Revenue_Validation.sql ====================
SELECT
  attribution_model,
  ROUND(SUM(attributed_revenue), 2) AS attributed_revenue,
  COUNT(DISTINCT order_id) AS unique_orders,
  COUNT(*) AS attribution_records
FROM `customer360-mktg.customer360.crm_attribution`
GROUP BY attribution_model
ORDER BY attribution_model;

-- ==================== 65_Final_Database_Inventory_Audit.sql ====================
SELECT
  table_name,
  table_type,
  creation_time
FROM `customer360-mktg.customer360.INFORMATION_SCHEMA.TABLES`
ORDER BY table_type, table_name;

-- ==================== 66_Final_Table_View_Summary.sql ====================
SELECT
  table_type,
  COUNT(*) AS total_objects
FROM `customer360-mktg.customer360.INFORMATION_SCHEMA.TABLES`
GROUP BY table_type
ORDER BY table_type;

-- ==================== 67_Core_Table_Row_Count_Audit.sql ====================
SELECT 'crm_customers_import' AS table_name, COUNT(*) AS total_rows
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

ORDER BY table_name;

-- ==================== 68_Customer_Order_Referential_Integrity.sql ====================
SELECT
  'Orders with missing customers' AS validation_check,
  COUNT(*) AS failed_records
FROM `customer360-mktg.customer360.crm_orders` o
LEFT JOIN `customer360-mktg.customer360.crm_customers_import` c
  ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL

UNION ALL

SELECT
  'Order items with missing orders',
  COUNT(*)
FROM `customer360-mktg.customer360.crm_order_items` i
LEFT JOIN `customer360-mktg.customer360.crm_orders` o
  ON i.order_id = o.order_id
WHERE o.order_id IS NULL

UNION ALL

SELECT
  'Order items with missing products',
  COUNT(*)
FROM `customer360-mktg.customer360.crm_order_items` i
LEFT JOIN `customer360-mktg.customer360.crm_products` p
  ON i.product_id = p.product_id
WHERE p.product_id IS NULL;

-- ==================== 69_Customer_360_Final_Validation.sql ====================
SELECT
  COUNT(*) AS total_customers,
  COUNT(DISTINCT customer_id) AS unique_customers,
  SUM(total_orders) AS total_orders,
  ROUND(SUM(total_revenue), 2) AS total_revenue,
  ROUND(AVG(total_revenue), 2) AS average_customer_revenue
FROM `customer360-mktg.customer360.vw_customer_360`;

-- ==================== 70_RFM_Final_Validation.sql ====================
SELECT
  COUNT(*) AS total_customers,
  COUNT(DISTINCT customer_id) AS unique_customers,
  COUNTIF(customer_segment IS NULL) AS missing_segments
FROM `customer360-mktg.customer360.vw_customer_rfm`;

-- ==================== 71_CLV_Final_Validation.sql ====================
SELECT
  COUNT(*) AS total_customers,
  COUNT(DISTINCT customer_id) AS unique_customers,
  COUNTIF(clv_segment IS NULL) AS missing_clv_segments,
  ROUND(SUM(lifetime_revenue), 2) AS total_lifetime_revenue
FROM `customer360-mktg.customer360.vw_customer_clv`;

-- ==================== 72_Marketing_Spend_Final_Validation.sql ====================
SELECT
  COUNT(*) AS total_records,
  COUNT(DISTINCT spend_id) AS unique_spend_ids,
  COUNTIF(spend_amount IS NULL) AS missing_spend,
  ROUND(SUM(spend_amount), 2) AS total_marketing_spend,
  SUM(impressions) AS total_impressions,
  SUM(clicks) AS total_clicks,
  SUM(conversions) AS total_conversions
FROM `customer360-mktg.customer360.crm_marketing_spend`;

-- ==================== 73_Campaign_Final_Validation.sql ====================
SELECT
  COUNT(*) AS total_campaigns,
  COUNT(DISTINCT campaign_id) AS unique_campaigns,
  COUNTIF(campaign_name IS NULL) AS missing_campaign_names,
  COUNTIF(channel IS NULL) AS missing_channels,
  COUNTIF(start_date IS NULL OR end_date IS NULL) AS missing_dates,
  COUNTIF(end_date < start_date) AS invalid_date_ranges
FROM `customer360-mktg.customer360.crm_campaigns`;

-- ==================== 74_Product_Final_Validation.sql ====================
SELECT
  column_name,
  data_type
FROM `customer360-mktg.customer360.INFORMATION_SCHEMA.COLUMNS`
WHERE table_name = 'crm_products'
ORDER BY ordinal_position;

-- ==================== 75_Web_Events_Final_Validation.sql ====================
SELECT
  COUNT(*) AS total_events,
  COUNT(DISTINCT event_id) AS unique_event_ids,
  COUNTIF(customer_id IS NULL) AS missing_customer_ids,
  COUNTIF(session_id IS NULL) AS missing_session_ids,
  COUNTIF(event_name IS NULL) AS missing_event_names,
  COUNT(DISTINCT event_name) AS unique_event_types
FROM `customer360-mktg.customer360.crm_web_events`;

-- ==================== 76_Final_Data_Quality_Audit.sql ====================
SELECT
  'Customers' AS data_area,
  COUNT(*) AS total_records,
  COUNTIF(customer_id IS NULL) AS missing_ids
FROM `customer360-mktg.customer360.crm_customers_import`

UNION ALL

SELECT
  'Orders',
  COUNT(*),
  COUNTIF(order_id IS NULL)
FROM `customer360-mktg.customer360.crm_orders`

UNION ALL

SELECT
  'Products',
  COUNT(*),
  COUNTIF(product_id IS NULL)
FROM `customer360-mktg.customer360.crm_products`

UNION ALL

SELECT
  'Marketing Spend',
  COUNT(*),
  COUNTIF(spend_id IS NULL)
FROM `customer360-mktg.customer360.crm_marketing_spend`

UNION ALL

SELECT
  'Attribution',
  COUNT(*),
  COUNTIF(attribution_id IS NULL)
FROM `customer360-mktg.customer360.crm_attribution`

UNION ALL

SELECT
  'Web Events',
  COUNT(*),
  COUNTIF(event_id IS NULL)
FROM `customer360-mktg.customer360.crm_web_events`

ORDER BY data_area;

-- ==================== 77_Final_Business_KPI_Validation.sql ====================
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
