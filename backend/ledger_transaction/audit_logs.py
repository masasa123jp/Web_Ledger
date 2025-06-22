import logging
from datetime import datetime
from typing import Any, Dict, List
from backend.api_util.api_util import get_db_connection

def log_audit(action: str, details: str) -> None:
    """
    監査ログを記録します。
    """
    try:
        with get_db_connection() as conn:
            with conn.cursor() as cursor:
                query = """
                    INSERT INTO audit_logs (action, details, timestamp)
                    VALUES (%s, %s, %s)
                """
                timestamp = datetime.now()
                cursor.execute(query, (action, details, timestamp))
            conn.commit()
    except Exception as e:
        logging.error("Error logging audit: %s", e)
        raise

def get_audit_logs() -> List[Dict[str, Any]]:
    """
    監査ログを全件、タイムスタンプ降順で取得します。
    """
    try:
        with get_db_connection() as conn:
            with conn.cursor() as cursor:
                query = "SELECT * FROM audit_logs ORDER BY timestamp DESC"
                cursor.execute(query)
                rows = cursor.fetchall()
                return [dict(row) for row in rows]
    except Exception as e:
        logging.error("Error retrieving audit logs: %s", e)
        raise
