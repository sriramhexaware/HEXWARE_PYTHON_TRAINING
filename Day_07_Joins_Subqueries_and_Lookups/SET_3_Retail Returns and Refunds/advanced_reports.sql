--Create database and tables

USE RetailReturns;


CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(50)
);

CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(50),
    category VARCHAR(30)
);

CREATE TABLE Stores (
    store_id INT PRIMARY KEY,
    store_name VARCHAR(50),
    region VARCHAR(30)
);

CREATE TABLE Employees (
    employee_id INT PRIMARY KEY,
    employee_name VARCHAR(50),
    manager_id INT NULL,
    store_id INT,
    FOREIGN KEY (manager_id) REFERENCES Employees(employee_id),
    FOREIGN KEY (store_id) REFERENCES Stores(store_id)
);

CREATE TABLE Returns (
    return_id INT PRIMARY KEY,
    order_id INT,
    customer_id INT,
    product_id INT,
    store_id INT,
    employee_id INT,
    return_date DATE
);

CREATE TABLE Refunds (
    refund_id INT PRIMARY KEY,
    return_id INT,
    refund_amount DECIMAL(10,2),
    refund_date DATE
);

--insert records into table
INSERT INTO Customers VALUES
(1,'Arun'),(2,'Bala'),(3,'Kiran'),
(4,'Deepak'),(5,'Ravi'),(6,'Manoj');
INSERT INTO Products VALUES
(101,'Laptop','Electronics'),
(102,'Mobile','Electronics'),
(103,'Shoes','Fashion'),
(104,'Watch','Accessories'),
(105,'Headphones','Electronics');
INSERT INTO Stores VALUES
(1,'Chennai Store','South'),
(2,'Coimbatore Store','South'),
(3,'Bangalore Store','South'),
(4,'Mumbai Store','West');
INSERT INTO Employees VALUES
(1,'Raj',NULL,1),
(2,'Kumar',1,1),
(3,'Suresh',1,2),
(4,'Vijay',NULL,3),
(5,'Ajay',4,3),
(6,'Mani',NULL,4);
INSERT INTO Returns VALUES
(1,1001,1,101,1,2,'2026-01-05'),
(2,1002,2,101,1,2,'2026-01-06'),
(3,1003,3,102,2,3,'2026-01-07'),
(4,1004,1,103,2,3,'2026-01-08'),
(5,1005,4,103,3,5,'2026-01-09'),
(6,1006,5,104,3,5,'2026-01-10'),
(7,1007,2,105,1,2,'2026-01-11'),
(8,1008,3,101,2,3,'2026-01-12'),
(9,1009,6,102,4,6,'2026-01-13'),
(10,1010,4,105,4,6,'2026-01-14');
INSERT INTO Refunds VALUES
(1,1,50000,'2026-01-06'),
(2,2,50000,'2026-01-07'),
(3,3,15000,'2026-01-08'),
(4,5,3000,'2026-01-10'),
(5,6,5000,'2026-01-11'),
(6,7,2000,'2026-01-12'),
(7,9,15000,'2026-01-14');

--Task - 1 : Ten advanced queries
--Products with return rate above 10%
SELECT p.product_name,
       COUNT(r.return_id) * 100.0 / 50 AS return_rate
FROM Products p
JOIN Returns r ON p.product_id = r.product_id
GROUP BY p.product_name
HAVING COUNT(r.return_id) * 100.0 / 50 > 10;

--Customers who returned products but received no refund
SELECT DISTINCT c.customer_id, c.customer_name
FROM Customers c
JOIN Returns r ON c.customer_id = r.customer_id
WHERE NOT EXISTS (
    SELECT 1 FROM Refunds f
    WHERE f.return_id = r.return_id
);

--Stores with the highest total refund value
SELECT TOP 1 WITH TIES s.store_name,
       SUM(f.refund_amount) AS total_refund
FROM Stores s
JOIN Returns r ON s.store_id = r.store_id
JOIN Refunds f ON r.return_id = f.return_id
GROUP BY s.store_name
ORDER BY total_refund DESC;

--Display employees and their managers
SELECT e.employee_name AS employee,
       m.employee_name AS manager
FROM Employees e
LEFT JOIN Employees m ON e.manager_id = m.employee_id;

