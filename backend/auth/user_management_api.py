# backend/auth/user_management_api.py

from flask import Blueprint, request, jsonify, session
from backend.auth.user_management import UserManagement
import logging

user_management_bp = Blueprint('user_management_api', __name__, url_prefix='/api/user_management')
user_management = UserManagement()

# --- ユーザー管理 ---
@user_management_bp.route('/allusers', methods=['GET'])
def get_users():
    try:
        users = user_management.get_all_users()
        return jsonify(users), 200
    except Exception as e:
        logging.error("ユーザー取得エラー: %s", str(e))
        return jsonify({'message': str(e)}), 400