

CREATE TABLE Seats (
    SeatID INT PRIMARY KEY,
    FlightID INT,
    SeatNumber VARCHAR(10),
    Status VARCHAR(20)
);

CREATE TABLE Bookings (
    BookingID INT PRIMARY KEY,
    PassengerName VARCHAR(50),
    FlightID INT,
    SeatID INT,
    Fare DECIMAL(10,2),
    BookingDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (SeatID) REFERENCES Seats(SeatID)
);

INSERT INTO Seats VALUES
(1, 101, 'A1', 'AVAILABLE'),
(2, 101, 'A2', 'AVAILABLE'),
(3, 101, 'A3', 'BOOKED'),
(4, 102, 'B1', 'AVAILABLE');

INSERT INTO Bookings
(BookingID, PassengerName, FlightID, SeatID, Fare)
VALUES
(1001, 'Arun', 101, 3, 5000);

--Task 1 – Atomic Airline Seat Booking

DECLARE @SeatID INT = 1,
        @BookingID INT = 1002,
        @PassengerName VARCHAR(50) = 'Rahul',
        @Fare DECIMAL(10,2) = 4500;

BEGIN TRY
    BEGIN TRAN;

    IF NOT EXISTS (
        SELECT 1 FROM Seats WITH (UPDLOCK, HOLDLOCK)
        WHERE SeatID = @SeatID AND Status = 'AVAILABLE'
    )
        THROW 50001, 'Seat is not available', 1;

    INSERT INTO Bookings
    (BookingID, PassengerName, FlightID, SeatID, Fare)
    SELECT @BookingID, @PassengerName, FlightID, @SeatID, @Fare
    FROM Seats
    WHERE SeatID = @SeatID;

    UPDATE Seats
    SET Status = 'BOOKED'
    WHERE SeatID = @SeatID;

    COMMIT TRAN;

    PRINT 'Seat booked successfully';

END TRY
BEGIN CATCH

    IF XACT_STATE() <> 0
        ROLLBACK TRAN;

    PRINT ERROR_MESSAGE();

END CATCH;

SELECT * FROM Seats;
SELECT * FROM Bookings;

--Task 2 – Simultaneous Seat Booking Using Two Sessions
UPDATE Seats
SET Status = 'AVAILABLE'
WHERE SeatID = 2;
DELETE FROM Bookings
WHERE SeatID = 2;

--READ COMMITTED
-- Customer A
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

BEGIN TRAN;

IF EXISTS (
    SELECT 1 FROM Seats
    WHERE SeatID = 2 AND Status = 'AVAILABLE'
)
BEGIN
    WAITFOR DELAY '00:00:10';

    INSERT INTO Bookings
    (BookingID, PassengerName, FlightID, SeatID, Fare)
    VALUES (1003, 'Customer A', 101, 2, 4500);

    UPDATE Seats
    SET Status = 'BOOKED'
    WHERE SeatID = 2;

    COMMIT TRAN;
    PRINT 'Customer A booked successfully';
END
ELSE
BEGIN
    ROLLBACK TRAN;
    PRINT 'Seat unavailable';
END;

--Customer b
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

BEGIN TRAN;

IF EXISTS (
    SELECT 1 FROM Seats
    WHERE SeatID = 2 AND Status = 'AVAILABLE'
)
BEGIN
    INSERT INTO Bookings
    (BookingID, PassengerName, FlightID, SeatID, Fare)
    VALUES (1004, 'Customer B', 101, 2, 4500);

    UPDATE Seats
    SET Status = 'BOOKED'
    WHERE SeatID = 2;

    COMMIT TRAN;
    PRINT 'Customer B booked successfully';
END
ELSE
BEGIN
    ROLLBACK TRAN;
    PRINT 'Seat unavailable';
END;

--SERIALIZABLE
UPDATE Seats
SET Status = 'AVAILABLE'
WHERE SeatID = 2;
DELETE FROM Bookings
WHERE SeatID = 2;

--Customer A
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

BEGIN TRAN;

IF EXISTS (
    SELECT 1 FROM Seats
    WHERE SeatID = 2 AND Status = 'AVAILABLE'
)
BEGIN
    WAITFOR DELAY '00:00:10';

    INSERT INTO Bookings
    (BookingID, PassengerName, FlightID, SeatID, Fare)
    VALUES (1005, 'Customer A', 101, 2, 4500);

    UPDATE Seats
    SET Status = 'BOOKED'
    WHERE SeatID = 2;

    COMMIT TRAN;
    PRINT 'Customer A booked successfully';
END
ELSE
BEGIN
    ROLLBACK TRAN;
    PRINT 'Seat unavailable';
END;

--Customer B
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

BEGIN TRAN;

IF EXISTS (
    SELECT 1 FROM Seats
    WHERE SeatID = 2 AND Status = 'AVAILABLE'
)
BEGIN
    INSERT INTO Bookings
    (BookingID, PassengerName, FlightID, SeatID, Fare)
    VALUES (1006, 'Customer B', 101, 2, 4500);

    UPDATE Seats
    SET Status = 'BOOKED'
    WHERE SeatID = 2;

    COMMIT TRAN;
    PRINT 'Customer B booked successfully';
END
ELSE
BEGIN
    ROLLBACK TRAN;
    PRINT 'Seat unavailable';
END;

--Verification
SELECT * FROM Seats
WHERE SeatID = 2;

SELECT * FROM Bookings
WHERE SeatID = 2;