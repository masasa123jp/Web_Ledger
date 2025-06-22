-------------------------------
-- サンプルデータ挿入用SQL
-------------------------------

-- 2. 認証関連のサンプルデータ
-- INSERT INTO web_ledger.role_master (role_name) VALUES 
-- ('Admin'),
-- ('User');

-- INSERT INTO web_ledger.users (username, password, role_id) VALUES 
-- ('admin_user', 'hashed_password_here', (SELECT id FROM web_ledger.role_master WHERE role_name = 'Admin')),
-- ('test_user', 'hashed_password_here', (SELECT id FROM web_ledger.role_master WHERE role_name = 'User'));

-- 3. 統合マスタ管理のサンプルデータ

-- 3-1. マスタ種別（OS, Middleware, AccountingYear, Quarter, Month, Initiative, Person, Organization, Ledger, System）
INSERT INTO web_ledger.master_types (master_type, description) VALUES 
('PLATFORM', 'システムの搭載先基盤管理'),
('SYSTEM_PLATFORM', 'システムの搭載先統合環境管理'),
('OS', 'サーバーのオペレーティングシステム管理'),
('Middleware', 'ミドルウェア管理'),
('AccountingYear', '年度および四半期の会計期間管理'),
('Quarter', '各四半期の管理'),
('Month', '月の管理'),
('Initiative', '事業戦略やプロジェクト施策の管理'),
('Person', '各部門の責任者や担当者情報の管理'),
('Organization', '企業内の組織構造管理'),
('Ledger', '台帳定義管理'),
('System', '社内利用システム管理');


-- 3-0. マスタ項目定義のサンプル（PLATFORM）
INSERT INTO web_ledger.master_field_definitions (master_id, field_name, data_type, max_length, is_required, input_constraints)
VALUES 
((SELECT id FROM web_ledger.master_types WHERE master_type = 'PLATFORM'), 'version', 'varchar', 50, false, NULL);

-- 3-1. マスタ項目定義のサンプル（SYSTEM_PLATFORM）
INSERT INTO web_ledger.master_field_definitions (master_id, field_name, data_type, max_length, is_required, input_constraints)
VALUES 
((SELECT id FROM web_ledger.master_types WHERE master_type = 'SYSTEM_PLATFORM'), 'version', 'varchar', 50, false, NULL);

-- 3-2. ミドルウェア（Middleware）のフィールド定義
INSERT INTO web_ledger.master_field_definitions (master_id, field_name, data_type, max_length, is_required, input_constraints)
VALUES 
((SELECT id FROM web_ledger.master_types WHERE master_type = 'Middleware'), 'vendor', 'varchar', 100, true, NULL),
((SELECT id FROM web_ledger.master_types WHERE master_type = 'Middleware'), 'version', 'varchar', 50, true, NULL);

-- 3-2. 会計年度（AccountingYear）のフィールド定義
INSERT INTO web_ledger.master_field_definitions (master_id, field_name, data_type, max_length, is_required, input_constraints)
VALUES 
((SELECT id FROM web_ledger.master_types WHERE master_type = 'AccountingYear'), 'start_date', 'date', NULL, true, 'YYYY-MM-DD'),
((SELECT id FROM web_ledger.master_types WHERE master_type = 'AccountingYear'), 'end_date', 'date', NULL, true, 'YYYY-MM-DD');

-- 3-2. 四半期（Quarter）のフィールド定義
INSERT INTO web_ledger.master_field_definitions (master_id, field_name, data_type, max_length, is_required, input_constraints)
VALUES 
((SELECT id FROM web_ledger.master_types WHERE master_type = 'Quarter'), 'start_month', 'integer', NULL, true, NULL),
((SELECT id FROM web_ledger.master_types WHERE master_type = 'Quarter'), 'end_month', 'integer', NULL, true, NULL);

-- 3-2. 月（Month）のフィールド定義
INSERT INTO web_ledger.master_field_definitions (master_id, field_name, data_type, max_length, is_required, input_constraints)
VALUES 
((SELECT id FROM web_ledger.master_types WHERE master_type = 'Month'), 'month_number', 'integer', NULL, true, NULL);

-- 3-2. 施策（Initiative）のフィールド定義
INSERT INTO web_ledger.master_field_definitions (master_id, field_name, data_type, max_length, is_required, input_constraints)
VALUES 
((SELECT id FROM web_ledger.master_types WHERE master_type = 'Initiative'), 'effective_from', 'date', NULL, true, 'YYYY-MM-DD'),
((SELECT id FROM web_ledger.master_types WHERE master_type = 'Initiative'), 'effective_to', 'date', NULL, true, 'YYYY-MM-DD');

-- 3-2. 担当者（Person）のフィールド定義
INSERT INTO web_ledger.master_field_definitions (master_id, field_name, data_type, max_length, is_required, input_constraints)
VALUES 
((SELECT id FROM web_ledger.master_types WHERE master_type = 'Person'), 'email', 'varchar', 100, true, NULL),
((SELECT id FROM web_ledger.master_types WHERE master_type = 'Person'), 'phone', 'varchar', 20, true, NULL);

-- 3-2. 組織（Organization）のフィールド定義
INSERT INTO web_ledger.master_field_definitions (master_id, field_name, data_type, max_length, is_required, input_constraints)
VALUES 
((SELECT id FROM web_ledger.master_types WHERE master_type = 'Organization'), 'parent_code', 'varchar', 50, false, NULL);

-- 3-2. システム（System）のフィールド定義
INSERT INTO web_ledger.master_field_definitions (master_id, field_name, data_type, max_length, is_required, input_constraints)
VALUES 
((SELECT id FROM web_ledger.master_types WHERE master_type = 'System'), 'version', 'varchar', 50, false, NULL),
((SELECT id FROM web_ledger.master_types WHERE master_type = 'System'), 'owner_department', 'varchar', 100, false, NULL);

-- 3-3. 統合マスタレコードのサンプルデータ

INSERT INTO web_ledger.unified_master_records (master_id, record_data)
VALUES (
  (SELECT id FROM web_ledger.master_types WHERE master_type = 'PLATFORM'),
  '{"code": "PHYS_PLATFORM", "name": "物理システム基盤", "description": "オンプレミスの物理サーバ基盤", "vendor": "Various", "version": "N/A"}'
);

-- Amazon Web Services
INSERT INTO web_ledger.unified_master_records (master_id, record_data)
VALUES (
  (SELECT id FROM web_ledger.master_types WHERE master_type = 'PLATFORM'),
  '{"code": "AWS", "name": "Amazon Web Services", "description": "クラウドプラットフォームサービス", "vendor": "Amazon", "version": "最新"}'
);

-- Microsoft Azure
INSERT INTO web_ledger.unified_master_records (master_id, record_data)
VALUES (
  (SELECT id FROM web_ledger.master_types WHERE master_type = 'PLATFORM'),
  '{"code": "AZURE", "name": "Microsoft Azure", "description": "クラウドプラットフォームサービス", "vendor": "Microsoft", "version": "最新"}'
);

-- Google Cloud Platform
INSERT INTO web_ledger.unified_master_records (master_id, record_data)
VALUES (
  (SELECT id FROM web_ledger.master_types WHERE master_type = 'PLATFORM'),
  '{"code": "GCP", "name": "Google Cloud Platform", "description": "クラウドプラットフォームサービス", "vendor": "Google", "version": "最新"}'
);

-- Watoson Cloud Platform
INSERT INTO web_ledger.unified_master_records (master_id, record_data)
VALUES (
  (SELECT id FROM web_ledger.master_types WHERE master_type = 'PLATFORM'),
  '{"code": "WATOSON", "name": "Watoson Cloud Platform", "description": "クラウドプラットフォームサービス（Watoson）", "vendor": "Watoson", "version": "最新"}'
);

INSERT INTO web_ledger.unified_master_records (master_id, record_data)
VALUES 
  ((SELECT id FROM web_ledger.master_types WHERE master_type = 'PLATFORM'),
   '{"code": "VMWARE_ESXi55", "name": "VMware ESXi 5.5", "description": "旧バージョンのVMwareハイパーバイザ", "vendor": "VMware", "version": "5.5"}');

INSERT INTO web_ledger.unified_master_records (master_id, record_data)
VALUES 
  ((SELECT id FROM web_ledger.master_types WHERE master_type = 'PLATFORM'),
   '{"code": "VMWARE_ESXi60", "name": "VMware ESXi 6.0", "description": "旧バージョンのVMwareハイパーバイザ", "vendor": "VMware", "version": "6.0"}');

INSERT INTO web_ledger.unified_master_records (master_id, record_data)
VALUES 
  ((SELECT id FROM web_ledger.master_types WHERE master_type = 'PLATFORM'),
   '{"code": "VMWARE_ESXi65", "name": "VMware ESXi 6.5", "description": "旧バージョンのVMwareハイパーバイザ", "vendor": "VMware", "version": "6.5"}');

INSERT INTO web_ledger.unified_master_records (master_id, record_data)
VALUES 
  ((SELECT id FROM web_ledger.master_types WHERE master_type = 'PLATFORM'),
   '{"code": "VMWARE_ESXi67", "name": "VMware ESXi 6.7", "description": "旧バージョンのVMwareハイパーバイザ", "vendor": "VMware", "version": "6.7"}');

