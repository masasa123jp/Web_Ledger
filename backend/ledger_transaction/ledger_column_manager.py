import logging
from typing import Optional, List, Dict, Any
from backend.api_util.api_util import get_connection

class LedgerColumnManager:
    """
    台帳項目（カラム）の管理を行います。
    """
    def add_ledger_column(self, ledger_master_id: int, column_name: str, data_type: str,
                          max_length: int, display_order: int, is_filterable: bool = False) -> None:
        """
        新しい台帳項目を追加します。
        """
        try:
            with get_connection() as conn:
                with conn.cursor() as cursor:
                    cursor.execute("""
                        INSERT INTO master_field_definitions 
                        (ledger_master_id, column_name, data_type, max_length, display_order, is_filterable)
                        VALUES (%s, %s, %s, %s, %s, %s)
                    """, (ledger_master_id, column_name, data_type, max_length, display_order, int(is_filterable)))
        except Exception as e:
            logging.error("Error adding ledger column: %s", e)
            raise

    def update_ledger_column(self, column_id: int, column_name: Optional[str] = None,
                             data_type: Optional[str] = None, max_length: Optional[int] = None,
                             display_order: Optional[int] = None, is_filterable: Optional[bool] = None) -> None:
        """
        指定された項目のみを更新します。
        """
        updates = []
        params = []

        if column_name is not None:
            updates.append("column_name = %s")
            params.append(column_name)
        if data_type is not None:
            updates.append("data_type = %s")
            params.append(data_type)
        if max_length is not None:
            updates.append("max_length = %s")
            params.append(max_length)
        if display_order is not None:
            updates.append("display_order = %s")
            params.append(display_order)
        if is_filterable is not None:
            updates.append("is_filterable = %s")
            params.append(int(is_filterable))

        if not updates:
            return  # 更新項目がない場合

        query = "UPDATE master_field_definitions SET " + ", ".join(updates) + " WHERE id = %s"
        params.append(column_id)

        try:
            with get_connection() as conn:
                with conn.cursor() as cursor:
                    cursor.execute(query, params)
        except Exception as e:
            logging.error("Error updating ledger column: %s", e)
            raise

    def delete_ledger_column(self, column_id: int) -> None:
        """
        指定された台帳項目を削除します。
        """
        try:
            with get_connection() as conn:
                with conn.cursor() as cursor:
                    cursor.execute("DELETE FROM master_field_definitions WHERE id = %s", (column_id,))
        except Exception as e:
            logging.error("Error deleting ledger column: %s", e)
            raise

    def get_columns_by_ledger(self, ledger_master_id: int) -> List[Dict[str, Any]]:
        """
        ledger_master_id に紐づく台帳項目情報を取得します。
        """
        try:
            with get_connection() as conn:
                with conn.cursor() as cursor:
                    cursor.execute("""
                        SELECT * FROM master_field_definitions 
                        WHERE ledger_master_id = %s ORDER BY display_order ASC
                    """, (ledger_master_id,))
                    rows = cursor.fetchall()
                    return [dict(row) for row in rows]
        except Exception as e:
            logging.error("Error retrieving ledger columns: %s", e)
            raise
