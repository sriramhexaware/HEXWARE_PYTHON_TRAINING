--Task 4 – Monthly Statement Using CTE, ROW_NUMBER() and LAG()

CREATE TABLE Transactions (
    TransactionID INT PRIMARY KEY,
    AccountID INT,
    TransactionDate DATE,
    Amount DECIMAL(12,2),
    TransactionType VARCHAR(10),
    Balance DECIMAL(12,2)
);

INSERT INTO Transactions VALUES
(1, 101, '2026-11-01', 2000, 'CREDIT', 10000),
(2, 101, '2026-11-05', 1000, 'DEBIT', 9000),
(3, 101, '2026-11-10', 3000, 'CREDIT', 12000),
(4, 101, '2026-11-15', 2000, 'DEBIT', 10000),
(5, 101, '2026-11-20', 1500, 'DEBIT', 8500);

WITH MonthlyStatement AS (
    SELECT
        TransactionID,
        AccountID,
        TransactionDate,
        Amount,
        TransactionType,
        Balance,
        ROW_NUMBER() OVER (
            PARTITION BY AccountID
            ORDER BY TransactionDate, TransactionID
        ) AS RowNum,
        LAG(Balance) OVER (
            PARTITION BY AccountID
            ORDER BY TransactionDate, TransactionID
        ) AS PreviousBalance
    FROM Transactions
    WHERE TransactionDate >= '2026-11-01'
      AND TransactionDate < '2026-12-01'
)
SELECT *
FROM MonthlyStatement
ORDER BY AccountID, RowNum;