INSERT INTO web_ledger.unified_master_records (master_id, record_data)
VALUES 
  ((SELECT id FROM web_ledger.master_types WHERE master_type = 'PLATFORM'),
   '{"code": "VMWARE_ESXi70", "name": "VMware ESXi 7.0", "description": "現行運用バージョンのVMwareハイパーバイザ", "vendor": "VMware", "version": "7.0"}');

INSERT INTO web_ledger.unified_master_records (master_id, record_data)
VALUES 
  ((SELECT id FROM web_ledger.master_types WHERE master_type = 'PLATFORM'),
   '{"code": "VMWARE_ESXi80", "name": "VMware ESXi 8.0", "description": "最新バージョンのVMwareハイパーバイザ", "vendor": "VMware", "version": "8.0"}');

-- オンプレミス仮想環境
INSERT INTO web_ledger.unified_master_records (master_id, record_data)
VALUES (
  (SELECT id FROM web_ledger.master_types WHERE master_type = 'PLATFORM'),
  '{"code": "ON_PREMISE_VIRTUAL", "name": "オンプレミス独自仮想環境", "description": "物理サーバ上に構築された独自仮想環境", "vendor": "Various", "version": "N/A"}'
);

-- Red Hat OpenShift（旧バージョン）
INSERT INTO web_ledger.unified_master_records (master_id, record_data)
VALUES (
  (SELECT id FROM web_ledger.master_types WHERE master_type = 'PLATFORM'),
  '{"code": "RH_OPENSHIFT311", "name": "Red Hat OpenShift 3.11", "description": "旧バージョンのRed Hat OpenShift Container Platform", "vendor": "Red Hat", "version": "3.11"}'
);

-- Red Hat OpenShift（最新バージョン例）
INSERT INTO web_ledger.unified_master_records (master_id, record_data)
VALUES (
  (SELECT id FROM web_ledger.master_types WHERE master_type = 'PLATFORM'),
  '{"code": "RH_OPENSHIFT412", "name": "Red Hat OpenShift Container Platform 4.12", "description": "最新バージョンのRed Hat OpenShift Container Platform", "vendor": "Red Hat", "version": "4.12"}'
);

-- オンプレミス物理環境
INSERT INTO web_ledger.unified_master_records (master_id, record_data)
VALUES (
  (SELECT id FROM web_ledger.master_types WHERE master_type = 'PLATFORM'),
  '{"code": "ON_PREMISE_PHYSICAL", "name": "オンプレミス独自物理環境", "description": "独自物理サーバ環境", "vendor": "Various", "version": "N/A"}'
);

-- G3~G5,Eta
INSERT INTO web_ledger.unified_master_records (master_id, record_data)
VALUES (
  (SELECT id FROM web_ledger.master_types WHERE master_type = 'SYSTEM_PLATFORM'),
  '{"code": "G3", "name": "G3環境", "description": "G3統合環境", "vendor": "-", "version": "G3"}'
);
INSERT INTO web_ledger.unified_master_records (master_id, record_data)
VALUES (
  (SELECT id FROM web_ledger.master_types WHERE master_type = 'SYSTEM_PLATFORM'),
  '{"code": "G4", "name": "G4環境", "description": "G4統合環境", "vendor": "-", "version": "G4"}'
);
INSERT INTO web_ledger.unified_master_records (master_id, record_data)
VALUES (
  (SELECT id FROM web_ledger.master_types WHERE master_type = 'SYSTEM_PLATFORM'),
  '{"code": "G5", "name": "G5環境", "description": "G5統合環境", "vendor": "-", "version": "G5"}'
);
INSERT INTO web_ledger.unified_master_records (master_id, record_data)
VALUES (
  (SELECT id FROM web_ledger.master_types WHERE master_type = 'SYSTEM_PLATFORM'),
  '{"code": "Eta", "name": "Eta環境", "description": "Eta統合環境", "vendor": "-", "version": "Eta"}'
);



-- 3-3. OSマスタ（最新＋旧バージョン）
INSERT INTO web_ledger.unified_master_records (master_id, record_data)
VALUES 
((SELECT id FROM web_ledger.master_types WHERE master_type = 'OS'),
 '{"code": "WS2008S", "name": "Windows Server 2008 Standard", "description": "Microsoft Windows Server 2008 Standard", "version": "2008"}'),
((SELECT id FROM web_ledger.master_types WHERE master_type = 'OS'),
 '{"code": "WS2008D", "name": "Windows Server 2008 Datacenter", "description": "Microsoft Windows Server 2008 Datacenter", "version": "2008"}'),
((SELECT id FROM web_ledger.master_types WHERE master_type = 'OS'),
 '{"code": "WS2008R2S", "name": "Windows Server 2008R2", "description": "Microsoft Windows Server 2008 R2 Standard", "version": "2008R2"}'),
((SELECT id FROM web_ledger.master_types WHERE master_type = 'OS'),
 '{"code": "WS2008R2D", "name": "Windows Server 2008R2", "description": "Microsoft Windows Server 2008 R2 Datacenter", "version": "2008R2"}'),
((SELECT id FROM web_ledger.master_types WHERE master_type = 'OS'),
 '{"code": "WS2012S", "name": "Windows Server 2012", "description": "Microsoft Windows Server 2012 Standard", "version": "2012"}'),
((SELECT id FROM web_ledger.master_types WHERE master_type = 'OS'),
 '{"code": "WS2012D", "name": "Windows Server 2012", "description": "Microsoft Windows Server 2012 Datacenter", "version": "2012"}'),
((SELECT id FROM web_ledger.master_types WHERE master_type = 'OS'),
 '{"code": "WS2012R2S", "name": "Windows Server 2012R2", "description": "Microsoft Windows Server 2012 R2 Standard", "version": "2012R2"}'),
((SELECT id FROM web_ledger.master_types WHERE master_type = 'OS'),
 '{"code": "WS2012R2D", "name": "Windows Server 2012R2", "description": "Microsoft Windows Server 2012 R2 Datacenter", "version": "2012R2"}'),
((SELECT id FROM web_ledger.master_types WHERE master_type = 'OS'),
 '{"code": "WS2016S", "name": "Windows Server 2016", "description": "Microsoft Windows Server 2016 Standard", "version": "2016"}'),
((SELECT id FROM web_ledger.master_types WHERE master_type = 'OS'),
 '{"code": "WS2016D", "name": "Windows Server 2016", "description": "Microsoft Windows Server 2016 Datacenter", "version": "2016"}'),
((SELECT id FROM web_ledger.master_types WHERE master_type = 'OS'),
 '{"code": "WS2019S", "name": "Windows Server 2019", "description": "Microsoft Windows Server 2019 Standard", "version": "2019"}'),
((SELECT id FROM web_ledger.master_types WHERE master_type = 'OS'),
 '{"code": "WS2019D", "name": "Windows Server 2019", "description": "Microsoft Windows Server 2019 Datacenter", "version": "2019"}'),
((SELECT id FROM web_ledger.master_types WHERE master_type = 'OS'),
 '{"code": "WS2022S", "name": "Windows Server 2022", "description": "Microsoft Windows Server 2022 Standard", "version": "2022"}'),
((SELECT id FROM web_ledger.master_types WHERE master_type = 'OS'),
 '{"code": "WS2022D", "name": "Windows Server 2022", "description": "Microsoft Windows Server 2022 Datacenter", "version": "2022"}'),
((SELECT id FROM web_ledger.master_types WHERE master_type = 'OS'),
 '{"code": "UB18LTS", "name": "Ubuntu 18.04 LTS", "description": "Ubuntu Linux 18.04 LTS", "version": "18.04"}'),
((SELECT id FROM web_ledger.master_types WHERE master_type = 'OS'),
 '{"code": "UB20LTS", "name": "Ubuntu 20.04 LTS", "description": "Ubuntu Linux Long Term Support Release 20.04", "version": "20.04"}'),
((SELECT id FROM web_ledger.master_types WHERE master_type = 'OS'),
 '{"code": "RHEL6", "name": "Red Hat Enterprise Linux 6", "description": "RHEL 6 Enterprise Edition", "version": "6"}'),
((SELECT id FROM web_ledger.master_types WHERE master_type = 'OS'),
 '{"code": "RHEL7", "name": "Red Hat Enterprise Linux 7", "description": "RHEL 7 Enterprise Edition", "version": "7"}'),
((SELECT id FROM web_ledger.master_types WHERE master_type = 'OS'),
 '{"code": "RHEL8", "name": "Red Hat Enterprise Linux 8", "description": "RHEL 8 Enterprise Edition", "version": "8"}'),
((SELECT id FROM web_ledger.master_types WHERE master_type = 'OS'),
 '{"code": "RHEL8", "name": "Red Hat Enterprise Linux 9", "description": "RHEL 9 Enterprise Edition", "version": "9"}'),
((SELECT id FROM web_ledger.master_types WHERE master_type = 'OS'),
 '{"code": "ZOS24", "name": "z/OS 2.4", "description": "IBM z/OS Version 2.4", "version": "2.4"}'),
((SELECT id FROM web_ledger.master_types WHERE master_type = 'OS'),
 '{"code": "ZOS25", "name": "z/OS 2.5", "description": "IBM z/OS Version 2.5", "version": "2.5"}');

