-- Task 3 – Batch Update Testing and Evidence
-- Prepare the test data

UPDATE accounts
SET balance =
    CASE
        WHEN account_id = 101 THEN 10000
        WHEN account_id = 102 THEN 15000
        WHEN account_id = 103 THEN 20000
        WHEN account_id = 104 THEN 25000
        WHEN account_id = 105 THEN 12000
    END
WHERE account_id BETWEEN 101 AND 105;

SELECT *
FROM accounts
ORDER BY account_id;

-- Test 1 – Successful batch update

UPDATE vw_accounts
SET balance =
    CASE
        WHEN account_id = 101 THEN 11000
        WHEN account_id = 102 THEN 16000
        WHEN account_id = 103 THEN 21000
        WHEN account_id = 104 THEN 26000
        WHEN account_id = 105 THEN 13000
    END
WHERE account_id BETWEEN 101 AND 105;

SELECT *
FROM accounts
ORDER BY account_id;

--Test 2 – Batch update with one invalid account
BEGIN TRY

    UPDATE vw_accounts
    SET balance =
        CASE
            WHEN account_id = 101 THEN 12000
            WHEN account_id = 102 THEN -500
            WHEN account_id = 103 THEN 22000
            WHEN account_id = 104 THEN 27000
            WHEN account_id = 105 THEN 14000
        END
    WHERE account_id BETWEEN 101 AND 105;

    PRINT 'Batch update completed successfully';

END TRY

BEGIN CATCH

    PRINT 'Batch update rejected';

    SELECT
        ERROR_NUMBER() AS ErrorNumber,
        ERROR_MESSAGE() AS ErrorMessage;

END CATCH;

-- Verify the outcome
SELECT
    account_id,
    account_holder,
    account_type,
    balance
FROM accounts
ORDER BY account_id

-- Task 4 – Nested and Recursive Triggers

-- Create demonstration tables
CREATE TABLE trigger_demo_A
(
    id INT PRIMARY KEY,
    value INT
);

CREATE TABLE trigger_demo_B
(
    id INT PRIMARY KEY,
    value INT
);

CREATE TABLE trigger_demo_log
(
    log_id INT IDENTITY(1,1) PRIMARY KEY,
    message VARCHAR(200),
    created_at DATETIME DEFAULT GETDATE()
);

INSERT INTO trigger_demo_A VALUES (1, 10);
INSERT INTO trigger_demo_B VALUES (1, 10);

-- Create Trigger A
CREATE TRIGGER trg_demo_A
ON trigger_demo_A
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE b
    SET b.value = i.value
    FROM trigger_demo_B b
    INNER JOIN inserted i
        ON b.id = i.id;
END;

-- Create Trigger B

CREATE TRIGGER trg_demo_B
ON trigger_demo_B
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO trigger_demo_log(message)
    VALUES ('Trigger B executed after Table B was updated');
END;

-- Test nested execution

UPDATE trigger_demo_A
SET value = 50
WHERE id = 1;

SELECT * FROM trigger_demo_A;
SELECT * FROM trigger_demo_B;
SELECT * FROM trigger_demo_log;

-- Recursive Triggers
-- Enable recursive triggers

ALTER DATABASE CURRENT
SET RECURSIVE_TRIGGERS ON;

-- Create a demonstration table

CREATE TABLE trigger_recursive_demo
(
    id INT PRIMARY KEY,
    value INT
);

INSERT INTO trigger_recursive_demo
VALUES (1, 0);

-- Create a recursive trigger

CREATE TRIGGER trg_recursive_demo
ON trigger_recursive_demo
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF TRIGGER_NESTLEVEL() > 3
        RETURN;

    UPDATE t
    SET value = value + 1
    FROM trigger_recursive_demo t
    INNER JOIN inserted i
        ON t.id = i.id
    WHERE t.value < 3;
END;

UPDATE trigger_recursive_demo
SET value = 1
WHERE id = 1;

SELECT * FROM trigger_recursive_demo;

-- How to Prevent Trigger Loops

-- Method 1 – Use TRIGGER_NESTLEVEL()

IF TRIGGER_NESTLEVEL() > 1
    RETURN;

-- Method 2 – Use a condition before updating

UPDATE t
SET value = i.value
FROM trigger_demo_B t
INNER JOIN inserted i
    ON t.id = i.id
WHERE t.value <> i.value;

-- Method 3 – Disable recursive triggers when not required

ALTER DATABASE CURRENT
SET RECURSIVE_TRIGGERS OFF;

--  Check Trigger Configuration

SELECT
    name,
    is_recursive_triggers_on
FROM sys.databases
WHERE database_id = DB_ID();

EXEC sp_configure 'nested triggers';