# Customer 360 and Marketing Attribution Platform

## 1. Project Overview

The Customer 360 and Marketing Attribution Platform is an end-to-end data analytics and business intelligence project designed to bring together customer, sales, product, website engagement, and marketing data into an analytical environment.

The project uses Google BigQuery for cloud data storage, SQL and dbt for data transformation and testing, Python for exploratory and business analysis, and Power BI for interactive business intelligence dashboards. GA4 public sample data is analysed separately. Segment collects website demo events and successfully routes them to BigQuery.

The platform focuses on customer behaviour, customer lifetime value, marketing campaign effectiveness, and multi-touch marketing attribution.

## 2. Project Objectives

- Build a unified Customer 360 data view.
- Analyse customer purchasing behaviour.
- Perform RFM customer segmentation.
- Calculate Customer Lifetime Value (CLV).
- Analyse customer acquisition and retention.
- Evaluate marketing campaign performance.
- Implement multiple marketing attribution models.
- Calculate channel-wise ROAS and revenue-based ROI.
- Validate data quality and business KPIs.
- Collect website behavioural events using Segment.
- Develop interactive Power BI dashboards.

## 3. Technology Stack

| Technology | Purpose |
| --- | --- |
| Google BigQuery | Cloud data warehouse |
| --- | --- |
| SQL | Data querying, transformation and analysis |
| --- | --- |
| dbt | SQL model management, transformation, testing and documentation |
| --- | --- |
| Python | Exploratory data analysis, customer analytics and visualizations |
| --- | --- |
| Pandas and NumPy | Data manipulation and numerical analysis |
| --- | --- |
| Matplotlib and Seaborn | Data visualization |
| --- | --- |
| GA4 Public Dataset | Separate website engagement analysis |
| --- | --- |
| Segment | Website event collection and routing to BigQuery |
| --- | --- |
| Google Cloud | Cloud project and service account environment |
| --- | --- |
| Power BI | Data modelling and interactive dashboards |
| --- | --- |
| DAX | Business measures and KPI calculations |

## 4. Data Sources

- GA4 public sample ecommerce dataset.
- Synthetic CRM customer data.
- Synthetic order and product data.
- Synthetic marketing campaign and spend data.
- Synthetic customer session and web event data.
- Segment JavaScript demo events (Identify, Page and Track events).

Data note: CRM, orders, sessions, marketing, and web event records are synthetic project data. GA4 public sample data is analysed separately. Direct identity-level integration between GA4 users and CRM customers has not been established. Segment demo events are a separate event collection stream and should not be described as identity-linked to the synthetic CRM records unless that linkage is implemented and validated.

## 5. BigQuery Environment

- Google Cloud Project: `customer360-mktg`
- Main dataset: `customer360`
- Dataset region: `asia-south1`
- Environment: BigQuery Sandbox

The CRM dataset contains the following recorded data volumes:

| Data entity | Records |
| --- | --- |
| Customers | 20 |
| --- | --- |
| Orders | 40 |
| --- | --- |
| Order items | 40 |
| --- | --- |
| Products | 10 |
| --- | --- |
| Marketing spend | 10 |
| --- | --- |
| Campaigns | 10 |
| --- | --- |
| Web events | 200 |
| --- | --- |
| Customer sessions | 40 |

## 6. SQL and Data Engineering

- 77 SQL queries saved and backed up.
- Customer and order relationship validation.
- Order item and product relationship validation.
- Missing value and duplicate ID checks.
- Campaign date validation.
- Customer 360, CLV and RFM analysis.
- Revenue and marketing performance analysis.
- Attribution revenue reconciliation.
- Business KPI validation.

Consolidated SQL backup: `ALL_SQL_QUERIES.sql`.

## 7. dbt Transformation

The dbt project organizes SQL transformations into modular layers:

- 4 staging models.
- 3 intermediate models.
- 1 mart model.
- 8 models in total.

The latest recorded dbt build completed with **52 PASS** (8 models and 44 tests). dbt documentation and model lineage were reviewed.

## 8. Python Data Analysis

Python analysis was performed in the notebook `Customer_360_Data_Analysis.ipynb`.

Libraries and tools used include:

- Pandas
- NumPy
- Matplotlib
- Seaborn
- BigQuery client

Analysis covered customer, revenue, RFM, marketing spend, campaign and attribution data.

Recorded analysis outputs:

- `customer_segment_revenue.png`
- `marketing_channel_roas.png`
- `customer360_business_insights.csv`

8.1 Customer Segment Results

| Segment | Customers | Revenue | Revenue share |
| --- | --- | --- | --- |
| Champions | 6 | ₹368,366 | 40.57% |
| --- | --- | --- | --- |
| At Risk | 8 | ₹283,883 | 31.26% |
| --- | --- | --- | --- |
| Regular | 4 | ₹183,251 | 20.18% |
| --- | --- | --- | --- |
| Loyal | 2 | ₹72,500 | 7.98% |
| --- | --- | --- | --- |
| **Total** | **20** | **₹908,000** | **100%** |

Percentages may differ slightly from 100% due to rounding.

