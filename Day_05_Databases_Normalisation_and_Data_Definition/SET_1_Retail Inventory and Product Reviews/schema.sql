--Database and Table Creation

use Hexaware;

SELECT DB_NAME() AS CurrentDatabase;

CREATE TABLE Categories (
    Category_ID INT PRIMARY KEY,
    Category_Name VARCHAR(50)
);

SELECT * FROM Categories;

CREATE TABLE Suppliers (
    Supplier_ID INT PRIMARY KEY,
    Supplier_Name VARCHAR(100),
    Supplier_Phone VARCHAR(15)
)

SELECT * FROM Suppliers;

CREATE TABLE Warehouses (
    Warehouse_ID INT PRIMARY KEY,
    Warehouse_Name VARCHAR(100)
);

SELECT * FROM Warehouses;

CREATE TABLE Products (
    SKU VARCHAR(20) PRIMARY KEY,
    Product_Name VARCHAR(100),
    Category_ID INT,
    Supplier_ID INT,

    FOREIGN KEY (Category_ID)
    REFERENCES Categories(Category_ID),

    FOREIGN KEY (Supplier_ID)
    REFERENCES Suppliers(Supplier_ID)
);

SELECT * FROM Products;

CREATE TABLE Inventory (
    SKU VARCHAR(20),
    Warehouse_ID INT,
    Quantity INT,
    Reorder_Level INT,

    PRIMARY KEY (SKU, Warehouse_ID),

    FOREIGN KEY (SKU)
    REFERENCES Products(SKU),

    FOREIGN KEY (Warehouse_ID)
    REFERENCES Warehouses(Warehouse_ID)
);

SELECT * FROM Inventory;

-- Modify Commands

ALTER TABLE Categories
ALTER COLUMN Category_Name VARCHAR(50) NOT NULL;

ALTER TABLE Suppliers
ALTER COLUMN Supplier_Name VARCHAR(100) NOT NULL;

ALTER TABLE Suppliers
ALTER COLUMN Supplier_Phone VARCHAR(15) NOT NULL;

ALTER TABLE Suppliers
ADD CONSTRAINT UQ_Supplier_Phone
UNIQUE (Supplier_Phone);

ALTER TABLE Warehouses
ALTER COLUMN Warehouse_Name VARCHAR(100) NOT NULL;

ALTER TABLE Warehouses
ADD CONSTRAINT UQ_Warehouse_Name
UNIQUE (Warehouse_Name);

ALTER TABLE Products
ALTER COLUMN Product_Name VARCHAR(100) NOT NULL;

ALTER TABLE Products
ALTER COLUMN Category_ID INT NOT NULL;

ALTER TABLE Products
ALTER COLUMN Supplier_ID INT NOT NULL;

ALTER TABLE Inventory
ALTER COLUMN Quantity INT NOT NULL;

ALTER TABLE Inventory
ALTER COLUMN Reorder_Level INT NOT NULL;

ALTER TABLE Inventory
ADD CONSTRAINT CK_Quantity
CHECK (Quantity >= 0);

ALTER TABLE Inventory
ADD CONSTRAINT DF_Quantity
DEFAULT 0 FOR Quantity;

ALTER TABLE Inventory
ADD CONSTRAINT DF_Reorder_Level
DEFAULT 10 FOR Reorder_Level;

ALTER TABLE Inventory
ADD CONSTRAINT CK_Reorder_Level
CHECK (Reorder_Level >= 0);

--Insert into Tables

INSERT INTO Categories
(Category_ID, Category_Name)
VALUES
(1, 'Electronics'),
(2, 'Furniture'),
(3, 'Clothing'),
(4, 'Footwear'),
(5, 'Books'),
(6, 'Groceries'),
(7, 'Sports'),
(8, 'Accessories'),
(9, 'Kitchen'),
(10, 'Toys');

SELECT * FROM Categories;

INSERT INTO Suppliers
(Supplier_ID, Supplier_Name, Supplier_Phone)
VALUES
(1, 'ABC Suppliers', '9876543210'),
(2, 'XYZ Traders', '9876501234'),
(3, 'Global Products', '9876512345'),
(4, 'Smart Distributors', '9876523456'),
(5, 'Prime Wholesale', '9876534567'),
(6, 'Metro Supplies', '9876545678'),
(7, 'City Traders', '9876556789'),
(8, 'Royal Distributors', '9876567890'),
(9, 'Universal Suppliers', '9876578901'),
(10, 'Best Products', '9876589012');


SELECT * FROM Suppliers;

INSERT INTO Warehouses
(Warehouse_ID, Warehouse_Name)
VALUES
(1, 'Chennai'),
(2, 'Coimbatore'),
(3, 'Bangalore'),
(4, 'Hyderabad'),
(5, 'Mumbai'),
(6, 'Delhi'),
(7, 'Pune'),
(8, 'Kolkata'),
(9, 'Kochi'),
(10, 'Madurai');

SELECT * FROM Warehouses;

INSERT INTO Products
(SKU, Product_Name, Category_ID, Supplier_ID)
VALUES
('P101', 'Laptop', 1, 1),
('P102', 'Office Chair', 2, 2),
('P103', 'T Shirt', 3, 3),
('P104', 'Sports Shoes', 4, 4),
('P105', 'Python Book', 5, 5),
('P106', 'Rice Bag', 6, 6),
('P107', 'Football', 7, 7),
('P108', 'Smart Watch', 8, 8),
('P109', 'Mixer Grinder', 9, 9),
('P110', 'Toy Car', 10, 10);


SELECT * FROM Products;

INSERT INTO Inventory
(SKU, Warehouse_ID, Quantity, Reorder_Level)
VALUES
('P101', 1, 25, 10),
('P102', 2, 30, 10),
('P103', 3, 50, 15),
('P104', 4, 20, 5),
('P105', 5, 40, 10),
('P106', 6, 100, 20),
('P107', 7, 15, 5),
('P108', 8, 35, 10),
('P109', 9, 18, 5),
('P110', 10, 12, 5);

SELECT * FROM Inventory;

--Task 3 failing insert Queries

INSERT INTO Products
VALUES ('P101', 'Gaming Laptop', 1, 1);

INSERT INTO Products
VALUES ('P111', 'New Product', 999, 1);

INSERT INTO Inventory
(SKU, Warehouse_ID, Quantity, Reorder_Level)
VALUES ('P101', 2, -10, 5);

INSERT INTO Suppliers
(Supplier_ID, Supplier_Name, Supplier_Phone)
VALUES (11, NULL, '9876590123');

--Update Suplier Phone Number

--Before UPDATE
SELECT *
FROM Suppliers
WHERE Supplier_ID = 1;

--UPDATE
UPDATE Suppliers
SET Supplier_Phone = '9999988888'
WHERE Supplier_ID = 1;

--After Update
SELECT *
FROM Suppliers
WHERE Supplier_ID = 1;

--Befor Delete
SELECT *
FROM Products
WHERE SKU = 'P110';

----Delete Command
DELETE FROM Products
WHERE SKU = 'P110';

--After Product
SELECT *
FROM Products
WHERE SKU = 'P110';