-- Task 2 – Create usp_Recharge procedure

-- Create stored procedure


CREATE PROCEDURE usp_Recharge
    @SubscriberID INT,
    @PlanID INT,
    @Amount DECIMAL(10,2),
    @NewBalance DECIMAL(10,2) OUTPUT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        IF @Amount <= 0
            THROW 50001, 'Invalid recharge amount', 1;

        IF NOT EXISTS (
            SELECT 1 FROM RechargePlans
            WHERE PlanID = @PlanID
              AND Amount = @Amount
        )
            THROW 50002, 'Invalid recharge plan', 1;

        IF NOT EXISTS (
            SELECT 1 FROM Subscribers
            WHERE SubscriberID = @SubscriberID
              AND SubscriberType = 'Prepaid'
        )
            THROW 50003, 'Invalid prepaid subscriber', 1;

        UPDATE Subscribers
        SET Balance = Balance + @Amount,
            ValidityEndDate = DATEADD(
                DAY,
                (SELECT ValidityDays FROM RechargePlans
                 WHERE PlanID = @PlanID),
                CASE
                    WHEN ValidityEndDate < CAST(GETDATE() AS DATE)
                    THEN CAST(GETDATE() AS DATE)
                    ELSE ValidityEndDate
                END
            )
        WHERE SubscriberID = @SubscriberID;

        SELECT @NewBalance = Balance
        FROM Subscribers
        WHERE SubscriberID = @SubscriberID;

        INSERT INTO RechargeHistory
        (SubscriberID, PlanID, Amount)
        VALUES
        (@SubscriberID, @PlanID, @Amount);

        COMMIT TRANSACTION;

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH
END;
go

-- Execute and test
-- Test 1 – Successful recharge

DECLARE @Balance DECIMAL(10,2);

EXEC usp_Recharge
    @SubscriberID = 1,
    @PlanID = 101,
    @Amount = 50,
    @NewBalance = @Balance OUTPUT;

SELECT @Balance AS NewBalance;

-- Test 2 – Invalid recharge amount

DECLARE @Balance DECIMAL(10,2);

EXEC usp_Recharge
    @SubscriberID = 1,
    @PlanID = 101,
    @Amount = -50,
    @NewBalance = @Balance OUTPUT;

-- Test 3 – Verify recharge history

SELECT * FROM RechargeHistory;

-- Task 3 – Create SQL Server Functions
-- Scalar function

CREATE FUNCTION fn_ValidityDaysLeft
(
    @SubscriberID INT
)
RETURNS INT
AS
BEGIN
    DECLARE @Days INT;

    SELECT @Days = DATEDIFF(
        DAY, CAST(GETDATE() AS DATE), ValidityEndDate
    )
    FROM Subscribers
    WHERE SubscriberID = @SubscriberID;

    RETURN ISNULL(@Days, 0);
END;

SELECT dbo.fn_ValidityDaysLeft(1) AS DaysLeft;

-- Table-valued function


CREATE FUNCTION fn_LastFiveRecharges
(
    @SubscriberID INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT TOP 5
        RechargeID,
        SubscriberID,
        PlanID,
        Amount,
        RechargeDate
    FROM RechargeHistory
    WHERE SubscriberID = @SubscriberID
    ORDER BY RechargeDate DESC, RechargeID DESC
);

SELECT * FROM dbo.fn_LastFiveRecharges(1);


