# Enterprise Business Intelligence Suite --- Test Results

> **Project validation report**\
> Records SQL Server, Power BI, security, navigation, KPI
> reconciliation, and scheduled-job test results.

------------------------------------------------------------------------

## Test Summary

  -----------------------------------------------------------------------
  Area                                Result
  ----------------------------------- -----------------------------------
  SQL Server connectivity             **PASS**

  AdventureWorksDW2022 restore        **PASS**

  FactInternetSales row count         **60,398 rows**

  Total sales reconciliation          **PASS**

  Yearly sales and profit query       **Executed successfully
                                      (2010--2014)**

  Six Power BI report pages           **PASS**

  Region and product drill-through    **PASS**

  Australia_Sales RLS Desktop test    **PASS for documented test**

  Tested DAX KPI reconciliation       **PASS for documented contexts**

  EnterpriseBI_Daily_Refresh job      **PASS**

  SQL Server Agent schedule           **Sunday, 11:00 PM**
  -----------------------------------------------------------------------

------------------------------------------------------------------------

## 1. SQL Server Connectivity

-   **Test:** Connect to SQL Server using SSMS.
-   **Expected result:** Database connection succeeds.
-   **Actual result:** Passed.

## 2. Database Restore

-   **Test:** Restore the AdventureWorksDW2022 sample database.
-   **Expected result:** Database appears in SQL Server.
-   **Actual result:** Passed.

## 3. Sales Data Validation

-   **Test:** Count rows in `FactInternetSales`.
-   **Expected result:** Query returns a row count.
-   **Actual result:** **60,398 rows**.

## 4. Total Sales Validation

-   **Test:** Calculate total `SalesAmount` in SQL Server and compare
    with Power BI.
-   **Expected result:** SQL and Power BI totals agree after rounding.
-   **Actual result:**
    -   SQL Server total: **29,358,677.2207**
    -   Power BI display: approximately **29.36M**
-   **Status:** **PASS**

## 5. Yearly Sales and Profit

-   **Test:** Join `FactInternetSales` with `DimDate` and aggregate
    sales, product cost, and profit by `CalendarYear`.
-   **Expected result:** Query returns yearly totals.
-   **Actual result:** Query executed successfully for **2010--2014**.
-   **Interpretation note:** 2014 data is partial and must not be
    compared directly with a full year.

## 6. Power BI Report Pages and Navigation

-   **Test:** Create and validate report pages and drill-through
    navigation.
-   **Actual result:** Six pages created:
    1.  Executive Dashboard
    2.  Region Analysis
    3.  Sales Trends
    4.  Product Analysis
    5.  Region Details
    6.  Product Details
-   Region and product drill-through navigation tested successfully.
-   **Status:** **PASS**

## 7. Row-Level Security (RLS)

-   **Test:** Apply the `Australia_Sales` role in Power BI Desktop.
-   **Expected result:** Only Australia sales data is visible in the
    tested visual/context.
-   **Actual result:** The Sales by Country chart showed Australia
    during role testing.
-   **Status:** **PASS --- documented Power BI Desktop role test**
-   **Note:** If the report is published, configure and verify role
    assignments in Power BI Service separately.

## 8. KPI Validation and Data Limitations

  -----------------------------------------------------------------------
  KPI / Check             SQL result or           Result
                          comparison              
  ----------------------- ----------------------- -----------------------
  Total Sales             SQL: 29,358,677.2207;   **PASS**
                          Power BI: approximately 
                          29.36M                  

  YTD Sales               Approximately           **PASS**
                          45,694.72; matched      
                          January 2014 SQL sales  
                          for the tested date     
                          selection               

  YoY Profit Growth       Current Period Profit:  **PASS**
                          12,080,883.645;         
                          Previous Period Profit: 
                          5,609,042.5586; growth: 
                          approximately 115.38%.  
                          Matched Power BI for 29 
                          Dec 2010--28 Jan 2014   

  Rolling 12M Sales       SQL: 15,615,345.06 for  **PASS**
                          29 Jan 2013--28 Jan     
                          2014; Power BI:         
                          approximately 15.615M   

  YoY Sales Growth (Same  1--28 Jan 2014:         **PASS**
  Period)                 45,694.72; 1--28 Jan    
                          2013: 781,900.00;       
                          growth: approximately   
                          -94.16%. Matched Power  
                          BI                      

  Full-Year YoY           2014 data ends on 28    **CAUTION**
  Comparison              Jan 2014                
  -----------------------------------------------------------------------

