# backend/dashboard/dashboard_data_management_service.py
import logging
import json
from backend.api_util.api_util import get_connection

class DashboardDataManagementService:
    """
    画面から指定された台帳(ledger_type) と 項目IDリスト(field_ids) に基づき、
    ledger_records などからレコードを抽出して、sheetData を組み立てる。
    """

    def _get_valid_field_ids(self, ledger_type: str, field_ids: list) -> dict:
        """
        指定された ledger_type(tag) に対応する master_field_definitions から
        該当する id の field_name を取得し、{ id: field_name } で返す。
        """
        with get_connection() as conn:
            cursor = conn.cursor()
            query = """
                SELECT id, field_name
                FROM web_ledger.master_field_definitions
                WHERE tag = %s
                  AND id = ANY(%s::int[])
            """
            cursor.execute(query, (ledger_type, field_ids))
            rows = cursor.fetchall()
            result = { row["id"]: row["field_name"] for row in rows }
            return result

    def create_ledger_records(self, label_mapping, data_rows):
        """
        label_mapping: { "1": "ID", "2": "テーマ名", ... }
        data_rows: ledger_records から取得した行 [ (id, data_id, column_id, data, ...), ... ]

        同じ data_id をまとめて1行とし、label_mapping[column_id] をキー、data を値とする dict を作る。
        """
        records = {}
        for row in data_rows:
            record_id   = row[1]  # data_id
            field_key   = str(row[2])   # column_id
            field_value = row[3]
            if record_id not in records:
                records[record_id] = {}
            label = label_mapping.get(field_key, field_key)
            records[record_id][label] = field_value
        # record_id 昇順にソートしてリスト化
        ledger_records = [records[k] for k in sorted(records.keys())]
        return ledger_records

    def get_dynamic_data(self, ledger_type: str, field_ids: list, limit: int) -> dict:
        """
        ledger_type: e.g. "LEDGER001"
        field_ids:   [1,2,3,4,...]
        limit:       int
        戻り値は {
          "kpi": {...},       # 必要に応じて
          "chartData": {...}, # 必要に応じて
          "sheetData": { "data": [...], "columns": [...] }
        }
        """
        try:
            # 1) 項目ID→項目名のマッピング取得
            field_names = self._get_valid_field_ids(ledger_type, field_ids)
            print("Valid field mapping:", json.dumps(field_names, ensure_ascii=False, indent=2))

            # 2) ledger_records から該当データを抽出
            with get_connection() as conn:
                cursor = conn.cursor()
                query = """
                    SELECT *
                    FROM web_ledger.ledger_records
                    WHERE column_id = ANY(%s::int[])
                    ORDER BY data_id, column_id ASC
                    LIMIT %s
                """
                cursor.execute(query, (field_ids, limit * len(field_ids)))
                records = cursor.fetchall()

            # 3) create_ledger_records() でレコードを組み立て
            ledger_data = self.create_ledger_records(field_names, records)
            print("Ledger data:", json.dumps(ledger_data, ensure_ascii=False, indent=2))

            # 戻り値として sheetData を必ず { data: [...], columns: [...] } の形で返す
            result = {
                "kpi": {},        # 必要なら別途KPI計算
                "chartData": {},  # 必要ならチャート用データ
                "sheetData": {
                    "data": ledger_data if ledger_data else [],
                    "columns": []
                }
            }
            return result

        except Exception as e:
            logging.error("Dynamic data retrieval failed: %s", e)
            # 例外を再スローし、API 層でハンドリング
            raise

dashboard_data_management_service = DashboardDataManagementService()