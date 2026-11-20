CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(50),
    Category VARCHAR(50),
    Stock INT
);
INSERT INTO Products VALUES
(1, 'Laptop', 'Electronics', 10),
(2, 'Mouse', 'Electronics', 5),
(3, 'Chair', 'Furniture', 8),
(4, 'Table', 'Furniture', 3),
(5, 'Keyboard', 'Electronics', 2);

-- Task 2 – Correlated Subquery

SELECT ProductID, ProductName, Category, Stock
FROM Products p
WHERE Stock < (
    SELECT AVG(Stock)
    FROM Products
    WHERE Category = p.Category
);

-- Task 3 – Rank Products by Sales Using CTE
CREATE TABLE Sales (
    SaleID INT PRIMARY KEY,
    ProductID INT,
    Quantity INT,
    SaleDate DATE,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

INSERT INTO Sales VALUES
(1, 1, 10, '2026-01-10'),
(2, 2, 20, '2026-01-15'),
(3, 3, 15, '2026-01-20'),
(4, 4, 5, '2026-02-05'),
(5, 5, 25, '2026-02-10'),
(6, 1, 8, '2026-02-15'),
(7, 2, 12, '2026-02-20'),
(8, 3, 10, '2026-03-05'),
(9, 4, 7, '2026-03-10'),
(10, 5, 15, '2026-03-15');

WITH ProductSales AS (
    SELECT
        p.ProductID,
        p.ProductName,
        p.Category,
        SUM(s.Quantity) AS TotalSales,
        ROW_NUMBER() OVER (
            PARTITION BY p.Category
            ORDER BY SUM(s.Quantity) DESC
        ) AS SalesRank
    FROM Products p
    JOIN Sales s ON p.ProductID = s.ProductID
    GROUP BY p.ProductID, p.ProductName, p.Category
)
SELECT *
FROM ProductSales
WHERE SalesRank <= 3
ORDER BY Category, SalesRank;

-- Task 4 – Month-on-Month Sales Using LEAD and LAG

WITH MonthlySales AS (
    SELECT
        ProductID,
        DATEFROMPARTS(YEAR(SaleDate), MONTH(SaleDate), 1) AS SalesMonth,
        SUM(Quantity) AS TotalSales
    FROM Sales
    GROUP BY ProductID,
             DATEFROMPARTS(YEAR(SaleDate), MONTH(SaleDate), 1)
),
Months AS (
    SELECT DISTINCT SalesMonth FROM MonthlySales
),
ProductMonths AS (
    SELECT p.ProductID, p.ProductName, m.SalesMonth
    FROM Products p
    CROSS JOIN Months m
),
SalesReport AS (
    SELECT
        pm.ProductID,
        pm.ProductName,
        pm.SalesMonth,
        COALESCE(ms.TotalSales, 0) AS TotalSales
    FROM ProductMonths pm
    LEFT JOIN MonthlySales ms
        ON pm.ProductID = ms.ProductID
        AND pm.SalesMonth = ms.SalesMonth
)
SELECT *,
    LAG(TotalSales) OVER (
        PARTITION BY ProductID ORDER BY SalesMonth
    ) AS PreviousMonthSales,
    LEAD(TotalSales) OVER (
        PARTITION BY ProductID ORDER BY SalesMonth
    ) AS NextMonthSales,
    TotalSales - LAG(TotalSales) OVER (
        PARTITION BY ProductID ORDER BY SalesMonth
    ) AS SalesChange
FROM SalesReport
ORDER BY ProductID, SalesMonth;