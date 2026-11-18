--create database and tables

USE BankLoanDB;

CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    city VARCHAR(50)
);

CREATE TABLE Branches (
    branch_id INT PRIMARY KEY,
    branch_name VARCHAR(100) NOT NULL,
    location VARCHAR(100)
);

CREATE TABLE Loans (
    loan_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    branch_id INT NOT NULL,
    loan_amount DECIMAL(12,2) NOT NULL,
    loan_date DATE NOT NULL,

    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (branch_id) REFERENCES Branches(branch_id),

    CHECK (loan_amount > 0)
);

CREATE TABLE Repayments (
    repayment_id INT PRIMARY KEY,
    loan_id INT NOT NULL,
    installment_no INT NOT NULL,
    due_date DATE NOT NULL,
    repayment_date DATE NULL,
    amount DECIMAL(10,2) NOT NULL,

    FOREIGN KEY (loan_id) REFERENCES Loans(loan_id),
    CHECK (amount > 0),
    UNIQUE (loan_id, installment_no)
);

CREATE TABLE LoanGuarantors (
    loan_id INT NOT NULL,
    guarantor_customer_id INT NOT NULL,

    PRIMARY KEY (loan_id, guarantor_customer_id),

    FOREIGN KEY (loan_id) REFERENCES Loans(loan_id),
    FOREIGN KEY (guarantor_customer_id) REFERENCES Customers(customer_id)
);

--insert records
INSERT INTO Customers VALUES
(101, 'Arun', 'arun@gmail.com', 'Chennai'),
(102, 'Kiran', 'kiran@gmail.com', 'Coimbatore'),
(103, 'Priya', 'priya@gmail.com', 'Bangalore'),
(104, 'Rahul', 'rahul@gmail.com', 'Hyderabad'),
(105, 'Divya', 'divya@gmail.com', 'Mumbai');
INSERT INTO Branches VALUES
(1, 'Chennai Main Branch', 'Chennai'),
(2, 'Coimbatore Branch', 'Coimbatore'),
(3, 'Bangalore Branch', 'Bangalore'),
(4, 'Hyderabad Branch', 'Hyderabad'),
(5, 'Mumbai Branch', 'Mumbai');
INSERT INTO Loans VALUES
(1001, 101, 1, 500000, '2026-01-10'),
(1002, 102, 2, 800000, '2026-02-15'),
(1003, 103, 3, 300000, '2026-03-20'),
(1004, 101, 2, 400000, '2026-04-05'),
(1005, 104, 4, 1000000, '2026-05-12');
INSERT INTO Repayments VALUES
(1, 1001, 1, '2026-11-01', '2026-11-10', 15000),
(2, 1002, 1, '2026-06-01', NULL, 20000),
(3, 1002, 2, '2026-07-01', NULL, 20000),
(4, 1002, 3, '2026-08-01', NULL, 20000),
(5, 1002, 4, '2026-09-01', NULL, 20000);
INSERT INTO LoanGuarantors VALUES
(1001, 102),
(1002, 103),
(1003, 104),
(1004, 105),
(1005, 101);

--TEN Queries
--Customers with loans in more than one branch
SELECT c.customer_name
FROM Customers c
JOIN Loans l ON c.customer_id = l.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING COUNT(DISTINCT l.branch_id) > 1;

--Find guarantors who are also borrowers (SELF JOIN)
SELECT DISTINCT c.customer_name
FROM LoanGuarantors g
JOIN Loans l ON g.guarantor_customer_id = l.customer_id
JOIN Customers c ON c.customer_id = g.guarantor_customer_id;

--Loans overdue by more than three instalments
SELECT loan_id, COUNT(*) AS overdue_installments
FROM Repayments
WHERE due_date < CAST(GETDATE() AS DATE)
AND repayment_date IS NULL
GROUP BY loan_id
HAVING COUNT(*) > 3;

--Branches with no loans (LEFT JOIN)
SELECT b.branch_name
FROM Branches b
LEFT JOIN Loans l ON b.branch_id = l.branch_id
WHERE l.loan_id IS NULL;

--Display loan details with customer and branch names
SELECT l.loan_id, c.customer_name, b.branch_name, l.loan_amount
FROM Loans l
JOIN Customers c ON l.customer_id = c.customer_id
JOIN Branches b ON l.branch_id = b.branch_id;

--Customers who have not taken any loans
SELECT c.customer_name
FROM Customers c
LEFT JOIN Loans l ON c.customer_id = l.customer_id
WHERE l.loan_id IS NULL;

--Find total loan amount for each customer
SELECT c.customer_name, SUM(l.loan_amount) AS total_loan
FROM Customers c
JOIN Loans l ON c.customer_id = l.customer_id
GROUP BY c.customer_name;

--Find total repayment amount for each loan
SELECT loan_id, SUM(amount) AS total_repayment
FROM Repayments
WHERE repayment_date IS NOT NULL
GROUP BY loan_id;

--Count loans in each branch, including branches with zero loans
SELECT b.branch_name, COUNT(l.loan_id) AS loan_count
FROM Branches b
LEFT JOIN Loans l ON b.branch_id = l.branch_id
GROUP BY b.branch_name;

--Display loans with their repayment details
SELECT l.loan_id, r.installment_no, r.amount,
       r.due_date, r.repayment_date
FROM Loans l
LEFT JOIN Repayments r ON l.loan_id = r.loan_id;

--Task 2: Correlated and uncorrelated subqueries
--Find customers whose total loan exposure exceeds their branch average.
--Uncorrelated subquery
SELECT customer_id, SUM(loan_amount) AS total_exposure
FROM Loans
GROUP BY customer_id
HAVING SUM(loan_amount) >
(
    SELECT AVG(loan_amount) FROM Loans
);
--Correlated subquery
SELECT c.customer_name, SUM(l.loan_amount) AS total_exposure
FROM Customers c
JOIN Loans l ON c.customer_id = l.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING SUM(l.loan_amount) >
(
    SELECT AVG(l2.loan_amount)
    FROM Loans l2
    WHERE l2.branch_id = l.branch_id
);

--Task 3 – EXISTS and NOT EXISTS
--Find customers who have at least one loan but no repayment in the last 60 day
SELECT c.customer_name
FROM Customers c
WHERE EXISTS (
    SELECT 1 FROM Loans l
    WHERE l.customer_id = c.customer_id
)
AND NOT EXISTS (
    SELECT 1
    FROM Loans l
    JOIN Repayments r ON l.loan_id = r.loan_id
    WHERE l.customer_id = c.customer_id
      AND r.repayment_date >= DATEADD(DAY, -60, GETDATE())
      AND r.repayment_date <= GETDATE()
);

--Task 4: Nested subquery
--Find branches whose highest loan is greater than the bank-wide average of branch maximums
SELECT b.branch_name, MAX(l.loan_amount) AS highest_loan
FROM Branches b
JOIN Loans l ON b.branch_id = l.branch_id
GROUP BY b.branch_id, b.branch_name
HAVING MAX(l.loan_amount) >
(
    SELECT AVG(branch_max)
    FROM (
        SELECT MAX(loan_amount) AS branch_max
        FROM Loans
        GROUP BY branch_id
    ) x
);