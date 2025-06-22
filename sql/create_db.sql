-- D:\pg\py\3.2.15\my_ai_docs_system_bk\db\create_db.sql
-- ローカル環境で PostgreSQL に「my_ai_docs_db」を作成し、
-- DBユーザー mydbuser へ権限付与する例

select current_setting('client_encoding'); -- 現在のクライアントエンコーディングを確認
set client_encoding to 'utf8'; -- 変更

CREATE DATABASE web_ledger OWNER mydbuser;

-- 必要な拡張機能の有効化
\c web_ledger mydbuser
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";