# Data Dictionary – Customer 360 and Marketing Attribution Platform

## 1. Customer Data

`crm_customers_import`

| Column | Business Meaning |
| --- | --- |
| `customer_id` | Unique customer identifier |
| `email` | Customer email address |
| `first_name` | Customer first name |
| `last_name` | Customer last name |
| `signup_date` | Customer registration date |
| `acquisition_channel` | Channel through which customer was acquired |
| `country` | Customer country |

## 2. Transaction Data

`crm_orders`

| Column | Business Meaning |
| --- | --- |
| `order_id` | Unique order identifier |
| `customer_id` | Customer associated with the order |
| `order_date` | Date of purchase |
| `order_amount` | Total order revenue |
| `order_status` | Current order status |
| `payment_method` | Payment method used |

`crm_order_items`

Contains individual product records associated with customer orders.

**Key identifiers:**

- `order_id`
- `product_id`

`crm_products`

| Column | Business Meaning |
| --- | --- |
| `product_id` | Unique product identifier |
| `product_name` | Product name |
| `category` | Product category |
| `subcategory` | Product subcategory |
| `brand` | Product brand |
| `unit_cost` | Cost per product unit |
| `unit_price` | Selling price per product unit |

## 3. Marketing Data

`crm_campaigns`

| Column | Business Meaning |
| --- | --- |
| `campaign_id` | Unique campaign identifier |
| `campaign_name` | Marketing campaign name |
| `channel` | Marketing channel |
| `start_date` | Campaign start date |
| `end_date` | Campaign end date |

`crm_marketing_spend`

Stores campaign-level marketing expenditure and performance metrics.

| Field | Business Meaning |
| --- | --- |
| `spend_id` | Unique marketing spend record identifier |
| `spend_amount` | Marketing expenditure |
| `impressions` | Number of ad impressions |
| `clicks` | Number of ad clicks |
| `conversions` | Number of conversions |

## 4. Customer Engagement Data

`crm_customer_sessions`

| Column | Business Meaning |
| --- | --- |
| `session_id` | Unique session identifier |
| `customer_id` | Associated customer |
| `session_start` | Session start timestamp |
| `session_end` | Session end timestamp |
| `device_category` | Device used during the session |

`session_campaign_mapping`

Connects customer sessions with available marketing source and campaign information.

**Important fields:**

- `session_id`
- `customer_id`
- `session_start`
- `source`
- `medium`
- `campaign_id`

`crm_web_events`

Stores synthetic website interaction events.

| Field | Business Meaning |
| --- | --- |
| `event_id` | Unique event identifier |
| `customer_id` | Associated customer |
| `session_id` | Associated session |
| `event_name` | Type of website event |

## 5. Attribution Data

`crm_attribution`

Stores detailed attribution records.

| Column | Business Meaning |
| --- | --- |
| `attribution_id` | Unique attribution record identifier |
| `customer_id` | Associated customer |
| `order_id` | Associated order |
| `campaign_id` | Mapped campaign identifier; may be NULL |
| `channel` | Marketing source/channel |
| `attribution_model` | Attribution model applied |
| `attribution_date` | Date of the credited touchpoint |
| `attributed_revenue` | Revenue credited to the touchpoint |

`attribution_model_results`

Stores aggregated attribution performance by model, source and campaign.

| Field | Business Meaning |
| --- | --- |
| `attribution_model` | Attribution model used |
| `source` | Marketing source |
| `campaign` | Campaign name or identifier |
| `orders` | Number of attributed orders |
| `attributed_revenue` | Revenue credited under the attribution model |

## 6. Analytical Views

| View | Business Purpose |
| --- | --- |
| `vw_customer_360` | Unified customer profile and purchasing metrics |
| `vw_customer_rfm` | Recency, Frequency and Monetary segmentation |
| `vw_customer_clv` | Customer lifetime value analysis |
| `vw_attribution_summary` | Aggregated marketing attribution performance |

## 7. dbt Transformation Layer

The project uses dbt to organise and test SQL transformations in BigQuery.

| dbt Layer | Model Count | Purpose |
| --- | --- | --- |
| Staging | 4 | Prepare and standardise source data |
| Intermediate | 3 | Apply reusable business transformations |
| Mart | 1 | Provide an analytical model for reporting |
| **Total** | **8** | **Organised transformation models** |

**Latest recorded dbt build:** 52 PASS (8 models and 44 tests).

The staging, intermediate and mart models form the transformation layer between source tables and downstream analytics. Refer to the dbt project files for the exact model names, columns and tests.

## 8. Important Business Definitions

