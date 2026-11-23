use Hexaware

CREATE TABLE products
(
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    cost_price DECIMAL(10,2)
);
CREATE TABLE product_price
(
    product_id INT PRIMARY KEY,
    selling_price DECIMAL(10,2),

    FOREIGN KEY (product_id)
    REFERENCES products(product_id)
);
INSERT INTO products
VALUES
(1, 'Laptop', 40000),
(2, 'Keyboard', 500),
(3, 'Mouse', 200),
(4, 'Monitor', 8000);

INSERT INTO product_price
VALUES
(1, 50000),
(2, 800),
(3, 350),
(4, 10000);
SELECT 
    p.product_id,
    p.product_name,
    p.cost_price,
    pp.selling_price
FROM products p
JOIN product_price pp
ON p.product_id = pp.product_id;