**Data limitation:** Available 2014 sales data ends on **28 January
2014**. Comparing partial-year 2014 results with full-year 2013 results
would be misleading. Use like-for-like periods for meaningful YoY
analysis.

## 9. Additional Power BI and SQL Job Tests

  ------------------------------------------------------------------------------
  Test                    Result / Evidence              Status
  ----------------------- ------------------------------ -----------------------
  Region Drill-through    Selected region filters the    **PASS**
                          Region Details page            

  Product Drill-through   Selecting Mountain-200 Black,  **PASS**
                          46 from Top 10 Products by     
                          Sales opened Product Details   
                          and displayed only that        
                          product, with sales of         
                          approximately 1.37M in the     
                          report's displayed currency    

  Back Button Navigation  Region Details and Product     **PASS**
                          Details return to their        
                          respective source pages        

  SQL Server Agent Job    `EnterpriseBI_Daily_Refresh`   **PASS**
                          executed successfully          

  SQL Job Schedule        Configured for every Sunday at **Configured**
                          11:00 PM                       

  Executive Dashboard     Changing the selected end date **PASS**
  Date Slicer             updated the main KPI cards.    
                          YTD Sales and YoY Sales Growth 
                          (Same Period) were validated   
                          against SQL for the tested     
                          date contexts. Rolling 12M     
                          Sales was reconciled against   
                          SQL for the documented date    
                          boundaries                     

  Region Chart            Selecting Australia in Sales   **PASS**
  Interaction             by Country filtered Sales by   
                          US Region to blank because     
                          Australia has no US-region     
                          records; clearing the          
                          selection restored the         
                          original chart                 

  Sales Trends Date       Changing the date range to 29  **PASS**
  Slicer                  Dec 2010--31 Dec 2012 filtered 
                          the line chart to that period  
                          and excluded 2013 and 2014     
                          data                           

  Product Chart Selection Selecting a product in Top 10  **PASS**
                          Products by Sales highlighted  
                          the product and displayed      
                          sales details in the tooltip   
  ------------------------------------------------------------------------------

## 10. Final Handoff Checks

Before handing off or publishing the project, verify the following:

-   [ ] Confirm the final saved Power BI (`.pbix`) file opens
    successfully and contains all six report pages.
-   [ ] Confirm Power BI Desktop is in normal report view, not **View as
    roles** mode, before saving the final version.
-   [ ] Confirm the final folder contains the intended deliverables and
    that the final SQL scripts and this test-results file are saved.
-   [ ] Power BI Service publishing is optional and depends on
    access/licensing.
-   [ ] GitHub publication is optional if repository publication is
    planned.

------------------------------------------------------------------------

## Conclusion

SQL connectivity, database restoration, sales row-count validation,
total sales reconciliation, yearly SQL analysis, and Power BI report
creation have been completed. The project includes six report pages,
validated KPI measures for the tested contexts, region and product
drill-through navigation, tested report interactions, an
Australia-specific RLS role tested in Power BI Desktop, and a
successfully executed SQL Server Agent job.

YTD Sales, Rolling 12M Sales, YoY Profit Growth, and YoY Sales Growth
(Same Period) were reconciled against SQL for the documented test
contexts. The AdventureWorksDW2022 sales data used here ends on **28
January 2014**; this partial 2014 period is an important limitation when
interpreting year-over-year results.

**Remaining handoff check:** Verify that the final saved Power BI file
opens with all six report pages and is saved in normal report view.
Power BI Service and GitHub publication are optional future
improvements.

------------------------------------------------------------------------

**Project:** Enterprise Business Intelligence Suite\
**Primary tools:** SQL Server, SSMS, Power BI Desktop, DAX, Power Query\
**Validation scope:** SQL data checks, Power BI KPIs, report
interactions, RLS Desktop test, SQL Server Agent job
