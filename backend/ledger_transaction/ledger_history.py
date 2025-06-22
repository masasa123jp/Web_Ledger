import logging
from datetime import datetime
from typing import Any, Dict, List
from backend.api_util.api_util import get_connection

def record_ledger_history(ledger_master_id: int, data_id: int, updated_by: str, change_details: str) -> None:
    """
    台帳更新の履歴を記録します。
    """
    try:
        with get_connection() as conn:
            with conn.cursor() as cursor:
                query = """
                    INSERT INTO ledger_history (ledger_master_id, data_id, updated_by, change_details, updated_at)
                    VALUES (%s, %s, %s, %s, %s)
                """
                timestamp = datetime.now()
                cursor.execute(query, (ledger_master_id, data_id, updated_by, change_details, timestamp))
            conn.commit()
    except Exception as e:
        logging.error("Error recording ledger history: %s", e)
        raise

def get_ledger_history(ledger_master_id: int, data_id: int) -> List[Dict[str, Any]]:
    """
    指定された台帳レコードの更新履歴を取得します。
    """
    try:
        with get_connection() as conn:
            with conn.cursor() as cursor:
                query = """
                    SELECT * FROM ledger_history
                    WHERE ledger_master_id = %s AND data_id = %s
                    ORDER BY updated_at DESC
                """
                cursor.execute(query, (ledger_master_id, data_id))
                rows = cursor.fetchall()
                return [dict(row) for row in rows]
    except Exception as e:
        logging.error("Error retrieving ledger history: %s", e)
        raise
