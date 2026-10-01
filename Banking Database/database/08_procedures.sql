USE banking_db;

DROP PROCEDURE IF EXISTS transfer_money;
DROP PROCEDURE IF EXISTS deposit_money;
DROP PROCEDURE IF EXISTS withdraw_money;

DELIMITER //

CREATE PROCEDURE transfer_money(
    IN p_sender_account INT,
    IN p_receiver_account INT,
    IN p_amount DECIMAL(15,2),
    IN p_description VARCHAR(255)
)
main: BEGIN
    DECLARE sender_balance DECIMAL(15,2);
    DECLARE sender_status VARCHAR(20);
    DECLARE receiver_status VARCHAR(20);
    DECLARE transfer_type INT;
    DECLARE transaction_code VARCHAR(80);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    IF p_amount <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Transfer amount must be greater than zero';
    END IF;

    IF p_sender_account = p_receiver_account THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Sender and receiver accounts cannot be the same';
    END IF;

    START TRANSACTION;

    SELECT balance, status
    INTO sender_balance, sender_status
    FROM accounts
    WHERE account_id = p_sender_account
    FOR UPDATE;

    IF sender_status IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Sender account does not exist';
    END IF;

    SELECT status
    INTO receiver_status
    FROM accounts
    WHERE account_id = p_receiver_account
    FOR UPDATE;

    IF receiver_status IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Receiver account does not exist';
    END IF;

    IF sender_status <> 'Active' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Sender account is not active';
    END IF;

    IF receiver_status <> 'Active' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Receiver account is not active';
    END IF;

    IF sender_balance < p_amount THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Insufficient funds';
    END IF;

    SELECT transaction_type_id
    INTO transfer_type
    FROM transaction_types
    WHERE transaction_type_name = 'Transfer';

    SET transaction_code = CONCAT('TRF-', UUID_SHORT());

    UPDATE accounts
    SET balance = balance - p_amount
    WHERE account_id = p_sender_account;

    UPDATE accounts
    SET balance = balance + p_amount
    WHERE account_id = p_receiver_account;

    INSERT INTO transactions
    (
        account_id, transaction_type_id, reference_account_id,
        amount, description, status, reference_code
    )
    VALUES
    (
        p_sender_account, transfer_type, p_receiver_account,
        p_amount, p_description, 'Completed', transaction_code
    );

    INSERT INTO transactions
    (
        account_id, transaction_type_id, reference_account_id,
        amount, description, status, reference_code
    )
    VALUES
    (
        p_receiver_account, transfer_type, p_sender_account,
        p_amount, p_description, 'Completed',
        CONCAT(transaction_code, '-R')
    );

    COMMIT;

    SELECT 'Transfer completed successfully' AS message,
           transaction_code AS reference_code;
END //

CREATE PROCEDURE deposit_money(
    IN p_account_id INT,
    IN p_amount DECIMAL(15,2),
    IN p_description VARCHAR(255)
)
BEGIN
    DECLARE account_status VARCHAR(20);
    DECLARE deposit_type INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    IF p_amount <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Deposit amount must be greater than zero';
    END IF;

    START TRANSACTION;

    SELECT status
    INTO account_status
    FROM accounts
    WHERE account_id = p_account_id
    FOR UPDATE;

    IF account_status IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Account does not exist';
    END IF;

    IF account_status <> 'Active' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Account is not active';
    END IF;

    SELECT transaction_type_id
    INTO deposit_type
    FROM transaction_types
    WHERE transaction_type_name = 'Deposit';

    UPDATE accounts
    SET balance = balance + p_amount
    WHERE account_id = p_account_id;

    INSERT INTO transactions
    (
        account_id, transaction_type_id, amount,
        description, status, reference_code
    )
    VALUES
    (
        p_account_id, deposit_type, p_amount,
        p_description, 'Completed', CONCAT('DEP-', UUID_SHORT())
    );

    COMMIT;

    SELECT 'Deposit completed successfully' AS message;
END //

CREATE PROCEDURE withdraw_money(
    IN p_account_id INT,
    IN p_amount DECIMAL(15,2),
    IN p_description VARCHAR(255)
)
BEGIN
    DECLARE current_balance DECIMAL(15,2);
    DECLARE account_status VARCHAR(20);
    DECLARE withdrawal_type INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    IF p_amount <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Withdrawal amount must be greater than zero';
    END IF;

    START TRANSACTION;

    SELECT balance, status
    INTO current_balance, account_status
    FROM accounts
    WHERE account_id = p_account_id
    FOR UPDATE;

    IF account_status IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Account does not exist';
    END IF;

    IF account_status <> 'Active' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Account is not active';
    END IF;

    IF current_balance < p_amount THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Insufficient funds';
    END IF;

    SELECT transaction_type_id
    INTO withdrawal_type
    FROM transaction_types
    WHERE transaction_type_name = 'Withdrawal';

    UPDATE accounts
    SET balance = balance - p_amount
    WHERE account_id = p_account_id;

    INSERT INTO transactions
    (
        account_id, transaction_type_id, amount,
        description, status, reference_code
    )
    VALUES
    (
        p_account_id, withdrawal_type, p_amount,
        p_description, 'Completed', CONCAT('WDR-', UUID_SHORT())
    );

    COMMIT;

    SELECT 'Withdrawal completed successfully' AS message;
END //

DELIMITER ;
