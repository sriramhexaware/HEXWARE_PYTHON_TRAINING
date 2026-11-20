-- Task 1 – Inventory Reservation Transaction

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(50),
    Category VARCHAR(50),
    Stock INT
);

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(50),
    OrderDate DATETIME DEFAULT GETDATE()
);

CREATE TABLE OrderLines (
    OrderLineID INT PRIMARY KEY,
    OrderID INT,
    ProductID INT,
    Quantity INT,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

INSERT INTO Products VALUES
(1, 'Laptop', 'Electronics', 10),
(2, 'Mouse', 'Electronics', 5),
(3, 'Chair', 'Furniture', 8),
(4, 'Table', 'Furniture', 3),
(5, 'Keyboard', 'Electronics', 2);

-- reserve transaction
BEGIN TRY
    BEGIN TRANSACTION;

    UPDATE Products
    SET Stock = Stock - 2
    WHERE ProductID = 1 AND Stock >= 2;

    IF @@ROWCOUNT = 0
        THROW 50001, 'Insufficient laptop stock', 1;

    UPDATE Products
    SET Stock = Stock - 1
    WHERE ProductID = 2 AND Stock >= 1;

    IF @@ROWCOUNT = 0
        THROW 50002, 'Insufficient mouse stock', 1;

    INSERT INTO Orders (OrderID, CustomerName)
    VALUES (101, 'Arun');

    INSERT INTO OrderLines VALUES
    (1, 101, 1, 2),
    (2, 101, 2, 1);

    COMMIT TRANSACTION;
    PRINT 'Order placed successfully';

END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    PRINT ERROR_MESSAGE();
END CATCH;

-- rollback when stock is insufficient

BEGIN TRY
    BEGIN TRANSACTION;

    UPDATE Products
    SET Stock = Stock - 20
    WHERE ProductID = 5 AND Stock >= 20;

    IF @@ROWCOUNT = 0
        THROW 50003, 'Insufficient stock', 1;

    INSERT INTO Orders (OrderID, CustomerName)
    VALUES (102, 'Rahul');

    INSERT INTO OrderLines VALUES
    (3, 102, 5, 20);

    COMMIT TRANSACTION;
    PRINT 'Order placed successfully';

END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    PRINT ERROR_MESSAGE();
END CATCH;

-- verify the result
SELECT * FROM Products;
SELECT * FROM Orders;
SELECT * FROM OrderLines;
