-- =============================
-- Sprint5 から Sprint6 への DB マイグレーションスクリプト例
-- ※実行前に必ずバックアップを取得してください
-- =============================

BEGIN;

-- 1. 新規テーブルの作成
-- 1.1. master_types テーブル（統一マスターの種類を管理）
CREATE TABLE web_ledger.master_types (
    id SERIAL PRIMARY KEY,
    master_type VARCHAR(100) NOT NULL UNIQUE,  -- 例: OS, Middleware, AccountingYear, Quarter, Month, Initiative, Person, Organization, Ledger, System
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 1.2. master_field_definitions テーブル（各マスターの項目定義）
CREATE TABLE IF NOT EXISTS web_ledger.master_field_definitions (
    id SERIAL PRIMARY KEY,
    master_id INTEGER NOT NULL REFERENCES web_ledger.master_types(id) ON DELETE CASCADE,
    field_name VARCHAR(100) NOT NULL,
    data_type VARCHAR(50) NOT NULL,
    max_length INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

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
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 1.3. unified_master_records テーブル（必要に応じて、統一マスターの実データを格納）
CREATE TABLE IF NOT EXISTS web_ledger.unified_master_records (
    id SERIAL PRIMARY KEY,
    master_type_id INTEGER NOT NULL REFERENCES web_ledger.master_types(id),
    record_data JSONB,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. 既存テーブルの改修
-- 2.1. ledger_records テーブルに新カラムの追加（統一マスター連携用、更新日時）
ALTER TABLE web_ledger.ledger_records
--    ADD COLUMN IF NOT EXISTS unified_master_id INTEGER,
    ADD COLUMN IF NOT EXISTS updated_at TIMESTAMP;

UPDATE web_ledger.ledger_records
SET unified_master_id = ledger_master_id
WHERE unified_master_id IS DISTINCT FROM ledger_master_id;

-- 3. インデックスおよび制約の追加
CREATE INDEX IF NOT EXISTS idx_master_types_type ON web_ledger.master_types(master_type);
CREATE INDEX IF NOT EXISTS idx_field_definitions_master ON web_ledger.master_field_definitions(master_id);
CREATE INDEX IF NOT EXISTS idx_ledger_records_unified_master ON web_ledger.ledger_records(unified_master_id);

-- 4. 既存データの移行（必要に応じた例）
-- 4.1. 旧台帳マスターから新規 master_types への移行
--INSERT INTO web_ledger.master_types (master_type)
--SELECT DISTINCT ledger_name
--FROM web_ledger.ledger_master
--ON CONFLICT (master_type) DO NOTHING;

-- 4.2. ledger_column_master の項目定義を master_field_definitions へ移行
INSERT INTO web_ledger.master_field_definitions (master_id, field_name, data_type, max_length, display_order)
SELECT mt.id, lcm.column_name, lcm.data_type, lcm.max_length, lcm.display_order
FROM web_ledger.ledger_column_master lcm
JOIN web_ledger.ledger_master lm ON lcm.ledger_master_id = lm.id
JOIN web_ledger.master_types mt ON lm.ledger_name = mt.master_type
ORDER BY lcm.id
ON CONFLICT DO NOTHING

-- 4.3. ledger_records の更新日時を初期値で埋める
UPDATE web_ledger.ledger_records
SET updated_at = CURRENT_TIMESTAMP
WHERE updated_at IS NULL;

-- 1: システム管理者向けマニュアル
UPDATE web_ledger.manuals
SET
    title = 'システム管理者向けマニュアル',
    content = $$はじめに：アプリケーション概要
このアプリは、最新のWeb台帳管理システムとして、業務データの入力、管理、分析を一元化するために設計されています。柔軟かつ拡張性に富んだモジュール構成により、従来の機能に加え、以下の特長を実現しています。

1.1 システム概要と新機能のポイント
• モジュール再構成
  従来の設定ファイルは廃止し、すべて config.py に統一。機能が明確に分離され統合管理。
• 新たな機能
  バージョン情報画面、ユーザー管理画面、マニュアル画面、生成AI画面、ピボットテーブル画面の個別保持。
  非同期タスク（Celery）、キャッシュ（Redis）などパフォーマンス管理機能強化。

1.2 インストール・セットアップ
• 環境設定：config.py で SECRET_KEY、DB接続情報、APIキー等を管理。
• データベース設定：PostgreSQL。sql/ 内DDLを用いてマイグレーション。
• 依存ライブラリ：requirements.txt からインストール。

1.3 運用・監視
• ログ管理：詳細ログ出力を定期監視。
• 非同期タスク／キャッシュ：Flower や Redis モニタで状態確認。
• アップデート：バージョン情報APIでシステム全体のバージョン管理。
$$,
    updated_by = 'admin',
    updated_at = NOW()
WHERE id = 1;

-- 2: 管理職向けマニュアル
UPDATE web_ledger.manuals
SET
    title = '管理職向けマニュアル',
    content = $$はじめに：アプリケーション概要
このアプリは、最新のWeb台帳管理システムとして、業務データの入力、管理、分析を一元化します。直感的な管理画面で意思決定を支援します。

2.1 システム概要と管理画面の利用
• 主要管理画面：バージョン情報、ユーザー管理、マニュアル、生成AI
• 各画面でシステム状態確認、ユーザー権限設定、オンラインマニュアル閲覧、AI支援利用が可能

2.2 管理画面の利用方法
• アクセス：トップページまたは管理者ダッシュボードから各URLへ
• 機能：
  - バージョン情報：最新バージョン・更新履歴確認
  - ユーザー管理：追加・編集・削除、操作ログ記録
  - マニュアル：オンラインで閲覧・更新
  - 生成AI：チャット形式で業務支援、利用状況レポート収集

2.3 業務改善と意思決定の支援
• ダッシュボードとレポートで業績分析・プロセス改善
• 定期的にレポート画面を確認し意思決定に活用
$$,
    updated_by = 'admin',
    updated_at = NOW()
WHERE id = 2;

-- 3: 一般従業員向けマニュアル
UPDATE web_ledger.manuals
SET
    title = '一般従業員向けマニュアル',
    content = $$はじめに：アプリケーション概要
このアプリは、最新のWeb台帳管理システムとして、業務データの入力、管理、分析を一元化し、直感的なUIで誰でも簡単に操作可能です。

3.1 アプリケーションの基本操作
• トップページから台帳入力、レポート、チャット、ピボットテーブルへアクセス

3.2 台帳入力とデータ管理
• 台帳入力フォーム：動的生成フォームでリアルタイム検証
• ピボットテーブル：データ集計・分析を表形式で表示

3.3 レポートと生成AIの利用
• レポートダッシュボード：グラフ形式で業務状況を可視化
• 生成AIチャット：リアルタイム応答で疑問解決・改善提案

3.4 利用上の注意事項
• 正しい形式でデータ入力
• 不明点・エラーは管理者へ連絡
• 画面上のヘルプ情報を参照
$$,
    updated_by = 'admin',
    updated_at = NOW()
WHERE id = 3;

-- ledger_master_mapping テーブル作成例
CREATE TABLE web_ledger.ledger_master_mapping (
    id SERIAL PRIMARY KEY,
    master_type_id INTEGER NOT NULL,
    field_name character varying(100) NOT NULL,
    tag text NOT NULL,
    CONSTRAINT fk_master_types FOREIGN KEY (master_type_id)
        REFERENCES web_ledger.master_types(id)
        ON UPDATE NO ACTION
        ON DELETE CASCADE,
    CONSTRAINT fk_master_field_definitions FOREIGN KEY (master_type_id, field_name, tag)
        REFERENCES web_ledger.master_field_definitions (master_id, field_name, tag)
        ON UPDATE NO ACTION
        ON DELETE CASCADE
);



-- 既存の一意性制約を削除
ALTER TABLE web_ledger.master_field_definitions
DROP CONSTRAINT master_field_definitions_master_id_field_name_key;

-- ledger_id と field_name の組み合わせで新たな一意性制約を追加
ALTER TABLE web_ledger.master_field_definitions
ADD CONSTRAINT master_field_definitions_master_id_field_name_tag_key UNIQUE (master_id, field_name,tag);

INSERT INTO web_ledger.master_field_definitions (id, tag, master_id, field_name, data_type, max_length, display_order, is_required)
VALUES
  (1, 'LEDGER001', 14,'ID', 'number', 200, 101, FALSE),
  (2, 'LEDGER001', 14,'テーマ名', 'text', 200, 102, TRUE),
  (3, 'LEDGER001', 14,'年度', 'number', 200, 103, TRUE),
  (4, 'LEDGER001', 14,'予算種別', 'text', 200, 104, TRUE),
  (5, 'LEDGER001', 14,'予算番号', 'text', 200, 105, TRUE),
  (6, 'LEDGER001', 14,'予算名称', 'text', 200, 106, TRUE),
  (7, 'LEDGER001', 14,'予算額', 'number', 200, 107, TRUE),
  (8, 'LEDGER001', 14,'利用部門', 'text', 200, 108, TRUE),
  (9, 'LEDGER001', 14,'振替部門', 'text', 200, 110, TRUE),
  (10, 'LEDGER001', 14,'dummy1', 'text', 200, 151, FALSE),
  (11, 'LEDGER001', 14,'dummy2', 'text', 200, 152, FALSE),
  (12, 'LEDGER001', 14,'dummy3', 'text', 200, 153, FALSE),
  (13, 'LEDGER001', 14,'dummy4', 'text', 200, 154, FALSE),
  (14, 'LEDGER001', 14,'dummy5', 'text', 200, 155, FALSE),
  (15, 'LEDGER001', 14,'dummy6', 'text', 200, 156, FALSE),
  (16, 'LEDGER001', 14,'dummy7', 'text', 200, 157, FALSE),
  (17, 'LEDGER001', 14,'dummy8', 'text', 200, 158, FALSE),
  (18, 'LEDGER001', 14,'dummy9', 'text', 200, 159, FALSE),
  (19, 'LEDGER001', 14,'dummy10', 'text', 200, 160, FALSE),
  (20, 'LEDGER001', 14,'dummy11', 'text', 200, 161, FALSE),
  (21, 'LEDGER001', 14,'dummy12', 'text', 200, 162, FALSE),
  (22, 'LEDGER001', 14,'dummy13', 'text', 200, 163, FALSE),
  (23, 'LEDGER001', 14,'dummy14', 'text', 200, 164, FALSE),
  (24, 'LEDGER001', 14,'dummy15', 'text', 200, 165, FALSE),
  (25, 'LEDGER001', 14,'dummy16', 'text', 200, 166, FALSE),
  (26, 'LEDGER001', 14,'dummy17', 'text', 200, 167, FALSE),
  (27, 'LEDGER001', 14,'dummy18', 'text', 200, 168, FALSE),
  (28, 'LEDGER001', 14,'dummy19', 'text', 200, 169, FALSE),
  (29, 'LEDGER001', 14,'dummy20', 'text', 200, 170, FALSE),
  (30, 'LEDGER002', 14,'ID', 'number', 200, 101, FALSE),
  (31, 'LEDGER002', 14,'年度', 'text', 200, 102, TRUE),
  (32, 'LEDGER002', 14,'予算種別', 'number', 200, 103, TRUE),
  (33, 'LEDGER002', 14,'予算番号', 'text', 200, 104, TRUE),
  (34, 'LEDGER002', 14,'予算名称', 'text', 200, 105, TRUE),
  (35, 'LEDGER002', 14,'予算額', 'number', 200, 106, TRUE),
  (36, 'LEDGER002', 14,'利用部門', 'text', 200, 107, TRUE),
  (37, 'LEDGER002', 14,'振替部門', 'text', 200, 108, TRUE),
  (38, 'LEDGER002', 14,'発注部門', 'text', 200, 109, TRUE),
  (39, 'LEDGER002', 14,'発注担当者', 'text', 200, 110, TRUE),
  (40, 'LEDGER002', 14,'発注日', 'date', 200, 111, TRUE),
  (41, 'LEDGER002', 14,'検収担当者', 'text', 200, 112, TRUE),
  (42, 'LEDGER002', 14,'検収完了日', 'date', 200, 113, TRUE),
  (43, 'LEDGER002', 14,'dummy1', 'text', 200, 151, FALSE),
  (44, 'LEDGER002', 14,'dummy2', 'text', 200, 152, FALSE),
  (45, 'LEDGER002', 14,'dummy3', 'text', 200, 153, FALSE),
  (46, 'LEDGER002', 14,'dummy4', 'text', 200, 154, FALSE),
  (47, 'LEDGER002', 14,'dummy5', 'text', 200, 155, FALSE),
  (48, 'LEDGER002', 14,'dummy6', 'text', 200, 156, FALSE),
  (49, 'LEDGER002', 14,'dummy7', 'text', 200, 157, FALSE),
  (50, 'LEDGER002', 14,'dummy8', 'text', 200, 158, FALSE),
  (51, 'LEDGER002', 14,'dummy9', 'text', 200, 159, FALSE),
  (52, 'LEDGER002', 14,'dummy10', 'text', 200, 160, FALSE),
  (53, 'LEDGER002', 14,'dummy11', 'text', 200, 161, FALSE),
  (54, 'LEDGER002', 14,'dummy12', 'text', 200, 162, FALSE),
  (55, 'LEDGER002', 14,'dummy13', 'text', 200, 163, FALSE),
  (56, 'LEDGER002', 14,'dummy14', 'text', 200, 164, FALSE),
  (57, 'LEDGER002', 14,'dummy15', 'text', 200, 165, FALSE),
  (58, 'LEDGER002', 14,'dummy16', 'text', 200, 166, FALSE),
  (59, 'LEDGER002', 14,'dummy17', 'text', 200, 167, FALSE),
  (60, 'LEDGER002', 14,'dummy18', 'text', 200, 168, FALSE),
  (61, 'LEDGER002', 14,'dummy19', 'text', 200, 169, FALSE),
  (62, 'LEDGER002', 14,'dummy20', 'text', 200, 170, FALSE),
  (63, 'LEDGER003', 14,'ID', 'number', 200, 101, FALSE),
  (64, 'LEDGER003', 14,'管理部門', 'text', 200, 102, TRUE),
  (65, 'LEDGER003', 14,'システムコード', 'text', 200, 103, TRUE),
  (66, 'LEDGER003', 14,'システム標準名称', 'text', 200, 104, TRUE),
  (67, 'LEDGER003', 14,'システム名', 'text', 200, 105, TRUE),
  (68, 'LEDGER003', 14,'ホスト名', 'text', 200, 106, TRUE),
  (69, 'LEDGER003', 14,'OSバージョン', 'text', 200, 107, TRUE),
  (70, 'LEDGER003', 14,'稼働開始日', 'date', 200, 108, TRUE),
  (71, 'LEDGER003', 14,'最終パッチ適用日', 'date', 200, 109, TRUE),
  (72, 'LEDGER003', 14,'パッチ適用推進状況', 'text', 200, 110, TRUE),
  (73, 'LEDGER003', 14,'稼働終了予定', 'date', 200, 111, TRUE),
  (74, 'LEDGER003', 14,'移管状況', 'text', 200, 112, TRUE),
  (75, 'LEDGER003', 14,'次回パッチ適用予定', 'date', 200, 113, TRUE),
  (76, 'LEDGER003', 14,'次期サーバーリプレイス予定', 'date', 200, 114, TRUE),
  (77, 'LEDGER003', 14,'次期サーバーバージョン', 'text', 200, 115, TRUE),
  (78, 'LEDGER003', 14,'リプレイス推進状況', 'text', 200, 116, TRUE),
  (79, 'LEDGER003', 14,'システム利用ユーザー部門', 'text', 200, 117, TRUE),
  (80, 'LEDGER003', 14,'費用負担部門', 'text', 200, 118, TRUE),
  (81, 'LEDGER003', 14,'予算コード', 'text', 200, 119, TRUE),
  (82, 'LEDGER003', 14,'予算名称', 'text', 200, 120, TRUE),
  (83, 'LEDGER003', 14,'予算額', 'number', 200, 121, TRUE),
  (84, 'LEDGER003', 14,'振替部門', 'text', 200, 122, TRUE),
  (85, 'LEDGER003', 14,'dummy1', 'text', 200, 151, FALSE),
  (86, 'LEDGER003', 14,'dummy2', 'text', 200, 152, FALSE),
  (87, 'LEDGER003', 14,'dummy3', 'text', 200, 153, FALSE),
  (88, 'LEDGER003', 14,'dummy4', 'text', 200, 154, FALSE),
  (89, 'LEDGER003', 14,'dummy5', 'text', 200, 155, FALSE),
  (90, 'LEDGER003', 14,'dummy6', 'text', 200, 156, FALSE),
  (91, 'LEDGER003', 14,'dummy7', 'text', 200, 157, FALSE),
  (92, 'LEDGER003', 14,'dummy8', 'text', 200, 158, FALSE),
  (93, 'LEDGER003', 14,'dummy9', 'text', 200, 159, FALSE),
  (94, 'LEDGER003', 14,'dummy10', 'text', 200, 160, FALSE),
  (95, 'LEDGER003', 14,'dummy11', 'text', 200, 161, FALSE),
  (96, 'LEDGER003', 14,'dummy12', 'text', 200, 162, FALSE),
  (97, 'LEDGER003', 14,'dummy13', 'text', 200, 163, FALSE),
  (98, 'LEDGER003', 14,'dummy14', 'text', 200, 164, FALSE),
  (99, 'LEDGER003', 14,'dummy15', 'text', 200, 165, FALSE),
  (100, 'LEDGER003', 14,'dummy16', 'text', 200, 166, FALSE),
  (101, 'LEDGER003', 14,'dummy17', 'text', 200, 167, FALSE),
  (102, 'LEDGER003', 14,'dummy18', 'text', 200, 168, FALSE),
  (103, 'LEDGER003', 14,'dummy19', 'text', 200, 169, FALSE),
  (104, 'LEDGER003', 14,'dummy20', 'text', 200, 170, FALSE);

INSERT INTO web_ledger.ledger_master_mapping (master_type_id, field_name, tag)
VALUES
  -- LEDGER001 のマッピング
  (14, 'ID', 'LEDGER001'),
  (14, 'テーマ名', 'LEDGER001'),
  (14, '年度', 'LEDGER001'),
  (14, '予算種別', 'LEDGER001'),
  (14, '予算番号', 'LEDGER001'),
  (14, '予算名称', 'LEDGER001'),
  (14, '予算額', 'LEDGER001'),
  (14, '利用部門', 'LEDGER001'),
  (14, '振替部門', 'LEDGER001'),
  (14, 'dummy1', 'LEDGER001'),
  (14, 'dummy2', 'LEDGER001'),
  (14, 'dummy3', 'LEDGER001'),
  (14, 'dummy4', 'LEDGER001'),
  (14, 'dummy5', 'LEDGER001'),
  (14, 'dummy6', 'LEDGER001'),
  (14, 'dummy7', 'LEDGER001'),
  (14, 'dummy8', 'LEDGER001'),
  (14, 'dummy9', 'LEDGER001'),
  (14, 'dummy10', 'LEDGER001'),
  (14, 'dummy11', 'LEDGER001'),
  (14, 'dummy12', 'LEDGER001'),
  (14, 'dummy13', 'LEDGER001'),
  (14, 'dummy14', 'LEDGER001'),
  (14, 'dummy15', 'LEDGER001'),
  (14, 'dummy16', 'LEDGER001'),
  (14, 'dummy17', 'LEDGER001'),
  (14, 'dummy18', 'LEDGER001'),
  (14, 'dummy19', 'LEDGER001'),
  (14, 'dummy20', 'LEDGER001'),
  
  -- LEDGER002 のマッピング
  (14, 'ID', 'LEDGER002'),
  (14, '年度', 'LEDGER002'),
  (14, '予算種別', 'LEDGER002'),
  (14, '予算番号', 'LEDGER002'),
  (14, '予算名称', 'LEDGER002'),
  (14, '予算額', 'LEDGER002'),
  (14, '利用部門', 'LEDGER002'),
  (14, '振替部門', 'LEDGER002'),
  (14, '発注部門', 'LEDGER002'),
  (14, '発注担当者', 'LEDGER002'),
  (14, '発注日', 'LEDGER002'),
  (14, '検収担当者', 'LEDGER002'),
  (14, '検収完了日', 'LEDGER002'),
  (14, 'dummy1', 'LEDGER002'),
  (14, 'dummy2', 'LEDGER002'),
  (14, 'dummy3', 'LEDGER002'),
  (14, 'dummy4', 'LEDGER002'),
  (14, 'dummy5', 'LEDGER002'),
  (14, 'dummy6', 'LEDGER002'),
  (14, 'dummy7', 'LEDGER002'),
  (14, 'dummy8', 'LEDGER002'),
  (14, 'dummy9', 'LEDGER002'),
  (14, 'dummy10', 'LEDGER002'),
  (14, 'dummy11', 'LEDGER002'),
  (14, 'dummy12', 'LEDGER002'),
  (14, 'dummy13', 'LEDGER002'),
  (14, 'dummy14', 'LEDGER002'),
  (14, 'dummy15', 'LEDGER002'),
  (14, 'dummy16', 'LEDGER002'),
  (14, 'dummy17', 'LEDGER002'),
  (14, 'dummy18', 'LEDGER002'),
  (14, 'dummy19', 'LEDGER002'),
  (14, 'dummy20', 'LEDGER002'),
  
  -- LEDGER003 のマッピング
  (14, 'ID', 'LEDGER003'),
  (14, '管理部門', 'LEDGER003'),
  (14, 'システムコード', 'LEDGER003'),
  (14, 'システム標準名称', 'LEDGER003'),
  (14, 'システム名', 'LEDGER003'),
  (14, 'ホスト名', 'LEDGER003'),
  (14, 'OSバージョン', 'LEDGER003'),
  (14, '稼働開始日', 'LEDGER003'),
  (14, '最終パッチ適用日', 'LEDGER003'),
  (14, 'パッチ適用推進状況', 'LEDGER003'),
  (14, '稼働終了予定', 'LEDGER003'),
  (14, '移管状況', 'LEDGER003'),
  (14, '次回パッチ適用予定', 'LEDGER003'),
  (14, '次期サーバーリプレイス予定', 'LEDGER003'),
  (14, '次期サーバーバージョン', 'LEDGER003'),
  (14, 'リプレイス推進状況', 'LEDGER003'),
  (14, 'システム利用ユーザー部門', 'LEDGER003'),
  (14, '費用負担部門', 'LEDGER003'),
  (14, '予算コード', 'LEDGER003'),
  (14, '予算名称', 'LEDGER003'),
  (14, '予算額', 'LEDGER003'),
  (14, '振替部門', 'LEDGER003'),
  (14, 'dummy1', 'LEDGER003'),
  (14, 'dummy2', 'LEDGER003'),
  (14, 'dummy3', 'LEDGER003'),
  (14, 'dummy4', 'LEDGER003'),
  (14, 'dummy5', 'LEDGER003'),
  (14, 'dummy6', 'LEDGER003'),
  (14, 'dummy7', 'LEDGER003'),
  (14, 'dummy8', 'LEDGER003'),
  (14, 'dummy9', 'LEDGER003'),
  (14, 'dummy10', 'LEDGER003'),
  (14, 'dummy11', 'LEDGER003'),
  (14, 'dummy12', 'LEDGER003'),
  (14, 'dummy13', 'LEDGER003'),
  (14, 'dummy14', 'LEDGER003'),
  (14, 'dummy15', 'LEDGER003'),
  (14, 'dummy16', 'LEDGER003'),
  (14, 'dummy17', 'LEDGER003'),
  (14, 'dummy18', 'LEDGER003'),
  (14, 'dummy19', 'LEDGER003'),
  (14, 'dummy20', 'LEDGER003');

-- 1. 既存の外部キー制約（ledger_columns_master への参照）を削除
ALTER TABLE web_ledger.ledger_records
DROP CONSTRAINT IF EXISTS ledger_records_column_id_fkey;

-- 2. ledger_records の column_id 列を master_field_definitions(id) への外部キーに再設定
ALTER TABLE web_ledger.ledger_records
ADD CONSTRAINT ledger_records_field_id_fkey
FOREIGN KEY (column_id) REFERENCES web_ledger.master_field_definitions(id)
ON UPDATE NO ACTION
ON DELETE CASCADE;

COMMIT;

-- =============================
-- マイグレーション完了
-- =============================
