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