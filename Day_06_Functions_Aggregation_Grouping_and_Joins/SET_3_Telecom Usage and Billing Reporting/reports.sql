--create database and table
CREATE DATABASE TelecomDB;

USE TelecomDB;

CREATE TABLE Subscribers (
    Subscriber_ID INT PRIMARY KEY,
    Subscriber_Name VARCHAR(100),
    Circle VARCHAR(50),
    Plan_ID INT
);
CREATE TABLE Plans (
    Plan_ID INT PRIMARY KEY,
    Plan_Name VARCHAR(100),
    Data_Limit_MB INT,
    Monthly_Fee DECIMAL(10,2)
);
CREATE TABLE Call_Records (
    Record_ID INT PRIMARY KEY,
    Subscriber_ID INT,
    Call_Date DATETIME,
    Call_Minutes INT,
    Data_Used_MB DECIMAL(10,2)
);
CREATE TABLE Invoices (
    Invoice_ID INT PRIMARY KEY,
    Subscriber_ID INT,
    Invoice_Number VARCHAR(30),
    Invoice_Date DATE,
    Due_Date DATE,
    Invoice_Amount DECIMAL(10,2),
    Payment_Status VARCHAR(20)
);

--Insert records
INSERT INTO Plans
(Plan_ID, Plan_Name, Data_Limit_MB, Monthly_Fee)
VALUES
(1, 'Basic Plan', 10240, 199),
(2, 'Standard Plan', 20480, 399),
(3, 'Premium Plan', 51200, 599),
(4, 'Unlimited Plan', 102400, 999);

INSERT INTO Subscribers
(Subscriber_ID, Subscriber_Name, Circle, Plan_ID)
VALUES
(1, 'Arun', 'Chennai', 1),
(2, 'Priya', 'Coimbatore', 2),
(3, 'Rahul', 'Madurai', 2),
(4, 'Divya', 'Chennai', 3),
(5, 'Karthik', 'Bangalore', 1),
(6, 'Meena', 'Coimbatore', 4),
(7, 'Vijay', 'Trichy', 3),
(8, 'Sneha', 'Chennai', 2),
(9, 'Ajay', 'Madurai', 1),
(10, 'Nila', 'Trichy', 4);

INSERT INTO Call_Records
(Record_ID, Subscriber_ID, Call_Date, Call_Minutes, Data_Used_MB)
VALUES
(1, 1, '2026-09-05', 45, 3000),
(2, 1, '2026-10-10', 60, 4000),
(3, 2, '2026-09-12', 80, 5000),
(4, 2, '2026-10-15', 65, 6000),
(5, 3, '2026-09-18', 50, 3000),
(6, 3, '2026-10-20', 70, 4000),
(7, 4, '2026-09-08', 120, 30000),
(8, 4, '2026-09-25', 90, 25000),
(9, 4, '2026-10-12', 100, 20000),
(10, 5, '2026-09-14', 35, 2000),
(11, 5, '2026-10-17', 40, 3000),
(12, 6, '2026-09-20', 150, 40000),
(13, 6, '2026-10-22', 130, 30000),
(14, 7, '2026-09-11', 110, 40000),
(15, 7, '2026-10-19', 140, 20000),
(16, 8, '2026-09-16', 55, 7000),
(17, 8, '2026-10-24', 60, 8000);

INSERT INTO Invoices
(Invoice_ID, Subscriber_ID, Invoice_Number, Invoice_Date,
 Due_Date, Invoice_Amount, Payment_Status)
VALUES
(1001, 1, 'tel-1001', '2026-09-01', '2026-09-15', 199, 'Paid'),
(1002, 2, 'tel-1002', '2026-09-01', '2026-09-15', 399, 'Paid'),
(1003, 3, 'tel-1003', '2026-09-01', '2026-09-15', 399, 'Unpaid'),
(1004, 4, 'tel-1004', '2026-09-01', '2026-09-15', 599, 'Paid'),
(1005, 5, 'tel-1005', '2026-09-01', '2026-09-15', 199, 'Unpaid'),
(1006, 6, 'tel-1006', '2026-09-01', '2026-09-15', 999, 'Paid'),
(1007, 7, 'tel-1007', '2026-09-01', '2026-09-15', 599, 'Paid'),
(1008, 8, 'tel-1008', '2026-09-01', '2026-09-15', 399, 'Paid');

--Query 1: Total call minutes per plan
SELECT
    p.Plan_Name,
    SUM(cr.Call_Minutes) AS Total_Call_Minutes
FROM Plans p
INNER JOIN Subscribers s
    ON p.Plan_ID = s.Plan_ID
INNER JOIN Call_Records cr
    ON s.Subscriber_ID = cr.Subscriber_ID
GROUP BY p.Plan_Name;

