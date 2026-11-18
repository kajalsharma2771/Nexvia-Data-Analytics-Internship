USE AdventureWorksDW2022;
GO

SELECT TOP 10 *
FROM dbo.DimDate;

SELECT TOP 10 *
FROM dbo.FactInternetSales;

SELECT COUNT(*) AS TotalSalesRows
FROM dbo.FactInternetSales;

SELECT
    SUM(SalesAmount) AS TotalSalesAmount
FROM dbo.FactInternetSales;

SELECT TOP 10
    SalesAmount,
    TotalProductCost,
    SalesAmount - TotalProductCost AS Profit
FROM dbo.FactInternetSales;

SELECT
    SUM(SalesAmount) AS TotalSales,
    SUM(TotalProductCost) AS TotalCost,
    SUM(SalesAmount - TotalProductCost) AS TotalProfit
FROM dbo.FactInternetSales;

SELECT
    d.CalendarYear,
    SUM(f.SalesAmount) AS TotalSales,
    SUM(f.TotalProductCost) AS TotalCost,
    SUM(f.SalesAmount - f.TotalProductCost) AS TotalProfit
FROM dbo.FactInternetSales AS f
JOIN dbo.DimDate AS d
    ON f.OrderDateKey = d.DateKey
GROUP BY d.CalendarYear
ORDER BY d.CalendarYear;

USE AdventureWorksDW2022;
GO

SELECT
    d.CalendarYear,
    SUM(f.SalesAmount) AS TotalSales,
    SUM(f.TotalProductCost) AS TotalProductCost,
    SUM(f.SalesAmount - f.TotalProductCost) AS TotalProfit
FROM dbo.FactInternetSales AS f
INNER JOIN dbo.DimDate AS d
    ON f.OrderDateKey = d.DateKey
GROUP BY d.CalendarYear
ORDER BY d.CalendarYear;


