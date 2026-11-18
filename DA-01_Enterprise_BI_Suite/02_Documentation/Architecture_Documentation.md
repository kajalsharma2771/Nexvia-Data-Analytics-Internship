# Enterprise Business Intelligence Suite for a Multi-Region Company

> **Architecture Documentation**\
> A sales analytics solution built with SQL Server and Power BI.

------------------------------------------------------------------------

## 1. Project Overview

This project analyzes sales performance across products, dates, and
sales territories using SQL Server and Power BI.

## 2. Data Source

  Item              Details
  ----------------- ----------------------------------------------
  Database          `AdventureWorksDW2022`
  Main fact table   `FactInternetSales`
  Key dimensions    `DimDate`, `DimProduct`, `DimSalesTerritory`

## 3. Architecture Components

1.  **SQL Server** stores the `AdventureWorksDW2022` database.
2.  **SQL queries** validate sales data and calculate business
    summaries.
3.  **Power Query** prepares data for analysis.
4.  **Power BI data model** connects fact and dimension tables.
5.  **DAX measures** calculate:
    -   Sales
    -   Profit
    -   Profit margin
    -   Year-to-date (YTD) sales
    -   Year-over-year (YoY) growth
    -   Rolling 12-month sales
6.  **Power BI reports** provide six report pages:
    -   Executive Dashboard
    -   Region Analysis
    -   Sales Trends
    -   Product Analysis
    -   Region Details
    -   Product Details
7.  **Row-Level Security (RLS)** restricts report data by territory. The
    Australia role has been tested.

## 4. Data Flow

The solution follows this high-level data flow:

``` mermaid
flowchart LR
    A["AdventureWorksDW2022"] --> B["SQL Server"]
    B --> C["Power BI Data Preparation"]
    C --> D["Power BI Data Model"]
    D --> E["DAX Measures"]
    E --> F["Power BI Reports"]
```

**Flow summary:**\
`AdventureWorksDW2022` → SQL Server → Power BI Data Preparation and
Model → DAX Measures → Power BI Reports.

## 5. Security

An `Australia_Sales` role was created using a country filter on
`DimSalesTerritory`. The role was tested using **View as** in Power BI
Desktop.

## 6. Planned Enhancements

-   Publish to Power BI Service and configure online refresh if access
    and licensing permit.
-   Publish the project to GitHub if repository publication is planned.
-   Extend the solution with additional data sources or automated data
    pipelines in a future version.

## 7. Important Data Limitation

The available 2014 sales data ends on **January 28, 2014**. Full-year
2014 versus 2013 comparisons should therefore be labelled carefully;
same-period comparisons are more appropriate.

## 8. Architecture Diagram

The architecture diagram is referenced as:

`Enterprise_BI_Architecture_Diagram.png`

Place this image in the same folder as this Markdown file if you want to
display it directly in the GitHub repository. To embed it, add the
following line after uploading the image:

``` markdown
![Enterprise BI Architecture](Enterprise_BI_Architecture_Diagram.png)
```

------------------------------------------------------------------------

## Document Information

  Field               Value
  ------------------- ----------------------------------------
  Project             Enterprise Business Intelligence Suite
  Document            Architecture Documentation
  Primary tools       SQL Server, Power Query, Power BI, DAX
  Security approach   Power BI Row-Level Security
