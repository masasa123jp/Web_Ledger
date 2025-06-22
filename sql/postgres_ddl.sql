-- 1. スキーマの作成
CREATE SCHEMA IF NOT EXISTS web_ledger;

---------------------------------------------------
-- 2. 認証関連テーブル
---------------------------------------------------
-- 2-1. 役割管理テーブル
CREATE TABLE web_ledger.role_master (
    id SERIAL PRIMARY KEY,
    role_name TEXT NOT NULL UNIQUE
);

-- 2-2. ユーザーテーブル
CREATE TABLE web_ledger.users (
    id SERIAL PRIMARY KEY,
    username TEXT NOT NULL UNIQUE,
    password TEXT NOT NULL,
    role_id INTEGER NOT NULL,
    FOREIGN KEY (role_id) REFERENCES web_ledger.role_master(id)
);

---------------------------------------------------
-- 3. 統合マスタ管理テーブル
---------------------------------------------------
-- 3-1. マスタ種別テーブル
CREATE TABLE web_ledger.master_types (
    id SERIAL PRIMARY KEY,
    master_type VARCHAR(100) NOT NULL UNIQUE,  -- 例: OS, Middleware, AccountingYear, Quarter, Month, Initiative, Person, Organization, Ledger, System
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 3-2. マスタ項目定義テーブル
CREATE TABLE web_ledger.master_field_definitions (
    id SERIAL PRIMARY KEY,
    master_id INTEGER NOT NULL REFERENCES web_ledger.master_types(id) ON DELETE CASCADE,
    field_name VARCHAR(100) NOT NULL,
    data_type VARCHAR(50) NOT NULL,
    max_length INTEGER,
    display_order INTEGER,
    is_required BOOLEAN DEFAULT true,
    input_constraints TEXT,
    UNIQUE (master_id, field_name),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    tag TEXT NOT NULL
);



-- 3-3. 統合マスタレコードテーブル
CREATE TABLE web_ledger.unified_master_records (
    id SERIAL PRIMARY KEY,
    master_id INTEGER NOT NULL REFERENCES web_ledger.master_types(id) ON DELETE CASCADE,
    record_data JSONB NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- インデックス作成（パフォーマンス向上のため）
CREATE INDEX IF NOT EXISTS idx_master_types_type ON web_ledger.master_types(master_type);
CREATE INDEX IF NOT EXISTS idx_field_definitions_master ON web_ledger.master_field_definitions(master_id);
CREATE INDEX IF NOT EXISTS idx_ledger_records_unified_master ON web_ledger.ledger_records(unified_master_id);

---------------------------------------------------
-- 4. 台帳トランザクション管理テーブル
---------------------------------------------------
-- 4-1. 台帳運用データテーブル
CREATE TABLE web_ledger.ledger_records (
    id SERIAL PRIMARY KEY,
    ledger_definition_id INTEGER NOT NULL REFERENCES web_ledger.unified_master_records(id),
    data_id INTEGER NOT NULL,
    column_id INTEGER NOT NULL,
    unified_master_id INTEGER NOT NULL,
    data TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 4-2. 台帳更新履歴テーブル
CREATE TABLE web_ledger.ledger_history (
    id SERIAL PRIMARY KEY,
    ledger_definition_id INTEGER NOT NULL REFERENCES web_ledger.unified_master_records(id),
    update_row INTEGER NOT NULL,
    updated_by TEXT NOT NULL,
    update_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    update_details TEXT
);

-- 4-3. 監査ログテーブル
CREATE TABLE web_ledger.audit_logs (
    id SERIAL PRIMARY KEY,
    action TEXT NOT NULL,
    details TEXT,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

---------------------------------------------------
-- 5. その他管理テーブル
---------------------------------------------------
-- 5-1. マニュアルテーブル
CREATE TABLE web_ledger.manuals (
    id SERIAL PRIMARY KEY,
    title TEXT NOT NULL,
    content TEXT,
    updated_by TEXT,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 5-2. バージョン履歴テーブル
CREATE TABLE web_ledger.version_history (
    id SERIAL PRIMARY KEY,
    version TEXT NOT NULL,
    sprint TEXT NOT NULL,
    update_info TEXT,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);