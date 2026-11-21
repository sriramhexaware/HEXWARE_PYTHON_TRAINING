use Hexaware


CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15)
);

CREATE TABLE Agents (
    AgentID INT PRIMARY KEY,
    AgentName VARCHAR(100)
);

CREATE TABLE Policies (
    PolicyID INT PRIMARY KEY,
    CustomerID INT,
    AgentID INT,
    Premium DECIMAL(10,2),
    DueDate DATE,
    PolicyStatus VARCHAR(20),
    NoClaimYears INT,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (AgentID) REFERENCES Agents(AgentID)
);

CREATE TABLE Claims (
    ClaimID INT PRIMARY KEY,
    PolicyID INT,
    ClaimStatus VARCHAR(20),
    FOREIGN KEY (PolicyID) REFERENCES Policies(PolicyID)
);

CREATE TABLE PolicyRenewalAudit (
    AuditID INT IDENTITY(1,1) PRIMARY KEY,
    PolicyID INT,
    OldPremium DECIMAL(10,2),
    NewPremium DECIMAL(10,2),
    RenewalDate DATETIME DEFAULT GETDATE()
);

CREATE TABLE PolicyStatusLog (
    LogID INT IDENTITY(1,1) PRIMARY KEY,
    PolicyID INT,
    OldStatus VARCHAR(20),
    NewStatus VARCHAR(20),
    UpdatedAt DATETIME DEFAULT GETDATE()
);


INSERT INTO Customers VALUES
(1, 'Arun', 'arun@gmail.com', '9876543210'),
(2, 'Kumar', 'kumar@gmail.com', '9876543211'),
(3, 'Ravi', 'ravi@gmail.com', '9876543212');

INSERT INTO Agents VALUES
(101, 'Agent A'),
(102, 'Agent B');

INSERT INTO Policies VALUES
(1001, 1, 101, 10000, DATEADD(DAY, 10, GETDATE()), 'Active', 3),
(1002, 2, 101, 15000, DATEADD(DAY, 20, GETDATE()), 'Active', 5),
(1003, 3, 102, 12000, DATEADD(DAY, -10, GETDATE()), 'Active', 0);

INSERT INTO Claims VALUES
(1, 1001, 'Approved'),
(2, 1002, 'Pending'),
(3, 1003, 'Rejected');
