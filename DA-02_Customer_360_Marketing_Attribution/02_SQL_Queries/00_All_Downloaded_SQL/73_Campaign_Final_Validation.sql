SELECT
  COUNT(*) AS total_campaigns,
  COUNT(DISTINCT campaign_id) AS unique_campaigns,
  COUNTIF(campaign_name IS NULL) AS missing_campaign_names,
  COUNTIF(channel IS NULL) AS missing_channels,
  COUNTIF(start_date IS NULL OR end_date IS NULL) AS missing_dates,
  COUNTIF(end_date < start_date) AS invalid_date_ranges
FROM `customer360-mktg.customer360.crm_campaigns`;