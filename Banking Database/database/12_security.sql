USE banking_db;

-- Replace these placeholder passwords before using outside a local demo.
CREATE USER IF NOT EXISTS
'banking_app'@'localhost'
IDENTIFIED BY 'CHANGE_THIS_PASSWORD';

GRANT SELECT, INSERT, UPDATE
ON banking_db.*
TO 'banking_app'@'localhost';

CREATE USER IF NOT EXISTS
'banking_report'@'localhost'
IDENTIFIED BY 'CHANGE_THIS_PASSWORD';

GRANT SELECT
ON banking_db.*
TO 'banking_report'@'localhost';

SHOW GRANTS FOR 'banking_app'@'localhost';
SHOW GRANTS FOR 'banking_report'@'localhost';

FLUSH PRIVILEGES;
