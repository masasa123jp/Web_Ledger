# backend/report_dashboard/report_generator.py

"""
report_generator.py - 台帳データを集計し、分析レポートを生成するモジュール。
グラフ描画用データや統計情報を生成します。
"""

from backend.api_util.api_util import get_connection
import logging

class ReportGenerator:
    def generate_report(self, date_from: str, date_to: str) -> dict:
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