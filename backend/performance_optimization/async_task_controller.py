# backend/performance_optimization/async_task_controller.py

"""
async_task_controller.py - 非同期タスクを管理する API コントローラー。
Celery タスクの起動および状態確認を行います。
"""

from flask import Blueprint, request, jsonify
from celery.result import AsyncResult
from backend.performance_optimization.async_task_manager import long_running_task
import logging

async_bp = Blueprint('async_task', __name__, url_prefix='/api/async-task')

@async_bp.route('', methods=['POST'])
def trigger_async_task():
    """
    POST /api/async-task
    非同期タスクを起動し、タスクIDを返す。
    リクエスト例: { "numbers": [10, 20, 30, 40] }
    """
    data = request.get_json()
    numbers = data.get("numbers", [1, 2, 3, 4, 5])
    try:
        task = long_running_task.delay(numbers)
        return jsonify({"task_id": task.id}), 202
    except Exception as e:
        logging.error(f"非同期タスク起動エラー: {e}")
        return jsonify({"message": "非同期タスクの起動に失敗しました。"}), 500

@async_bp.route('/<task_id>', methods=['GET'])
def check_async_task(task_id: str):
    """
    GET /api/async-task/<task_id>
    非同期タスクの状態と結果を返す。
    """
    try:
        task_result = AsyncResult(task_id)
        response = {
            "task_id": task_id,
            "state": task_result.state,
            "result": task_result.result
        }
        return jsonify(response), 200
    except Exception as e:
        logging.error(f"非同期タスク状態確認エラー: {e}")
        return jsonify({"message": "非同期タスクの状態確認に失敗しました。"}), 500