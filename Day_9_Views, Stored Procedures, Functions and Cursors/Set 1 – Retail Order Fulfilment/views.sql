--Task 1 – Create SQL Server Views

-- vw_order_summary – Hide cost price and supplier information
go
CREATE VIEW vw_order_summary AS
SELECT o.OrderID, o.CustomerID, o.OrderDate, o.Status,
       p.ProductName, oi.Quantity, oi.UnitPrice
FROM Orders o
JOIN OrderItems oi ON o.OrderID = oi.OrderID
JOIN Products p ON oi.ProductID = p.ProductID;
go
-- vw_low_stock – Display products with low stock
go
CREATE VIEW vw_low_stock AS
SELECT ProductID, ProductName, Stock
FROM Products
WHERE Stock < 5;
go
-- An updatable view using WITH CHECK OPTION
go
CREATE VIEW vw_pending_orders AS
SELECT OrderID, CustomerID, OrderDate, Status
FROM Orders
WHERE Status = 'Pending'
WITH CHECK OPTION;
go
-- verify

SELECT * FROM vw_order_summary;
SELECT * FROM vw_low_stock;

-- Update through the view

UPDATE vw_pending_orders
SET Status = 'Processing'
WHERE OrderID = 2;

-- Test WITH CHECK OPTION [fails]

UPDATE vw_pending_orders
SET Status = 'Completed'
WHERE OrderID = 1;