--Find customers who returned more than one product
SELECT c.customer_name, COUNT(r.return_id) AS total_returns
FROM Customers c
JOIN Returns r ON c.customer_id = r.customer_id
GROUP BY c.customer_name
HAVING COUNT(r.return_id) > 1;

--Find products that have never been returned
SELECT product_name
FROM Products
WHERE product_id NOT IN (
    SELECT product_id FROM Returns
    WHERE product_id IS NOT NULL
);

--Find products that have never been returned
SELECT product_name
FROM Products
WHERE product_id NOT IN (
    SELECT product_id FROM Returns
    WHERE product_id IS NOT NULL
);

--Find stores whose refund value is above the average store refund value
SELECT s.store_name, SUM(f.refund_amount) AS total_refund
FROM Stores s
JOIN Returns r ON s.store_id = r.store_id
JOIN Refunds f ON r.return_id = f.return_id
GROUP BY s.store_id, s.store_name
HAVING SUM(f.refund_amount) > (
    SELECT AVG(total_refund)
    FROM (
        SELECT SUM(f2.refund_amount) AS total_refund
        FROM Returns r2
        JOIN Refunds f2 ON r2.return_id = f2.return_id
        GROUP BY r2.store_id
    ) x
);

--Find products with refund amounts greater than the average refund amount
SELECT p.product_name, SUM(f.refund_amount) AS total_refund
FROM Products p
JOIN Returns r ON p.product_id = r.product_id
JOIN Refunds f ON r.return_id = f.return_id
GROUP BY p.product_id, p.product_name
HAVING SUM(f.refund_amount) > (
    SELECT AVG(refund_amount) FROM Refunds
);

--Task 2 – IN, NOT IN, NULL pitfall and NOT EXISTS
SELECT * FROM Customers
WHERE customer_id IN (
    SELECT customer_id FROM Returns
);


SELECT * FROM Customers
WHERE customer_id NOT IN (
    SELECT customer_id FROM Returns
);

SELECT * FROM Customers c
WHERE NOT EXISTS (
    SELECT 1 FROM Returns r
    WHERE r.customer_id = c.customer_id
);

--Task 3 – ANY and ALL operators
SELECT s.store_name, SUM(f.refund_amount) AS total_refund
FROM Stores s
JOIN Returns r ON s.store_id = r.store_id
JOIN Refunds f ON r.return_id = f.return_id
GROUP BY s.store_id, s.store_name, s.region
HAVING SUM(f.refund_amount) > ANY (
    SELECT SUM(f2.refund_amount)
    FROM Stores s2
    JOIN Returns r2 ON s2.store_id = r2.store_id
    JOIN Refunds f2 ON r2.return_id = f2.return_id
    WHERE s2.region = s.region
      AND s2.store_id <> s.store_id
    GROUP BY s2.store_id
);

SELECT s.store_name, SUM(f.refund_amount) AS total_refund
FROM Stores s
JOIN Returns r ON s.store_id = r.store_id
JOIN Refunds f ON r.return_id = f.return_id
GROUP BY s.store_id, s.store_name, s.region
HAVING SUM(f.refund_amount) > ALL (
    SELECT SUM(f2.refund_amount)
    FROM Stores s2
    JOIN Returns r2 ON s2.store_id = r2.store_id
    JOIN Refunds f2 ON r2.return_id = f2.return_id
    WHERE s2.region = s.region
      AND s2.store_id <> s.store_id
    GROUP BY s2.store_id
);

--Task 4 – Two nested subqueries with execution results
--Find customers whose total refund is greater than the average customer refund.
SELECT customer_name
FROM Customers
WHERE customer_id IN (
    SELECT r.customer_id
    FROM Returns r
    JOIN Refunds f ON r.return_id = f.return_id
    GROUP BY r.customer_id
    HAVING SUM(f.refund_amount) > (
        SELECT AVG(total_refund)
        FROM (
            SELECT SUM(f2.refund_amount) AS total_refund
            FROM Returns r2
            JOIN Refunds f2 ON r2.return_id = f2.return_id
            GROUP BY r2.customer_id
        ) x
    )
);

--Find products whose return count is greater than the average product return count
SELECT product_name
FROM Products
WHERE product_id IN (
    SELECT product_id
    FROM Returns
    GROUP BY product_id
    HAVING COUNT(*) > (
        SELECT AVG(return_count)
        FROM (
            SELECT COUNT(*) AS return_count
            FROM Returns
            GROUP BY product_id
        ) x
    )
);
