USE AdventureWorksDW2022;
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

    WITH YearlyProfit AS
(
    SELECT
        YEAR(d.FullDateAlternateKey) AS SalesYear,
        SUM(f.SalesAmount) AS TotalSales,
        SUM(f.TotalProductCost) AS TotalProductCost,
        SUM(f.SalesAmount) - SUM(f.TotalProductCost) AS TotalProfit
    FROM dbo.FactInternetSales AS f
    INNER JOIN dbo.DimDate AS d
        ON f.OrderDateKey = d.DateKey
    GROUP BY YEAR(d.FullDateAlternateKey)
)
SELECT
    SalesYear,
    TotalSales,
    TotalProductCost,
    TotalProfit,
    LAG(TotalProfit) OVER (ORDER BY SalesYear) AS PreviousYearProfit,
    100.0 * (
        TotalProfit - LAG(TotalProfit) OVER (ORDER BY SalesYear)
    ) / NULLIF(
        LAG(TotalProfit) OVER (ORDER BY SalesYear), 0
    ) AS YoYProfitGrowthPercent
FROM YearlyProfit
ORDER BY SalesYear;

WITH CurrentPeriod AS
(
    SELECT
        SUM(f.SalesAmount) - SUM(f.TotalProductCost) AS CurrentProfit
    FROM dbo.FactInternetSales AS f
    INNER JOIN dbo.DimDate AS d
        ON f.OrderDateKey = d.DateKey
    WHERE d.FullDateAlternateKey >= '2010-12-29'
      AND d.FullDateAlternateKey <= '2014-01-28'
),
PreviousPeriod AS
(
    SELECT
        SUM(f.SalesAmount) - SUM(f.TotalProductCost) AS PreviousProfit
    FROM dbo.FactInternetSales AS f
    INNER JOIN dbo.DimDate AS d
        ON f.OrderDateKey = d.DateKey
    WHERE d.FullDateAlternateKey >= '2009-12-29'
      AND d.FullDateAlternateKey <= '2013-01-28'
)
SELECT
    CurrentProfit,
    PreviousProfit,
    100.0 * (CurrentProfit - PreviousProfit)
        / NULLIF(PreviousProfit, 0) AS YoYProfitGrowthPercent
FROM CurrentPeriod
CROSS JOIN PreviousPeriod;

WITH SalesPeriods AS
(
    SELECT
        SUM(
            CASE
                WHEN d.FullDateAlternateKey >= '2014-01-01'
                 AND d.FullDateAlternateKey <  '2014-01-29'
                THEN f.SalesAmount
                ELSE 0
            END
        ) AS CurrentPeriodSales,

        SUM(
            CASE
                WHEN d.FullDateAlternateKey >= '2013-01-01'
                 AND d.FullDateAlternateKey <  '2013-01-29'
                THEN f.SalesAmount
                ELSE 0
            END
        ) AS PreviousPeriodSales
    FROM dbo.FactInternetSales AS f
    INNER JOIN dbo.DimDate AS d
        ON f.OrderDateKey = d.DateKey
    WHERE
        (d.FullDateAlternateKey >= '2014-01-01'
         AND d.FullDateAlternateKey < '2014-01-29')
        OR
        (d.FullDateAlternateKey >= '2013-01-01'
         AND d.FullDateAlternateKey < '2013-01-29')
)
SELECT
    CurrentPeriodSales,
    PreviousPeriodSales,
    100.0 * (CurrentPeriodSales - PreviousPeriodSales)
        / NULLIF(PreviousPeriodSales, 0) AS YoYSalesGrowthPercent
FROM SalesPeriods;