-- OS/400 V4R4（初期のAS/400オペレーティングシステム）
INSERT INTO web_ledger.unified_master_records (master_id, record_data)
VALUES (
  (SELECT id FROM web_ledger.master_types WHERE master_type = 'OS'),
  '{"code": "AS400_OS_V4R4", "name": "OS/400 V4R4", "description": "初期のAS/400オペレーティングシステム", "vendor": "IBM", "version": "V4R4"}'
);

-- OS/400 V5R1
INSERT INTO web_ledger.unified_master_records (master_id, record_data)
VALUES (
  (SELECT id FROM web_ledger.master_types WHERE master_type = 'OS'),
  '{"code": "AS400_OS_V5R1", "name": "OS/400 V5R1", "description": "主要なAS/400 OS/400シリーズバージョン", "vendor": "IBM", "version": "V5R1"}'
);

-- OS/400 V5R3
INSERT INTO web_ledger.unified_master_records (master_id, record_data)
VALUES (
  (SELECT id FROM web_ledger.master_types WHERE master_type = 'OS'),
  '{"code": "AS400_OS_V5R3", "name": "OS/400 V5R3", "description": "アップデート版のAS/400 OS/400シリーズ", "vendor": "IBM", "version": "V5R3"}'
);

-- OS/400 V6R1
INSERT INTO web_ledger.unified_master_records (master_id, record_data)
VALUES (
  (SELECT id FROM web_ledger.master_types WHERE master_type = 'OS'),
  '{"code": "AS400_OS_V6R1", "name": "OS/400 V6R1", "description": "AS/400 OS/400シリーズの進化版", "vendor": "IBM", "version": "V6R1"}'
);

-- IBM i 7.1（OS/400からIBM iへの移行期）
INSERT INTO web_ledger.unified_master_records (master_id, record_data)
VALUES (
  (SELECT id FROM web_ledger.master_types WHERE master_type = 'OS'),
  '{"code": "IBM_i_7_1", "name": "IBM i 7.1", "description": "IBM iオペレーティングシステム（旧OS/400）の初期バージョン", "vendor": "IBM", "version": "7.1"}'
);

-- IBM i 7.2
INSERT INTO web_ledger.unified_master_records (master_id, record_data)
VALUES (
  (SELECT id FROM web_ledger.master_types WHERE master_type = 'OS'),
  '{"code": "IBM_i_7_2", "name": "IBM i 7.2", "description": "IBM iオペレーティングシステムのバージョン", "vendor": "IBM", "version": "7.2"}'
);

-- IBM i 7.3
INSERT INTO web_ledger.unified_master_records (master_id, record_data)
VALUES (
  (SELECT id FROM web_ledger.master_types WHERE master_type = 'OS'),
  '{"code": "IBM_i_7_3", "name": "IBM i 7.3", "description": "IBM iオペレーティングシステムのアップデートバージョン", "vendor": "IBM", "version": "7.3"}'
);

-- IBM i 7.4（最新バージョン）
INSERT INTO web_ledger.unified_master_records (master_id, record_data)
VALUES (
  (SELECT id FROM web_ledger.master_types WHERE master_type = 'OS'),
  '{"code": "IBM_i_7_4", "name": "IBM i 7.4", "description": "最新バージョンのIBM iオペレーティングシステム", "vendor": "IBM", "version": "7.4"}'
);


-- 3-3. ミドルウェアマスタ（最新＋旧バージョン）
INSERT INTO web_ledger.unified_master_records (master_id, record_data)
VALUES 
((SELECT id FROM web_ledger.master_types WHERE master_type = 'Middleware'),
 '{"code": "WEBSPHERE855", "name": "IBM WebSphere Application Server 8.5.5", "description": "旧バージョンのエンタープライズ向けアプリケーションサーバ", "vendor": "IBM", "version": "8.5.5"}'),
((SELECT id FROM web_ledger.master_types WHERE master_type = 'Middleware'),
 '{"code": "WEBSPHERE905", "name": "IBM WebSphere Application Server 9.0.5", "description": "エンタープライズ向けアプリケーションサーバ", "vendor": "IBM", "version": "9.0.5"}'),
((SELECT id FROM web_ledger.master_types WHERE master_type = 'Middleware'),
 '{"code": "TOMCAT8", "name": "Apache Tomcat 8.5.70", "description": "旧バージョンのJavaサーブレットコンテナ", "vendor": "Apache", "version": "8.5.70"}'),
((SELECT id FROM web_ledger.master_types WHERE master_type = 'Middleware'),
 '{"code": "TOMCAT9", "name": "Apache Tomcat 9.0.65", "description": "Javaサーブレットコンテナ", "vendor": "Apache", "version": "9.0.65"}'),
((SELECT id FROM web_ledger.master_types WHERE master_type = 'Middleware'),
 '{"code": "NGINX1180", "name": "Nginx 1.18.0", "description": "旧バージョンの高性能HTTPサーバ", "vendor": "NGINX Inc.", "version": "1.18.0"}'),
((SELECT id FROM web_ledger.master_types WHERE master_type = 'Middleware'),
 '{"code": "NGINX1201", "name": "Nginx 1.20.1", "description": "高性能HTTPサーバ", "vendor": "NGINX Inc.", "version": "1.20.1"}'),
((SELECT id FROM web_ledger.master_types WHERE master_type = 'Middleware'),
 '{"code": "IIS85", "name": "Microsoft IIS 8.5", "description": "旧バージョンのWindows向けWebサーバ", "vendor": "Microsoft", "version": "8.5"}'),
((SELECT id FROM web_ledger.master_types WHERE master_type = 'Middleware'),
 '{"code": "IIS10", "name": "Microsoft IIS 10.0", "description": "Windows向けWebサーバ", "vendor": "Microsoft", "version": "10.0"}');
-- WAS Liberty（旧バージョン例）
INSERT INTO web_ledger.unified_master_records (master_id, record_data)
VALUES (
  (SELECT id FROM web_ledger.master_types WHERE master_type = 'Middleware'),
  '{"code": "WAS_LIBERTY20011", "name": "IBM WebSphere Liberty 20.0.0.11", "description": "旧バージョンのWAS Liberty", "vendor": "IBM", "version": "20.0.0.11"}'
);
INSERT INTO web_ledger.unified_master_records (master_id, record_data)
VALUES (
  (SELECT id FROM web_ledger.master_types WHERE master_type = 'Middleware'),
  '{"code": "WAS_LIBERTY21012", "name": "IBM WebSphere Liberty 21.0.0.12", "description": "中間バージョンのWAS Liberty", "vendor": "IBM", "version": "21.0.0.12"}'
);
-- WAS Liberty（最新バージョン例）
INSERT INTO web_ledger.unified_master_records (master_id, record_data)
VALUES (
  (SELECT id FROM web_ledger.master_types WHERE master_type = 'Middleware'),
  '{"code": "WAS_LIBERTY22006", "name": "IBM WebSphere Liberty 22.0.0.6", "description": "最新バージョンのWAS Liberty", "vendor": "IBM", "version": "22.0.0.6"}'
);

-- ---------------------------------------------
-- 追加のサンプルデータ
-- Oracle Database（データベースサーバ）のサンプル
INSERT INTO web_ledger.unified_master_records (master_id, record_data)
VALUES
  ((SELECT id FROM web_ledger.master_types WHERE master_type = 'Middleware'),
   '{"code": "ORADB12C", "name": "Oracle Database 12c", "description": "旧バージョンのエンタープライズ向けデータベース", "vendor": "Oracle", "version": "12c"}'),
  ((SELECT id FROM web_ledger.master_types WHERE master_type = 'Middleware'),
   '{"code": "ORADB19C", "name": "Oracle Database 19c", "description": "エンタープライズ向けデータベース", "vendor": "Oracle", "version": "19c"}');

-- DB2 for z/OS v.12 のサンプルデータ
INSERT INTO web_ledger.unified_master_records (master_id, record_data)
VALUES (
  (SELECT id FROM web_ledger.master_types WHERE master_type = 'Middleware'),
  '{"code": "DB2_ZOS12", "name": "IBM DB2 for z/OS 12", "description": "最新バージョンのDB2 for z/OS", "vendor": "IBM", "version": "12"}'
);

-- IBM DB2 for i（AS/400向け DB2）のサンプルデータ
INSERT INTO web_ledger.unified_master_records (master_id, record_data)
VALUES (
  (SELECT id FROM web_ledger.master_types WHERE master_type = 'Middleware'),
  '{"code": "DB2_FOR_I74", "name": "IBM DB2 for i 7.4", "description": "IBM i（AS/400）向け統合データベース。旧称 DB2/400", "vendor": "IBM", "version": "7.4"}'
);


-- Apache Httpd（Webサーバ）のサンプル
INSERT INTO web_ledger.unified_master_records (master_id, record_data)
VALUES
  ((SELECT id FROM web_ledger.master_types WHERE master_type = 'Middleware'),
   '{"code": "HTTPD2441", "name": "Apache Httpd 2.4.41", "description": "旧バージョンの高性能Webサーバ", "vendor": "Apache", "version": "2.4.41"}'),
  ((SELECT id FROM web_ledger.master_types WHERE master_type = 'Middleware'),
   '{"code": "HTTPD2457", "name": "Apache Httpd 2.4.57", "description": "高性能Webサーバ", "vendor": "Apache", "version": "2.4.57"}');

