-- Task 1 – Create SQL Server Views

-- Create vw_prepaid_subscribers to display only prepaid subscribers

CREATE VIEW vw_prepaid_subscribers
AS
SELECT
    SubscriberID,
    SubscriberName,
    Phone,
    Balance,
    ValidityEndDate
FROM Subscribers
WHERE SubscriberType = 'Prepaid';
go

SELECT * FROM vw_prepaid_subscribers;

-- Create vw_recharge_summary to display recharge details

CREATE VIEW vw_recharge_summary
AS
SELECT
    s.SubscriberID,
    s.SubscriberName,
    COUNT(r.RechargeID) AS TotalRecharges,
    SUM(r.Amount) AS TotalAmount,
    MAX(r.RechargeDate) AS LastRechargeDate
FROM Subscribers s
LEFT JOIN RechargeHistory r
ON s.SubscriberID = r.SubscriberID
WHERE s.SubscriberType = 'Prepaid'
GROUP BY s.SubscriberID, s.SubscriberName;
go

SELECT * FROM vw_recharge_summary;

-- Verify postpaid-user hiding

SELECT * FROM vw_prepaid_subscribers
WHERE SubscriberType = 'Postpaid';