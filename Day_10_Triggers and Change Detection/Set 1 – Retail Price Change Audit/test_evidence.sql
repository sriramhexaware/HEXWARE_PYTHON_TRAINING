-- Task 3 – Test with Single-Row and Multi-Row Updates and Submit the Evidence
-- Test Case 1 – Single-Row Valid Update

UPDATE product_price
SET selling_price = 900
WHERE product_id = 2;

SELECT *
FROM product_price
WHERE product_id = 2;

SELECT *
FROM price_audit
WHERE product_id = 2;

-- Test Case 2 – Multi-Row Valid Update

UPDATE product_price
SET selling_price = selling_price + 100;

SELECT *
FROM product_price;

SELECT *
FROM price_audit
ORDER BY audit_id;

-- Test Case 3 – Single-Row Invalid Update
UPDATE product_price
SET selling_price = 30000
WHERE product_id = 1;

SELECT *
FROM product_price
WHERE product_id = 1;

SELECT *
FROM rejected_price_attempts;

-- Test Case 4 – Multi-Row Update with an Invalid Price

UPDATE product_price
SET selling_price =
    CASE
        WHEN product_id = 2 THEN 700
        WHEN product_id = 3 THEN 150
        WHEN product_id = 4 THEN 9000
    END
WHERE product_id IN (2, 3, 4);

--  Final Verification Queries
-- Display current product prices
SELECT
    p.product_id,
    p.product_name,
    p.cost_price,
    pp.selling_price
FROM products p
JOIN product_price pp
    ON p.product_id = pp.product_id;


-- Display successful price changes
SELECT *
FROM price_audit
ORDER BY audit_id;


-- Display rejected price attempts
SELECT *
FROM rejected_price_attempts
ORDER BY attempt_id;


-- Count successful changes
SELECT COUNT(*) AS total_successful_changes
FROM price_audit;


-- Count rejected attempts
SELECT COUNT(*) AS total_rejected_attempts
FROM rejected_price_attempts;