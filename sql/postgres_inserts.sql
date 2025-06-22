-- PostgreSQL INSERT statements generated from SQLite database
INSERT INTO web_ledger.role_master (id, role_name) VALUES (1, 'Admin');
INSERT INTO web_ledger.role_master (id, role_name) VALUES (2, 'Manager');
INSERT INTO web_ledger.role_master (id, role_name) VALUES (3, 'General User');
INSERT INTO web_ledger.users (id, username, password, role_id) VALUES (1, 'admin', 'scrypt:32768:8:1$lzoEZh8lhFDucfVY$5b6a7deaccd26d66913c2cf09b5c76b3e43f11d80645e18a019b12e9b7b5591a5156f793c663fdd86bff477c2e1435a1ac98c8608aefd62738c1931a2b0b501a', 1);
INSERT INTO web_ledger.users (id, username, password, role_id) VALUES (2, 'manager1', 'scrypt:32768:8:1$9gBhsIMcfg1iNk8F$fbb67d3fb4a2a2e491ca7cef6acd8e2d12c4df35deb812c5c168260aa7f7645789fa7f12602a58c46cbb7050545423912fd99c5d2e78a4ef36b8caf3ded8955c', 2);
INSERT INTO web_ledger.users (id, username, password, role_id) VALUES (3, 'manager2', 'scrypt:32768:8:1$1sW2LGxifp44UZeT$45b0c6bc79be125e4d1322205a403d7062cd237dbf63d6ab5d21a028ffbfc1d8bdd2635b29daf655c6b29d6fdd2745c9f1dcaffc763460e78f2fff0cc7b6f14a', 2);
INSERT INTO web_ledger.users (id, username, password, role_id) VALUES (4, 'user1', 'scrypt:32768:8:1$UEAXmlR8udCNiS6n$10e4cb8786eb5ad0f47bce703fe6a054cb302062b4ac9c5dad0106bac9dde99577f08d5fa51712e0403c26b6f2d48c2143dc1d76c25c0754f63abf44db57802e', 3);
INSERT INTO web_ledger.users (id, username, password, role_id) VALUES (5, 'user2', 'scrypt:32768:8:1$MiBDrR9rJzlfP8kn$628b753245556dd9aca79175ec60ee72120e2eeebd186441fa92d92fc93c93a3e6e957bb47739c090c7a9072fa8a4b6ecd9d295b06f32525b9b8fa0bc611262e', 3);
INSERT INTO web_ledger.users (id, username, password, role_id) VALUES (6, 'user3', 'scrypt:32768:8:1$1qB4vu9gK44rGr6x$5faecbce6b4a38fe61da29b6163174d5a87109b8b72d12ec73a820bd2640913b11551eae9d1f113ac1b9cb60d48c4ade63945c383bb44104db50abee82723cc9', 3);
INSERT INTO web_ledger.users (id, username, password, role_id) VALUES (7, 'user4', 'scrypt:32768:8:1$RhZ255FO5lcpuv5y$26ad9db44c3ad2ef698067df688b068b61464777207660479384062df45d6dfe0343b45445caff80d2394e23ea3c040aaeaeb7cd6ede4ac4ad472fc8ea62d1a2', 3);
INSERT INTO web_ledger.manuals (id, title, content, updated_by, updated_at) VALUES (1, 'ユーザーガイド', 'Web Ledgerアプリケーションの使用方法についての説明。', 'admin', '2025-03-05 14:32:48');
INSERT INTO web_ledger.manuals (id, title, content, updated_by, updated_at) VALUES (2, '管理者マニュアル', 'Web Ledgerアプリケーションの管理者向け操作手順。ユーザー管理、台帳管理、レポート生成方法などを詳細に説明します。', 'admin', '2025-03-05 14:32:48');
INSERT INTO web_ledger.manuals (id, title, content, updated_by, updated_at) VALUES (3, '一般ユーザーマニュアル', '一般ユーザー向けのWeb Ledgerアプリケーションの使用方法。台帳の閲覧、データの入力方法などを説明します。', 'admin', '2025-03-05 14:32:48');
INSERT INTO web_ledger.version_history (id, version, sprint, update_info, timestamp) VALUES (1, 'v1.0', '1', '基本的な台帳機能の初期リリース（ログイン/ログアウト、Web台帳表示、言語切替、AI分析を含む）。', '2025-03-03 12:00:00');
INSERT INTO web_ledger.version_history (id, version, sprint, update_info, timestamp) VALUES (2, 'v2.0', '2', 'マルチ台帳対応（予算、サーバー情報、注文）、UIの改善、包括的なユーザー管理、マニュアル、バージョン履歴の追加。', '2025-03-03 12:15:00');
INSERT INTO web_ledger.version_history (id, version, sprint, update_info, timestamp) VALUES (3, 'v3.0', '3', '台帳種類の選択機能の強化、データベースの正規化、UIの再設計、ファイルアップロード機能の拡充。', '2025-03-03 12:30:00');
INSERT INTO web_ledger.version_history (id, version, sprint, update_info, timestamp) VALUES (4, 'v4.0', '4', '台帳機能の強化（フィルタ行の追加、各セルの直接編集機能追加）、編集データの記録機能の追加。', '2025-03-03 12:45:00');
INSERT INTO web_ledger.version_history (id, version, sprint, update_info, timestamp) VALUES (5, 'v4.1', '4.1', '不具合修正（データ編集履歴モーダルの表示不可是正）', '2025-03-03 13:00:00');
INSERT INTO web_ledger.version_history (id, version, sprint, update_info, timestamp) VALUES (6, 'v5.0', '5', '・ダッシュボードのレイアウト・テーマのカスタマイズ機能を拡充（admin/managerロールによる台帳の新規作成や項目管理をDB化
・台帳の表示列をユーザー別に設定・ダウンロード可能にし、多言語対応（日英）や更新履歴の詳細管理を強化
・その他，レポート機能やAI連携、パフォーマンス最適化を実施', '2025-03-03 13:15:00');
INSERT INTO web_ledger.version_history (id, version, sprint, update_info, timestamp) VALUES (7, 'v6.0', '6', '統合マスタ管理と台帳定義の再設計、各種機能拡張, '2025-03-17 13:15:00');
INSERT INTO web_ledger.ledger_history (id, ledger_type_id, ledger_type, update_row, updated_by, update_time, update_details) VALUES (1, 1, '予算管理台帳', '1', 'admin', '2025-03-05 16:09:59', '予算額 を 100000 から 200000 に更新');
INSERT INTO web_ledger.ledger_history (id, ledger_type_id, ledger_type, update_row, updated_by, update_time, update_details) VALUES (2, 1, '予算管理台帳', '2' 'admin', '2025-03-05 16:16:29', '振替部門 を 部門B から 部門C に更新');
INSERT INTO web_ledger.ledger_history (id, ledger_type_id, ledger_type, update_row, updated_by, update_time, update_details) VALUES (3, 1, '予算管理台帳', '1' 'admin', '2025-03-07 05:58:30', '予算額 を 100000 から 100009 に更新');
INSERT INTO web_ledger.ledger_history (id, ledger_type_id, ledger_type, update_row, updated_by, update_time, update_details) VALUES (4, 1, '予算管理台帳', '1' 'admin', '2025-03-07 12:27:10', '予算額 を 100000 から 100050 に更新');
INSERT INTO web_ledger.ledger_history (id, ledger_type_id, ledger_type, update_row, updated_by, update_time, update_details) VALUES (5, 1, '予算管理台帳', '1' 'admin', '2025-03-08 05:32:01', '予算額 を 100000 から 100400 に更新');
INSERT INTO web_ledger.ledger_history (id, ledger_type_id, ledger_type, update_row, updated_by, update_time, update_details) VALUES (6, 1, '予算管理台帳', '1' 'admin', '2025-03-08 05:33:11', '予算額 を 100400 から 100440 に更新');
INSERT INTO web_ledger.audit_logs (id, action, details, timestamp) VALUES (1, 'Update Ledger', 'Ledger ID 1 の 予算額 を 100000 から 200000 に更新', '2025-03-06 01:09:59');
INSERT INTO web_ledger.audit_logs (id, action, details, timestamp) VALUES (2, 'Update Ledger', 'Ledger ID 2 の 振替部門 を 部門B から 部門C に更新', '2025-03-06 01:16:29');
INSERT INTO web_ledger.audit_logs (id, action, details, timestamp) VALUES (3, 'Update Ledger', 'Ledger ID 3 の 予算額 を 100000 から 100009 に更新', '2025-03-07 14:58:30');
INSERT INTO web_ledger.audit_logs (id, action, details, timestamp) VALUES (4, 'Update Ledger', 'Ledger ID 4 の 予算額 を 100000 から 100050 に更新', '2025-03-07 21:27:10');
INSERT INTO web_ledger.audit_logs (id, action, details, timestamp) VALUES (5, 'Update Ledger', 'Ledger ID 2 の 予算額 を 100000 から 100400 に更新', '2025-03-08 14:32:01');
INSERT INTO web_ledger.audit_logs (id, action, details, timestamp) VALUES (6, 'Update Ledger', 'Ledger ID 2 の 予算額 を 100400 から 100440 に更新', '2025-03-08 14:33:11');