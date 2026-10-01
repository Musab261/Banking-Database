USE banking_db;

-- Successful manual transfer example.
START TRANSACTION;

UPDATE accounts
SET balance = balance - 100
WHERE account_id = 1;

UPDATE accounts
SET balance = balance + 100
WHERE account_id = 3;

COMMIT;

-- Rollback example.
START TRANSACTION;

UPDATE accounts
SET balance = balance - 1000
WHERE account_id = 1;

SELECT account_id, account_number, balance
FROM accounts
WHERE account_id = 1;

ROLLBACK;

-- Savepoint example.
START TRANSACTION;

UPDATE accounts
SET balance = balance - 100
WHERE account_id = 1;

SAVEPOINT after_first_operation;

UPDATE accounts
SET balance = balance - 200
WHERE account_id = 1;

ROLLBACK TO SAVEPOINT after_first_operation;

COMMIT;
