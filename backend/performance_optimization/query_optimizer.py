# backend/performance_optimization/query_optimizer.py

"""
query_optimizer.py - SQL クエリの最適化およびキャッシュ管理モジュール。
指定されたクエリを実行し、キャッシュキーが与えられた場合は Redis キャッシュから結果を取得します。
また、実行時間をログに出力し、必要に応じてキャッシュへ結果を保存します。
"""

import time
import logging
from typing import Any, List, Optional, Tuple
from backend.api_util.api_util import get_connection
from backend.performance_optimization.cache_manager import get_cache, set_cache

def execute_optimized_query(query: str, params: Optional[Tuple[Any, ...]] = None,
                            cache_key: Optional[str] = None, cache_expiration: int = 300) -> List[Any]:
    """
    クエリを実行し、結果を返す。キャッシュキーが指定されている場合、Redis キャッシュを利用する。
    Args:
        query (str): SQL クエリ
        params (Optional[Tuple[Any, ...]]): クエリパラメータ
        cache_key (Optional[str]): キャッシュキー（指定されていればキャッシュ利用）
        cache_expiration (int): キャッシュの有効期限（秒）
    Returns:
        List[Any]: クエリ結果のリスト
    """
    if cache_key:
        cached_result = get_cache(cache_key)
        if cached_result:
            logging.info(f"キャッシュから結果を取得: {cache_key}")
            return cached_result

    start_time = time.time()
    try:
        with get_connection() as conn:
            cursor = conn.cursor()
            cursor.execute(query, params)
            result = cursor.fetchall()
        execution_time = time.time() - start_time
        logging.info(f"クエリ実行時間: {execution_time:.3f}秒, クエリ: {query}")
        if cache_key:
            set_cache(cache_key, result, expiration=cache_expiration)
        return result
    except Exception as e:
        logging.error(f"クエリ実行エラー: {e}")
        raise

def get_explain_plan(query: str, params: Optional[Tuple[Any, ...]] = None) -> str:
    """
    指定されたクエリの実行計画（EXPLAIN）を取得する。
    Args:
        query (str): SQL クエリ
        params (Optional[Tuple[Any, ...]]): クエリパラメータ
    Returns:
        str: 実行計画のテキスト
    """
    try:
        with get_connection() as conn:
            cursor = conn.cursor()
            explain_query = "EXPLAIN " + query
            cursor.execute(explain_query, params)
            plan = cursor.fetchall()
            plan_text = "\n".join(row[0] for row in plan)
        return plan_text
    except Exception as e:
        logging.error(f"EXPLAINクエリ実行エラー: {e}")
        raise