USE banking_db;

ALTER TABLE customers
ADD CONSTRAINT chk_customer_email
CHECK (email LIKE '%@%');

-- Date-of-birth validation is intentionally handled by application logic
-- rather than a CHECK using CURRENT_DATE, because MySQL restrictions on
-- non-deterministic expressions in CHECK constraints vary by version.
