# 🏦 Banking & Transaction Management System — MySQL

A portfolio-ready relational banking database project built with MySQL.

## Project Goals

This project demonstrates database development concepts that are important for transaction-heavy systems:

- Relational database design
- Normalization
- Primary and foreign keys
- Data integrity constraints
- ACID transactions
- COMMIT / ROLLBACK / SAVEPOINT
- Row-level locking with `SELECT ... FOR UPDATE`
- Stored procedures
- Stored functions
- Triggers
- Views
- Indexing
- Query optimization with `EXPLAIN`
- Audit logging
- Database security
- CTEs
- Window functions
- Analytical SQL

## Main Features

- Customer management
- Multiple bank accounts per customer
- Savings, checking, and business accounts
- Deposits
- Withdrawals
- Account-to-account transfers
- Transaction history
- Beneficiaries
- Loans
- Loan payments
- Automatic loan balance updates
- Account audit logging
- Application and reporting database users

## Database Tables

1. `customers`
2. `addresses`
3. `account_types`
4. `accounts`
5. `transaction_types`
6. `transactions`
7. `beneficiaries`
8. `loans`
9. `loan_payments`
10. `audit_logs`

## Important Stored Procedures

- `transfer_money()`
- `deposit_money()`
- `withdraw_money()`

## Important Functions

- `get_account_balance()`
- `calculate_loan_interest()`

## Important Triggers

- `after_account_update`
- `after_loan_payment`

## Transaction Processing

The transfer procedure:

1. Validates the amount.
2. Validates sender and receiver accounts.
3. Starts a transaction.
4. Locks account rows using `SELECT ... FOR UPDATE`.
5. Checks the sender's available balance.
6. Deducts the sender balance.
7. Credits the receiver balance.
8. Records both transaction entries.
9. Commits the transaction.

If an SQL exception occurs, the transaction is rolled back and the error is re-raised.

## Security

Separate database users are included:

- `banking_app` — application access
- `banking_report` — reporting/read-only access

Real passwords must never be committed to GitHub.

## Project Structure

```text
banking-mysql-database/
│
├── README.md
├── database/
│   ├── 01_create_database.sql
│   ├── 02_create_tables.sql
│   ├── 03_constraints.sql
│   ├── 04_insert_data.sql
│   ├── 05_indexes.sql
│   ├── 06_views.sql
│   ├── 07_functions.sql
│   ├── 08_procedures.sql
│   ├── 09_triggers.sql
│   ├── 10_transactions.sql
│   ├── 11_audit.sql
│   ├── 12_security.sql
│   └── 13_advanced_queries.sql
│
└── screenshots/
    ├── er_diagram.png

## How to Run

Open MySQL Workbench and run the SQL files in numerical order:

```text
01_create_database.sql
02_create_tables.sql
03_constraints.sql
04_insert_data.sql
05_indexes.sql
06_views.sql
07_functions.sql
08_procedures.sql
09_triggers.sql
10_transactions.sql
11_audit.sql
12_security.sql
13_advanced_queries.sql
```

For the security script, replace the placeholder passwords with local development passwords. Do not commit real credentials.

## Testing the Transfer System

After all scripts have been run:

```sql
SELECT account_id, account_number, balance
FROM accounts
WHERE account_id IN (1, 3);

CALL transfer_money(
    1,
    3,
    500.00,
    'Portfolio project transfer'
);

SELECT account_id, account_number, balance
FROM accounts
WHERE account_id IN (1, 3);

SELECT *
FROM transaction_history
ORDER BY transaction_date DESC;

SELECT *
FROM audit_logs
ORDER BY changed_at DESC;
```

## Example Business Questions

The database can answer questions such as:

- Which customers have the highest total balance?
- Which accounts have the highest balances?
- What is the transaction volume?
- Which transaction types have the highest volume?
- Which customers have outstanding loans?
- Which customers have no loans?
- What is the total outstanding loan amount?
- What is the transaction history for an account?

## Portfolio Focus

This project is designed to demonstrate practical database-development skills rather than merely basic SQL querying.

The main focus is reliable transaction processing, data integrity, concurrency control, auditing, security, and query performance.

## Author

Muhammad Musab

Database Developer Portfolio Project
