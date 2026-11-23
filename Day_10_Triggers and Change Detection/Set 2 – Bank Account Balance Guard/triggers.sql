-- Create the AFTER INSERT/UPDATE/DELETE trigger

CREATE TRIGGER trg_transaction_audit
ON account_transaction
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO transaction_audit
    (
        transaction_id,
        account_id,
        old_amount,
        new_amount,
        old_transaction_type,
        new_transaction_type,
        operation_type,
        changed_by,
        changed_at
    )
    SELECT
        COALESCE(i.transaction_id, d.transaction_id),
        COALESCE(i.account_id, d.account_id),

        d.amount,
        i.amount,

        d.transaction_type,
        i.transaction_type,

        CASE
            WHEN d.transaction_id IS NULL THEN 'INSERT'
            WHEN i.transaction_id IS NULL THEN 'DELETE'
            ELSE 'UPDATE'
        END,

        SUSER_SNAME(),
        GETDATE()

    FROM inserted i
    FULL OUTER JOIN deleted d
        ON i.transaction_id = d.transaction_id;

END;

-- Test the trigger
-- Test A – INSERT

INSERT INTO account_transaction
(account_id, transaction_type, amount)
VALUES
(101, 'DEPOSIT', 3000);

SELECT *
FROM transaction_audit;

-- Test B – UPDATE

UPDATE account_transaction
SET amount = 4000
WHERE transaction_id = 1;

SELECT *
FROM transaction_audit;

-- Test C – DELETE

DELETE FROM account_transaction
WHERE transaction_id = 2;

SELECT *
FROM transaction_audit;

-- Test multi-row operations
UPDATE account_transaction
SET amount = amount + 500;

SELECT *
FROM transaction_audit
ORDER BY audit_id;

SELECT
    audit_id,
    transaction_id,
    account_id,
    old_amount,
    new_amount,
    operation_type,
    changed_by,
    changed_at
FROM transaction_audit
ORDER BY audit_id;

-- Task 2 – Prevent Negative Savings Account Balance

CREATE VIEW vw_accounts
AS
SELECT
    account_id,
    account_type,
    balance
FROM accounts;

SELECT *
FROM vw_accounts;

-- Create the INSTEAD OF UPDATE trigger
go
CREATE TRIGGER trg_prevent_negative_balance
ON vw_accounts
INSTEAD OF UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Check whether any savings account
    -- will have a negative balance

    IF EXISTS
    (
        SELECT 1
        FROM inserted
        WHERE account_type = 'Savings'
          AND balance < 0
    )
    BEGIN

        THROW 50001,
        'Update rejected: Savings account balance cannot be negative.',
        1;

    END;

    -- Apply valid updates to the original table

    UPDATE a
    SET
        a.account_type = i.account_type,
        a.balance = i.balance
    FROM accounts a
    INNER JOIN inserted i
        ON a.account_id = i.account_id;

END;
IF EXISTS
(
    SELECT 1
    FROM inserted
    WHERE account_type = 'Savings'
      AND balance < 0
)

UPDATE a
SET
    a.account_type = i.account_type,
    a.balance = i.balance
FROM accounts a
INNER JOIN inserted i
    ON a.account_id = i.account_id;

-- Test 1 – Valid balance update
UPDATE vw_accounts
SET balance = 12000
WHERE account_id = 101;

SELECT *
FROM accounts
WHERE account_id = 101;

-- Test 2 – Invalid balance update
UPDATE vw_accounts
SET balance = -500
WHERE account_id = 102;

SELECT *
FROM accounts
WHERE account_id = 102;

-- Test 3 – Negative balance on a Current account
UPDATE vw_accounts
SET balance = -1000
WHERE account_id = 104;


SELECT *
FROM accounts
WHERE account_id = 104;