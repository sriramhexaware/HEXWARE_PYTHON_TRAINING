-- Task 4 – Cursor and Set-Based Rewrite

-- Cursor implementation


DECLARE @PolicyID INT;
DECLARE @OldStatus VARCHAR(20);

DECLARE policy_cursor CURSOR FOR
SELECT PolicyID, PolicyStatus
FROM Policies
WHERE DueDate < CAST(GETDATE() AS DATE)
  AND PolicyStatus = 'Active';

OPEN policy_cursor;

FETCH NEXT FROM policy_cursor
INTO @PolicyID, @OldStatus;

WHILE @@FETCH_STATUS = 0
BEGIN
    UPDATE Policies
    SET PolicyStatus = 'Lapsed'
    WHERE PolicyID = @PolicyID;

    INSERT INTO PolicyStatusLog
    (PolicyID, OldStatus, NewStatus)
    VALUES
    (@PolicyID, @OldStatus, 'Lapsed');

    FETCH NEXT FROM policy_cursor
    INTO @PolicyID, @OldStatus;
END;

CLOSE policy_cursor;
DEALLOCATE policy_cursor;

-- Set-based implementation


UPDATE Policies
SET PolicyStatus = 'Lapsed'
OUTPUT
    DELETED.PolicyID,
    DELETED.PolicyStatus,
    INSERTED.PolicyStatus,
    GETDATE()
INTO PolicyStatusLog
(PolicyID, OldStatus, NewStatus, UpdatedAt)
WHERE DueDate < CAST(GETDATE() AS DATE)
  AND PolicyStatus = 'Active';


  -- Verify the results

SELECT * FROM Policies;
SELECT * FROM PolicyStatusLog;
