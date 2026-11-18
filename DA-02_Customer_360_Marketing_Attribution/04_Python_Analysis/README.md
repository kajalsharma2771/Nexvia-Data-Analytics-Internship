# Customer 360 and Marketing Attribution Platform

## 1. Project Overview

The Customer 360 and Marketing Attribution Platform is an end-to-end Business Intelligence and Analytics project designed to analyze customer behavior, sales performance, customer lifetime value, marketing campaigns, and marketing attribution.

The project integrates customer, order, product, website interaction, and marketing data to generate actionable business insights.

## 2. Project Objectives

- Build a unified customer view.
- Analyze customer purchasing behavior.
- Segment customers using RFM analysis.
- Identify high-value and at-risk customers.
- Evaluate marketing campaign performance.
- Compare marketing attribution models.
- Calculate channel-level Return on Ad Spend (ROAS).
- Create interactive Power BI dashboards.

## 3. Technology Stack

| Technology | Purpose |
|---|---|
| Google BigQuery | Cloud data warehouse |
| SQL | Data extraction, transformation and analysis |
| dbt | Data transformation, testing and documentation |
| Python | Exploratory data analysis and visualization |
| Pandas and NumPy | Data manipulation and analysis |
| Matplotlib and Seaborn | Data visualization |
| Power BI | Interactive dashboards |
| Jupyter Notebook | Python development environment |
| Git | Version control |
| Segment | Website event collection and delivery to BigQuery (separate demo stream) |

## 4. Project Architecture

```text
Data Sources
    ↓
Google BigQuery
    ↓
SQL Data Analysis
    ↓
dbt Transformation Layer
    ↓
Customer 360 Data Models
    ↓
Python Analysis
    ↓
Power BI Dashboards
    ↓
Business Insights and Recommendations
```

## 5. Python Analysis

Python was connected to Google BigQuery to retrieve and analyze project datasets.

**Key analysis performed:**

- Customer data analysis
- Monthly revenue analysis
- Customer-level revenue analysis
- RFM customer segmentation
- Marketing spend analysis
- Campaign performance analysis
- Attribution model comparison
- Channel-level ROAS analysis
- Customer segment revenue analysis
- Business insights and recommendations

## 6. Key Business Metrics

| Metric | Result |
|---|---:|
| Total Customers | 20 |
| Total Orders | 40 |
| Total Revenue | ₹9,08,000 |
| Champions Customers | 6 |
| At Risk Customers | 8 |
| At Risk Historical Revenue | ₹2,83,883 |
| Marketing Spend | ₹1,15,000 |
| Impressions | 5,45,000 |
| Clicks | 31,600 |
| Conversions | 1,380 |
| Matched Attributed Revenue | ₹1,13,580 |

## 7. Customer Segmentation

The RFM analysis identified four customer segments:

- Champions: 6 customers
- At Risk: 8 customers
- Regular Customers: 4 customers
- Loyal Customers: 2 customers

Champions contributed the highest historical revenue, while the At Risk segment was identified as a priority for customer retention campaigns.

## 8. Marketing Attribution

Four attribution models were analyzed:

- First Touch
- Last Touch
- Linear
- Time Decay

The analysis compared attributed revenue across the four models and evaluated marketing channel performance.

Referral recorded the highest matched-attribution ROAS at **10.55x**, followed by Email at **1.42x**, Paid Search at **1.00x**, and Social Media at **0.48x**.

These ROAS figures are based on matched attributed revenue and should not be interpreted as profit.

## 9. Python Output Files

- `Customer_360_Data_Analysis.ipynb`
- `customer_segment_revenue.png`
- `marketing_channel_roas.png`
- `customer360_business_insights.csv`

The notebook and exported outputs are stored in this `04_Python_Analysis` folder. The PNG files are visual outputs, and the CSV contains the recorded business-insight output.

## 10. Business Recommendations

- Prioritize customer retention for the At Risk segment.
- Develop loyalty and referral programs for Champions.
- Improve repeat purchase frequency among Regular Customers.
- Evaluate marketing investment using channel-level ROAS.
- Optimize campaigns based on conversion and cost performance.

## 11. Project Outcome

The project demonstrates an end-to-end analytics workflow using cloud data warehousing, SQL, dbt, Python, and Power BI.

It provides customer segmentation, revenue analysis, marketing performance measurement, attribution analysis, and actionable business recommendations.

---

**Project:** Customer 360 and Marketing Attribution Platform  
**Python Environment:** Jupyter Notebook  
**Cloud Platform:** Google BigQuery

## Data Scope and Interpretation Notes

- The project uses synthetic CRM and marketing data; GA4 public sample data is analyzed separately.
- Direct identity-level integration between GA4 public sample users and synthetic CRM customers has not been established.
- Matched attributed revenue represents only the orders and touchpoints covered by the current attribution data. The recorded matched attributed revenue is ₹1,13,580 against total CRM revenue of ₹9,08,000.
- Attribution coverage is therefore 12.51%; interpret channel ROAS in light of this limited coverage.
- Revenue-based ROAS is not profit-based ROI.
- Segment website demo events are collected in a separate stream and are not identity-linked to the synthetic CRM customer records.
- Segment-to-BigQuery delivery has completed successfully. Segment reported 33 rows synced; 23 rows were individually verified in BigQuery across `tracks` (10), `pages` (5), `identifies` (4) and `user_sign_up` (4). The remaining 10 reported rows were not individually itemized in the saved table previews.
