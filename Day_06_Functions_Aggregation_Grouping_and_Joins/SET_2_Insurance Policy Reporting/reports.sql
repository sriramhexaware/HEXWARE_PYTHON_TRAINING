--create database and tables
CREATE DATABASE Hexaware;

USE Hexaware;

CREATE TABLE Customers (
    Customer_ID INT PRIMARY KEY,
    Customer_Name VARCHAR(100),
    DOB DATE,
    City VARCHAR(50)
);

CREATE TABLE Products (
    Product_ID INT PRIMARY KEY,
    Product_Name VARCHAR(100)
);

CREATE TABLE Agents (
    Agent_ID INT PRIMARY KEY,
    Agent_Name VARCHAR(100)
);

CREATE TABLE Policies (
    Policy_ID INT PRIMARY KEY,
    Policy_Number VARCHAR(30),
    Customer_ID INT,
    Product_ID INT,
    Agent_ID INT,
    Start_Date DATE,
    Expiry_Date DATE,
    Policy_Status VARCHAR(20)
);

CREATE TABLE Premiums (
    Premium_ID INT PRIMARY KEY,
    Policy_ID INT,
    Premium_Amount DECIMAL(10,2),
    Payment_Date DATE,
    Payment_Status VARCHAR(20)
);

CREATE TABLE Claims (
    Claim_ID INT PRIMARY KEY,
    Policy_ID INT,
    Claim_Amount DECIMAL(10,2),
    Claim_Date DATE,
    Settlement_Date DATE,
    Claim_Status VARCHAR(20),
    Damage_Category VARCHAR(50)
);

--insert into values
INSERT INTO Customers
(Customer_ID, Customer_Name, DOB, City)
VALUES
(1, 'Arun Kumar', '1998-05-12', 'Chennai'),
(2, 'Priya Sharma', '1985-08-20', 'Coimbatore'),
(3, 'Rahul Verma', '1978-03-15', 'Madurai'),
(4, 'Divya Raj', '1964-11-25', 'Chennai'),
(5, 'Karthik S', '1995-06-10', 'Bangalore'),
(6, 'Meena R', '1971-09-05', 'Coimbatore'),
(7, 'Vijay Kumar', '1990-02-18', 'Trichy'),
(8, 'Sneha R', '2000-12-30', 'Chennai');

INSERT INTO Products
(Product_ID, Product_Name)
VALUES
(1, 'Life Insurance'),
(2, 'Health Insurance'),
(3, 'Motor Insurance'),
(4, 'Home Insurance');

INSERT INTO Agents
(Agent_ID, Agent_Name)
VALUES
(1, 'Ramesh'),
(2, 'Suresh'),
(3, 'Kavitha'),
(4, 'Anand'),
(5, 'Priya');

INSERT INTO Policies
(Policy_ID, Policy_Number, Customer_ID, Product_ID, Agent_ID,
 Start_Date, Expiry_Date, Policy_Status)
VALUES
(1, 'POL1001', 1, 1, 1, '2025-12-01', '2026-12-01', 'Active'),
(2, 'POL1002', 1, 2, 2, '2026-03-01', '2027-03-01', 'Active'),
(3, 'POL1003', 2, 2, 1, '2025-06-15', '2026-06-15', 'Expired'),
(4, 'POL1004', 2, 3, 3, '2026-01-10', '2027-01-10', 'Active'),
(5, 'POL1005', 3, 1, 2, '2026-02-01', '2027-02-01', 'Active'),
(6, 'POL1006', 4, 4, 4, '2025-11-20', '2026-11-25', 'Active'),
(7, 'POL1007', 5, 3, 3, '2026-04-01', '2027-04-01', 'Active'),
(8, 'POL1008', 6, 2, 1, '2026-05-01', '2027-05-01', 'Active'),
(9, 'POL1009', 7, 1, 5, '2026-01-15', '2026-12-05', 'Active'),
(10, 'POL1010', 8, 4, 2, '2026-06-01', '2027-06-01', 'Active'),
(11, 'POL1011', 3, 2, 1, '2025-10-01', '2026-11-30', 'Active'),
(12, 'POL1012', 5, 1, 5, '2025-08-01', '2026-08-01', 'Expired');

--Check policy status counts

SELECT
    Policy_Status,
    COUNT(*) AS Total_Policies
FROM Policies
GROUP BY Policy_Status;

INSERT INTO Premiums
(Premium_ID, Policy_ID, Premium_Amount, Payment_Date, Payment_Status)
VALUES
(1, 1, 15000, '2026-01-01', 'Paid'),
(2, 1, 15000, '2026-11-01', 'Paid'),
(3, 2, 12000, '2026-03-01', 'Paid'),
(4, 3, 10000, '2025-06-15', 'Paid'),
(5, 4, 8000, '2026-01-10', 'Paid'),
(6, 5, 20000, '2026-02-01', 'Paid'),
(7, 6, 18000, '2025-11-20', 'Pending'),
(8, 7, 9000, '2026-04-01', 'Paid'),
(9, 8, 11000, '2026-05-01', 'Paid'),
(10, 9, 14000, '2026-01-15', 'Paid'),
(11, 10, 16000, '2026-06-01', 'Paid'),
(12, 11, 7000, '2025-10-01', 'Pending'),
(13, 12, 13000, '2025-08-01', 'Paid'),
(14, 4, 8000, '2026-07-10', 'Paid'),
(15, 5, 20000, '2026-08-01', 'Paid'),
(16, 7, 9000, '2026-10-01', 'Paid');

--Check payment status
SELECT
    Payment_Status,
    COUNT(*) AS Total_Payments,
    SUM(Premium_Amount) AS Total_Amount
FROM Premiums
GROUP BY Payment_Status;

