use bank;
CREATE TABLE Accounts (
    AccountID INT PRIMARY KEY,
    Balance DECIMAL(12,2),
    Status VARCHAR(20)
);

INSERT INTO Accounts VALUES
(101, 10000, 'ACTIVE'),
(102, 5000, 'ACTIVE'),
(103, 2000, 'INACTIVE');

--Task 1 – Atomic Funds Transfer

DECLARE @FromAccount INT = 101,
        @ToAccount INT = 102,
        @Amount DECIMAL(12,2) = 2000,
        @Balance DECIMAL(12,2),
        @Status VARCHAR(20);

BEGIN TRY
    BEGIN TRAN;

    IF @Amount <= 0 OR @FromAccount = @ToAccount
        THROW 50001, 'Invalid transfer details', 1;

    SELECT @Balance = Balance, @Status = Status
    FROM Accounts WITH (UPDLOCK, HOLDLOCK)
    WHERE AccountID = @FromAccount;

    IF @Balance IS NULL OR @Status <> 'ACTIVE'
        THROW 50002, 'Invalid source account', 1;
    IF @Balance < @Amount
        THROW 50003, 'Insufficient balance', 1;

    SELECT @Status = Status
    FROM Accounts WITH (UPDLOCK, HOLDLOCK)
    WHERE AccountID = @ToAccount;

    IF @Status IS NULL OR @Status <> 'ACTIVE'
        THROW 50004, 'Invalid destination account', 1;

    UPDATE Accounts
    SET Balance = Balance - @Amount
    WHERE AccountID = @FromAccount;

    UPDATE Accounts
    SET Balance = Balance + @Amount
    WHERE AccountID = @ToAccount;

    COMMIT TRAN;
    PRINT 'Transfer completed successfully';
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0
        ROLLBACK TRAN;
    THROW;
END CATCH;

SELECT * FROM Accounts;

--Task 2 – Deliberate Failure and Rollback Evidence

DECLARE @FromAccount INT = 101,
        @ToAccount INT = 102,
        @Amount DECIMAL(12,2) = 1000;

BEGIN TRY
    BEGIN TRAN;

    UPDATE Accounts
    SET Balance = Balance - @Amount
    WHERE AccountID = @FromAccount;

    PRINT 'Amount debited successfully';

    THROW 50005, 'Simulated transfer failure', 1;

    UPDATE Accounts
    SET Balance = Balance + @Amount
    WHERE AccountID = @ToAccount;

    COMMIT TRAN;
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0
        ROLLBACK TRAN;
    PRINT 'Transaction rolled back';
    PRINT ERROR_MESSAGE();
END CATCH;

SELECT AccountID, Balance
FROM Accounts
WHERE AccountID IN (101, 102);

--Task 3 – SAVEPOINT for Fee Rollback

CREATE TABLE TransactionFees (
    FeeID INT IDENTITY(1,1) PRIMARY KEY,
    AccountID INT,
    FeeAmount DECIMAL(10,2)
);

DECLARE @FromAccount INT = 101,
        @ToAccount INT = 102,
        @Amount DECIMAL(12,2) = 1000;

BEGIN TRY
    BEGIN TRAN;

    UPDATE Accounts
    SET Balance = Balance - @Amount
    WHERE AccountID = @FromAccount;

    UPDATE Accounts
    SET Balance = Balance + @Amount
    WHERE AccountID = @ToAccount;

    PRINT 'Transfer completed';

    SAVE TRAN FeeSave;

    BEGIN TRY

        INSERT INTO TransactionFees (AccountID, FeeAmount)
        VALUES (@FromAccount, 50);

        THROW 50006, 'Fee posting failed', 1;

    END TRY
    BEGIN CATCH

        IF XACT_STATE() = 1
            ROLLBACK TRAN FeeSave;

        PRINT 'Fee posting rolled back';
    END CATCH;
    COMMIT TRAN;
    PRINT 'Transfer committed successfully';
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0
        ROLLBACK TRAN;
    THROW;
END CATCH;

SELECT * FROM TransactionFees;