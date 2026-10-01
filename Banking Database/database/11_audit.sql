USE banking_db;

SELECT
    audit_id,
    table_name,
    record_id,
    action_type,
    changed_at,
    changed_by
FROM audit_logs
ORDER BY changed_at DESC;

SELECT
    audit_id,
    record_id AS account_id,
    old_value,
    new_value,
    changed_at,
    changed_by
FROM audit_logs
WHERE table_name = 'accounts'
ORDER BY changed_at DESC;
