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