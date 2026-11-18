--Database and table creation
USE Hexaware;

CREATE TABLE Customers (
    Customer_ID INT IDENTITY(1,1) PRIMARY KEY,
    Customer_Name VARCHAR(100) NOT NULL,
    Address VARCHAR(200) NOT NULL
);

CREATE TABLE Branches (
    Branch_ID INT IDENTITY(1,1) PRIMARY KEY,
    Branch_Name VARCHAR(100) NOT NULL,
    Branch_Address VARCHAR(200) NOT NULL
);

CREATE TABLE RelationshipManagers (
    Manager_ID INT IDENTITY(1,1) PRIMARY KEY,
    Manager_Name VARCHAR(100) NOT NULL,
    Branch_ID INT NOT NULL,

    FOREIGN KEY (Branch_ID)
    REFERENCES Branches(Branch_ID)
);

CREATE TABLE AccountTypes (
    Account_Type_ID INT IDENTITY(1,1) PRIMARY KEY,
    Account_Type_Name VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE Accounts (
    Account_ID INT IDENTITY(1,1) PRIMARY KEY,
    Account_Number VARCHAR(20) NOT NULL UNIQUE,
    Customer_ID INT NOT NULL,
    Account_Type_ID INT NOT NULL,
    Branch_ID INT NOT NULL,
    Manager_ID INT NOT NULL,
    Balance DECIMAL(15,2) NOT NULL DEFAULT 0,
    Opened_Date DATE NOT NULL DEFAULT GETDATE(),

    FOREIGN KEY (Customer_ID)
    REFERENCES Customers(Customer_ID),

    FOREIGN KEY (Account_Type_ID)
    REFERENCES AccountTypes(Account_Type_ID),

    FOREIGN KEY (Branch_ID)
    REFERENCES Branches(Branch_ID),

    FOREIGN KEY (Manager_ID)
    REFERENCES RelationshipManagers(Manager_ID)
);

--insert records

INSERT INTO Branches (Branch_Name, Branch_Address)
VALUES
('Chennai Main Branch', 'Anna Salai, Chennai'),
('Coimbatore Branch', 'RS Puram, Coimbatore'),
('Bangalore Branch', 'MG Road, Bangalore');

INSERT INTO Customers (Customer_Name, Address)
VALUES
('Arun Kumar', 'T Nagar, Chennai'),
('Priya Sharma', 'RS Puram, Coimbatore'),
('Rahul Verma', 'Anna Nagar, Chennai'),
('Divya Raj', 'MG Road, Bangalore'),
('Karthik S', 'Peelamedu, Coimbatore');

INSERT INTO RelationshipManagers (Manager_Name, Branch_ID)
VALUES
('Suresh Kumar', 1),
('Anitha Raj', 1),
('Vijay Kumar', 2),
('Meena Sharma', 3);

INSERT INTO AccountTypes (Account_Type_Name)
VALUES
('Savings'),
('Current'),
('Fixed Deposit');

INSERT INTO Accounts
(Account_Number, Customer_ID, Account_Type_ID, Branch_ID, Manager_ID, Balance, Opened_Date)
VALUES
('ACC1001', 1, 1, 1, 1, 75000.00, '2026-07-10'),
('ACC1002', 2, 2, 2, 3, 120000.00, '2026-08-15'),
('ACC1003', 3, 1, 1, 2, 45000.00, '2026-09-20'),
('ACC1004', 4, 3, 3, 4, 200000.00, '2026-06-05'),
('ACC1005', 5, 1, 2, 3, 90000.00, '2026-07-25'),
('ACC1006', 1, 2, 1, 1, 150000.00, '2026-10-12'),
('ACC1007', 2, 1, 2, 3, 30000.00, '2026-08-02'),
('ACC1008', 3, 3, 1, 2, 250000.00, '2026-09-05');

--DQL Commands
SELECT *
FROM Accounts
WHERE Balance > 50000
AND Opened_Date BETWEEN '2026-07-01' AND '2026-09-30';

SELECT *
FROM Accounts
WHERE Account_Type_ID = 1
OR Account_Type_ID = 2;

SELECT *
FROM Accounts
WHERE Branch_ID IN (1, 2, 3);

--DML Command
UPDATE Accounts
SET Balance = 85000
WHERE Account_Number = 'ACC1001';

DELETE FROM Accounts
WHERE Account_Number = 'ACC1008';

--Drop,Truncate,Delete
--Create a demo table

CREATE TABLE AccountTest (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    Account_Name VARCHAR(50)
);

INSERT INTO AccountTest (Account_Name)
VALUES
('Savings'),
('Current'),
('Fixed Deposit');

DELETE FROM AccountTest
WHERE ID = 2;

INSERT INTO AccountTest (Account_Name)
VALUES ('Salary Account');

TRUNCATE TABLE AccountTest;
SELECT * FROM AccountTest;

INSERT INTO AccountTest (Account_Name)
VALUES ('New Savings Account');

DROP TABLE AccountTest;

--Rollback test
--Create a sample table

CREATE TABLE RollbackTest (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    Name VARCHAR(50)
);

INSERT INTO RollbackTest (Name)
VALUES ('Arun'), ('Priya'), ('Rahul');

BEGIN TRANSACTION;

--delete
DELETE FROM RollbackTest
WHERE ID = 1;

SELECT * FROM RollbackTest;

ROLLBACK TRANSACTION;
--truncate
BEGIN TRANSACTION;

TRUNCATE TABLE RollbackTest;

SELECT * FROM RollbackTest;

ROLLBACK TRANSACTION;
--drop
BEGIN TRANSACTION;

DROP TABLE RollbackTest;

ROLLBACK TRANSACTION;
