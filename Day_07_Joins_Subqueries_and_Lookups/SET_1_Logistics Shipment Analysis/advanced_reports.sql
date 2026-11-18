--create database and table

use LogisticsDB;

CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    city VARCHAR(50)
);
CREATE TABLE Hubs (
    hub_id INT PRIMARY KEY,
    hub_name VARCHAR(100) NOT NULL,
    location VARCHAR(100)
);
CREATE TABLE Carriers (
    carrier_id INT PRIMARY KEY,
    carrier_name VARCHAR(100) NOT NULL
);
CREATE TABLE Employees (
    employee_id INT PRIMARY KEY,
    employee_name VARCHAR(100) NOT NULL,
    supervisor_id INT NULL,

    FOREIGN KEY (supervisor_id)
    REFERENCES Employees(employee_id)
);
CREATE TABLE Shipments (
    shipment_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    carrier_id INT NOT NULL,
    origin_hub_id INT NOT NULL,
    destination_hub_id INT NOT NULL,
    shipping_cost DECIMAL(10,2) NOT NULL,
    shipped_date DATE NOT NULL,
    expected_delivery_date DATE NOT NULL,
    actual_delivery_date DATE NULL,

    FOREIGN KEY (customer_id)
        REFERENCES Customers(customer_id),

    FOREIGN KEY (carrier_id)
        REFERENCES Carriers(carrier_id),

    FOREIGN KEY (origin_hub_id)
        REFERENCES Hubs(hub_id),

    FOREIGN KEY (destination_hub_id)
        REFERENCES Hubs(hub_id),

    CHECK (shipping_cost >= 0),
    CHECK (destination_hub_id <> origin_hub_id)
);
CREATE TABLE DeliveryEvents (
    event_id INT PRIMARY KEY,
    shipment_id INT NOT NULL,
    event_type VARCHAR(50) NOT NULL,
    event_date DATETIME NOT NULL,
    description VARCHAR(255),

    FOREIGN KEY (shipment_id)
        REFERENCES Shipments(shipment_id)
);

--insert into records

INSERT INTO Customers VALUES
(101, 'Arun', 'arun@gmail.com', 'Chennai'),
(102, 'Kiran', 'kiran@gmail.com', 'Coimbatore'),
(103, 'Priya', 'priya@gmail.com', 'Bangalore'),
(104, 'Rahul', 'rahul@gmail.com', 'Hyderabad'),
(105, 'Divya', 'divya@gmail.com', 'Mumbai');

INSERT INTO Hubs VALUES
(1, 'Chennai Hub', 'Chennai'),
(2, 'Coimbatore Hub', 'Coimbatore'),
(3, 'Bangalore Hub', 'Bangalore'),
(4, 'Hyderabad Hub', 'Hyderabad'),
(5, 'Mumbai Hub', 'Mumbai');

INSERT INTO Carriers VALUES
(201, 'BlueDart'),
(202, 'DTDC'),
(203, 'Delhivery'),
(204, 'FedEx'),
(205, 'DHL');

INSERT INTO Employees VALUES
(1, 'Rajesh', NULL),
(2, 'Suresh', 1),
(3, 'Anitha', 1),
(4, 'Karthik', 2),
(5, 'Divya', 2);

INSERT INTO Shipments VALUES
(1001, 101, 201, 1, 2, 500, '2026-11-01', '2026-11-03', '2026-11-03'),
(1002, 102, 202, 2, 3, 750, '2026-11-02', '2026-11-04', '2026-11-08'),
(1003, 103, 203, 3, 4, 900, '2026-11-03', '2026-11-05', '2026-11-09'),
(1004, 101, 201, 1, 5, 650, '2026-11-04', '2026-11-06', '2026-11-06'),
(1005, 104, 202, 4, 1, 800, '2026-11-05', '2026-11-07', '2026-11-12');

INSERT INTO DeliveryEvents VALUES
(1, 1001, 'Picked Up', '2026-11-01 09:00', 'Shipment collected'),
(2, 1001, 'Delivered', '2026-11-03 15:00', 'Delivered successfully'),
(3, 1002, 'Delayed', '2026-11-05 12:00', 'Weather conditions'),
(4, 1003, 'Delivered', '2026-11-09 17:00', 'Delivered late'),
(5, 1005, 'Delivered', '2026-11-12 18:00', 'Delivered late');

--joins

--Find shipments delayed by more than 2 days with carrier names
SELECT s.shipment_id, c.carrier_name
FROM Shipments s
INNER JOIN Carriers c
ON s.carrier_id = c.carrier_id
WHERE DATEDIFF(DAY, s.expected_delivery_date, s.actual_delivery_date) > 2;

