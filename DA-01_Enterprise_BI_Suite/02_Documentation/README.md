# Enterprise Business Intelligence Suite for a Multi-Region Company

A business intelligence solution for analyzing sales performance across
countries, sales regions, years, and products using Microsoft SQL Server
and Power BI.

------------------------------------------------------------------------

## Table of Contents

-   [Project Overview](#1-project-overview)
-   [Project Objectives](#2-project-objectives)
-   [Tools and Technologies](#3-tools-and-technologies)
-   [Data Source](#4-data-source)
-   [Dashboard Pages](#5-dashboard-pages)
-   [SQL Analysis](#6-sql-analysis)
-   [DAX Measures](#7-dax-measures)
-   [Row-Level Security](#8-row-level-security)
-   [Project Structure](#9-project-structure)
-   [Current Project Status](#10-current-project-status)
-   [Remaining Validation and Future
    Improvements](#11-remaining-validation-and-future-improvements)
-   [Conclusion](#12-conclusion)

------------------------------------------------------------------------

## 1. Project Overview

This project delivers a business intelligence solution for analyzing
sales performance across countries, sales regions, years, and products.
It uses **Microsoft SQL Server** for data storage and SQL-based
analysis, and **Power BI** for interactive dashboards and reporting.

## 2. Project Objectives

-   Analyze total sales, product costs, and profit.
-   Compare sales performance across countries and US sales regions.
-   Track yearly and monthly sales trends.
-   Identify top-performing products.
-   Implement Row-Level Security (RLS) to restrict data access by
    country.
-   Validate business metrics using SQL and Power BI.

## 3. Tools and Technologies

  -----------------------------------------------------------------------
  Technology                          Purpose
  ----------------------------------- -----------------------------------
  Microsoft SQL Server                Database storage and SQL-based
                                      analysis

  SQL Server Management Studio (SSMS) Database management, query
                                      execution, and validation

  AdventureWorksDW2022                Sample data warehouse

  Microsoft Power BI Desktop          Interactive reports and dashboards

  DAX (Data Analysis Expressions)     Business calculations and KPI
                                      measures

  Power Query                         Data preparation and transformation
  -----------------------------------------------------------------------

## 4. Data Source

The project uses the **AdventureWorksDW2022** sample data warehouse.

### Key Tables

  Table                 Role
  --------------------- ---------------------------
  `FactInternetSales`   Main sales fact table
  `DimDate`             Date dimension
  `DimProduct`          Product dimension
  `DimSalesTerritory`   Sales territory dimension

The fact table contains **60,398 sales rows**. The available sales data
extends through January 2014, so comparisons involving 2014 must account
for the incomplete year.

## 5. Dashboard Pages

The Power BI report contains six pages:

### 5.1 Executive Dashboard

Displays Total Sales, Total Orders, Total Profit, Profit Margin, Rolling
12M Sales, YTD Sales, and sales/profit growth indicators.

### 5.2 Region Analysis

Compares sales by country and US sales territory region.

### 5.3 Sales Trends

Visualizes monthly and yearly sales trends over the available date
range.

### 5.4 Product Analysis

Displays the top 10 products by sales.

### 5.5 Region Details

Provides a drill-through view of product sales for a selected sales
region.

### 5.6 Product Details

Provides a drill-through view for a selected product.

## 6. SQL Analysis

SQL queries analyze sales performance by year, country, sales territory,
and product.

### Analysis Includes

-   Sales row counts
-   Total sales
-   Product costs
-   Total profit
-   Yearly sales and profit
-   Country and territory-level sales

### Profit Calculation

``` sql
Profit = Sales Amount - Total Product Cost
```

The SQL sales total across the full fact table is approximately **29.36
million** in the source currency.

## 7. DAX Measures

The report includes measures such as:

-   Total Sales
-   Total Orders
-   Total Profit
-   Profit Margin %
-   Previous Year Sales
-   YoY Sales Growth %
-   YoY Profit Growth %
-   YTD Sales
-   Rolling 12M Sales
-   YoY Sales Growth (Same Period) %

Key DAX measures have been validated against SQL results for the tested
date contexts.

> **Data limitation:** The available 2014 data ends on **28 January
> 2014**, so full-year comparisons between 2013 and 2014 can be
> misleading.

## 8. Row-Level Security

An `Australia_Sales` role was created with the following filter:

``` dax
DimSalesTerritory[SalesTerritoryCountry] = "Australia"
```

The role was tested in Power BI Desktop using **View as roles**. The
test confirmed that the report was filtered to Australia. The report was
also checked in normal view with no role selected.

If the report is published to Power BI Service, appropriate user
assignments and access permissions must be configured.

## 9. Project Structure

``` text
Enterprise_BI_Project/
│
├── 01_Database/          # Database backup
├── 02_SQL_Scripts/       # SQL analysis scripts
├── 03_PowerBI/           # Power BI report
├── 04_Documentation/     # README, architecture documentation, and diagram
├── 05_Test_Results/      # Test results and validation evidence
└── 06_Presentation/      # Final project presentation
```

## 10. Current Project Status

-   SQL Server setup and database restoration completed.
-   SQL analysis queries executed successfully.
-   Six Power BI report pages created: Executive Dashboard, Region
    Analysis, Sales Trends, Product Analysis, Region Details, and
    Product Details.
-   Region Details and Product Details drill-through pages created and
    tested.
-   Australia RLS role created and previously tested in Power BI
    Desktop.
-   Architecture documentation and diagram files created.
-   Final presentation and test-results files created.

## 11. Remaining Validation and Future Improvements

-   Keep the January 2014 partial-year data limitation documented when
    interpreting year-over-year results.
-   Publish the report to Power BI Service if access and licensing
    permit.
-   Publish the project to GitHub if repository publication is planned.

## 12. Conclusion

The Enterprise Business Intelligence Suite for a Multi-Region Company
combines SQL-based data analysis with Power BI dashboards to explore
sales performance across time, geography, and products. The project
includes executive KPIs, regional and product analysis, drill-through
navigation, validated key business metrics, and an Australia-specific
Row-Level Security (RLS) role.

The core local project deliverables have been completed. Publishing to
Power BI Service and GitHub remains optional.

------------------------------------------------------------------------

**Project:** Enterprise Business Intelligence Suite for a Multi-Region
Company\
**Primary tools:** Microsoft SQL Server, SSMS, Power BI Desktop, DAX,
Power Query
