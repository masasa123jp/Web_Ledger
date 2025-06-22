# backend/report_dashboard/report_dashboard_api.py

"""
report_dashboard_api.py - レポートダッシュボード用 API モジュール

このモジュールは、ユーザーが指定したフィルタ条件（例: dateFrom, dateTo）に基づき
台帳レコードを集計し、Chart.js 用のグラフデータとサマリーデータを JSON 形式で返します。

また、必要に応じて台帳全体のレコードも取得できるエンドポイントを実装しています。
"""

import logging
from flask import Blueprint, request, jsonify
from backend.api_util.api_util import get_connection

report_dashboard_bp = Blueprint('report_dashboard', __name__, url_prefix='/api/report/dashboard')

def generate_report_data(date_from: str, date_to: str) -> dict:
    """
    台帳レコードを集計し、レポートデータおよびグラフ用データを生成する。
    Args:
        date_from (str): 集計開始日（YYYY-MM-DD形式 または None）
        date_to (str): 集計終了日（YYYY-MM-DD形式 または None）
    Returns:
        dict: {
            "summary": { category: total_amount, ... },
            "chartData": { "labels": [...], "datasets": [ { "label": "総売上", "data": [...], "backgroundColor": "rgba(75, 192, 192, 0.6)" } ] }
        }
    """
    query = """
        SELECT category, SUM(amount) AS total_amount, COUNT(*) AS record_count
        FROM web_ledger.ledger_records
        WHERE (%s IS NULL OR record_date >= %s)
          AND (%s IS NULL OR record_date <= %s)
        GROUP BY category
        ORDER BY total_amount DESC
    """
    params = (date_from, date_from, date_to, date_to)
    try:
        with get_connection() as conn:
            cursor = conn.cursor()
            cursor.execute(query, params)
            rows = cursor.fetchall()
            summary = [dict(row) for row in rows]
    except Exception as e:
        logging.error(f"集計クエリ実行エラー: {e}")
        raise

    labels = [item["category"] for item in summary]
    data = [float(item["total_amount"] or 0) for item in summary]
    chart_data = {
        "labels": labels,
        "datasets": [
            {
                "label": "総売上",
                "data": data,
                "backgroundColor": "rgba(75, 192, 192, 0.6)"
            }
        ]
    }
    return {
        "summary": {item["category"]: item["total_amount"] for item in summary},
        "chartData": chart_data
    }

@report_dashboard_bp.route('', methods=['GET'])
def get_dashboard_report():
    """
    GET /api/report/dashboard
    クエリパラメータ 'dateFrom' と 'dateTo' に基づいて台帳レコードを集計し、
    Chart.js 用のグラフデータおよびサマリーデータを生成して JSON 形式で返す。
    """
    date_from = request.args.get("dateFrom")
    date_to = request.args.get("dateTo")
    try:
        report_data = generate_report_data(date_from, date_to)
        return jsonify(report_data), 200
    except Exception as e:
        logging.error(f"レポート生成エラー: {e}")
        return jsonify({"message": "レポートの生成に失敗しました。"}), 500

@report_dashboard_bp.route('/records', methods=['GET'])
def get_all_ledger_records():
    """
    GET /api/report/dashboard/records
    台帳レコード全体を取得するエンドポイント（フロントエンドのHandsontable用）
    """
    ledger_type = request.args.get("type")
    if not ledger_type:
        return jsonify({"message": "台帳タイプが必要です。"}), 400

    try:
        with get_connection() as conn:
            cursor = conn.cursor()
            # カラム情報の取得
            cursor.execute("""
                SELECT mfd.field_name, mfd.data_type
                FROM web_ledger.master_field_definitions mfd
                JOIN web_ledger.master_types mt ON mfd.master_type_id = mt.id
                WHERE mt.master_type = %s
                ORDER BY mfd.display_order ASC
            """, (ledger_type,))
            columns_info = cursor.fetchall()
            columns = [dict(row) for row in columns_info]

            # 台帳レコードの取得
            cursor.execute("""
                SELECT lr.data_id, mfd.field_name, lr.data
                FROM web_ledger.ledger_records lr
                JOIN web_ledger.master_field_definitions mfd ON lr.column_id = mfd.id
                WHERE lr.ledger_definition_id = (
                    SELECT id FROM web_ledger.master_types WHERE master_type = %s
                )
                ORDER BY lr.data_id ASC
            """, (ledger_type,))
            records_raw = cursor.fetchall()
            records_dict = {}
            for row in records_raw:
                data_id = row["data_id"]
                field_name = row["field_name"]
                data = row["data"]
                if data_id not in records_dict:
                    records_dict[data_id] = {"ID": data_id}
                records_dict[data_id][field_name] = data
            records = list(records_dict.values())

        return jsonify({"columns": columns, "records": records}), 200
    except Exception as e:
        logging.error(f"台帳レコード取得エラー: {e}")
        return jsonify({"message": "台帳レコードの取得に失敗しました。"}), 500