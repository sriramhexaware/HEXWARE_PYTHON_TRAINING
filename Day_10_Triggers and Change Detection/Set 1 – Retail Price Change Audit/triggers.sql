-- Task 1: Create an AFTER UPDATE trigger on product_price that writes old price, new price, user and time into price_audit using the inserted and deleted tables (set-based, multi-row safe).
-- Create the AFTER UPDATE trigger

CREATE TRIGGER trg_price_audit
ON product_price
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO price_audit
    (
        product_id,
        old_price,
        new_price,
        changed_by,
        changed_at
    )
    SELECT
        d.product_id,
        d.selling_price,
        i.selling_price,
        SUSER_SNAME(),
        GETDATE()
    FROM deleted d
    INNER JOIN inserted i
        ON d.product_id = i.product_id;
END;

UPDATE product_price
SET selling_price = 55000
WHERE product_id = 1;

UPDATE product_price
SET selling_price = selling_price + 100;

UPDATE product_price
SET selling_price = 55000
WHERE product_id = 1;

SELECT *
FROM price_audit;

-- Task 2: Create an INSTEAD OF trigger that rejects any price below cost and logs the rejected attempt.
-- Create the INSTEAD OF trigger

CREATE TRIGGER trg_validate_price
ON product_price
INSTEAD OF UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Check for prices below cost
    IF EXISTS
    (
        SELECT 1
        FROM inserted i
        JOIN products p
            ON i.product_id = p.product_id
        WHERE i.selling_price < p.cost_price
    )
    BEGIN

        -- Log rejected attempts
        INSERT INTO rejected_price_attempts
        (
            product_id,
            attempted_price,
            cost_price,
            attempted_by,
            attempted_at,
            rejection_reason
        )
        SELECT
            i.product_id,
            i.selling_price,
            p.cost_price,
            SUSER_SNAME(),
            GETDATE(),
            'Selling price cannot be below cost price'
        FROM inserted i
        JOIN products p
            ON i.product_id = p.product_id
        WHERE i.selling_price < p.cost_price;

        -- Reject the entire update
        THROW 50001,
        'Update rejected: Selling price cannot be below cost price.',
        1;
    END;

    -- Apply valid updates
    UPDATE pp
    SET pp.selling_price = i.selling_price
    FROM product_price pp
    JOIN inserted i
        ON pp.product_id = i.product_id;

END;

-- Checking the cost price

IF EXISTS
(
    SELECT 1
    FROM inserted i
    JOIN products p
        ON i.product_id = p.product_id
    WHERE i.selling_price < p.cost_price
)

-- Logging rejected attempts

INSERT INTO rejected_price_attempts (...)
SELECT ...
FROM inserted i
JOIN products p
    ON i.product_id = p.product_id
WHERE i.selling_price < p.cost_price;

-- Applying valid updates

UPDATE pp
SET pp.selling_price = i.selling_price
FROM product_price pp
JOIN inserted i
    ON pp.product_id = i.product_id;

-- Test the trigger

UPDATE product_price
SET selling_price = 35000
WHERE product_id = 1;

-- Valid price

UPDATE product_price
SET selling_price = 60000
WHERE product_id = 1;


