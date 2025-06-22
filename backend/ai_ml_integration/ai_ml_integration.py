# backend/ai_ml_integration/ai_ml_integration.py

"""
ai_ml_integration.py - 生成AIと機械学習モデルの統合モジュール。
このモジュールは、Flask Blueprint を用いて生成AIチャットエンドポイントを提供します。

【概要】
・/api/ai/chat エンドポイント：
  セッションにチャット履歴を保持し、OpenAI API を呼び出して応答を生成します。
・/api/ai/analysis エンドポイント：
  フロントエンドから渡された台帳レコードに対して、AIAgent (ai_agent.py) を用いた台帳分析を実施します。

既存の
call_openai_api.py、ai_agent.pyの実装を活用しています。
"""

from flask import Blueprint, request, jsonify, session
import textwrap
import logging
from typing import Any, Dict, List
from backend.ai_ml_integration.call_openai_api import call_openai_api  # OpenAI API 呼び出し
from backend.ai_ml_integration.ai_agent import AIAgent  # 台帳分析用 AIエージェント

ai_bp = Blueprint('ai', __name__, url_prefix='/api/ai')

def format_ai_response(response: str, fmt: str = "plain") -> str:
    """
    AI応答テキストを指定された形式に整形
      - plain: 改行のみ、全体を最大100文字に切り詰め
      - html: 各行を <p> タグで囲む
      - md: Markdown形式（必要に応じてそのまま返す）
    """
    formatted = response.strip()
    wrapped = "\n".join(textwrap.wrap(formatted, width=20))
    if len(wrapped) > 100:
        wrapped = wrapped[:100]
    if fmt == "html":
        lines = wrapped.split("\n")
        return "".join(f"<p>{line}</p>" for line in lines)
    elif fmt == "md":
        return wrapped
    else:
        return wrapped

@ai_bp.route('/chat', methods=['POST'])
def ai_chat():
    """
    生成AIチャットエンドポイント
    リクエストJSON例:
      {
         "message": "ユーザーのメッセージ",
         "model": "gpt-4o-mini",    # オプション
         "reset": true/false,       # オプション（trueでチャット履歴リセット）
         "format": "plain"          # 出力形式: plain / html / md
      }
    """
    data = request.get_json()
    if not data or "message" not in data:
        return jsonify({"message": "messageが必要です。"}), 400

    user_message = data["message"].strip()
    model = data.get("model", "gpt-4o-mini")
    resp_format = data.get("format", "plain").lower()
    reset = data.get("reset", False)

    if reset:
        session['ai_chat_history'] = []

    # セッションに保持しているチャット履歴を取得
    chat_history = session.get('ai_chat_history', [])
    if user_message:
        chat_history.append({"role": "user", "content": user_message})

    try:
        # OpenAI API を呼び出して生成応答を取得
        ai_response = call_openai_api(messages=chat_history, model_name=model)
        formatted_response = format_ai_response(ai_response, fmt=resp_format)
        chat_history.append({"role": "assistant", "content": formatted_response})
        session['ai_chat_history'] = chat_history
        return jsonify({"ai_response": formatted_response, "model": model}), 200
    except Exception as e:
        logging.error(f"AIチャットエラー: {e}")
        return jsonify({"message": "AIチャットの処理中にエラーが発生しました。"}), 500

@ai_bp.route('/analysis', methods=['POST'])
def ai_analysis():
    """
    台帳分析エンドポイント
    リクエストJSON例:
      {
         "ledger_records": [ { "field_name": value, ... }, { ... } ],
         "instruction": "（任意）分析指示",
         "model": "gpt-4o-mini"  # （必要に応じて利用）
      }
    台帳レコードの集計結果（総レコード数、総金額、平均金額、推奨事項）を返します。
    """
    data = request.get_json()
    if not data or "ledger_records" not in data:
        return jsonify({"message": "ledger_records が必要です。"}), 400

    ledger_records = data["ledger_records"]
    instruction = data.get("instruction", "")

    try:
        # AIAgent を利用した台帳分析
        agent = AIAgent()
        analysis_result = agent.analyze_ledgers(ledger_records)
        # 任意：分析指示を結果に付与（必要に応じて）
        if instruction:
            analysis_result["instruction"] = instruction
        return jsonify({"analysis": analysis_result}), 200
    except Exception as e:
        logging.error(f"台帳分析エラー: {e}")
        return jsonify({"message": "台帳分析の処理中にエラーが発生しました。"}), 500