USE AdventureWorksDW2022;
GO

SELECT
    COUNT(*) AS TotalRows,
    MIN(OrderDate) AS FirstOrderDate,
    MAX(OrderDate) AS LastOrderDate,
    SUM(SalesAmount) AS TotalSales,
    SUM(TotalProductCost) AS TotalProductCost
FROM dbo.FactInternetSales;
GO

SELECT
    d.CalendarYear,
    d.MonthNumberOfYear,
    d.EnglishMonthName,
    COUNT(*) AS SalesRows,
    SUM(f.SalesAmount) AS MonthlySales
FROM dbo.FactInternetSales AS f
INNER JOIN dbo.DimDate AS d
    ON f.OrderDateKey = d.DateKey
GROUP BY
    d.CalendarYear,
    d.MonthNumberOfYear,
    d.EnglishMonthName
ORDER BY
    d.CalendarYear,
    d.MonthNumberOfYear;
GO

SELECT
    MIN(d.FullDateAlternateKey) AS PeriodStartDate,
    MAX(d.FullDateAlternateKey) AS PeriodEndDate,
    COUNT(*) AS SalesRows,
    SUM(f.SalesAmount) AS Rolling12MonthsSales
FROM dbo.FactInternetSales AS f
INNER JOIN dbo.DimDate AS d
    ON f.OrderDateKey = d.DateKey
WHERE d.FullDateAlternateKey >= '2013-01-29'
  AND d.FullDateAlternateKey <  '2014-01-29';
GO

SELECT
    SUM(f.SalesAmount) AS YTDSales
FROM dbo.FactInternetSales AS f
INNER JOIN dbo.DimDate AS d
    ON f.OrderDateKey = d.DateKey
WHERE d.FullDateAlternateKey >= '2014-01-01'
  AND d.FullDateAlternateKey <  '2014-01-29';
GO

WITH JanuaryComparison AS
(
    SELECT
        YEAR(d.FullDateAlternateKey) AS SalesYear,
        COUNT(*) AS SalesRows,
        SUM(f.SalesAmount) AS TotalSales
    FROM dbo.FactInternetSales AS f
    INNER JOIN dbo.DimDate AS d
        ON f.OrderDateKey = d.DateKey
    WHERE
        (d.FullDateAlternateKey >= '2013-01-01'
         AND d.FullDateAlternateKey < '2013-01-29')
        OR
        (d.FullDateAlternateKey >= '2014-01-01'
         AND d.FullDateAlternateKey < '2014-01-29')
    GROUP BY YEAR(d.FullDateAlternateKey)
)
SELECT
    SalesYear,
    SalesRows,
    TotalSales
FROM JanuaryComparison
ORDER BY SalesYear;
GO

SELECT
    d.CalendarYear,
    COUNT(*) AS SalesRows,
    SUM(f.SalesAmount) AS TotalSales,
    SUM(f.TotalProductCost) AS TotalProductCost,
    SUM(f.SalesAmount - f.TotalProductCost) AS TotalProfit
FROM dbo.FactInternetSales AS f
INNER JOIN dbo.DimDate AS d
    ON f.OrderDateKey = d.DateKey
GROUP BY d.CalendarYear
ORDER BY d.CalendarYear;
GO

SELECT
    COUNT(*) AS SalesRows,
    COUNT(DISTINCT SalesOrderNumber) AS DistinctOrders,
    COUNT(DISTINCT CustomerKey) AS DistinctCustomers
FROM dbo.FactInternetSales;
GO

SELECT
    st.SalesTerritoryCountry,
    st.SalesTerritoryRegion,
    COUNT(*) AS SalesRows,
    SUM(f.SalesAmount) AS TotalSales
FROM dbo.FactInternetSales AS f
INNER JOIN dbo.DimSalesTerritory AS st
    ON f.SalesTerritoryKey = st.SalesTerritoryKey
GROUP BY
    st.SalesTerritoryCountry,
    st.SalesTerritoryRegion
ORDER BY
    st.SalesTerritoryCountry,
    TotalSales DESC;
GO
