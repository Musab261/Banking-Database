USE banking_db;

CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(20) NOT NULL UNIQUE,
    date_of_birth DATE NOT NULL,
    national_id VARCHAR(50) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE addresses (
    address_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    address_line VARCHAR(255) NOT NULL,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100),
    postal_code VARCHAR(20),
    country VARCHAR(100) NOT NULL,
    CONSTRAINT fk_address_customer
        FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
        ON DELETE CASCADE
);

CREATE TABLE account_types (
    account_type_id INT AUTO_INCREMENT PRIMARY KEY,
    account_type_name VARCHAR(50) NOT NULL UNIQUE,
    minimum_balance DECIMAL(15,2) DEFAULT 0,
    annual_interest_rate DECIMAL(5,2) DEFAULT 0,
    CONSTRAINT chk_minimum_balance
        CHECK (minimum_balance >= 0),
    CONSTRAINT chk_interest_rate
        CHECK (annual_interest_rate >= 0)
);

CREATE TABLE accounts (
    account_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    account_type_id INT NOT NULL,
    account_number VARCHAR(20) NOT NULL UNIQUE,
    balance DECIMAL(15,2) NOT NULL DEFAULT 0,
    currency CHAR(3) NOT NULL DEFAULT 'USD',
    status ENUM('Active', 'Frozen', 'Closed') DEFAULT 'Active',
    opened_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_account_customer
        FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    CONSTRAINT fk_account_type
        FOREIGN KEY (account_type_id) REFERENCES account_types(account_type_id),
    CONSTRAINT chk_account_balance
        CHECK (balance >= 0)
);

CREATE TABLE transaction_types (
    transaction_type_id INT AUTO_INCREMENT PRIMARY KEY,
    transaction_type_name VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE transactions (
    transaction_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    account_id INT NOT NULL,
    transaction_type_id INT NOT NULL,
    reference_account_id INT NULL,
    amount DECIMAL(15,2) NOT NULL,
    transaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    description VARCHAR(255),
    status ENUM('Pending', 'Completed', 'Failed', 'Reversed') DEFAULT 'Completed',
    reference_code VARCHAR(80) UNIQUE,
    CONSTRAINT fk_transaction_account
        FOREIGN KEY (account_id) REFERENCES accounts(account_id),
    CONSTRAINT fk_transaction_type
        FOREIGN KEY (transaction_type_id) REFERENCES transaction_types(transaction_type_id),
    CONSTRAINT fk_reference_account
        FOREIGN KEY (reference_account_id) REFERENCES accounts(account_id),
    CONSTRAINT chk_transaction_amount
        CHECK (amount > 0)
);

CREATE TABLE beneficiaries (
    beneficiary_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    beneficiary_name VARCHAR(100) NOT NULL,
    account_number VARCHAR(20) NOT NULL,
    bank_name VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_beneficiary_customer
        FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
        ON DELETE CASCADE
);

CREATE TABLE loans (
    loan_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    loan_type VARCHAR(50) NOT NULL,
    principal_amount DECIMAL(15,2) NOT NULL,
    interest_rate DECIMAL(5,2) NOT NULL,
    term_months INT NOT NULL,
    outstanding_amount DECIMAL(15,2) NOT NULL,
    status ENUM('Active', 'Paid', 'Defaulted') DEFAULT 'Active',
    start_date DATE NOT NULL,
    CONSTRAINT fk_loan_customer
        FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    CONSTRAINT chk_loan_principal CHECK (principal_amount > 0),
    CONSTRAINT chk_loan_interest CHECK (interest_rate >= 0),
    CONSTRAINT chk_loan_term CHECK (term_months > 0),
    CONSTRAINT chk_outstanding CHECK (outstanding_amount >= 0)
);

CREATE TABLE loan_payments (
    loan_payment_id INT AUTO_INCREMENT PRIMARY KEY,
    loan_id INT NOT NULL,
    amount DECIMAL(15,2) NOT NULL,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    payment_method ENUM('Bank Transfer', 'Debit Card', 'Cash', 'Direct Debit') NOT NULL,
    CONSTRAINT fk_loan_payment_loan
        FOREIGN KEY (loan_id) REFERENCES loans(loan_id)
        ON DELETE CASCADE,
    CONSTRAINT chk_loan_payment_amount CHECK (amount > 0)
);

CREATE TABLE audit_logs (
    audit_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    table_name VARCHAR(100) NOT NULL,
    record_id BIGINT NOT NULL,
    action_type ENUM('INSERT', 'UPDATE', 'DELETE') NOT NULL,
    old_value JSON NULL,
    new_value JSON NULL,
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    changed_by VARCHAR(100)
);
