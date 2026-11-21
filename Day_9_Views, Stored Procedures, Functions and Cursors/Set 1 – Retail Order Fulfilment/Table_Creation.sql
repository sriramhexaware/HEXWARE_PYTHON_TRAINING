CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(50),
    CostPrice DECIMAL(10,2),
    SellingPrice DECIMAL(10,2),
    Stock INT,
    Supplier VARCHAR(50)
);

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY IDENTITY(1,1),
    CustomerID INT,
    OrderDate DATE DEFAULT GETDATE(),
    Status VARCHAR(20) DEFAULT 'Pending'
);

CREATE TABLE OrderItems (
    OrderItemID INT PRIMARY KEY IDENTITY(1,1),
    OrderID INT FOREIGN KEY REFERENCES Orders(OrderID),
    ProductID INT FOREIGN KEY REFERENCES Products(ProductID),
    Quantity INT,
    UnitPrice DECIMAL(10,2)
);

CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(50)
);

CREATE TABLE FollowUps (
    FollowUpID INT PRIMARY KEY IDENTITY(1,1),
    OrderID INT FOREIGN KEY REFERENCES Orders(OrderID),
    FollowUpDate DATE DEFAULT GETDATE(),
    Remarks VARCHAR(100)
);

INSERT INTO Customers VALUES
(1, 'Arun'),
(2, 'Kumar'),
(3, 'Ravi');

INSERT INTO Products VALUES
(101, 'Laptop', 35000, 45000, 10, 'Dell'),
(102, 'Mouse', 300, 500, 4, 'Logitech'),
(103, 'Keyboard', 500, 800, 15, 'HP'),
(104, 'Monitor', 8000, 12000, 2, 'Samsung'),
(105, 'Headphones', 1000, 1500, 20, 'Boat');

INSERT INTO Orders (CustomerID, OrderDate, Status) VALUES
(1, DATEADD(DAY,-5,GETDATE()), 'Pending'),
(2, DATEADD(DAY,-2,GETDATE()), 'Pending'),
(3, GETDATE(), 'Completed');

INSERT INTO OrderItems VALUES
(1, 101, 1, 45000),
(1, 102, 2, 500),
(2, 103, 1, 800),
(3, 104, 1, 12000);

SELECT * FROM Customers;
SELECT * FROM Products;
SELECT * FROM Orders;
SELECT * FROM OrderItems;
SELECT * FROM FollowUps;