-- Oracle Fusion Middleware（統合ミドルウェア）のサンプル
INSERT INTO web_ledger.unified_master_records (master_id, record_data)
VALUES
  ((SELECT id FROM web_ledger.master_types WHERE master_type = 'Middleware'),
   '{"code": "ORAFMW11G", "name": "Oracle Fusion Middleware 11g", "description": "旧バージョンの統合ミドルウェア", "vendor": "Oracle", "version": "11.1.1.7.0"}'),
  ((SELECT id FROM web_ledger.master_types WHERE master_type = 'Middleware'),
   '{"code": "ORAFMW12C", "name": "Oracle Fusion Middleware 12c", "description": "エンタープライズ向け統合ミドルウェア", "vendor": "Oracle", "version": "12.2.1.4.0"}');

-- Apache ActiveMQ Artemis（オープンソースのメッセージブローカー）のサンプル
INSERT INTO web_ledger.unified_master_records (master_id, record_data)
VALUES
  ((SELECT id FROM web_ledger.master_types WHERE master_type = 'Middleware'),
   '{"code": "ACTIVEMQ2163", "name": "Apache ActiveMQ Artemis 2.16.3", "description": "旧バージョンのオープンソースのメッセージブローカー", "vendor": "Apache", "version": "2.16.3"}'),
  ((SELECT id FROM web_ledger.master_types WHERE master_type = 'Middleware'),
   '{"code": "ACTIVEMQ2190", "name": "Apache ActiveMQ Artemis 2.19.0", "description": "オープンソースのメッセージブローカー", "vendor": "Apache", "version": "2.19.0"}');

-- Oracle WebLogic Server
INSERT INTO web_ledger.unified_master_records (master_id, record_data)
VALUES 
  ((SELECT id FROM web_ledger.master_types WHERE master_type = 'Middleware'),
   '{"code": "WEBLOGIC12214", "name": "Oracle WebLogic Server 12.2.1.4.0", "description": "旧バージョンのエンタープライズ向けアプリケーションサーバ", "vendor": "Oracle", "version": "12.2.1.4.0"}'),
  ((SELECT id FROM web_ledger.master_types WHERE master_type = 'Middleware'),
   '{"code": "WEBLOGIC14110", "name": "Oracle WebLogic Server 14.1.1.0", "description": "エンタープライズ向けアプリケーションサーバ", "vendor": "Oracle", "version": "14.1.1.0"}');

-- Red Hat JBoss EAP
INSERT INTO web_ledger.unified_master_records (master_id, record_data)
VALUES 
  ((SELECT id FROM web_ledger.master_types WHERE master_type = 'Middleware'),
   '{"code": "JBOSSEAP73", "name": "Red Hat JBoss EAP 7.3", "description": "旧バージョンのエンタープライズ向けアプリケーションサーバ", "vendor": "Red Hat", "version": "7.3"}'),
  ((SELECT id FROM web_ledger.master_types WHERE master_type = 'Middleware'),
   '{"code": "JBOSSEAP74", "name": "Red Hat JBoss EAP 7.4", "description": "エンタープライズ向けアプリケーションサーバ", "vendor": "Red Hat", "version": "7.4"}');

-- WildFly (コミュニティ版アプリケーションサーバ)
INSERT INTO web_ledger.unified_master_records (master_id, record_data)
VALUES 
  ((SELECT id FROM web_ledger.master_types WHERE master_type = 'Middleware'),
   '{"code": "WILDFLY250", "name": "WildFly 25.0.0.Final", "description": "旧バージョンのコミュニティ版アプリケーションサーバ", "vendor": "WildFly", "version": "25.0.0.Final"}'),
  ((SELECT id FROM web_ledger.master_types WHERE master_type = 'Middleware'),
   '{"code": "WILDFLY2613", "name": "WildFly 26.1.3.Final", "description": "コミュニティ版アプリケーションサーバ", "vendor": "WildFly", "version": "26.1.3.Final"}');

-- Apache Kafka (分散型ストリーミングプラットフォーム)
INSERT INTO web_ledger.unified_master_records (master_id, record_data)
VALUES 
  ((SELECT id FROM web_ledger.master_types WHERE master_type = 'Middleware'),
   '{"code": "KAFKA28", "name": "Apache Kafka 2.8.1", "description": "旧バージョンの分散型ストリーミングプラットフォーム", "vendor": "Apache", "version": "2.8.1"}'),
  ((SELECT id FROM web_ledger.master_types WHERE master_type = 'Middleware'),
   '{"code": "KAFKA34", "name": "Apache Kafka 3.4.0", "description": "分散型ストリーミングプラットフォーム", "vendor": "Apache", "version": "3.4.0"}');

-- RabbitMQ (オープンソースのメッセージブローカー)
INSERT INTO web_ledger.unified_master_records (master_id, record_data)
VALUES 
  ((SELECT id FROM web_ledger.master_types WHERE master_type = 'Middleware'),
   '{"code": "RABBITMQ38", "name": "RabbitMQ 3.8.9", "description": "旧バージョンのオープンソースのメッセージブローカー", "vendor": "Pivotal", "version": "3.8.9"}'),
  ((SELECT id FROM web_ledger.master_types WHERE master_type = 'Middleware'),
   '{"code": "RABBITMQ39", "name": "RabbitMQ 3.9.13", "description": "オープンソースのメッセージブローカー", "vendor": "Pivotal", "version": "3.9.13"}');


-- =============================================
-- Java SE バージョン（最新および旧バージョン）
-- =============================================
INSERT INTO web_ledger.unified_master_records (master_id, record_data)
VALUES 
  ((SELECT id FROM web_ledger.master_types WHERE master_type = 'Middleware'),
   '{"code": "JAVA_SE6", "name": "Java SE 6", "description": "旧バージョンのJava Standard Edition", "vendor": "Oracle", "version": "6"}'),
  ((SELECT id FROM web_ledger.master_types WHERE master_type = 'Middleware'),
   '{"code": "JAVA_SE7", "name": "Java SE 7", "description": "旧バージョンのJava Standard Edition", "vendor": "Oracle", "version": "7"}'),
  ((SELECT id FROM web_ledger.master_types WHERE master_type = 'Middleware'),
   '{"code": "JAVA_SE8", "name": "Java SE 8", "description": "長期サポート (LTS) のJava Standard Edition", "vendor": "Oracle", "version": "8"}'),
  ((SELECT id FROM web_ledger.master_types WHERE master_type = 'Middleware'),
   '{"code": "JAVA_SE9", "name": "Java SE 9", "description": "モジュールシステム導入のJava Standard Edition", "vendor": "Oracle", "version": "9"}'),
  ((SELECT id FROM web_ledger.master_types WHERE master_type = 'Middleware'),
   '{"code": "JAVA_SE10", "name": "Java SE 10", "description": "短期リリースのJava Standard Edition", "vendor": "Oracle", "version": "10"}'),
  ((SELECT id FROM web_ledger.master_types WHERE master_type = 'Middleware'),
   '{"code": "JAVA_SE11", "name": "Java SE 11", "description": "長期サポート (LTS) のJava Standard Edition", "vendor": "Oracle", "version": "11"}'),
  ((SELECT id FROM web_ledger.master_types WHERE master_type = 'Middleware'),
   '{"code": "JAVA_SE12", "name": "Java SE 12", "description": "短期リリースのJava Standard Edition", "vendor": "Oracle", "version": "12"}'),
  ((SELECT id FROM web_ledger.master_types WHERE master_type = 'Middleware'),
   '{"code": "JAVA_SE13", "name": "Java SE 13", "description": "短期リリースのJava Standard Edition", "vendor": "Oracle", "version": "13"}'),
  ((SELECT id FROM web_ledger.master_types WHERE master_type = 'Middleware'),
   '{"code": "JAVA_SE14", "name": "Java SE 14", "description": "短期リリースのJava Standard Edition", "vendor": "Oracle", "version": "14"}'),
  ((SELECT id FROM web_ledger.master_types WHERE master_type = 'Middleware'),
   '{"code": "JAVA_SE15", "name": "Java SE 15", "description": "短期リリースのJava Standard Edition", "vendor": "Oracle", "version": "15"}'),
  ((SELECT id FROM web_ledger.master_types WHERE master_type = 'Middleware'),
   '{"code": "JAVA_SE16", "name": "Java SE 16", "description": "短期リリースのJava Standard Edition", "vendor": "Oracle", "version": "16"}'),
  ((SELECT id FROM web_ledger.master_types WHERE master_type = 'Middleware'),
   '{"code": "JAVA_SE17", "name": "Java SE 17", "description": "長期サポート (LTS) のJava Standard Edition", "vendor": "Oracle", "version": "17"}'),
  ((SELECT id FROM web_ledger.master_types WHERE master_type = 'Middleware'),
   '{"code": "JAVA_SE18", "name": "Java SE 18", "description": "短期リリースのJava Standard Edition", "vendor": "Oracle", "version": "18"}'),
  ((SELECT id FROM web_ledger.master_types WHERE master_type = 'Middleware'),
   '{"code": "JAVA_SE19", "name": "Java SE 19", "description": "短期リリースのJava Standard Edition", "vendor": "Oracle", "version": "19"}'),
  ((SELECT id FROM web_ledger.master_types WHERE master_type = 'Middleware'),
   '{"code": "JAVA_SE20", "name": "Java SE 20", "description": "短期リリースのJava Standard Edition", "vendor": "Oracle", "version": "20"}'),
  ((SELECT id FROM web_ledger.master_types WHERE master_type = 'Middleware'),
   '{"code": "JAVA_SE21", "name": "Java SE 21", "description": "最新の長期サポート (LTS) のJava Standard Edition", "vendor": "Oracle", "version": "21"}');

