# backend/performance_optimization/response_time_logger.py

"""
response_time_logger.py - API レスポンス時間をログに記録するためのデコレーターを実装。
"""

import time
import logging
from functools import wraps
from flask import request

def log_response_time(func):
    """
    API エンドポイントのレスポンス時間を計測しログ出力するデコレーター
    """
    @wraps(func)
    def wrapper(*args, **kwargs):
        start = time.time()
        response = func(*args, **kwargs)
        end = time.time()
        elapsed = end - start
        logging.info(f"レスポンス時間: {elapsed:.4f}秒, エンドポイント: {request.path}")
        return response
    return wrapper