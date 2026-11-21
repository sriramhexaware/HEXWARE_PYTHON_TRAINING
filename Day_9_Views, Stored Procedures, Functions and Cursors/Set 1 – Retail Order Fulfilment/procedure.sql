-- Task 2 – Create usp_PlaceOrder

-- Create stored procedure

CREATE PROCEDURE usp_PlaceOrder
    @CustomerID INT,
    @ProductID INT,
    @Quantity INT,
    @OrderID INT OUTPUT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        IF NOT EXISTS (
            SELECT 1 FROM Products
            WHERE ProductID = @ProductID AND Stock >= @Quantity
        )
            THROW 50001, 'Insufficient stock or invalid product', 1;

        INSERT INTO Orders (CustomerID)
        VALUES (@CustomerID);

        SET @OrderID = SCOPE_IDENTITY();

        INSERT INTO OrderItems (OrderID, ProductID, Quantity, UnitPrice)
        SELECT @OrderID, ProductID, @Quantity, SellingPrice
        FROM Products WHERE ProductID = @ProductID;

        UPDATE Products
        SET Stock = Stock - @Quantity
        WHERE ProductID = @ProductID;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH
END;
GO

-- Execute the procedure

DECLARE @NewOrderID INT;

EXEC usp_PlaceOrder
    @CustomerID = 1,
    @ProductID = 102,
    @Quantity = 2,
    @OrderID = @NewOrderID OUTPUT;

SELECT @NewOrderID AS GeneratedOrderID;

-- Verify the result

SELECT * FROM Orders;
SELECT * FROM OrderItems;
SELECT * FROM Products;


-- Task 3 – Scalar Function and Inline Table-Valued Function

CREATE FUNCTION fn_OrderTotalWithTax(@OrderID INT)
RETURNS DECIMAL(10,2)
AS
BEGIN
    DECLARE @Total DECIMAL(10,2);

    SELECT @Total = SUM(Quantity * UnitPrice) * 1.18
    FROM OrderItems
    WHERE OrderID = @OrderID;

    RETURN ISNULL(@Total, 0);
END;
GO

-- Execute scalar function

SELECT dbo.fn_OrderTotalWithTax(1) AS TotalWithTax;

-- Create inline table-valued function

CREATE FUNCTION fn_CustomerOrders(@CustomerID INT)
RETURNS TABLE
AS
RETURN
(
    SELECT OrderID, CustomerID, OrderDate, Status
    FROM Orders
    WHERE CustomerID = @CustomerID
);
GO

-- Execute table-valued function

SELECT * FROM dbo.fn_CustomerOrders(1);
