# backend/auth/auth_api.py

from flask import Blueprint, request, jsonify, session
from backend.auth.user_management import UserManagement
import logging

auth_bp = Blueprint('auth_api', __name__, url_prefix='/api/auth')
user_mgmt = UserManagement()

@auth_bp.route('/login', methods=['POST'])
def login():
    """ユーザーログインエンドポイント。"""
    data = request.get_json()
    if not data:
        return jsonify({"message": "リクエストデータが無効です。"}), 400

    username = data.get('username')
    password = data.get('password')
    if not username or not password:
        return jsonify({"message": "ユーザー名とパスワードは必須です。"}), 400

    try:
        user = user_mgmt.verify_user(username, password)
        if user:
            # セッションにユーザ情報を保存
            session['user'] = user
            logging.info(f"ログイン成功: {user}")
            return jsonify({"message": "ログインに成功しました。", "user": user}), 200
        else:
            return jsonify({"message": "ユーザー名またはパスワードが間違っています。"}), 401
    except Exception as e:
        logging.error(f"ログイン処理中にエラーが発生: {e}")
        return jsonify({"message": "ログイン処理中にエラーが発生しました。"}), 500


@auth_bp.route('/logout', methods=['POST'])
def logout():
    """ユーザーのログアウト処理"""
    try:
        session.pop('user', None)
        return jsonify({"message": "ログアウトに成功しました。"}), 200
    except Exception as e:
        logging.error(f"ログアウト処理中にエラーが発生: {e}")
        return jsonify({"message": "ログアウト処理中にエラーが発生しました。"}), 500
