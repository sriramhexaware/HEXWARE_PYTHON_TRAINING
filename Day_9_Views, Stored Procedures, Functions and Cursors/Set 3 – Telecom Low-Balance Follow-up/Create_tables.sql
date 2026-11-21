use Hexaware

-- Create tables

CREATE TABLE Subscribers (
    SubscriberID INT PRIMARY KEY,
    SubscriberName VARCHAR(100),
    Phone VARCHAR(15),
    SubscriberType VARCHAR(20),
    Balance DECIMAL(10,2),
    ValidityEndDate DATE
);

CREATE TABLE RechargePlans (
    PlanID INT PRIMARY KEY,
    PlanName VARCHAR(50),
    Amount DECIMAL(10,2),
    ValidityDays INT
);

CREATE TABLE RechargeHistory (
    RechargeID INT IDENTITY(1,1) PRIMARY KEY,
    SubscriberID INT,
    PlanID INT,
    Amount DECIMAL(10,2),
    RechargeDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (SubscriberID) REFERENCES Subscribers(SubscriberID),
    FOREIGN KEY (PlanID) REFERENCES RechargePlans(PlanID)
);

CREATE TABLE NotificationLog (
    NotificationID INT IDENTITY(1,1) PRIMARY KEY,
    SubscriberID INT,
    Message VARCHAR(200),
    IsRead BIT DEFAULT 0,
    CreatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (SubscriberID) REFERENCES Subscribers(SubscriberID)
);

-- Insert sample data


INSERT INTO Subscribers VALUES
(1, 'Arun', '9876543210', 'Prepaid', 30, DATEADD(DAY, 10, GETDATE())),
(2, 'Kumar', '9876543211', 'Prepaid', 150, DATEADD(DAY, 20, GETDATE())),
(3, 'Ravi', '9876543212', 'Prepaid', 45, DATEADD(DAY, 5, GETDATE())),
(4, 'Manoj', '9876543213', 'Postpaid', 500, DATEADD(DAY, 30, GETDATE())),
(5, 'Vijay', '9876543214', 'Prepaid', 20, DATEADD(DAY, 15, GETDATE()));

INSERT INTO RechargePlans VALUES
(101, 'Basic', 50, 28),
(102, 'Standard', 100, 56),
(103, 'Premium', 200, 84);

INSERT INTO RechargeHistory
(SubscriberID, PlanID, Amount)
VALUES
(1, 101, 50),
(1, 102, 100),
(2, 103, 200),
(3, 101, 50),
(5, 102, 100);

-- Verify table data

SELECT * FROM Subscribers;
SELECT * FROM RechargePlans;
SELECT * FROM RechargeHistory;
SELECT * FROM NotificationLog;