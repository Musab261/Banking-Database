USE banking_db;

DROP TRIGGER IF EXISTS after_account_update;
DROP TRIGGER IF EXISTS after_loan_payment;

DELIMITER //

CREATE TRIGGER after_account_update
AFTER UPDATE ON accounts
FOR EACH ROW
BEGIN
    IF NOT (OLD.balance <=> NEW.balance)
       OR NOT (OLD.status <=> NEW.status) THEN

        INSERT INTO audit_logs
        (
            table_name,
            record_id,
            action_type,
            old_value,
            new_value,
            changed_by
        )
        VALUES
        (
            'accounts',
            OLD.account_id,
            'UPDATE',
            JSON_OBJECT(
                'balance', OLD.balance,
                'status', OLD.status
            ),
            JSON_OBJECT(
                'balance', NEW.balance,
                'status', NEW.status
            ),
            CURRENT_USER()
        );
    END IF;
END //

CREATE TRIGGER after_loan_payment
AFTER INSERT ON loan_payments
FOR EACH ROW
BEGIN
    UPDATE loans
    SET outstanding_amount = GREATEST(outstanding_amount - NEW.amount, 0),
        status = CASE
            WHEN GREATEST(outstanding_amount - NEW.amount, 0) = 0
            THEN 'Paid'
            ELSE status
        END
    WHERE loan_id = NEW.loan_id;
END //

DELIMITER ;