## 9. Key Business Analytics

- Customer 360 analysis
- Customer acquisition analysis
- RFM segmentation
- Customer Lifetime Value (CLV)
- Cohort analysis
- Repeat purchase analysis
- Monthly revenue analysis
- Marketing channel performance
- Campaign conversion efficiency
- Return on Ad Spend (ROAS)
- Revenue-based ROI
- First-Touch Attribution
- Last-Touch Attribution
- Linear Attribution
- Time-Decay Attribution

## 10. Attribution Analysis

Four attribution models were implemented:

## 1. First Touch
## 2. Last Touch
## 3. Linear
## 4. Time Decay

The attribution dataset contains 24 detailed records across four models and four matched orders.

- Total matched revenue: ₹113,580
- Total CRM order revenue: ₹908,000
- Attribution coverage: 12.51%

The remaining revenue is not covered by the current matched attribution data. Attribution coverage is therefore incomplete and should be considered when interpreting marketing performance.

Recorded channel matched-attribution ROAS:

| Channel | ROAS |
| --- | --- |
| Referral | 10.55x |
| --- | --- |
| Email | 1.42x |
| --- | --- |
| Paid Search | 1.00x |
| --- | --- |
| Social Media | 0.48x |

ROAS and revenue-based ROI use attributed revenue and marketing spend. Revenue-based ROI is not profit-based ROI.

## 11. GA4 Analysis

GA4 public sample ecommerce data was queried and analysed separately.

Recorded GA4 sample metrics:

| Metric | Value |
| --- | --- |
| GA4 Unique Users | 20,078 |
| --- | --- |
| GA4 Sessions | 25,141 |
| --- | --- |
| GA4 Purchase Events | 273 |

These metrics belong to the public GA4 sample dataset and are not directly combined with synthetic CRM customer identities.

## 12. Segment Website Event Collection and BigQuery Destination

Segment was added to the project to demonstrate website event collection and delivery to a cloud warehouse.

- Segment workspace: `Kajal-Sharma`
- JavaScript source: `Customer 360 Website Demo`
- BigQuery destination: `Customer360_BigQuery_Destination`
- Google Cloud project: `customer360-mktg`
- BigQuery location: `asia-south1`
- Destination schema shown in Segment: `customer_360_website_demo`

The website demo successfully generated test events. Segment Debugger previously showed 10 received events: 5 Track, 3 Page and 2 Identify.

A BigQuery service account was configured with BigQuery Data Editor and BigQuery Job User roles. New service-account JSON credentials were subsequently updated in the Segment credential configuration.

12.1 Segment Integration Status

**Status: Successfully synced and verified in BigQuery.**

After the service-account credentials were updated, the Segment destination sync completed successfully. Segment's Overview reported **33 rows synced** (latest recorded successful sync: 17 November 2026, approximately 4:16 PM).

The following destination tables were individually opened and their rows verified in BigQuery:

| BigQuery table | Verified rows |
| --- | ---: |
| `tracks` | 10 |
| `pages` | 5 |
| `identifies` | 4 |
| `user_sign_up` | 4 |
| **Total individually verified** | **23** |

The four table previews account for 23 individually verified rows. Segment's sync summary reported 33 rows overall; the remaining 10 rows were not individually itemized in the recorded table previews. These figures are therefore reported separately rather than treating all 33 rows as independently reconciled.

The earlier `bigquery.jobs.create` permission error occurred before the credential update and was resolved for the subsequent successful sync.

Do not include service-account private keys, JSON credentials or other secrets in this repository or project documentation.

## 13. Key Project Metrics

| Metric | Value |
| --- | --- |
| CRM Customers | 20 |
| --- | --- |
| CRM Orders | 40 |
| --- | --- |
| Total CRM Revenue | ₹908,000 |
| --- | --- |
| Products | 10 |
| --- | --- |
| Marketing Campaigns | 10 |
| --- | --- |
| Marketing Channels | 6 |
| --- | --- |
| Marketing Spend | ₹115,000 |
| --- | --- |
| Impressions | 545,000 |
| --- | --- |
| Clicks | 31,600 |
| --- | --- |
| Conversions | 1,380 |
| --- | --- |
| CRM Web Events | 200 |
| --- | --- |
| Attribution Records | 24 |
| --- | --- |
| Matched Attributed Revenue | ₹113,580 |
| --- | --- |
| Attribution Coverage | 12.51% |

## 14. Data Quality and Validation

The project includes:

- Customer and order relationship validation.
- Order item and product relationship validation.
- Missing value checks.
- Duplicate ID checks.
- Campaign date validation.
- Customer 360 validation.
- RFM and CLV validation.
- Attribution revenue reconciliation.
- Final business KPI validation.
- dbt model tests (latest recorded build: 44 tests passed, alongside 8 models).

## 15. Power BI Dashboard Development

Power BI was used to develop an interactive business intelligence report with four dashboard pages.

15.1 Executive Dashboard

- Total Revenue
- Total Orders
- Total Customers
- Average Order Value
- Monthly Revenue Trend
- Monthly Revenue by Month

15.2 Customer Analysis

