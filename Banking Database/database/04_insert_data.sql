USE banking_db;

INSERT INTO customers
(first_name, last_name, email, phone, date_of_birth, national_id)
VALUES
('John', 'Smith', 'john.smith@email.com', '5551001', '1985-04-12', 'ID10001'),
('Sarah', 'Johnson', 'sarah.johnson@email.com', '5551002', '1990-07-21', 'ID10002'),
('Michael', 'Brown', 'michael.brown@email.com', '5551003', '1982-11-05', 'ID10003'),
('Emily', 'Davis', 'emily.davis@email.com', '5551004', '1995-02-17', 'ID10004'),
('Daniel', 'Wilson', 'daniel.wilson@email.com', '5551005', '1978-09-30', 'ID10005'),
('Olivia', 'Taylor', 'olivia.taylor@email.com', '5551006', '1992-12-08', 'ID10006'),
('James', 'Anderson', 'james.anderson@email.com', '5551007', '1988-03-25', 'ID10007'),
('Sophia', 'Thomas', 'sophia.thomas@email.com', '5551008', '1997-06-14', 'ID10008'),
('William', 'Moore', 'william.moore@email.com', '5551009', '1980-10-11', 'ID10009'),
('Ava', 'Martin', 'ava.martin@email.com', '5551010', '1993-01-19', 'ID10010');

INSERT INTO addresses
(customer_id, address_line, city, state, postal_code, country)
VALUES
(1, '123 Main Street', 'New York', 'NY', '10001', 'USA'),
(2, '45 Oak Avenue', 'Los Angeles', 'CA', '90001', 'USA'),
(3, '78 Pine Road', 'Chicago', 'IL', '60601', 'USA'),
(4, '90 Lake Street', 'Houston', 'TX', '77001', 'USA'),
(5, '22 Market Street', 'Phoenix', 'AZ', '85001', 'USA'),
(6, '14 Park Avenue', 'Seattle', 'WA', '98101', 'USA'),
(7, '33 Hill Road', 'Boston', 'MA', '02108', 'USA'),
(8, '55 River Road', 'Denver', 'CO', '80202', 'USA'),
(9, '88 King Street', 'Miami', 'FL', '33101', 'USA'),
(10, '12 Queen Avenue', 'Dallas', 'TX', '75201', 'USA');

INSERT INTO account_types
(account_type_name, minimum_balance, annual_interest_rate)
VALUES
('Savings', 100.00, 3.50),
('Checking', 0.00, 0.00),
('Business', 500.00, 1.50);

INSERT INTO transaction_types
(transaction_type_name)
VALUES
('Deposit'),
('Withdrawal'),
('Transfer'),
('Fee'),
('Interest');

INSERT INTO accounts
(customer_id, account_type_id, account_number, balance, currency)
VALUES
(1, 1, '1000000001', 5000.00, 'USD'),
(1, 2, '2000000001', 2500.00, 'USD'),
(2, 1, '1000000002', 7500.00, 'USD'),
(3, 2, '2000000002', 3200.00, 'USD'),
(4, 1, '1000000003', 10000.00, 'USD'),
(5, 3, '3000000001', 25000.00, 'USD'),
(6, 1, '1000000004', 6200.00, 'USD'),
(7, 2, '2000000003', 1800.00, 'USD'),
(8, 1, '1000000005', 4500.00, 'USD'),
(9, 3, '3000000002', 35000.00, 'USD'),
(10, 2, '2000000004', 2900.00, 'USD');

INSERT INTO beneficiaries
(customer_id, beneficiary_name, account_number, bank_name)
VALUES
(1, 'Sarah Johnson', '1000000002', 'Demo Bank'),
(2, 'John Smith', '1000000001', 'Demo Bank'),
(3, 'Emily Davis', '1000000003', 'Demo Bank'),
(4, 'Michael Brown', '2000000002', 'Demo Bank'),
(5, 'Olivia Taylor', '1000000004', 'Demo Bank');

INSERT INTO loans
(customer_id, loan_type, principal_amount, interest_rate, term_months, outstanding_amount, start_date)
VALUES
(1, 'Personal Loan', 10000.00, 8.50, 24, 8500.00, '2026-01-10'),
(3, 'Auto Loan', 25000.00, 6.75, 60, 22000.00, '2026-02-15'),
(5, 'Business Loan', 50000.00, 7.25, 48, 47000.00, '2026-03-01'),
(7, 'Personal Loan', 8000.00, 9.00, 24, 6000.00, '2026-04-20');

INSERT INTO loan_payments
(loan_id, amount, payment_method)
VALUES
(1, 500.00, 'Bank Transfer'),
(1, 500.00, 'Direct Debit'),
(2, 750.00, 'Bank Transfer'),
(3, 1500.00, 'Direct Debit'),
(4, 400.00, 'Debit Card');

INSERT INTO transactions
(account_id, transaction_type_id, amount, description, status, reference_code)
VALUES
(1, 1, 2000.00, 'Salary Deposit', 'Completed', 'TXN100001'),
(1, 2, 250.00, 'ATM Withdrawal', 'Completed', 'TXN100002'),
(2, 1, 1000.00, 'Cash Deposit', 'Completed', 'TXN100003'),
(3, 1, 3000.00, 'Salary Deposit', 'Completed', 'TXN100004'),
(4, 2, 500.00, 'ATM Withdrawal', 'Completed', 'TXN100005'),
(5, 1, 5000.00, 'Business Revenue', 'Completed', 'TXN100006'),
(6, 2, 300.00, 'ATM Withdrawal', 'Completed', 'TXN100007'),
(7, 1, 1000.00, 'Salary Deposit', 'Completed', 'TXN100008'),
(8, 2, 200.00, 'ATM Withdrawal', 'Completed', 'TXN100009'),
(9, 1, 10000.00, 'Business Revenue', 'Completed', 'TXN100010');
