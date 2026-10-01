USE banking_db;

-- 1. Customer accounts
SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    a.account_number,
    at.account_type_name,
    a.balance,
    a.status
FROM customers c
JOIN accounts a ON c.customer_id = a.customer_id
JOIN account_types at ON a.account_type_id = at.account_type_id
ORDER BY customer_name;

-- 2. Customers with total balance
SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    SUM(a.balance) AS total_balance
FROM customers c
JOIN accounts a ON c.customer_id = a.customer_id
GROUP BY c.customer_id, customer_name
ORDER BY total_balance DESC;

-- 3. Highest balance accounts
SELECT account_number, balance
FROM accounts
ORDER BY balance DESC
LIMIT 5;

-- 4. Transaction volume
SELECT
    DATE(transaction_date) AS transaction_day,
    COUNT(*) AS transaction_count,
    SUM(amount) AS transaction_volume
FROM transactions
WHERE status = 'Completed'
GROUP BY DATE(transaction_date)
ORDER BY transaction_day;

-- 5. Transaction volume by type
SELECT
    tt.transaction_type_name,
    COUNT(t.transaction_id) AS transaction_count,
    SUM(t.amount) AS total_amount
FROM transactions t
JOIN transaction_types tt
    ON t.transaction_type_id = tt.transaction_type_id
WHERE t.status = 'Completed'
GROUP BY tt.transaction_type_name
ORDER BY total_amount DESC;

-- 6. Customers with loans
SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    l.loan_type,
    l.principal_amount,
    l.outstanding_amount,
    l.status
FROM customers c
JOIN loans l ON c.customer_id = l.customer_id
ORDER BY l.outstanding_amount DESC;

-- 7. Customers with outstanding loans above $10,000
SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    SUM(l.outstanding_amount) AS total_outstanding
FROM customers c
JOIN loans l ON c.customer_id = l.customer_id
GROUP BY c.customer_id, customer_name
HAVING total_outstanding > 10000
ORDER BY total_outstanding DESC;

-- 8. CTE: high-value customers
WITH customer_balances AS (
    SELECT
        c.customer_id,
        CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
        SUM(a.balance) AS total_balance
    FROM customers c
    JOIN accounts a ON c.customer_id = a.customer_id
    GROUP BY c.customer_id, customer_name
)
SELECT *
FROM customer_balances
WHERE total_balance > 10000
ORDER BY total_balance DESC;

-- 9. Window function: account ranking
SELECT
    account_number,
    balance,
    RANK() OVER (ORDER BY balance DESC) AS balance_rank
FROM accounts;

-- 10. Customer account ranking
SELECT
    customer_name,
    total_balance,
    RANK() OVER (ORDER BY total_balance DESC) AS customer_rank
FROM (
    SELECT
        CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
        SUM(a.balance) AS total_balance
    FROM customers c
    JOIN accounts a ON c.customer_id = a.customer_id
    GROUP BY c.customer_id, customer_name
) AS customer_totals;

-- 11. Customers without loans
SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name
FROM customers c
LEFT JOIN loans l ON c.customer_id = l.customer_id
WHERE l.loan_id IS NULL;

-- 12. Account transaction history
SELECT
    a.account_number,
    tt.transaction_type_name,
    t.amount,
    t.transaction_date,
    t.description,
    t.status
FROM transactions t
JOIN accounts a ON t.account_id = a.account_id
JOIN transaction_types tt
    ON t.transaction_type_id = tt.transaction_type_id
WHERE a.account_number = '1000000001'
ORDER BY t.transaction_date DESC;