- Customer Segmentation (RFM)
- High Value Customers
- Average Customer Lifetime Value
- Customer-level performance table
- Customer Lifetime Value by Segment

15.3 Marketing Attribution

- Attribution Model Comparison
- Marketing Spend by Channel
- Last Touch Attributed Revenue
- Return on Ad Spend (ROAS) by Channel
- Last Touch Attributed Revenue by Campaign

15.4 Campaign Performance

- Marketing Spend by Campaign
- Conversions by Campaign
- Total Impressions
- Total Clicks
- Total Conversions
- Click-Through Rate (CTR)
- Conversion Rate
- Cost per Conversion

15.5 Key Power BI Metrics

| Metric | Value |
| --- | --- |
| Total Revenue | ₹908,000 |
| --- | --- |
| Total Orders | 40 |
| --- | --- |
| Total Customers | 20 |
| --- | --- |
| Average Order Value | ₹22,700 |
| --- | --- |
| Marketing Spend | ₹115,000 |
| --- | --- |
| Marketing Conversions | 1,380 |
| --- | --- |
| Last Touch Attributed Revenue | ₹113,580 |
| --- | --- |
| CTR | 5.80% |
| --- | --- |
| Conversion Rate | 4.37% |
| --- | --- |
| Cost per Conversion | ₹83.33 |

15.6 Dashboard Interactivity

- Date range slicer.
- Acquisition channel slicer.
- Synchronized slicers across all four report pages.
- Interactive charts and KPI cards.

Power BI file: `Customer_360_Marketing_Attribution.pbix`.

The four report pages have been created and previously verified.

## 16. Key Business Insights

- The CRM dataset contains 20 customers and 40 orders.
- Total CRM revenue is ₹908,000.
- RFM segmentation identifies 8 At Risk customers, 6 Champions, 4 Regular customers and 2 Loyal customers.
- Customer Lifetime Value analysis identifies 4 High Value customers in the Power BI report.
- Total marketing spend is ₹115,000.
- Referral has the highest recorded Last Touch ROAS at approximately 10.55x.
- Overall campaign CTR is 5.80%.
- Overall conversion rate is 4.37%.
- Current attribution coverage is 12.51% of total CRM revenue.

Interpret results in the context of the synthetic dataset and incomplete attribution coverage.

## 17. Project Deliverables

Recorded project deliverables include:

- `README.md`
- `DATABASE_ARCHITECTURE.md`
- `DATA_DICTIONARY.md`
- `ALL_SQL_QUERIES.sql`
- ZIP backup of 77 SQL queries
- `Customer_360_Marketing_Attribution.pbix`
- `Customer_360_Data_Analysis.ipynb`
- Python analysis output files
- dbt project, models and documentation
- Project screenshots
- Updated project progress report

## 18. Current Project Status

| Project component | Status |
| --- | --- |
| BigQuery environment and CRM data setup | Completed |
| --- | --- |
| SQL analysis (77 queries) | Completed |
| --- | --- |
| dbt transformations (8 models) and tests | Completed; latest recorded build 52 PASS |
| --- | --- |
| Python data analysis | Completed |
| --- | --- |
| Customer 360, RFM and CLV analysis | Completed |
| --- | --- |
| Marketing attribution analysis | Completed with documented coverage limitation |
| --- | --- |
| GA4 public sample analysis | Completed separately |
| --- | --- |
| Power BI four-page report | Completed and previously verified |
| --- | --- |
| Segment source event collection | Test events received |
| --- | --- |
| Segment BigQuery credentials | Updated |
| --- | --- |
| Segment-to-BigQuery warehouse sync | Completed; Segment reported 33 rows synced, 23 individually verified across four BigQuery tables |
| --- | --- |
| Final end-to-end validation | Core project components completed; final repository and presentation review remains |

## 19. Known Limitations and Future Enhancements

### Known Limitations

- Attribution coverage is currently 12.51%; remaining CRM revenue is not covered by matched attribution records.
- GA4 public sample data was analysed separately and is not directly identity-linked to synthetic CRM data.
- Segment reported 33 rows synced; 23 rows were individually verified across the `tracks`, `pages`, `identifies` and `user_sign_up` tables. The remaining 10 reported rows were not individually itemized in the saved table previews.
- Revenue-based ROAS is not profit-based ROI.

### Future Enhancements

- Improve GA4 and CRM identity resolution.
- Integrate larger and more realistic business datasets.
- Expand attribution coverage.
- Implement advanced customer segmentation.
- Develop predictive customer churn models.
- Add customer purchase propensity analysis.
- Automate data refresh and reporting workflows.

## 20. Conclusion

The Customer 360 and Marketing Attribution Platform demonstrates an end-to-end analytics workflow, from cloud data preparation and SQL-based transformations to dbt modelling, Python analysis, customer analytics, marketing attribution and interactive Power BI reporting.

The core project build is complete, including the successful Segment-to-BigQuery sync. Segment's sync summary reported 33 rows, with 23 rows individually verified across four destination tables. Final project closure now depends on the remaining repository, architecture-documentation and presentation review.