-- =============================================
-- Java EE / Jakarta EE バージョン
-- =============================================
INSERT INTO web_ledger.unified_master_records (master_id, record_data)
VALUES 
  ((SELECT id FROM web_ledger.master_types WHERE master_type = 'Middleware'),
   '{"code": "JAVA_EE5", "name": "Java EE 5", "description": "旧バージョンのJava Enterprise Edition", "vendor": "Oracle", "version": "5"}'),
  ((SELECT id FROM web_ledger.master_types WHERE master_type = 'Middleware'),
   '{"code": "JAVA_EE6", "name": "Java EE 6", "description": "旧バージョンのJava Enterprise Edition", "vendor": "Oracle", "version": "6"}'),
  ((SELECT id FROM web_ledger.master_types WHERE master_type = 'Middleware'),
   '{"code": "JAVA_EE7", "name": "Java EE 7", "description": "旧バージョンのJava Enterprise Edition", "vendor": "Oracle", "version": "7"}'),
  ((SELECT id FROM web_ledger.master_types WHERE master_type = 'Middleware'),
   '{"code": "JAVA_EE8", "name": "Java EE 8", "description": "最後のJava EEリリース", "vendor": "Oracle", "version": "8"}'),
  ((SELECT id FROM web_ledger.master_types WHERE master_type = 'Middleware'),
   '{"code": "JAKARTA_EE9", "name": "Jakarta EE 9", "description": "Java EEからJakarta EEへの移行版", "vendor": "Eclipse Foundation", "version": "9"}'),
  ((SELECT id FROM web_ledger.master_types WHERE master_type = 'Middleware'),
   '{"code": "JAKARTA_EE10", "name": "Jakarta EE 10", "description": "最新のJakarta EE", "vendor": "Eclipse Foundation", "version": "10"}');

-- ---------------------------------------------
-- IBM Java 製品のサンプルデータ
-- ---------------------------------------------
-- IBM SDK for Java Technology Edition（旧バージョン）
INSERT INTO web_ledger.unified_master_records (master_id, record_data)
VALUES
  ((SELECT id FROM web_ledger.master_types WHERE master_type = 'Middleware'),
   '{"code": "IBM_JAVA6", "name": "IBM SDK for Java Technology Edition 6", "description": "旧バージョンのIBM Java", "vendor": "IBM", "version": "6"}'),
  ((SELECT id FROM web_ledger.master_types WHERE master_type = 'Middleware'),
   '{"code": "IBM_JAVA7", "name": "IBM SDK for Java Technology Edition 7", "description": "旧バージョンのIBM Java", "vendor": "IBM", "version": "7"}');

-- IBM SDK for Java Technology Edition（長期サポート版）
INSERT INTO web_ledger.unified_master_records (master_id, record_data)
VALUES
  ((SELECT id FROM web_ledger.master_types WHERE master_type = 'Middleware'),
   '{"code": "IBM_JAVA8", "name": "IBM SDK for Java Technology Edition 8", "description": "長期サポートのIBM Java", "vendor": "IBM", "version": "8"}'),
  ((SELECT id FROM web_ledger.master_types WHERE master_type = 'Middleware'),
   '{"code": "IBM_JAVA11", "name": "IBM SDK for Java Technology Edition 11", "description": "LTS版のIBM Java", "vendor": "IBM", "version": "11"}');

-- IBM Semeru Runtime（最新の OpenJ9 ベースのIBM Java）
INSERT INTO web_ledger.unified_master_records (master_id, record_data)
VALUES
  ((SELECT id FROM web_ledger.master_types WHERE master_type = 'Middleware'),
   '{"code": "IBM_SEMERU17", "name": "IBM Semeru Runtime 17", "description": "最新のIBM Java（OpenJ9ベース）", "vendor": "IBM", "version": "17"}');

-- ---------------------------------------------
-- IBM COBOL 製品のサンプルデータ
-- ---------------------------------------------
-- IBM Enterprise COBOL for z/OS のバージョン
INSERT INTO web_ledger.unified_master_records (master_id, record_data)
VALUES
  ((SELECT id FROM web_ledger.master_types WHERE master_type = 'Middleware'),
   '{"code": "IBM_COBOL58", "name": "IBM Enterprise COBOL for z/OS 5.8", "description": "最も古いバージョンのIBM COBOL for z/OS", "vendor": "IBM", "version": "5.8"}'),
  ((SELECT id FROM web_ledger.master_types WHERE master_type = 'Middleware'),
   '{"code": "IBM_COBOL59", "name": "IBM Enterprise COBOL for z/OS 5.9", "description": "旧バージョンのIBM COBOL for z/OS", "vendor": "IBM", "version": "5.9"}'),
  ((SELECT id FROM web_ledger.master_types WHERE master_type = 'Middleware'),
   '{"code": "IBM_COBOL60", "name": "IBM Enterprise COBOL for z/OS 6.0", "description": "旧バージョンのIBM COBOL for z/OS", "vendor": "IBM", "version": "6.0"}'),
  ((SELECT id FROM web_ledger.master_types WHERE master_type = 'Middleware'),
   '{"code": "IBM_COBOL61", "name": "IBM Enterprise COBOL for z/OS 6.1", "description": "旧バージョンのIBM COBOL for z/OS", "vendor": "IBM", "version": "6.1"}'),
  ((SELECT id FROM web_ledger.master_types WHERE master_type = 'Middleware'),
   '{"code": "IBM_COBOL62", "name": "IBM Enterprise COBOL for z/OS 6.2", "description": "旧バージョンのIBM COBOL for z/OS", "vendor": "IBM", "version": "6.2"}'),
  ((SELECT id FROM web_ledger.master_types WHERE master_type = 'Middleware'),
   '{"code": "IBM_COBOL63", "name": "IBM Enterprise COBOL for z/OS 6.3", "description": "最新バージョンのIBM COBOL for z/OS", "vendor": "IBM", "version": "6.3"}');

-- ---------------------------------------------
-- Micro Focus COBOL 製品のサンプルデータ
-- ---------------------------------------------
-- Micro Focus Visual COBOL のバージョン
INSERT INTO web_ledger.unified_master_records (master_id, record_data)
VALUES
  ((SELECT id FROM web_ledger.master_types WHERE master_type = 'Middleware'),
   '{"code": "MF_COBOL72", "name": "Micro Focus Visual COBOL 7.2", "description": "最も古いバージョンのMicro Focus Visual COBOL", "vendor": "Micro Focus", "version": "7.2"}'),
  ((SELECT id FROM web_ledger.master_types WHERE master_type = 'Middleware'),
   '{"code": "MF_COBOL73", "name": "Micro Focus Visual COBOL 7.3", "description": "旧バージョンのMicro Focus Visual COBOL", "vendor": "Micro Focus", "version": "7.3"}'),
  ((SELECT id FROM web_ledger.master_types WHERE master_type = 'Middleware'),
   '{"code": "MF_COBOL74", "name": "Micro Focus Visual COBOL 7.4", "description": "旧バージョンのMicro Focus Visual COBOL", "vendor": "Micro Focus", "version": "7.4"}'),
  ((SELECT id FROM web_ledger.master_types WHERE master_type = 'Middleware'),
   '{"code": "MF_COBOL75", "name": "Micro Focus Visual COBOL 7.5", "description": "旧バージョンのMicro Focus Visual COBOL", "vendor": "Micro Focus", "version": "7.5"}'),
  ((SELECT id FROM web_ledger.master_types WHERE master_type = 'Middleware'),
   '{"code": "MF_COBOL76", "name": "Micro Focus Visual COBOL 7.6", "description": "旧バージョンのMicro Focus Visual COBOL", "vendor": "Micro Focus", "version": "7.6"}'),
  ((SELECT id FROM web_ledger.master_types WHERE master_type = 'Middleware'),
   '{"code": "MF_COBOL80", "name": "Micro Focus Visual COBOL 8.0", "description": "最新バージョンのMicro Focus Visual COBOL", "vendor": "Micro Focus", "version": "8.0"}');

-- ---------------------------------------------
-- GnuCOBOL 製品のサンプルデータ（オープンソース）
-- ---------------------------------------------
-- GnuCOBOL のバージョン
INSERT INTO web_ledger.unified_master_records (master_id, record_data)
VALUES
  ((SELECT id FROM web_ledger.master_types WHERE master_type = 'Middleware'),
   '{"code": "GNU_COBOL11", "name": "GnuCOBOL 1.1", "description": "最も古いバージョンのGnuCOBOL", "vendor": "GnuCOBOL", "version": "1.1"}'),
  ((SELECT id FROM web_ledger.master_types WHERE master_type = 'Middleware'),
   '{"code": "GNU_COBOL15", "name": "GnuCOBOL 1.5", "description": "旧バージョンのGnuCOBOL", "vendor": "GnuCOBOL", "version": "1.5"}'),
  ((SELECT id FROM web_ledger.master_types WHERE master_type = 'Middleware'),
   '{"code": "GNU_COBOL20", "name": "GnuCOBOL 2.0", "description": "旧バージョンのGnuCOBOL", "vendor": "GnuCOBOL", "version": "2.0"}'),
  ((SELECT id FROM web_ledger.master_types WHERE master_type = 'Middleware'),
   '{"code": "GNU_COBOL21", "name": "GnuCOBOL 2.1", "description": "旧バージョンのGnuCOBOL", "vendor": "GnuCOBOL", "version": "2.1"}'),
  ((SELECT id FROM web_ledger.master_types WHERE master_type = 'Middleware'),
   '{"code": "GNU_COBOL22", "name": "GnuCOBOL 2.2", "description": "旧バージョンのGnuCOBOL", "vendor": "GnuCOBOL", "version": "2.2"}'),
  ((SELECT id FROM web_ledger.master_types WHERE master_type = 'Middleware'),
   '{"code": "GNU_COBOL312", "name": "GnuCOBOL 3.1.2", "description": "最新バージョンのGnuCOBOL", "vendor": "GnuCOBOL", "version": "3.1.2"}');


