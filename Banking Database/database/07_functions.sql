USE banking_db;

DROP FUNCTION IF EXISTS get_account_balance;
DROP FUNCTION IF EXISTS calculate_loan_interest;

DELIMITER //

CREATE FUNCTION get_account_balance(p_account_id INT)
RETURNS DECIMAL(15,2)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE current_balance DECIMAL(15,2);

    SELECT balance
    INTO current_balance
    FROM accounts
    WHERE account_id = p_account_id;

    RETURN COALESCE(current_balance, 0);
END //

CREATE FUNCTION calculate_loan_interest(
    p_principal DECIMAL(15,2),
    p_interest_rate DECIMAL(5,2),
    p_months INT
)
RETURNS DECIMAL(15,2)
DETERMINISTIC
BEGIN
    RETURN p_principal * (p_interest_rate / 100) * (p_months / 12);
END //

DELIMITER ;

SELECT get_account_balance(1);
SELECT calculate_loan_interest(10000, 8.5, 24);
