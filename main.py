#!/usr/bin/env python
"""
main.py - Web Ledger Management Application のエントリポイント。
Flask アプリケーションファクトリー create_app() を利用して初期化し、
各 API モジュールを Blueprint として登録します。
また、フロントエンドの各 HTML ページ（/frontend/ledger_form/ledger_form.html、
/frontend/dashboard/dashboard.html、/frontend/unified_master_manager/～ など）へアクセスできるルートも定義しています。
"""
import logging
import json
import sys
from flask import Flask, render_template, jsonify
from config import init_app as init_config
from backend.api_util.api_util import init_db_pool
from backend.auth.auth_api import auth_bp
from backend.master_management.master_management_api import master_bp
from backend.ledger_transaction.ledger_manager import ledger_bp
from backend.excel_import.excel_importer import excel_bp
from backend.ai_ml_integration.ai_ml_integration import ai_bp
from backend.version_info.version_info_api import version_info_bp, get_version_history_dict
from backend.manual.manual_api import manual_bp
from backend.report_dashboard.report_dashboard_api import report_dashboard_bp
from backend.performance_optimization.async_task_controller import async_bp
from backend.dashboard.dashboard_data_management_api import data_mgmt_bp
from backend.auth.user_management_api import user_management_bp

# ログ設定
logging.basicConfig(level=logging.INFO, format='%(asctime)s %(levelname)s %(message)s')

from backend.ledger_transaction.ledger_manager import LedgerManager

# 必要なマネージャーのインスタンスを作成
ledger_manager = LedgerManager()

def create_app():
    # フロントエンドの全HTMLテンプレートは /frontend 以下に配置
    app = Flask(
        __name__,
        template_folder='frontend',    # frontend 配下のすべてのHTMLテンプレートを利用
        static_folder='app/static'       # 静的ファイル（CSS, JS, 画像など）は app/static から配信
    )
    init_config(app)

    # 必須 DB 設定のチェック
    required = ["DB_NAME", "DB_USER", "DB_PASSWORD", "DB_HOST", "DB_PORT"]
    missing = [key for key in required if not app.config.get(key)]
    if missing:
        logging.error("DB設定が不足しています: %s", missing)
        sys.exit(1)

    try:
        init_db_pool(
            minconn=1,
            maxconn=20,
            dbname=app.config["DB_NAME"],
            user=app.config["DB_USER"],
            password=app.config["DB_PASSWORD"],
            host=app.config["DB_HOST"],
            port=int(app.config["DB_PORT"])
        )
    except Exception:
        logging.exception("DB接続プールの初期化に失敗しました。アプリケーションを終了します。")
        sys.exit(1)

    # Blueprint 登録
    for bp in [auth_bp, user_management_bp, master_bp, ledger_bp, excel_bp, report_dashboard_bp, ai_bp, version_info_bp, manual_bp, async_bp, data_mgmt_bp]:
        app.register_blueprint(bp)

    # 共通エラーハンドラ
    @app.errorhandler(404)
    def page_not_found(e):
        app.logger.error(f"404 エラー: {e}")
        return jsonify({"message": "ページが見つかりません。"}), 404

    @app.errorhandler(500)
    def internal_server_error(e):
        app.logger.error(f"500 エラー: {e}")
        return jsonify({"message": "内部サーバーエラーが発生しました。"}), 500

    # トップページ（例: frontend/index/index.html を利用）
    @app.route('/')
    def index():
        return render_template('index.html')

    # 各フロントエンドページへアクセスするためのルートを追加
    @app.route('/ledger_form/<path:filename>')
    def ledger_form(filename):
        return render_template(filename)

    @app.route('/dashboard/<path:filename>')
    def dashboard(filename):
        return render_template(filename)

    @app.route('/user_management/<path:filename>')
    def user_management(filename):
        return render_template(filename)

    @app.route('/manual/<path:filename>')
    def manual(filename):
        try:
            manuals = ledger_manager.get_manuals()
            return render_template(filename, manuals=manuals)
        except Exception as e:
            logging.error("マニュアルページ読み込みエラー: %s", str(e))
            return render_template(filename, manuals=[])

    @app.route('/version_history/<path:filename>')
    def version_history(filename):
        #history = get_version_history_dict()
        return render_template(filename)

    @app.route('/ai/<path:filename>')
    def ai(filename):
        return render_template(filename)

    @app.route('/pivot/<path:filename>')
    def pivot(filename):
        return render_template(filename)

    @app.route('/report_dashboard_ui/<path:filename>')
    def report_dashboard_ui(filename):
        return render_template(filename)
    
    # 新規追加: 統合マスター管理画面へのルート
    @app.route('/unified_master_manager/<path:filename>')
    def unified_master_manager(filename):
        return render_template(filename)

    return app


app = create_app()

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=app.config.get("DEBUG", False))
