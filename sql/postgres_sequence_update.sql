-- PostgreSQL Sequence update statements to prevent ID uniqueness violations
SELECT setval('web_ledger.role_master_id_seq', COALESCE((SELECT MAX(id) FROM web_ledger.role_master), 1), true);
SELECT setval('web_ledger.users_id_seq', COALESCE((SELECT MAX(id) FROM web_ledger.users), 1), true);
SELECT setval('web_ledger.ledger_master_id_seq', COALESCE((SELECT MAX(id) FROM web_ledger.ledger_master), 1), true);
SELECT setval('web_ledger.ledger_column_master_id_seq', COALESCE((SELECT MAX(id) FROM web_ledger.ledger_column_master), 1), true);
SELECT setval('web_ledger.ledger_records_id_seq', COALESCE((SELECT MAX(id) FROM web_ledger.ledger_records), 1), true);
SELECT setval('web_ledger.manuals_id_seq', COALESCE((SELECT MAX(id) FROM web_ledger.manuals), 1), true);
SELECT setval('web_ledger.version_history_id_seq', COALESCE((SELECT MAX(id) FROM web_ledger.version_history), 1), true);
SELECT setval('web_ledger.ledger_history_id_seq', COALESCE((SELECT MAX(id) FROM web_ledger.ledger_history), 1), true);
SELECT setval('web_ledger.audit_logs_id_seq', COALESCE((SELECT MAX(id) FROM web_ledger.audit_logs), 1), true);