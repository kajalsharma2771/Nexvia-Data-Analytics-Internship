# Project Progress Report
## Customer 360 and Marketing Attribution Platform


## 1. Cloud Environment

| Component | Details |
|---|---|
| Cloud platform | Google BigQuery Sandbox |
| Google Cloud project ID | `customer360-mktg` |
| Dataset | `customer360` |
| Data location | `asia-south1` |

## 2. Data Engineering and SQL

### Recorded data volumes

| Data entity | Records |
|---|---:|
| CRM customers | 20 |
| CRM orders | 40 |
| CRM order items | 40 |
| CRM products | 10 |
| Marketing spend | 10 |
| Campaigns | 10 |
| Web events | 200 |
| Customer sessions | 40 |

- SQL queries completed and backed up: **77**
- Data validation and quality checks: **Completed**

## 3. dbt Transformation

| Item | Status / Result |
|---|---|
| Staging models | 4 |
| Intermediate models | 3 |
| Mart models | 1 |
| Total dbt models | 8 |
| Latest recorded dbt build | **52 PASS** (8 models and 44 tests) |
| dbt documentation and lineage | Reviewed |

## 4. Customer Analytics

- Customer 360 view, CLV, RFM and customer segmentation: **Completed**
- Total CRM revenue: **₹908,000**

### RFM segment results

| Customer segment | Customers | Revenue | Revenue share |
|---|---:|---:|---:|
| Champions | 6 | ₹368,366 | 40.57% |
| At Risk | 8 | ₹283,883 | 31.26% |
| Regular | 4 | ₹183,251 | 20.18% |
| Loyal | 2 | ₹72,500 | 7.98% |
| **Total** | **20** | **₹908,000** | **100%** |

*Revenue shares may differ slightly from 100% because of rounding.*

## 5. Python Data Analysis

| Item | Details |
|---|---|
| Notebook | `Customer_360_Data_Analysis.ipynb` |
| Libraries and workflow | Pandas, NumPy, Matplotlib, Seaborn and BigQuery client |
| Analysis areas | Customer, revenue, RFM, marketing spend, campaign and attribution |

### Recorded outputs

- `customer_segment_revenue.png`
- `marketing_channel_roas.png`
- `customer360_business_insights.csv`
- `README.md`

## 6. Marketing Attribution

| Item | Result |
|---|---|
| Attribution models | First Touch, Last Touch, Linear and Time Decay |
| Matched attributed revenue | ₹113,580 |
| Total CRM revenue | ₹908,000 |
| Attribution coverage | 12.51% |
| Marketing spend | ₹115,000 |

### Recorded channel matched-attribution ROAS

| Channel | ROAS |
|---|---:|
| Referral | 10.55x |
| Email | 1.42x |
| Paid Search | 1.00x |
| Social Media | 0.48x |

Attribution analysis is completed with documented data limitations. Coverage is incomplete and should be considered when interpreting the results.

## 7. GA4 Analysis

- GA4 public sample data queries and analysis: **Completed separately**
- GA4 public sample data is not identity-linked to the synthetic CRM dataset.

## 8. Power BI Report

| Item | Details |
|---|---|
| Power BI file | `Customer_360_Marketing_Attribution.pbix` |
| Report pages | 4 |
| Current recorded status | Created and previously verified |

### Report pages

1. Executive Dashboard
2. Customer Analysis
3. Marketing Attribution
4. Campaign Performance

KPI cards, charts, slicers and report interactions are configured.

## 9. Segment Website Event Collection and BigQuery Destination

| Component | Details |
|---|---|
| Segment workspace | `Kajal-Sharma` |
| JavaScript source | `Customer 360 Website Demo` |
| BigQuery destination | `Customer360_BigQuery_Destination` |
| BigQuery project | `customer360-mktg` |
| Destination schema shown in Segment | `customer_360_website_demo` |
| Service account roles configured | BigQuery Data Editor and BigQuery Job User |
| Credential update | New service-account JSON credentials updated in Segment |

### Segment event test

Segment Debugger previously received **10 test events**:
- 5 Track events
- 3 Page events
- 2 Identify events

### Warehouse sync status

**Successfully synced and verified on 17 November 2026.**

The earlier sync failed with 0 rows and a `bigquery.jobs.create` permission error. That failure occurred before the service-account credential update. After the new credentials were saved in Segment, a fresh warehouse sync completed successfully.

- Segment sync status: **Complete**
- Segment sync summary: **33 rows synced**
- BigQuery event-table previews independently confirmed:
  - `tracks`: 10 rows
  - `pages`: 5 rows
  - `identifies`: 4 rows
  - `user_sign_up`: 4 rows
- The four listed tables account for 23 rows. Segment's overall summary reported 33 rows; the remaining 10 rows are not itemized in this verification note.
- Previous credential key: deleted after the new key was added.

**Security note:** Never include service-account private keys, JSON credential contents or other secrets in this repository.

## 10. Documentation and Deliverables Recorded

- `README.md`
- `DATABASE_ARCHITECTURE.md`
- `DATA_DICTIONARY.md`
- `ALL_SQL_QUERIES.sql`
- ZIP backup of 77 SQL files
- Project screenshots
- `Customer_360_Marketing_Attribution.pbix`
- Python notebook and analysis outputs
- dbt project and model documentation

## 11. Known Limitations

- Attribution coverage is 12.51%; the remaining CRM revenue is not covered by matched attribution records.
- GA4 public sample data was analysed separately and is not directly identity-linked to synthetic CRM data.
- Revenue-based ROAS is not profit-based ROI.
- Segment website demo events are a separate event stream and are not the same records as the synthetic CRM dataset.

## 12. Current Project Status

| Project component | Status |
|---|---|
| BigQuery CRM data setup and SQL analysis | Completed |
| dbt transformations and tests | Completed — latest recorded build: 52 PASS |
| Python analysis | Completed |
| Power BI dashboards | Completed and previously verified |
| GA4 sample analysis | Completed separately |
| Segment source event collection | Completed — 10 test events received |
| Segment BigQuery destination credentials | Updated |
| Segment BigQuery warehouse sync | Completed — Segment reported 33 rows synced |
| BigQuery event-table verification | Completed — `tracks` (10), `pages` (5), `identifies` (4), `user_sign_up` (4) |
| Final documentation and end-to-end closure | In progress |

## Overall Status

The core project build and Segment-to-BigQuery event delivery are completed and verified. Segment reported 33 rows synced, and BigQuery previews confirmed rows in the `tracks`, `pages`, `identifies` and `user_sign_up` tables. Remaining work is final documentation consistency review, end-to-end project validation and GitHub publication.
