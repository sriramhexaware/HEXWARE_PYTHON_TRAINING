-- Task 2 – Create usp_RenewPolicy procedure


CREATE PROCEDURE usp_RenewPolicy
    @PolicyID INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        DECLARE @OldPremium DECIMAL(10,2),
                @NewPremium DECIMAL(10,2),
                @NoClaimYears INT;

        SELECT @OldPremium = Premium,
               @NoClaimYears = NoClaimYears
        FROM Policies
        WHERE PolicyID = @PolicyID
          AND PolicyStatus = 'Active';

        IF @OldPremium IS NULL
            THROW 50001, 'Policy is not active or does not exist', 1;

        IF EXISTS (
            SELECT 1 FROM Claims
            WHERE PolicyID = @PolicyID
              AND ClaimStatus = 'Pending'
        )
            THROW 50002, 'Policy has pending claims', 1;

        SET @NewPremium = @OldPremium *
            CASE WHEN @NoClaimYears >= 3 THEN 0.90 ELSE 1 END;

        UPDATE Policies
        SET Premium = @NewPremium,
            DueDate = DATEADD(YEAR, 1, DueDate)
        WHERE PolicyID = @PolicyID;

        INSERT INTO PolicyRenewalAudit
        (PolicyID, OldPremium, NewPremium)
        VALUES
        (@PolicyID, @OldPremium, @NewPremium);

        COMMIT TRANSACTION;

        PRINT 'Policy renewed successfully';

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH
END;

-- Test 1 – Successful renewal

EXEC usp_RenewPolicy @PolicyID = 1001;


-- Test 2 – Renewal blocked due to pending claim

EXEC usp_RenewPolicy @PolicyID = 1002;

SELECT * FROM PolicyRenewalAudit;

-- Task 3 – Create Premium Functions

-- Scalar function – fn_PremiumWithNoClaimDiscount


CREATE FUNCTION fn_PremiumWithNoClaimDiscount
(
    @Premium DECIMAL(10,2),
    @NoClaimYears INT
)
RETURNS DECIMAL(10,2)
AS
BEGIN
    RETURN CASE
        WHEN @NoClaimYears >= 3 THEN @Premium * 0.90
        ELSE @Premium
    END;
END;

SELECT dbo.fn_PremiumWithNoClaimDiscount(10000, 3) AS NewPremium;

-- Table-valued function – Agent Renewal Quotes


CREATE FUNCTION fn_AgentRenewalQuotes
(
    @AgentID INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT
        PolicyID,
        CustomerID,
        Premium AS CurrentPremium,
        dbo.fn_PremiumWithNoClaimDiscount(
            Premium, NoClaimYears
        ) AS RenewalPremium,
        DueDate
    FROM Policies
    WHERE AgentID = @AgentID
      AND PolicyStatus = 'Active'
);

SELECT * FROM dbo.fn_AgentRenewalQuotes(101);

