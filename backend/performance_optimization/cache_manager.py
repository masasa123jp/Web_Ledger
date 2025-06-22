# backend/performance_optimization/cache_manager.py

"""
cache_manager.py - Redis を利用したキャッシュ管理モジュール。
SQLクエリ結果などのキャッシュを管理します。
"""

import redis
import json
import os
import logging
from typing import Any

# Redis の初期化（環境変数 REDIS_CACHE_URL などで設定可能）
redis_host = os.environ.get("REDIS_HOST", "localhost")
redis_port = int(os.environ.get("REDIS_PORT", 6379))
redis_db = int(os.environ.get("REDIS_DB", 1))

try:
    cache = redis.Redis(host=redis_host, port=redis_port, db=redis_db)
    cache.ping()
except redis.exceptions.ConnectionError as e:
    logging.error(f"Redisへの接続エラー: {e}")
    cache = None

def set_cache(key: str, value: Any, expiration: int = 300) -> None:
    """
    キャッシュに値を保存する。値は JSON 形式に変換。
    Args:
        key (str): キャッシュキー
        value: キャッシュする値
        expiration (int): 有効期限（秒）
    """
    if cache:
        try:
            cache.set(key, json.dumps(value), ex=expiration)
            logging.info(f"キャッシュ設定: {key}")
        except Exception as e:
            logging.error(f"キャッシュ設定エラー: {e}")

def get_cache(key: str) -> Any:
    """
    キャッシュから値を取得する。値は JSON から復元。
    Args:
        key (str): キャッシュキー
    Returns:
        Any: キャッシュされた値、存在しなければ None
    """
    if cache:
        try:
            data = cache.get(key)
            if data:
                logging.info(f"キャッシュ取得: {key}")
                return json.loads(data)
        except Exception as e:
            logging.error(f"キャッシュ取得エラー: {e}")
    return None

def delete_cache(key: str) -> None:
    """
    指定されたキャッシュキーを削除する。
    Args:
        key (str): キャッシュキー
    """
    if cache:
        try:
            cache.delete(key)
            logging.info(f"キャッシュ削除: {key}")
        except Exception as e:
            logging.error(f"キャッシュ削除エラー: {e}")