--Query 2: Subscribers exceeding their data limit
SELECT
    s.Subscriber_Name,
    p.Plan_Name,
    MONTH(cr.Call_Date) AS Usage_Month,
    SUM(cr.Data_Used_MB) AS Total_Data_Used_MB,
    p.Data_Limit_MB
FROM Subscribers s
INNER JOIN Plans p
    ON s.Plan_ID = p.Plan_ID
INNER JOIN Call_Records cr
    ON s.Subscriber_ID = cr.Subscriber_ID
GROUP BY
    s.Subscriber_ID,
    s.Subscriber_Name,
    p.Plan_Name,
    MONTH(cr.Call_Date),
    p.Data_Limit_MB
HAVING SUM(cr.Data_Used_MB) > p.Data_Limit_MB;

--Query 3 – Month-wise revenue
SELECT
    YEAR(Invoice_Date) AS Invoice_Year,
    MONTH(Invoice_Date) AS Invoice_Month,
    SUM(Invoice_Amount) AS Total_Revenue
FROM Invoices
GROUP BY
    YEAR(Invoice_Date),
    MONTH(Invoice_Date)
ORDER BY
    Invoice_Year,
    Invoice_Month;

--Query 4 – Invoices overdue by more than 15 days
SELECT
    Invoice_ID,
    Invoice_Number,
    Subscriber_ID,
    Invoice_Amount,
    Due_Date,
    DATEDIFF(DAY, Due_Date, GETDATE()) AS Days_Overdue
FROM Invoices
WHERE
    Payment_Status = 'Unpaid'
    AND Due_Date < DATEADD(DAY, -15, CAST(GETDATE() AS DATE));

--Query 5 – Subscribers with no usage
SELECT
    s.Subscriber_ID,
    s.Subscriber_Name,
    s.Circle
FROM Subscribers s
LEFT JOIN Call_Records cr
    ON s.Subscriber_ID = cr.Subscriber_ID
WHERE cr.Record_ID IS NULL;

--Query 6 – Average revenue per user (ARPU) by circle
SELECT
    s.Circle,
    SUM(ISNULL(i.Invoice_Amount, 0)) AS Total_Revenue,
    COUNT(DISTINCT s.Subscriber_ID) AS Total_Subscribers,
    CAST(
        SUM(ISNULL(i.Invoice_Amount, 0)) * 1.0 /
        COUNT(DISTINCT s.Subscriber_ID)
        AS DECIMAL(10,2)
    ) AS ARPU
FROM Subscribers s
LEFT JOIN Invoices i
    ON s.Subscriber_ID = i.Subscriber_ID
GROUP BY s.Circle;

--Query 7 – Plan popularity
SELECT
    p.Plan_Name,
    COUNT(s.Subscriber_ID) AS Total_Subscribers
FROM Plans p
LEFT JOIN Subscribers s
    ON p.Plan_ID = s.Plan_ID
GROUP BY p.Plan_ID, p.Plan_Name
ORDER BY Total_Subscribers DESC;

--Query 8 – Top 10 data consumers
SELECT TOP 10
    s.Subscriber_ID,
    s.Subscriber_Name,
    SUM(cr.Data_Used_MB) AS Total_Data_Used_MB,
    CAST(
        SUM(cr.Data_Used_MB) / 1024.0
        AS DECIMAL(10,2)
    ) AS Total_Data_Used_GB
FROM Subscribers s
INNER JOIN Call_Records cr
    ON s.Subscriber_ID = cr.Subscriber_ID
GROUP BY
    s.Subscriber_ID,
    s.Subscriber_Name
ORDER BY Total_Data_Used_MB DESC;

--Format invoice numbers
SELECT
    Invoice_ID,
    UPPER(Invoice_Number) AS Formatted_Invoice_Number,
    CONCAT('TEL-', RIGHT('000000' + CAST(Invoice_ID AS VARCHAR(6)), 6))
        AS Generated_Invoice_Number
FROM Invoices;

--Calculate due-date status
SELECT
    Invoice_Number,
    Due_Date,
    Payment_Status,
    CASE
        WHEN Payment_Status = 'Paid' THEN 'Paid'
        WHEN Due_Date < CAST(GETDATE() AS DATE)
             AND DATEDIFF(DAY, Due_Date, GETDATE()) > 15
            THEN 'Overdue More Than 15 Days'
        WHEN Due_Date < CAST(GETDATE() AS DATE)
            THEN 'Overdue'
        ELSE 'Not Due'
    END AS Due_Date_Status
FROM Invoices;

--Demonstrate NULL with SUM and AVG
SELECT
    s.Subscriber_Name,
    COUNT(cr.Data_Used_MB) AS Usage_Records,
    SUM(cr.Data_Used_MB) AS Total_Data,
    AVG(cr.Data_Used_MB) AS Average_Data
FROM Subscribers s
LEFT JOIN Call_Records cr
    ON s.Subscriber_ID = cr.Subscriber_ID
GROUP BY s.Subscriber_ID, s.Subscriber_Name;