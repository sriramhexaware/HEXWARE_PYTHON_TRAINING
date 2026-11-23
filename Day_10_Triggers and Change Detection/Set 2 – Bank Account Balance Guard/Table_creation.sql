use Hexaware

CREATE TABLE accounts
(
    account_id INT PRIMARY KEY,
    account_holder VARCHAR(100),
    account_type VARCHAR(20),
    balance DECIMAL(12,2)
);
CREATE TABLE account_transaction
(
    transaction_id INT IDENTITY(1,1) PRIMARY KEY,
    account_id INT,
    transaction_type VARCHAR(20),
    amount DECIMAL(12,2),
    transaction_date DATETIME DEFAULT GETDATE(),

    FOREIGN KEY (account_id)
    REFERENCES accounts(account_id)
);
INSERT INTO accounts
VALUES
(101, 'Arun', 'Savings', 10000),
(102, 'Bala', 'Savings', 15000),
(103, 'Charan', 'Savings', 20000),
(104, 'David', 'Current', 25000),
(105, 'Ezhil', 'Savings', 12000);
INSERT INTO account_transaction
(account_id, transaction_type, amount)
VALUES
(101, 'DEPOSIT', 2000),
(102, 'WITHDRAWAL', 1000),
(103, 'DEPOSIT', 5000);
CREATE TABLE transaction_audit
(
    audit_id INT IDENTITY(1,1) PRIMARY KEY,
    transaction_id INT,
    account_id INT,

    old_amount DECIMAL(12,2),
    new_amount DECIMAL(12,2),

    old_transaction_type VARCHAR(20),
    new_transaction_type VARCHAR(20),

    operation_type VARCHAR(20),
    changed_by VARCHAR(100),
    changed_at DATETIME DEFAULT GETDATE()
);