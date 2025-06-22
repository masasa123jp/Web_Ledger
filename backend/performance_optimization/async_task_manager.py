# backend/performance_optimization/async_task_manager.py

"""
async_task_manager.py - Celery を利用した非同期タスク管理モジュール。
Redis をブローカーおよび結果バックエンドとして利用し、長時間処理タスクを実行します。
"""

import time
import logging
from celery import Celery
import os

# Redis の接続情報は環境変数から取得する（例: REDIS_URL）
redis_url = os.environ.get("CELERY_BROKER_URL", "redis://localhost:6379/0")
backend_url = os.environ.get("CELERY_RESULT_BACKEND", "redis://localhost:6379/0")

celery_app = Celery('tasks', broker=redis_url, backend=backend_url)

@celery_app.task
def long_running_task(numbers: list) -> int:
    """
    非同期タスクの例。指定された数値のリストの合計を算出する処理（模擬的に5秒のスリープを実施）。
    Args:
        numbers (list): 数値のリスト
    Returns:
        int: 合計値
    """
    logging.info(f"非同期タスク開始: numbers={numbers}")
    start_time = time.time()
    time.sleep(5)  # 模擬的な重い処理
    result = sum(numbers)
    elapsed = time.time() - start_time
    logging.info(f"非同期タスク完了: result={result}, elapsed={elapsed:.3f}秒")
    return result