"""
user_management.py - ユーザーおよびロール管理機能。
"""
import logging
from werkzeug.security import generate_password_hash, check_password_hash
from backend.api_util.api_util import get_connection

class UserManagement:
    def __init__(self):
        pass

    def hash_password(self, plain_password):
        """
        Werkzeugのgenerate_password_hashを使って
        scrypt方式でハッシュを生成
        """
        # scrypt対応: 2.3系以上のWerkzeugで利用可
        return generate_password_hash(plain_password, method='scrypt')

    def verify_user(self, username, plain_password):
        """
        ユーザー認証: DBからパスワードハッシュを取り出し
        check_password_hash() で照合する
        """
        try:
            with get_connection() as conn:
                with conn.cursor() as cursor:
                    # passwordカラムを含むようにSELECTする
                    query = """
                      SELECT u.id, u.username, u.password, r.role_name
                      FROM web_ledger.users u
                      JOIN web_ledger.role_master r ON u.role_id = r.id
                      WHERE u.username = %s
                    """
                    cursor.execute(query, (username,))
                    row = cursor.fetchone()
                    # rowは { "id":..., "username":..., "password":..., "role_name":... } のDictのはず

                    if row:
                        stored_hash = row['password']
                        # Werkzeugで照合
                        if check_password_hash(stored_hash, plain_password):
                            return {
                                "id": row["id"],
                                "username": row["username"],
                                "role": row["role_name"]
                            }
                    return None
        except Exception as e:
            logging.error(f"ユーザー認証エラー: {e}")
            return None

    def add_user(self, username, plain_password, role):
        """
        新規ユーザー追加: username, plain_password, role
        """
        try:
            # ハッシュ生成 (scrypt)
            hashed_pw = self.hash_password(plain_password)
            with get_connection() as conn:
                with conn.cursor() as cursor:
                    # role_idを取得
                    cursor.execute("SELECT id FROM web_ledger.role_master WHERE role_name = %s", (role,))
                    role_row = cursor.fetchone()
                    if not role_row:
                        raise ValueError("指定された役割が存在しません。")
                    role_id = role_row["id"]

                    # ユーザー作成
                    query = """
                      INSERT INTO web_ledger.users (username, password, role_id)
                      VALUES (%s, %s, %s) RETURNING id
                    """
                    cursor.execute(query, (username, hashed_pw, role_id))
                    user_id = cursor.fetchone()['id']
                conn.commit()

            logging.info(f"新規ユーザーが追加されました: {username} (ID: {user_id})")
            return user_id
        except Exception as e:
            logging.error(f"ユーザー追加エラー: {e}")
            # psycopg2: ロールバック
            conn.rollback()
            raise

    def update_user(self, user_id, username=None, plain_password=None, role=None):
        """
        既存ユーザー情報の更新
        """
        try:
            with get_connection() as conn:
                with conn.cursor() as cursor:
                    updates = []
                    params = []

                    if username:
                        updates.append("username = %s")
                        params.append(username)
                    if plain_password:
                        hashed_pw = self.hash_password(plain_password)
                        updates.append("password = %s")
                        params.append(hashed_pw)
                    if role:
                        cursor.execute("SELECT id FROM web_ledger.role_master WHERE role_name = %s", (role,))
                        role_row = cursor.fetchone()
                        if not role_row:
                            raise ValueError("指定された役割が存在しません。")
                        role_id = role_row["id"]
                        updates.append("role_id = %s")
                        params.append(role_id)

                    if not updates:
                        raise ValueError("更新対象がありません。")

                    params.append(user_id)
                    query = f"UPDATE web_ledger.users SET {', '.join(updates)} WHERE id = %s"
                    cursor.execute(query, tuple(params))
                conn.commit()

            logging.info(f"ユーザーが更新されました: ID {user_id}")
        except Exception as e:
            logging.error(f"ユーザー更新エラー: {e}")
            conn.rollback()
            raise

    def delete_user(self, user_id):
        """
        ユーザー削除
        """
        try:
            with get_connection() as conn:
                with conn.cursor() as cursor:
                    query = "DELETE FROM web_ledger.users WHERE id = %s"
                    cursor.execute(query, (user_id,))
                conn.commit()
            logging.info(f"ユーザーが削除されました: ID {user_id}")
        except Exception as e:
            logging.error(f"ユーザー削除エラー: {e}")
            conn.rollback()
            raise

    def get_all_users(self):
        """
        ユーザー一覧取得
        """
        try:
            with get_connection() as conn:
                with conn.cursor() as cursor:
                    query = """
                        SELECT u.id, u.username, r.role_name AS role
                        FROM web_ledger.users u
                        JOIN web_ledger.role_master r ON u.role_id = r.id
                        ORDER BY u.username
                    """
                    cursor.execute(query)
                    rows = cursor.fetchall()
                    return [dict(row) for row in rows]
        except Exception as e:
            logging.error(f"ユーザー取得エラー: {e}")
            return []
