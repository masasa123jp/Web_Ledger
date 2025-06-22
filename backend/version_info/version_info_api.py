#!/usr/bin/env python
"""
version_info_api.py - バージョン履歴取得の RESTful API を実装。
version_history テーブルからバージョン情報を取得し、JSON レスポンスとして返します。
"""

import logging
from flask import Blueprint, jsonify
from backend.api_util.api_util import get_connection

# Blueprint の登録。URLプレフィックスを '/api/version_history' に統一
version_info_bp = Blueprint('version_info', __name__, url_prefix='/api/version_history')

@version_info_bp.route('/', methods=['GET'])
def get_version_history():
    """
    バージョン履歴を取得するエンドポイント。
    Returns:
        JSON: バージョン履歴のリスト（各エントリは辞書形式）
    """
    try:
        history = get_version_history_dict()
        return jsonify(history), 200
    except Exception as e:
        logging.error("バージョン履歴取得エラー: %s", str(e))
        return jsonify({"message": "バージョン履歴の取得に失敗しました。"}), 400


def get_version_history_dict() -> dict:
    """
    バージョン履歴を取得するエンドポイント。
    Returns:
        JSON: バージョン履歴のリスト（各エントリは辞書形式）
    """
    try:
        with get_connection() as conn:
            cursor = conn.cursor()
            # version_history テーブルの情報を timestamp の降順で取得
            cursor.execute("SELECT * FROM web_ledger.version_history ORDER BY timestamp DESC")
            rows = cursor.fetchall()
            history = [dict(row) for row in rows]
        return history
    except Exception as e:
        logging.error("バージョン履歴取得エラー: %s", str(e))
        return jsonify({"message": "バージョン履歴の取得に失敗しました。"}), 400