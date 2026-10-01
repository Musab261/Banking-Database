USE banking_db;

CREATE OR REPLACE VIEW account_summary AS
SELECT
    a.account_id,
    a.account_number,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    at.account_type_name,
    a.balance,
    a.currency,
    a.status,
    a.opened_at
FROM accounts a
JOIN customers c ON a.customer_id = c.customer_id
JOIN account_types at ON a.account_type_id = at.account_type_id;

CREATE OR REPLACE VIEW transaction_history AS
SELECT
    t.transaction_id,
    a.account_number,
    tt.transaction_type_name,
    t.amount,
    t.transaction_date,
    t.description,
    t.status,
    t.reference_code,
    t.reference_account_id
FROM transactions t
JOIN accounts a ON t.account_id = a.account_id
JOIN transaction_types tt ON t.transaction_type_id = tt.transaction_type_id;

CREATE OR REPLACE VIEW customer_loan_summary AS
SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    COUNT(l.loan_id) AS total_loans,
    COALESCE(SUM(l.principal_amount), 0) AS total_borrowed,
    COALESCE(SUM(l.outstanding_amount), 0) AS total_outstanding
FROM customers c
LEFT JOIN loans l ON c.customer_id = l.customer_id
GROUP BY c.customer_id, customer_name;
