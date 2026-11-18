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