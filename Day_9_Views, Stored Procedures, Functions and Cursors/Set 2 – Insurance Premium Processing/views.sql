-- Task 1 – Create vw_policy_due view


CREATE VIEW vw_policy_due
AS
SELECT
    p.PolicyID,
    c.CustomerID,
    c.CustomerName,
    c.Email,
    c.Phone,
    p.Premium,
    p.DueDate,
    p.PolicyStatus
FROM Policies p
JOIN Customers c
ON p.CustomerID = c.CustomerID
WHERE p.DueDate BETWEEN CAST(GETDATE() AS DATE)
                    AND DATEADD(DAY, 30, CAST(GETDATE() AS DATE));
go

SELECT * FROM vw_policy_due;