-- 3-3. 会計年度マスタ
INSERT INTO web_ledger.unified_master_records (master_id, record_data, created_at, updated_at)
VALUES 
((SELECT id FROM web_ledger.master_types WHERE master_type = 'AccountingYear'),
 '{"code": "2023", "name": "Fiscal Year 2023", "description": "2023年度（2023-04-01 ～ 2024-03-31）", "start_date": "2023-04-01", "end_date": "2024-03-31"}', '2023-04-01', '2024-03-31'),
((SELECT id FROM web_ledger.master_types WHERE master_type = 'AccountingYear'),
 '{"code": "2024", "name": "Fiscal Year 2024", "description": "2024年度（2024-04-01 ～ 2025-03-31）", "start_date": "2024-04-01", "end_date": "2025-03-31"}', '2024-04-01', '2025-03-31'),
((SELECT id FROM web_ledger.master_types WHERE master_type = 'AccountingYear'),
 '{"code": "2025", "name": "Fiscal Year 2025", "description": "2025年度（2025-04-01 ～ 2026-03-31）", "start_date": "2025-04-01", "end_date": "2026-03-31"}', '2025-04-01', '2026-03-31'),
((SELECT id FROM web_ledger.master_types WHERE master_type = 'AccountingYear'),
 '{"code": "2026", "name": "Fiscal Year 2026", "description": "2026年度（2026-04-01 ～ 2027-03-31）", "start_date": "2026-04-01", "end_date": "2027-03-31"}', '2026-04-01', '2027-03-31'),
((SELECT id FROM web_ledger.master_types WHERE master_type = 'AccountingYear'),
 '{"code": "2027", "name": "Fiscal Year 2027", "description": "2027年度（2027-04-01 ～ 2028-03-31）", "start_date": "2027-04-01", "end_date": "2028-03-31"}', '2027-04-01', '2028-03-31');

-- 3-3. 四半期マスタ
INSERT INTO web_ledger.unified_master_records (master_id, record_data)
VALUES 
((SELECT id FROM web_ledger.master_types WHERE master_type = 'Quarter'),
 '{"code": "Q1", "name": "第一四半期", "metadata": {"start_month": 4, "end_month": 6}}'),
((SELECT id FROM web_ledger.master_types WHERE master_type = 'Quarter'),
 '{"code": "Q2", "name": "第二四半期", "metadata": {"start_month": 7, "end_month": 9}}'),
((SELECT id FROM web_ledger.master_types WHERE master_type = 'Quarter'),
 '{"code": "Q3", "name": "第三四半期", "metadata": {"start_month": 10, "end_month": 12}}'),
((SELECT id FROM web_ledger.master_types WHERE master_type = 'Quarter'),
 '{"code": "Q4", "name": "第四四半期", "metadata": {"start_month": 1, "end_month": 3}}');

-- 3-3. 月マスタ
INSERT INTO web_ledger.unified_master_records (master_id, record_data)
VALUES 
((SELECT id FROM web_ledger.master_types WHERE master_type = 'Month'),
 '{"code": "1", "name": "1月", "metadata": {"month_number": 1}}'),
((SELECT id FROM web_ledger.master_types WHERE master_type = 'Month'),
 '{"code": "2", "name": "2月", "metadata": {"month_number": 2}}'),
((SELECT id FROM web_ledger.master_types WHERE master_type = 'Month'),
 '{"code": "3", "name": "3月", "metadata": {"month_number": 3}}'),
((SELECT id FROM web_ledger.master_types WHERE master_type = 'Month'),
 '{"code": "4", "name": "4月", "metadata": {"month_number": 4}}'),
((SELECT id FROM web_ledger.master_types WHERE master_type = 'Month'),
 '{"code": "5", "name": "5月", "metadata": {"month_number": 5}}'),
((SELECT id FROM web_ledger.master_types WHERE master_type = 'Month'),
 '{"code": "6", "name": "6月", "metadata": {"month_number": 6}}'),
((SELECT id FROM web_ledger.master_types WHERE master_type = 'Month'),
 '{"code": "7", "name": "7月", "metadata": {"month_number": 7}}'),
((SELECT id FROM web_ledger.master_types WHERE master_type = 'Month'),
 '{"code": "8", "name": "8月", "metadata": {"month_number": 8}}'),
((SELECT id FROM web_ledger.master_types WHERE master_type = 'Month'),
 '{"code": "9", "name": "9月", "metadata": {"month_number": 9}}'),
((SELECT id FROM web_ledger.master_types WHERE master_type = 'Month'),
 '{"code": "10", "name": "10月", "metadata": {"month_number": 10}}'),
((SELECT id FROM web_ledger.master_types WHERE master_type = 'Month'),
 '{"code": "11", "name": "11月", "metadata": {"month_number": 11}}'),
((SELECT id FROM web_ledger.master_types WHERE master_type = 'Month'),
 '{"code": "12", "name": "12月", "metadata": {"month_number": 12}}');

-- 3-3. 施策（Initiative）マスタ
INSERT INTO web_ledger.unified_master_records (master_id, record_data)
VALUES 
((SELECT id FROM web_ledger.master_types WHERE master_type = 'Initiative'),
 '{"code": "PRJ111111111111111", "name": "新製品開発促進", "description": "市場ニーズに応じた新製品開発プロジェクト"}');

-- 3-3. 担当者（Person）マスタ
INSERT INTO web_ledger.unified_master_records (master_id, record_data)
VALUES 
((SELECT id FROM web_ledger.master_types WHERE master_type = 'Person'),
 '{"code": "J0XXXXXX", "name": "山田 太郎", "description": "営業部 営業担当", "email": "taro.yamada@example.com", "phone": "03-1234-5678"}'),
((SELECT id FROM web_ledger.master_types WHERE master_type = 'Person'),
 '{"code": "J0YYYYYY", "name": "佐藤 花子", "description": "開発部 プロジェクトリーダー", "email": "hanako.sato@example.com", "phone": "03-2345-6789"}');

-- 3-3. 組織（Organization）マスタ
INSERT INTO web_ledger.unified_master_records (master_id, record_data)
VALUES 
((SELECT id FROM web_ledger.master_types WHERE master_type = 'Organization'),
 '{"code": "ORG001", "name": "本社", "description": "本社グループ全体を統括"}'),
((SELECT id FROM web_ledger.master_types WHERE master_type = 'Organization'),
 '{"code": "ORG002", "name": "営業部", "description": "国内営業部門", "parent_code": "ORG001"}'),
((SELECT id FROM web_ledger.master_types WHERE master_type = 'Organization'),
 '{"code": "ORG003", "name": "開発部", "description": "製品開発部門", "parent_code": "ORG001"}');

-- 3-3. システム（System）マスタ
INSERT INTO web_ledger.unified_master_records (master_id, record_data)
VALUES 
((SELECT id FROM web_ledger.master_types WHERE master_type = 'System'),
 '{"code": "SYS001", "name": "顧客管理システム", "description": "顧客情報管理システム", "version": "1.2.3", "owner_department": "営業部"}'),
((SELECT id FROM web_ledger.master_types WHERE master_type = 'System'),
 '{"code": "SYS002", "name": "在庫管理システム", "description": "在庫と発注を管理するシステム", "version": "3.0", "owner_department": "物流部"}');

-------------------------------
-- 4. 台帳トランザクション管理のサンプルデータ
-------------------------------

-- 4-1. LEDGER_RECORDS（例: 台帳定義は統合マスタ内の "Ledger" として管理）
-- ここでは、統合マスタ管理の中で台帳定義として登録されているレコードのIDを利用する
--INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data)
--VALUES 
--((SELECT id FROM web_ledger.unified_master_records 
--   WHERE record_data->>'code' = 'LEDGER001' AND (SELECT master_type FROM web_ledger.master_types WHERE id = master_id) = 'Ledger'),
--  1, 1, 'サンプル台帳データ1'),
--((SELECT id FROM web_ledger.unified_master_records 
--   WHERE record_data->>'code' = 'LEDGER001' AND (SELECT master_type FROM web_ledger.master_types WHERE id = master_id) = 'Ledger'),
--  2, 1, 'サンプル台帳データ2');

-- 4-2. LEDGER_HISTORY のサンプル
--INSERT INTO web_ledger.ledger_history (ledger_definition_id, update_row, updated_by, update_details)
--VALUES 
--((SELECT id FROM web_ledger.unified_master_records 
--   WHERE record_data->>'code' = 'LEDGER001' AND (SELECT master_type FROM web_ledger.master_types WHERE id = master_id) = 'Ledger'),
--  1, 'admin_user', '初回作成');