--Find all customers, including those without shipments
SELECT c.customer_name, s.shipment_id
FROM Customers c
LEFT JOIN Shipments s
ON c.customer_id = s.customer_id;

--Find hubs with no outbound shipments
SELECT h.hub_name
FROM Hubs h
LEFT JOIN Shipments s
ON h.hub_id = s.origin_hub_id
WHERE s.shipment_id IS NULL;

--Display shipments with their origin and destination hub names
SELECT s.shipment_id,
       h1.hub_name AS origin_hub,
       h2.hub_name AS destination_hub
FROM Shipments s
INNER JOIN Hubs h1
ON s.origin_hub_id = h1.hub_id
INNER JOIN Hubs h2
ON s.destination_hub_id = h2.hub_id;

--Display employees with their supervisors
SELECT e.employee_name,
       s.employee_name AS supervisor_name
FROM Employees e
LEFT JOIN Employees s
ON e.supervisor_id = s.employee_id;

--Display all customers and shipments, including unmatched records
SELECT c.customer_name, s.shipment_id
FROM Customers c
FULL OUTER JOIN Shipments s
ON c.customer_id = s.customer_id;

--Find shipments with their delivery event details
SELECT s.shipment_id,
       d.event_type,
       d.description
FROM Shipments s
INNER JOIN DeliveryEvents d
ON s.shipment_id = d.shipment_id;

--Find all carriers and their shipment counts, including carriers with zero shipments
SELECT c.carrier_name,
       COUNT(s.shipment_id) AS total_shipments
FROM Carriers c
LEFT JOIN Shipments s
ON c.carrier_id = s.carrier_id
GROUP BY c.carrier_name;

--Find customers who shipped to more than one different hub
SELECT c.customer_name
FROM Customers c
INNER JOIN Shipments s
ON c.customer_id = s.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING COUNT(DISTINCT s.destination_hub_id) > 1;

--Display shipment ID, customer, carrier and destination hub
SELECT s.shipment_id,
       c.customer_name,
       cr.carrier_name,
       h.hub_name AS destination_hub
FROM Shipments s
INNER JOIN Customers c
ON s.customer_id = c.customer_id
INNER JOIN Carriers cr
ON s.carrier_id = cr.carrier_id
INNER JOIN Hubs h
ON s.destination_hub_id = h.hub_id;

--Subqueries using IN, EXISTS, ANY and ALL
--IN -> Find customers who have shipped at least once
SELECT customer_name
FROM Customers
WHERE customer_id IN (
    SELECT customer_id
    FROM Shipments
);
--EXISTS -> Find customers who have shipments
SELECT c.customer_name
FROM Customers c
WHERE EXISTS (
    SELECT 1
    FROM Shipments s
    WHERE s.customer_id = c.customer_id
);
--ANY -> Find carriers whose average shipping cost is greater than at least one carrier's average shipping cost
SELECT carrier_name
FROM Carriers
WHERE carrier_id IN (
    SELECT carrier_id
    FROM Shipments
    GROUP BY carrier_id
    HAVING AVG(shipping_cost) > ANY (
        SELECT AVG(shipping_cost)
        FROM Shipments
        GROUP BY carrier_id
    )
);
--ALL ->Find carriers whose average shipping cost is greater than every other carrier's average shipping cost
SELECT carrier_name
FROM Carriers
WHERE carrier_id IN (
    SELECT carrier_id
    FROM Shipments
    GROUP BY carrier_id
    HAVING AVG(shipping_cost) > ALL (
        SELECT AVG(shipping_cost)
        FROM Shipments
        GROUP BY carrier_id
    )
);

--Rewrite two subqueries as JOIN
--Find customers who have shipments using INNER JOIN instead of IN
SELECT DISTINCT c.customer_name
FROM Customers c
INNER JOIN Shipments s
ON c.customer_id = s.customer_id;
--Find customers who have shipments using INNER JOIN instead of EXISTS
SELECT DISTINCT c.customer_name
FROM Customers c
INNER JOIN Shipments s
ON c.customer_id = s.customer_id;

--Nested Subquery
--Find the second-highest shipping cost for each origin hub
SELECT h.hub_name, MAX(s.shipping_cost) AS second_highest_cost
FROM Shipments s
JOIN Hubs h
ON s.origin_hub_id = h.hub_id
WHERE s.shipping_cost < (
    SELECT MAX(s2.shipping_cost)
    FROM Shipments s2
    WHERE s2.origin_hub_id = s.origin_hub_id
)
GROUP BY h.hub_name;