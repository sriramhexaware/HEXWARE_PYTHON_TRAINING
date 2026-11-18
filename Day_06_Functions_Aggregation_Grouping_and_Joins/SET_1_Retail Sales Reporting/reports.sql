-- Database and table creation
USE Hexaware;


CREATE TABLE Customers (
    Customer_ID INT IDENTITY(1,1) PRIMARY KEY,
    Customer_Name VARCHAR(100) NOT NULL,
    City VARCHAR(50) NOT NULL,
    Email VARCHAR(100) UNIQUE
);
CREATE TABLE Products (
    Product_ID INT IDENTITY(1,1) PRIMARY KEY,
    Product_Name VARCHAR(100) NOT NULL,
    Category VARCHAR(50) NOT NULL,
    Price DECIMAL(10,2) NOT NULL CHECK (Price >= 0)
);
CREATE TABLE Orders (
    Order_ID INT IDENTITY(1,1) PRIMARY KEY,
    Customer_ID INT,
    Order_Date DATE,
    Payment_Status VARCHAR(20),

    FOREIGN KEY (Customer_ID)
    REFERENCES Customers(Customer_ID)
);
CREATE TABLE Order_Items (
    Item_ID INT IDENTITY(1,1) PRIMARY KEY,
    Order_ID INT,
    Product_ID INT,
    Quantity INT,
    Unit_Price DECIMAL(10,2),

    FOREIGN KEY (Order_ID) REFERENCES Orders(Order_ID),
    FOREIGN KEY (Product_ID) REFERENCES Products(Product_ID)
);
--insert records
INSERT INTO Customers (Customer_Name, City, Email)
VALUES
('Arun Kumar', 'Chennai', 'arun@gmail.com'),
('Priya Sharma', 'Coimbatore', 'priya@gmail.com'),
('Rahul Verma', 'Chennai', 'rahul@gmail.com'),
('Divya Raj', 'Bangalore', 'divya@gmail.com'),
('Karthik S', 'Coimbatore', 'karthik@gmail.com'),
('Meena R', 'Madurai', 'meena@gmail.com');

INSERT INTO Products (Product_Name, Category, Price)
VALUES
('Laptop', 'Electronics', 50000),
('Mobile', 'Electronics', 20000),
('Headphones', 'Accessories', 2000),
('Keyboard', 'Accessories', 1500),
('Chair', 'Furniture', 5000),
('Table', 'Furniture', 8000),
('Monitor', 'Electronics', 12000),
('Mouse', 'Accessories', 800);

INSERT INTO Orders (Customer_ID, Order_Date, Payment_Status)
VALUES
(1, '2026-11-01', 'Paid'),
(1, '2026-11-05', 'Pending'),
(1, '2026-11-10', 'Paid'),
(1, '2026-11-15', 'Paid'),
(2, '2026-11-03', 'Paid'),
(2, '2026-10-15', 'Pending'),
(3, '2026-10-20', 'Paid'),
(3, '2026-09-12', 'Paid'),
(4, '2026-11-08', 'Pending'),
(5, '2026-10-25', 'Paid'),
(5, '2026-11-12', 'Paid');

INSERT INTO Order_Items (Order_ID, Product_ID, Quantity, Unit_Price)
VALUES
(1, 1, 1, 50000),
(1, 3, 2, 2000),
(2, 2, 1, 20000),
(2, 4, 2, 1500),
(3, 1, 1, 50000),
(3, 7, 1, 12000),
(4, 5, 2, 5000),
(5, 2, 2, 20000),
(5, 8, 2, 800),
(6, 3, 3, 2000),
(7, 1, 1, 50000),
(7, 6, 1, 8000),
(8, 4, 4, 1500),
(9, 7, 2, 12000),
(10, 5, 3, 5000),
(11, 2, 1, 20000),
(11, 3, 1, 2000);

--return all tables
SELECT * FROM Customers;
SELECT * FROM Products;
SELECT * FROM Orders;
SELECT * FROM Order_Items;

--Top 5 Products by Revenue
SELECT TOP 5
    p.Product_Name,
    SUM(oi.Quantity * oi.Unit_Price) AS Total_Revenue
FROM Products p
JOIN Order_Items oi
    ON p.Product_ID = oi.Product_ID
GROUP BY p.Product_Name
ORDER BY Total_Revenue DESC;

--Month-wise Sales
SELECT
    FORMAT(o.Order_Date, 'yyyy-MM') AS Sales_Month,
    SUM(oi.Quantity * oi.Unit_Price) AS Total_Sales
FROM Orders o
JOIN Order_Items oi
    ON o.Order_ID = oi.Order_ID
GROUP BY FORMAT(o.Order_Date, 'yyyy-MM')
ORDER BY Sales_Month;

--Customers with More Than 3 Orders
SELECT
    c.Customer_Name,
    COUNT(o.Order_ID) AS Total_Orders
FROM Customers c
JOIN Orders o
    ON c.Customer_ID = o.Customer_ID
GROUP BY c.Customer_ID, c.Customer_Name
HAVING COUNT(o.Order_ID) > 3;

--Average Basket Value per City
SELECT
    c.City,
    AVG(Order_Total) AS Average_Basket_Value
FROM Customers c
JOIN Orders o
    ON c.Customer_ID = o.Customer_ID
JOIN (
    SELECT
        Order_ID,
        SUM(Quantity * Unit_Price) AS Order_Total
    FROM Order_Items
    GROUP BY Order_ID
) AS OrderValues
    ON o.Order_ID = OrderValues.Order_ID
GROUP BY c.City;

--Orders Without Payment (LEFT JOIN)
SELECT
    o.Order_ID,
    c.Customer_Name,
    o.Order_Date,
    o.Payment_Status
FROM Orders o
LEFT JOIN Customers c
    ON o.Customer_ID = c.Customer_ID
WHERE o.Payment_Status <> 'Paid';

--Customers with No Orders
SELECT
    c.Customer_ID,
    c.Customer_Name
FROM Customers c
LEFT JOIN Orders o
    ON c.Customer_ID = o.Customer_ID
WHERE o.Order_ID IS NULL;

--Day with the Highest Sales
SELECT TOP 1
    o.Order_Date,
    SUM(oi.Quantity * oi.Unit_Price) AS Total_Sales
FROM Orders o
JOIN Order_Items oi
    ON o.Order_ID = oi.Order_ID
GROUP BY o.Order_Date
ORDER BY Total_Sales DESC;

--UPPER, CONCAT, DATEDIFF, FORMAT,ROUND
SELECT
    Customer_Name,
    UPPER(Customer_Name) AS Uppercase_Name
FROM Customers;

SELECT
    Customer_Name,
    CONCAT(Customer_Name, ' - ', City) AS Customer_Details
FROM Customers;

SELECT
    Order_ID,
    Order_Date,
    DATEDIFF(DAY, Order_Date, GETDATE()) AS Days_Since_Order
FROM Orders;

SELECT
    Order_ID,
    Order_Date,
    FORMAT(Order_Date, 'dd-MM-yyyy') AS Formatted_Date
FROM Orders;

SELECT
    ROUND(1234.5678, 2) AS Rounded_Value;

--Null in count(*),count(column),avg(column)
CREATE TABLE Null_Practice (
    ID INT,
    Salary DECIMAL(10,2)
);

INSERT INTO Null_Practice VALUES
(1, 20000),
(2, 30000),
(3, NULL),
(4, 40000),
(5, NULL);

SELECT
    COUNT(*) AS Total_Rows,
    COUNT(Salary) AS Salary_Count,
    AVG(Salary) AS Average_Salary
FROM Null_Practice;