-- 4-3. AUDIT_LOGS のサンプル
--INSERT INTO web_ledger.audit_logs (action, details)
--VALUES 
--('Update', '台帳レコード1の更新が行われました');

-------------------------------
-- 5. その他管理テーブルのサンプルデータ
-------------------------------

-- 5-1. MANUALS
--INSERT INTO web_ledger.manuals (title, content, updated_by)
--VALUES 
--('ユーザーマニュアル', 'ここにユーザーマニュアルの内容を記述', 'admin_user');




INSERT INTO web_ledger.unified_master_records (master_id, record_data)
VALUES (
  (SELECT id FROM web_ledger.master_types WHERE master_type = 'Ledger'),
  '{
    "code": "LEDGER001",
    "name": "予算管理台帳",
    "filterable_columns": ["テーマ名", "年度", "予算種別", "予算番号", "予算名称", "予算額", "利用部門", "振替部門"]
  }'
);

INSERT INTO web_ledger.unified_master_records (master_id, record_data)
VALUES (
  (SELECT id FROM web_ledger.master_types WHERE master_type = 'Ledger'),
  '{
    "code": "LEDGER002",
    "name": "発注管理台帳",
    "filterable_columns": ["年度", "予算種別", "予算番号", "予算名称", "予算額", "利用部門", "振替部門", "発注部門", "発注担当者", "発注日", "検収担当者", "検収完了日"]
  }'
);

INSERT INTO web_ledger.unified_master_records (master_id, record_data)
VALUES (
  (SELECT id FROM web_ledger.master_types WHERE master_type = 'Ledger'),
  '{
    "code": "LEDGER003",
    "name": "サーバー管理台帳",
    "filterable_columns": ["管理部門", "システムコード", "システム標準名称", "システム名", "ホスト名", "OSバージョン", "稼働開始日", "最終パッチ適用日", "パッチ適用推進状況", "稼働終了予定", "移管状況", "次回パッチ適用予定", "次期サーバーリプレイス予定", "次期サーバーバージョン", "リプレイス推進状況", "システム利用ユーザー部門", "費用負担部門", "予算コード", "予算名称", "予算額", "振替部門"]
  }'
);


-- 「予算管理台帳」用フィールド定義（例）
INSERT INTO web_ledger.master_field_definitions (master_id, field_name, data_type, max_length, is_required, input_constraints)
VALUES 
((SELECT id FROM web_ledger.master_types WHERE master_type = 'Ledger'), 'ID', 'number', 200, false, NULL),
((SELECT id FROM web_ledger.master_types WHERE master_type = 'Ledger'), 'テーマ名', 'text', 200, true, NULL),
((SELECT id FROM web_ledger.master_types WHERE master_type = 'Ledger'), '年度', 'number', 200, true, NULL),
((SELECT id FROM web_ledger.master_types WHERE master_type = 'Ledger'), '予算種別', 'text', 200, true, NULL),
((SELECT id FROM web_ledger.master_types WHERE master_type = 'Ledger'), '予算番号', 'text', 200, true, NULL),
((SELECT id FROM web_ledger.master_types WHERE master_type = 'Ledger'), '予算名称', 'text', 200, true, NULL),
((SELECT id FROM web_ledger.master_types WHERE master_type = 'Ledger'), '予算額', 'real', 200, true, NULL),
((SELECT id FROM web_ledger.master_types WHERE master_type = 'Ledger'), '利用部門', 'text', 200, true, NULL),
((SELECT id FROM web_ledger.master_types WHERE master_type = 'Ledger'), '振替部門', 'text', 200, true, NULL),
-- Dummy columns（dummy1～dummy20）
((SELECT id FROM web_ledger.master_types WHERE master_type = 'Ledger'), 'dummy1', 'text', 200, false, NULL),
((SELECT id FROM web_ledger.master_types WHERE master_type = 'Ledger'), 'dummy2', 'text', 200, false, NULL),
((SELECT id FROM web_ledger.master_types WHERE master_type = 'Ledger'), 'dummy3', 'text', 200, false, NULL),
((SELECT id FROM web_ledger.master_types WHERE master_type = 'Ledger'), 'dummy4', 'text', 200, false, NULL),
((SELECT id FROM web_ledger.master_types WHERE master_type = 'Ledger'), 'dummy5', 'text', 200, false, NULL),
((SELECT id FROM web_ledger.master_types WHERE master_type = 'Ledger'), 'dummy6', 'text', 200, false, NULL),
((SELECT id FROM web_ledger.master_types WHERE master_type = 'Ledger'), 'dummy7', 'text', 200, false, NULL),
((SELECT id FROM web_ledger.master_types WHERE master_type = 'Ledger'), 'dummy8', 'text', 200, false, NULL),
((SELECT id FROM web_ledger.master_types WHERE master_type = 'Ledger'), 'dummy9', 'text', 200, false, NULL),
((SELECT id FROM web_ledger.master_types WHERE master_type = 'Ledger'), 'dummy10', 'text', 200, false, NULL),
((SELECT id FROM web_ledger.master_types WHERE master_type = 'Ledger'), 'dummy11', 'text', 200, false, NULL),
((SELECT id FROM web_ledger.master_types WHERE master_type = 'Ledger'), 'dummy12', 'text', 200, false, NULL),
((SELECT id FROM web_ledger.master_types WHERE master_type = 'Ledger'), 'dummy13', 'text', 200, false, NULL),
((SELECT id FROM web_ledger.master_types WHERE master_type = 'Ledger'), 'dummy14', 'text', 200, false, NULL),
((SELECT id FROM web_ledger.master_types WHERE master_type = 'Ledger'), 'dummy15', 'text', 200, false, NULL),
((SELECT id FROM web_ledger.master_types WHERE master_type = 'Ledger'), 'dummy16', 'text', 200, false, NULL),
((SELECT id FROM web_ledger.master_types WHERE master_type = 'Ledger'), 'dummy17', 'text', 200, false, NULL),
((SELECT id FROM web_ledger.master_types WHERE master_type = 'Ledger'), 'dummy18', 'text', 200, false, NULL),
((SELECT id FROM web_ledger.master_types WHERE master_type = 'Ledger'), 'dummy19', 'text', 200, false, NULL),
((SELECT id FROM web_ledger.master_types WHERE master_type = 'Ledger'), 'dummy20', 'text', 200, false, NULL);

INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (1, 1, 1, '1', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (1, 1, 2, 'テーマA', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (1, 1, 3, '2023', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (1, 1, 4, '種別A', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (1, 1, 5, 'B001', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (1, 1, 6, '予算名A', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (1, 1, 7, '200000', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (1, 1, 8, '部門A', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (1, 1, 9, '部門B', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (1, 1, 10, 'ダミー1', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (1, 1, 11, 'ダミー2', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (1, 1, 12, 'ダミー3', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (1, 1, 13, 'ダミー4', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (1, 1, 14, 'ダミー5', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (1, 1, 15, 'ダミー6', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (1, 1, 16, 'ダミー7', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (1, 1, 17, 'ダミー8', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (1, 1, 18, 'ダミー9', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (1, 1, 19, 'ダミー10', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (1, 1, 20, 'ダミー11', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (1, 1, 21, 'ダミー12', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (1, 1, 22, 'ダミー13', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (1, 1, 23, 'ダミー14', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (1, 1, 24, 'ダミー15', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (1, 1, 25, 'ダミー16', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (1, 1, 26, 'ダミー17', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (1, 1, 27, 'ダミー18', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (1, 1, 28, 'ダミー19', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (1, 1, 29, 'ダミー20', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (1, 2, 1, '2', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (1, 2, 2, 'テーマA', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (1, 2, 3, '2023', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (1, 2, 4, '種別A', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (1, 2, 5, 'B001', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (1, 2, 6, '予算名B', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (1, 2, 7, '100440', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (1, 2, 8, '部門A', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (1, 2, 9, '部門C', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (1, 2, 10, 'ダミー1', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (1, 2, 11, 'ダミー2', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (1, 2, 12, 'ダミー3', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (1, 2, 13, 'ダミー4', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (1, 2, 14, 'ダミー5', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (1, 2, 15, 'ダミー6', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (1, 2, 16, 'ダミー7', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (1, 2, 17, 'ダミー8', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (1, 2, 18, 'ダミー9', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (1, 2, 19, 'ダミー10', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (1, 2, 20, 'ダミー11', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (1, 2, 21, 'ダミー12', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (1, 2, 22, 'ダミー13', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (1, 2, 23, 'ダミー14', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (1, 2, 24, 'ダミー15', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (1, 2, 25, 'ダミー16', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (1, 2, 26, 'ダミー17', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (1, 2, 27, 'ダミー18', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (1, 2, 28, 'ダミー19', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (1, 2, 29, 'ダミー20', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (2, 1, 30, '1', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (2, 1, 31, '2023', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (2, 1, 32, '種別A', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (2, 1, 33, 'B001', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (2, 1, 34, '予算名A', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (2, 1, 35, '100000', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (2, 1, 36, '部門A', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (2, 1, 37, '部門B', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (2, 1, 38, '部門A', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (2, 1, 39, '担当者A', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (2, 1, 40, '2023-10-15', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (2, 1, 41, '担当者B', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (2, 1, 42, '2023-11-22', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (2, 1, 43, 'ダミー1', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (2, 1, 44, 'ダミー2', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (2, 1, 45, 'ダミー3', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (2, 1, 46, 'ダミー4', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (2, 1, 47, 'ダミー5', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (2, 1, 48, 'ダミー6', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (2, 1, 49, 'ダミー7', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (2, 1, 50, 'ダミー8', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (2, 1, 51, 'ダミー9', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (2, 1, 52, 'ダミー10', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (2, 1, 53, 'ダミー11', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (2, 1, 54, 'ダミー12', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (2, 1, 55, 'ダミー13', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (2, 1, 56, 'ダミー14', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (2, 1, 57, 'ダミー15', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (2, 1, 58, 'ダミー16', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (2, 1, 59, 'ダミー17', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (2, 1, 60, 'ダミー18', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (2, 1, 61, 'ダミー19', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (2, 1, 62, 'ダミー20', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (2, 2, 30, '2', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (2, 2, 31, '2023', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (2, 2, 32, '種別A', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (2, 2, 33, 'B001', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (2, 2, 34, '予算名B', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (2, 2, 35, '100000', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (2, 2, 36, '部門A', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (2, 2, 37, '部門B', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (2, 2, 38, '部門A', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (2, 2, 39, '担当者A', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (2, 2, 40, '2023-10-15', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (2, 2, 41, '担当者B', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (2, 2, 42, '2023-11-22', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (2, 2, 43, 'ダミー1', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (2, 2, 44, 'ダミー2', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (2, 2, 45, 'ダミー3', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (2, 2, 46, 'ダミー4', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (2, 2, 47, 'ダミー5', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (2, 2, 48, 'ダミー6', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (2, 2, 49, 'ダミー7', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (2, 2, 50, 'ダミー8', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (2, 2, 51, 'ダミー9', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (2, 2, 52, 'ダミー10', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (2, 2, 53, 'ダミー11', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (2, 2, 54, 'ダミー12', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (2, 2, 55, 'ダミー13', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (2, 2, 56, 'ダミー14', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (2, 2, 57, 'ダミー15', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (2, 2, 58, 'ダミー16', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (2, 2, 59, 'ダミー17', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (2, 2, 60, 'ダミー18', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (2, 2, 61, 'ダミー19', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (2, 2, 62, 'ダミー20', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (2, 3, 30, '3', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (2, 3, 31, '2023', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (2, 3, 32, '種別A', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (2, 3, 33, 'B001', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (2, 3, 34, '予算名C', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (2, 3, 35, '100000', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (2, 3, 36, '部門A', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (2, 3, 37, '部門B', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (2, 3, 38, '部門A', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (2, 3, 39, '担当者A', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (2, 3, 40, '2023-10-15', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (2, 3, 41, '担当者B', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (2, 3, 42, '2023-11-22', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (2, 3, 43, 'ダミー1', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (2, 3, 44, 'ダミー2', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (2, 3, 45, 'ダミー3', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (2, 3, 46, 'ダミー4', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (2, 3, 47, 'ダミー5', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (2, 3, 48, 'ダミー6', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (2, 3, 49, 'ダミー7', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (2, 3, 50, 'ダミー8', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (2, 3, 51, 'ダミー9', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (2, 3, 52, 'ダミー10', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (2, 3, 53, 'ダミー11', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (2, 3, 54, 'ダミー12', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (2, 3, 55, 'ダミー13', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (2, 3, 56, 'ダミー14', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (2, 3, 57, 'ダミー15', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (2, 3, 58, 'ダミー16', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (2, 3, 59, 'ダミー17', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (2, 3, 60, 'ダミー18', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (2, 3, 61, 'ダミー19', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (2, 3, 62, 'ダミー20', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (3, 1, 63, '1', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (3, 1, 64, '部門A', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (3, 1, 65, 'S001', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (3, 1, 66, 'システム標準名A', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (3, 1, 67, 'システム名A', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (3, 1, 68, 'host-001', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (3, 1, 69, 'OSv1.0', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (3, 1, 70, '2023-01-01', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (3, 1, 71, '2023-10-01', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (3, 1, 72, '進行中', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (3, 1, 73, '2026-03-31', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (3, 1, 74, '運用移管済', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (3, 1, 75, '2023-11-01', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (3, 1, 76, '2024-01-01', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (3, 1, 77, 'バージョン2.0', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (3, 1, 78, '推進中', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (3, 1, 79, 'ユーザー部門A', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (3, 1, 80, '費用部門A', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (3, 1, 81, 'B001', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (3, 1, 82, '予算名A', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (3, 1, 83, '100000', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (3, 1, 84, '部門B', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (3, 1, 85, 'ダミー1', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (3, 1, 86, 'ダミー2', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (3, 1, 87, 'ダミー3', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (3, 1, 88, 'ダミー4', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (3, 1, 89, 'ダミー5', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (3, 1, 90, 'ダミー6', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (3, 1, 91, 'ダミー7', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (3, 1, 92, 'ダミー8', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (3, 1, 93, 'ダミー9', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (3, 1, 94, 'ダミー10', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (3, 1, 95, 'ダミー11', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (3, 1, 96, 'ダミー12', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (3, 1, 97, 'ダミー13', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (3, 1, 98, 'ダミー14', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (3, 1, 99, 'ダミー15', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (3, 1, 100, 'ダミー16', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (3, 1, 101, 'ダミー17', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (3, 1, 102, 'ダミー18', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (3, 1, 103, 'ダミー19', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (3, 1, 104, 'ダミー20', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (3, 2, 63, '2', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (3, 2, 64, '部門A', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (3, 2, 65, 'S002', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (3, 2, 66, 'システム標準名A', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (3, 2, 67, 'システム名A', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (3, 2, 68, 'host-002', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (3, 2, 69, 'OSv1.0', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (3, 2, 70, '2023-01-01', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (3, 2, 71, '2023-10-01', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (3, 2, 72, '進行中', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (3, 2, 73, '2026-03-31', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (3, 2, 74, '運用移管済', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (3, 2, 75, '2023-11-01', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (3, 2, 76, '2024-01-01', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (3, 2, 77, 'バージョン2.0', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (3, 2, 78, '推進中', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (3, 2, 79, 'ユーザー部門A', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (3, 2, 80, '費用部門A', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (3, 2, 81, 'B001', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (3, 2, 82, '予算名A', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (3, 2, 83, '100000', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (3, 2, 84, '部門B', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (3, 2, 85, 'ダミー1', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (3, 2, 86, 'ダミー2', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (3, 2, 87, 'ダミー3', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (3, 2, 88, 'ダミー4', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (3, 2, 89, 'ダミー5', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (3, 2, 90, 'ダミー6', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (3, 2, 91, 'ダミー7', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (3, 2, 92, 'ダミー8', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (3, 2, 93, 'ダミー9', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (3, 2, 94, 'ダミー10', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (3, 2, 95, 'ダミー11', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (3, 2, 96, 'ダミー12', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (3, 2, 97, 'ダミー13', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (3, 2, 98, 'ダミー14', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (3, 2, 99, 'ダミー15', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (3, 2, 100, 'ダミー16', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (3, 2, 101, 'ダミー17', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (3, 2, 102, 'ダミー18', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (3, 2, 103, 'ダミー19', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (3, 2, 104, 'ダミー20', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (3, 3, 63, '3', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (3, 3, 64, '部門A', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (3, 3, 65, 'S003', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (3, 3, 66, 'システム標準名A', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (3, 3, 67, 'システム名A', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (3, 3, 68, 'host-003', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (3, 3, 69, 'OSv1.0', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (3, 3, 70, '2023-01-01', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (3, 3, 71, '2023-10-01', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (3, 3, 72, '進行中', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (3, 3, 73, '2026-03-31', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (3, 3, 74, '運用移管済', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (3, 3, 75, '2023-11-01', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (3, 3, 76, '2024-01-01', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (3, 3, 77, 'バージョン2.0', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (3, 3, 78, '推進中', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (3, 3, 79, 'ユーザー部門A', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (3, 3, 80, '費用部門A', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (3, 3, 81, 'B001', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (3, 3, 82, '予算名A', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (3, 3, 83, '100000', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (3, 3, 84, '部門B', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (3, 3, 85, 'ダミー1', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (3, 3, 86, 'ダミー2', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (3, 3, 87, 'ダミー3', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (3, 3, 88, 'ダミー4', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (3, 3, 89, 'ダミー5', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (3, 3, 90, 'ダミー6', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (3, 3, 91, 'ダミー7', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (3, 3, 92, 'ダミー8', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (3, 3, 93, 'ダミー9', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (3, 3, 94, 'ダミー10', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (3, 3, 95, 'ダミー11', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (3, 3, 96, 'ダミー12', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (3, 3, 97, 'ダミー13', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (3, 3, 98, 'ダミー14', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (3, 3, 99, 'ダミー15', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (3, 3, 100, 'ダミー16', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (3, 3, 101, 'ダミー17', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (3, 3, 102, 'ダミー18', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (3, 3, 103, 'ダミー19', '2025-03-05 14:32:48');
INSERT INTO web_ledger.ledger_records (ledger_definition_id, data_id, column_id, data, created_at) VALUES (3, 3, 104, 'ダミー20', '2025-03-05 14:32:48');