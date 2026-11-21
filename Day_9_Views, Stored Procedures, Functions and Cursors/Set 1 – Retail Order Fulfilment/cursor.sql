-- Task 4 – Cursor vs Set-Based Approach

-- Create cursor-based procedure

CREATE PROCEDURE usp_CursorFollowUps
AS
BEGIN
    DECLARE @OrderID INT;

    DECLARE order_cursor CURSOR FOR
    SELECT OrderID
    FROM Orders
    WHERE Status = 'Pending'
      AND OrderDate < DATEADD(DAY, -3, GETDATE());

    OPEN order_cursor;

    FETCH NEXT FROM order_cursor INTO @OrderID;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        INSERT INTO FollowUps (OrderID, Remarks)
        VALUES (@OrderID, 'Order pending for more than 3 days');

        FETCH NEXT FROM order_cursor INTO @OrderID;
    END;

    CLOSE order_cursor;
    DEALLOCATE order_cursor;
END;
GO

-- Execute cursor procedure

EXEC usp_CursorFollowUps;

-- Verify follow-up records

SELECT * FROM FollowUps;

-- Rewrite using set-based approach

INSERT INTO FollowUps (OrderID, Remarks)
SELECT OrderID, 'Order pending for more than 3 days'
FROM Orders
WHERE Status = 'Pending'
  AND OrderDate < DATEADD(DAY, -3, GETDATE());





