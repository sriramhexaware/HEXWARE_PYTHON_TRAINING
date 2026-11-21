-- Task 4 – Cursor and Set-Based Notification Processing

-- Cursor implementation


DECLARE @SubscriberID INT;

DECLARE subscriber_cursor CURSOR FOR
SELECT SubscriberID
FROM Subscribers
WHERE SubscriberType = 'Prepaid'
  AND Balance < 50;

OPEN subscriber_cursor;

FETCH NEXT FROM subscriber_cursor INTO @SubscriberID;

WHILE @@FETCH_STATUS = 0
BEGIN
    INSERT INTO NotificationLog
    (SubscriberID, Message)
    VALUES
    (@SubscriberID, 'Your balance is below 50. Please recharge.');

    FETCH NEXT FROM subscriber_cursor INTO @SubscriberID;
END;

CLOSE subscriber_cursor;
DEALLOCATE subscriber_cursor;

-- Set-based implementation


INSERT INTO NotificationLog (SubscriberID, Message)
SELECT
    SubscriberID,
    'Your balance is below 50. Please recharge.'
FROM Subscribers
WHERE SubscriberType = 'Prepaid'
  AND Balance < 50;

  --  Compare execution time
  -- Cursor timing

DECLARE @Start DATETIME2 = SYSDATETIME();
DECLARE @SubscriberID INT;

DECLARE subscriber_cursor CURSOR FOR
SELECT SubscriberID
FROM Subscribers
WHERE SubscriberType = 'Prepaid'
  AND Balance < 50;

OPEN subscriber_cursor;
FETCH NEXT FROM subscriber_cursor INTO @SubscriberID;

WHILE @@FETCH_STATUS = 0
BEGIN
    INSERT INTO NotificationLog (SubscriberID, Message)
    VALUES (@SubscriberID, 'Low balance alert');

    FETCH NEXT FROM subscriber_cursor INTO @SubscriberID;
END;

CLOSE subscriber_cursor;
DEALLOCATE subscriber_cursor;

SELECT DATEDIFF(MICROSECOND, @Start, SYSDATETIME())
AS CursorTimeMicroseconds;

-- Set-based timing

DECLARE @Start DATETIME2 = SYSDATETIME();

INSERT INTO NotificationLog (SubscriberID, Message)
SELECT SubscriberID, 'Low balance alert'
FROM Subscribers
WHERE SubscriberType = 'Prepaid'
  AND Balance < 50;

SELECT DATEDIFF(MICROSECOND, @Start, SYSDATETIME())
AS SetBasedTimeMicroseconds;

DELETE FROM NotificationLog;


