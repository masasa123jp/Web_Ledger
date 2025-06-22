#!/usr/bin/env python
"""
manual_api.py - マニュアル管理の RESTful API を実装。
マニュアルの取得および更新処理を、台帳管理モジュールの機能を利用して実施します。
"""

import logging
from flask import Blueprint, request, jsonify, session, render_template
from typing import Any, Dict, List

# LedgerManager は既存の台帳管理処理を提供
from backend.master_management.master_management_api import LedgerMasterManager
from backend.ledger_transaction.ledger_manager import LedgerManager

# 必要なマネージャーのインスタンスを作成
#ledger_master_manager = LedgerMasterManager()
ledger_manager = LedgerManager()

# Blueprint の登録。URL プレフィックスは '/api/manual' とする
manual_bp = Blueprint('manual', __name__, url_prefix='/api/manual')

@manual_bp.route('/manuals', methods=['GET'])
def get_manuals() -> Any:
    """
    マニュアルを全件取得するエンドポイント。
    Returns:
        JSON: マニュアルのリスト
    """
    try:
        manuals: List[Dict[str, Any]] = ledger_manager.get_manuals()
        print(manuals)
        return jsonify(manuals), 200
    except Exception as e:
        logging.error("マニュアル取得エラー: %s", str(e))
        return jsonify({"message": "マニュアルの取得に失敗しました。"}), 400

@manual_bp.route('/manuals/<int:manual_id>', methods=['GET'])
def get_manual(manual_id: int) -> Any:
    """
    指定したIDのマニュアルを取得するエンドポイント。
    Returns:
        JSON: 該当マニュアル（存在しない場合は 404 エラー）
    """
    try:
        manuals: List[Dict[str, Any]] = ledger_manager.get_manuals()
        manual = next((m for m in manuals if m.get("id") == manual_id), None)
        if manual:
            return jsonify(manual), 200
        else:
            return jsonify({"message": "マニュアルが見つかりません。"}), 404
    except Exception as e:
        logging.error("マニュアル取得エラー: %s", str(e))
        return jsonify({"message": "マニュアルの取得に失敗しました。"}), 400

@manual_bp.route('/manuals/<int:manual_id>', methods=['PUT'])
def update_manual(manual_id: int) -> Any:
    """
    指定したIDのマニュアルを更新するエンドポイント。
    リクエストJSONには 'title' と 'content' を含む必要があります。
    """
    data: Dict[str, Any] = request.get_json()
    title: str = data.get("title")
    content: str = data.get("content")
    if not title or not content:
        return jsonify({"message": "タイトルとコンテンツが必要です。"}), 400

    try:
        # セッションからログインユーザー名を取得（存在しない場合は "unknown"）
        updated_by = session.get("user", {}).get("username", "unknown")
        ledger_manager.update_manual(manual_id, title, content, updated_by)
        return jsonify({"message": "マニュアルを更新しました。"}), 200
    except Exception as e:
        logging.error("マニュアル更新エラー: %s", str(e))
        return jsonify({"message": "マニュアルの更新に失敗しました。"}), 400
