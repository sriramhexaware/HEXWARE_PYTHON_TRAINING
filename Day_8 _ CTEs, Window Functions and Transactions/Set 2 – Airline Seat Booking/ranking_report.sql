CREATE TABLE Passengers (
    PassengerID INT PRIMARY KEY,
    PassengerName VARCHAR(50),
    FlightID INT,
    Fare DECIMAL(10,2)
);
INSERT INTO Passengers VALUES
(1, 'Arun', 101, 8000),
(2, 'Bala', 101, 7000),
(3, 'Kumar', 101, 7000),
(4, 'David', 101, 6000),
(5, 'Ezhil', 101, 5000),
(6, 'Frank', 102, 9000),
(7, 'Gokul', 102, 8500),
(8, 'Hari', 102, 8500),
(9, 'Imran', 102, 7500);

-- Task 3 – Passenger Fare Ranking Using RANK() and DENSE_RANK()

SELECT
    PassengerID,
    PassengerName,
    FlightID,
    Fare,
    RANK() OVER (
        PARTITION BY FlightID ORDER BY Fare DESC
    ) AS FareRank,
    DENSE_RANK() OVER (
        PARTITION BY FlightID ORDER BY Fare DESC
    ) AS DenseRank
FROM Passengers
ORDER BY FlightID, Fare DESC;

-- Task 4 – CTE and Running Total of Revenue
WITH FlightReport AS (
    SELECT
        PassengerID,
        PassengerName,
        FlightID,
        Fare,
        RANK() OVER (
            PARTITION BY FlightID ORDER BY Fare DESC
        ) AS FareRank,
        DENSE_RANK() OVER (
            PARTITION BY FlightID ORDER BY Fare DESC
        ) AS DenseRank
    FROM Passengers
)
SELECT *,
    SUM(Fare) OVER (
        PARTITION BY FlightID
        ORDER BY Fare DESC, PassengerID
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS RunningRevenue
FROM FlightReport
ORDER BY FlightID, Fare DESC, PassengerID;