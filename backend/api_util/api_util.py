#!/usr/bin/env python
"""
api_util.py - API 共通ユーティリティ。
入力検証、パラメータ化クエリ、データベース接続プール管理などを実装します。
このモジュールは、データベース接続管理と共通ユーティリティ関数を一元管理するためのものです。
"""

import logging
import threading
import psycopg2
import psycopg2.extras
from psycopg2 import pool

# ログ設定 (必要に応じてアプリケーション起動時に上書き可能)
logging.basicConfig(level=logging.INFO, format="%(asctime)s %(levelname)s %(message)s")

_db_pool = None
_db_pool_lock = threading.Lock()

def init_db_pool(minconn: int, maxconn: int, **db_params) -> None:
    """
    PostgreSQL のコネクションプールを初期化する。
    複数回呼び出しても、既に初期化済みなら再生成しない。
    """
    global _db_pool
    with _db_pool_lock:
        if _db_pool is not None:
            logging.info("DBプールは既に初期化済みです。スキップします。")
            return
        try:
            _db_pool = pool.ThreadedConnectionPool(
                minconn,
                maxconn,
                cursor_factory=psycopg2.extras.DictCursor,
                **db_params
            )
            logging.info("PostgreSQL コネクションプールが初期化されました。")
        except psycopg2.OperationalError as oe:
            logging.error("PostgreSQL コネクションプールの初期化エラー: %s", oe)
            raise RuntimeError(f"DB接続エラー: {oe}") from oe
        except Exception as e:
            logging.error("PostgreSQL コネクションプールの初期化中に予期しないエラーが発生しました。", exc_info=True)
            raise

def close_db_pool() -> None:
    """
    コネクションプールをクローズする。
    アプリケーション終了時に呼び出すこと。
    """
    global _db_pool
    if _db_pool:
        try:
            _db_pool.closeall()
            logging.info("PostgreSQL コネクションプールがクローズされました。")
        except Exception as e:
            logging.error("コネクションプールクローズ中にエラー: %s", e)
        finally:
            _db_pool = None

class _ConnectionManager:
    def __init__(self, pool_obj: pool.ThreadedConnectionPool) -> None:
        self.pool = pool_obj
        self.conn = None

    def __enter__(self):
        try:
            self.conn = self.pool.getconn()
            return self.conn
        except Exception as e:
            logging.error("コネクション取得エラー: %s", e)
            raise

    def __exit__(self, exc_type, exc_val, exc_tb):
        if not self.conn:
            return
        try:
            if exc_type is None:
                self.conn.commit()
            else:
                self.conn.rollback()
        except Exception as e:
            logging.error("トランザクション処理エラー: %s", e)
        finally:
            try:
                self.pool.putconn(self.conn)
            except Exception as e:
                logging.error("コネクション返却エラー: %s", e)


def get_connection():
    """
    コネクションプールから接続を取得し、with構文で利用可能にする。
    """
    global _db_pool
    if _db_pool is None:
        raise RuntimeError("DBプールが初期化されていません。init_db_pool() を先に呼び出してください。")
    return _ConnectionManager(_db_pool)

# 追加のユーティリティ関数はここに実装可能
