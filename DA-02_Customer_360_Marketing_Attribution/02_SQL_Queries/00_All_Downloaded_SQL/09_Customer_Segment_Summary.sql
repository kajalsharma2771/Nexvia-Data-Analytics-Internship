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