| Metric | Definition |
| --- | --- |
| Total Revenue | Sum of order amounts |
| Average Order Value (AOV) | Total revenue divided by total orders |
| ROAS | Attributed revenue divided by marketing spend |
| ROI | (Attributed revenue - marketing spend) divided by marketing spend × 100 |
| CTR | Clicks divided by impressions × 100 |
| Conversion Rate | Conversions divided by clicks × 100 |
| Customer Lifetime Value (CLV) | Customer-level lifetime revenue measure |
| Recency | Days since the customer's latest purchase |
| Frequency | Number of customer orders |
| Monetary | Customer purchase value |

## 9. Python Analysis Outputs

Python analysis is performed using the project notebook `Customer_360_Data_Analysis.ipynb`, using Pandas, NumPy, Matplotlib and Seaborn, with BigQuery data access.

| Output | Description |
| --- | --- |
| `customer_segment_revenue.png` | Revenue contribution by customer segment |
| `marketing_channel_roas.png` | Marketing channel ROAS visualisation |
| `customer360_business_insights.csv` | Exported business insights |

### Recorded RFM segment counts

| Customer Segment | Customers |
| --- | --- |
| Champions | 6 |
| At Risk | 8 |
| Regular | 4 |
| Loyal | 2 |
| **Total** | **20** |

These are the recorded analysis results; refresh the notebook outputs if the underlying data changes.

## 10. Power BI Measures and KPI Definitions

| KPI | Business Definition |
| --- | --- |
| Total Customers | Distinct count of customer IDs |
| Total Orders | Distinct count of order IDs |
| Total Revenue | Sum of order amounts |
| Average Order Value | Total Revenue / Total Orders |
| Total Marketing Spend | Sum of marketing spend |
| Total Impressions | Sum of advertising impressions |
| Total Clicks | Sum of advertising clicks |
| Total Conversions | Sum of marketing conversions |
| CTR | Clicks / Impressions × 100 |
| Conversion Rate | Conversions / Clicks × 100 |
| Cost per Conversion | Marketing Spend / Conversions |
| ROAS | Attributed Revenue / Marketing Spend |
| Customer Lifetime Value | Customer-level lifetime revenue |

## 11. Reporting Layer

Power BI contains four interactive report pages:

## 1. Executive Dashboard

## 2. Customer Analysis

## 3. Marketing Attribution

## 4. Campaign Performance

### Interactive features

- Date range slicer
- Acquisition channel slicer
- Synchronized filters across all four report pages
- Interactive KPI cards, charts and tables

## 12. Segment Event Collection and BigQuery Destination

Segment is configured as a website event collection source for the project.

| Component | Description / Status |
| --- | --- |
| Segment workspace | `Kajal-Sharma` |
| Segment source | `Customer 360 Website Demo` |
| Test application | Next.js website demo |
| Events tested | Track, Page and Identify |
| BigQuery destination | `Customer360_BigQuery_Destination` |
| Google Cloud project | `customer360-mktg` |
| Destination dataset/schema | `customer_360_website_demo` |
| BigQuery location | `asia-south1` |
| Warehouse delivery | Successfully synced and verified |

The Segment Debugger received 10 test events: 5 Track, 3 Page and 2 Identify. After the service-account credentials were updated, the Segment destination sync completed successfully. Segment's Overview reported **33 rows synced** (latest recorded successful sync: 17 November 2026, approximately 4:16 PM).

### 12.1 Verified BigQuery Destination Tables

| BigQuery table | Business meaning | Individually verified rows |
| --- | --- | ---: |
| `tracks` | Website Track events containing custom interaction/event data | 10 |
| `pages` | Page Viewed events and page context | 5 |
| `identifies` | Identify events used to associate traits with a user | 4 |
| `user_sign_up` | User Sign Up track event table | 4 |
| **Total individually verified** | | **23** |

The four table previews account for 23 individually verified rows. Segment's sync summary reported 33 rows overall; the remaining 10 rows were not individually itemized in the recorded BigQuery table previews. These figures are reported separately and should not be treated as a complete 33-row table-level reconciliation.

The earlier `bigquery.jobs.create` permission error occurred before the credential update and was resolved for the subsequent successful sync. Do not store service-account private keys or JSON credential contents in this documentation or source control.

## 13. Data Notes and Limitations

- CRM and marketing data are synthetic.
- GA4 public sample data is analysed separately.
- Direct CRM-to-GA4 identity resolution has not been implemented.
- Segment demo events are a separate collection stream and are not identity-linked to synthetic CRM customers.
- Segment reported 33 rows synced; 23 rows were individually verified across the four destination tables listed above. The remaining 10 reported rows were not individually itemized in the saved table previews.
- Some attribution records have NULL campaign IDs where no confirmed mapping exists.
- Attribution coverage is currently 12.51% of total CRM order revenue.
- Attribution results cover only matched orders and touchpoints.
- Attribution revenue should not be summed across all four attribution models because the same order revenue is represented in multiple models.
- ROAS and ROI are revenue-based measures and do not represent profit-based returns.