--Check collected premium
SELECT
    SUM(Premium_Amount) AS Total_Premium_Collected
FROM Premiums
WHERE Payment_Status = 'Paid';

INSERT INTO Claims
(Claim_ID, Policy_ID, Claim_Amount, Claim_Date, Settlement_Date, Claim_Status, Damage_Category)
VALUES
(1, 1, 50000, '2026-02-10', '2026-02-20', 'Settled', 'Accidental Damage'),
(2, 2, 25000, '2026-04-15', '2026-04-25', 'Settled', 'Hospitalization'),
(3, 4, 12000, '2026-05-20', '2026-06-05', 'Settled', 'Vehicle Accident'),
(4, 5, 80000, '2026-07-01', '2026-07-20', 'Settled', 'Critical Illness'),
(5, 6, 30000, '2026-11-10', NULL, 'Pending', 'Fire Damage'),
(6, 7, 15000, '2026-08-05', '2026-08-12', 'Approved', 'Vehicle Accident'),
(7, 8, 10000, '2026-09-01', NULL, 'Under Review', 'Hospitalization'),
(8, 9, 45000, '2026-10-10', '2026-10-18', 'Settled', 'Accidental Damage'),
(9, 10, 22000, '2026-10-15', '2026-10-28', 'Settled', 'Fire Damage'),
(10, 11, 18000, '2026-11-01', NULL, 'Pending', 'Hospitalization'),
(11, 3, 9000, '2025-08-10', '2025-08-20', 'Rejected', 'Hospitalization'),
(12, 4, 7000, '2026-07-15', '2026-07-25', 'Settled', 'Vehicle Accident');

--Count claims by status
SELECT
    Claim_Status,
    COUNT(*) AS Total_Claims
FROM Claims
GROUP BY Claim_Status;

--Calculate settlement duration
SELECT
    Claim_ID,
    Claim_Status,
    DATEDIFF(DAY, Claim_Date, Settlement_Date) AS Settlement_Days
FROM Claims
WHERE Settlement_Date IS NOT NULL;

--Policies expiring in the next 30 days
SELECT
    Policy_ID,
    Policy_Number,
    Customer_ID,
    Expiry_Date,
    Policy_Status
FROM Policies
WHERE Expiry_Date BETWEEN CAST(GETDATE() AS DATE)
                      AND DATEADD(DAY, 30, CAST(GETDATE() AS DATE))
ORDER BY Expiry_Date;

--Premium collected per product
SELECT
    pr.Product_Name,
    SUM(pm.Premium_Amount) AS Total_Premium_Collected
FROM Products pr
JOIN Policies po
    ON pr.Product_ID = po.Product_ID
JOIN Premiums pm
    ON po.Policy_ID = pm.Policy_ID
WHERE pm.Payment_Status = 'Paid'
GROUP BY pr.Product_Name
ORDER BY Total_Premium_Collected DESC;

--Customers with more than one active policy
SELECT
    c.Customer_ID,
    c.Customer_Name,
    COUNT(p.Policy_ID) AS Active_Policy_Count
FROM Customers c
JOIN Policies p
    ON c.Customer_ID = p.Customer_ID
WHERE p.Policy_Status = 'Active'
GROUP BY
    c.Customer_ID,
    c.Customer_Name
HAVING COUNT(p.Policy_ID) > 1;

--Policies without claims
SELECT
    p.Policy_ID,
    p.Policy_Number,
    c.Customer_Name,
    pr.Product_Name,
    p.Policy_Status
FROM Policies p
JOIN Customers c
    ON p.Customer_ID = c.Customer_ID
JOIN Products pr
    ON p.Product_ID = pr.Product_ID
LEFT JOIN Claims cl
    ON p.Policy_ID = cl.Policy_ID
WHERE cl.Claim_ID IS NULL;

--Monthly new policies
SELECT
    YEAR(Start_Date) AS Policy_Year,
    MONTH(Start_Date) AS Policy_Month,
    COUNT(*) AS Total_New_Policies
FROM Policies
GROUP BY
    YEAR(Start_Date),
    MONTH(Start_Date)
ORDER BY
    Policy_Year,
    Policy_Month;

--Top 5 agents by premium collected
SELECT TOP 5
    a.Agent_ID,
    a.Agent_Name,
    SUM(pm.Premium_Amount) AS Total_Premium_Collected
FROM Agents a
JOIN Policies p
    ON a.Agent_ID = p.Agent_ID
JOIN Premiums pm
    ON p.Policy_ID = pm.Policy_ID
WHERE pm.Payment_Status = 'Paid'
GROUP BY
    a.Agent_ID,
    a.Agent_Name
ORDER BY
    Total_Premium_Collected DESC;

--Date functions: DATEADD and DATEDIFF

SELECT
    Policy_ID,
    Policy_Number,
    Start_Date,
    Expiry_Date,
    DATEDIFF(DAY, Start_Date, Expiry_Date) AS Policy_Duration_Days
FROM Policies;

SELECT
    Policy_ID,
    Policy_Number,
    Expiry_Date,
    DATEADD(DAY, 30, Expiry_Date) AS Extended_Expiry_Date
FROM Policies;

--LEFT(), RIGHT(), CONCAT() LEN() function

SELECT
    Policy_Number,
    LEFT(Policy_Number, 3) AS First_Three_Characters
FROM Policies;

SELECT
    Policy_Number,
    RIGHT(Policy_Number, 2) AS Last_Two_Characters
FROM Policies;

SELECT
    Policy_Number,
    CONCAT(
        LEFT(Policy_Number, 3),
        '****',
        RIGHT(Policy_Number, 2)
    ) AS Masked_Policy_Number
FROM Policies;

SELECT
    Policy_Number,
    LEN(Policy_Number) AS Policy_Number_Length
FROM Policies;

