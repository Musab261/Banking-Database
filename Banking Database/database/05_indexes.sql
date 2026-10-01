USE banking_db;

CREATE INDEX idx_customer_email ON customers(email);
CREATE INDEX idx_customer_national_id ON customers(national_id);
CREATE INDEX idx_account_customer ON accounts(customer_id);
CREATE INDEX idx_account_status ON accounts(status);
CREATE INDEX idx_transaction_account ON transactions(account_id);
CREATE INDEX idx_transaction_date ON transactions(transaction_date);
CREATE INDEX idx_transaction_type ON transactions(transaction_type_id);
CREATE INDEX idx_transaction_reference ON transactions(reference_account_id);
CREATE INDEX idx_loan_customer ON loans(customer_id);
CREATE INDEX idx_loan_status ON loans(status);
CREATE INDEX idx_loan_payment_loan ON loan_payments(loan_id);

EXPLAIN
SELECT *
FROM transactions
WHERE account_id = 1
ORDER BY transaction_date DESC;
