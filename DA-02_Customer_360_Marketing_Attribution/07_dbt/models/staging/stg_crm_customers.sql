
{{ config(materialized='view') }}

SELECT
    customer_id,
    CONCAT(first_name, ' ', last_name) AS customer_name,
    email,
    country,
    acquisition_channel,
    signup_date
FROM `customer360-mktg.customer360.crm_customers_import`
