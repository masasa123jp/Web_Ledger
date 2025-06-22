# backend/dashboard/dashboard_data_service.py
import logging
from backend.api_util.api_util import get_connection

class DashboardDataService:
    def get_kpi_data(self):
        """
        KPI用のデータをDBから取得するサンプル実装
        """
        try:
            with get_connection() as conn:
                cursor = conn.cursor()
                cursor.execute("""
                    SELECT
                      SUM(amount)       AS total_sales,
                      AVG(amount)       AS average_sales,
                      COUNT(*)          AS transaction_count
                    FROM web_ledger.ledger_records
                """)
                row = cursor.fetchone()
                if row:
                    return {
                        "Total Sales": float(row["total_sales"] or 0),
                        "Average Sales": float(row["average_sales"] or 0),
                        "Transaction Count": int(row["transaction_count"] or 0)
                    }
                else:
                    return {
                        "Total Sales": 0,
                        "Average Sales": 0,
                        "Transaction Count": 0
                    }
        except Exception as e:
            logging.error("Error retrieving KPI data: %s", e)
            raise

    def get_chart_data(self):
        """
        チャート描画用のデータをDBから取得するダミー実装例
        """
        try:
            # 実際にはDBクエリなど
            return {
                "labels": ["Jan", "Feb", "Mar", "Apr"],
                "values": [500, 700, 650, 800]
            }
        except Exception as e:
            logging.error("Error retrieving chart data: %s", e)
            raise

    def get_sheet_data(self):
        """
        スプレッドシート表示用のデータをDBから取得するダミー実装例
        """
        try:
            with get_connection() as conn:
                cursor = conn.cursor()
                cursor.execute("""
                    SELECT id, record_date, amount, category
                    FROM web_ledger.ledger_records
                    ORDER BY record_date DESC
                    LIMIT 10
                """)
                rows = cursor.fetchall()
                header = ["ID", "Date", "Amount", "Category"]
                data = [header]
                for row in rows:
                    data.append([
                        row["id"],
                        str(row["record_date"]),
                        float(row["amount"] or 0),
                        row["category"]
                    ])
                return {
                    "data": data
                }
        except Exception as e:
            logging.error("Error retrieving sheet data: %s", e)
            raise

dashboard_data_service = DashboardDataService()