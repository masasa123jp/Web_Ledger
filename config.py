import os

class Config:
    """
    アプリケーション全体の設定を管理するクラス
    """

    # Flask の基本設定
    SECRET_KEY = os.environ.get("SECRET_KEY", "your_default_secret_key")
    DEBUG = os.environ.get("DEBUG", "True").lower() in ["true", "1", "yes"]

    # データベース設定（PostgreSQL）
    # 環境変数からDB接続情報を取得
    DB_NAME = os.environ.get("POSTGRES_DB", "web_ledger")
    DB_USER = os.environ.get("POSTGRES_USER", "mydbuser")
    DB_PASSWORD = os.environ.get("POSTGRES_PASSWORD", "mypassword")
    DB_HOST = os.environ.get("POSTGRES_HOST", "localhost")
    DB_PORT = os.environ.get("POSTGRES_PORT", "5432")

    # OpenAI API 設定（生成AI連携用）
    OPENAI_API_KEY = os.environ.get("OPENAI_API_KEY", "your_openai_api_key")

    # Celery 設定（非同期タスク管理用）
    CELERY_BROKER_URL = os.environ.get("CELERY_BROKER_URL", "redis://localhost:6379/0")
    CELERY_RESULT_BACKEND = os.environ.get("CELERY_RESULT_BACKEND", "redis://localhost:6379/0")

    # Redis キャッシュ設定
    REDIS_HOST = os.environ.get("REDIS_HOST", "localhost")
    REDIS_PORT = int(os.environ.get("REDIS_PORT", 6379))
    REDIS_DB = int(os.environ.get("REDIS_DB", 1))

def init_app(app):
    """
    Flask アプリケーションに Config を適用するユーティリティ関数
    """
    app.config.from_object(Config)
