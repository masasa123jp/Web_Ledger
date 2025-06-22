import psycopg2
from psycopg2.extras import RealDictCursor
import logging
from backend.api_util.api_util import get_connection  # コンテキストマネージャーとして利用
import json

class MasterFieldService:
    def get_all_masters(self):
        """
        すべてのマスター情報と、その項目定義または統合マスタレコードを取得する。
        Ledgerの場合は master_field_definitions と unified_master_records を返す。
        """
        try:
            with get_connection() as conn:
                with conn.cursor(cursor_factory=RealDictCursor) as cursor:
                    cursor.execute(
                        "SELECT id, master_type, description, created_at FROM web_ledger.master_types ORDER BY display_order"
                    )
                    masters = cursor.fetchall()
                    for master in masters:
                        # master_types テーブルの id を master_id に変換
                        master['master_id'] = master.pop('id')
                        
                        if master['master_type'].strip().lower() == 'ledger':
                            # Ledgerの場合：項目定義（tag を含む）を取得
                            cursor.execute("""
                                SELECT id, field_name, data_type, max_length, display_order, is_required, input_constraints, created_at, tag
                                FROM web_ledger.master_field_definitions
                                WHERE master_id = %s ORDER BY display_order
                            """, (master['master_id'],))
                            fields = cursor.fetchall()
                            master['fields'] = fields
                            
                            # Ledgerの場合：台帳定義（unified_master_records）も取得する
                            cursor.execute("""
                                SELECT id, record_data, created_at, updated_at
                                FROM web_ledger.unified_master_records
                                WHERE master_id = %s ORDER BY id
                            """, (master['master_id'],))
                            ledgerRecords = cursor.fetchall()
                            for rec in ledgerRecords:
                                if isinstance(rec['record_data'], str):
                                    rec['record_data'] = json.loads(rec['record_data'])
                            master['unified_master_records'] = ledgerRecords
                        else:
                            # 非Ledgerの場合：unified_master_records を取得する
                            cursor.execute("""
                                SELECT id, record_data, created_at, updated_at
                                FROM web_ledger.unified_master_records
                                WHERE master_id = %s ORDER BY id
                            """, (master['master_id'],))
                            records = cursor.fetchall()
                            for rec in records:
                                if isinstance(rec['record_data'], str):
                                    rec['record_data'] = json.loads(rec['record_data'])
                            master['unified_master_records'] = records
            return masters
        except Exception as e:
            logging.exception("マスター情報の取得に失敗しました。")
            raise e

    def add_master(self, data):
        try:
            with get_connection() as conn:
                with conn.cursor() as cursor:
                    cursor.execute("""
                        INSERT INTO web_ledger.master_types (master_type)
                        VALUES (%s) RETURNING id
                    """, (data['master_type'],))
                    master_id = cursor.fetchone()[0]
                    for field in data['fields']:
                        cursor.execute("""
                            INSERT INTO web_ledger.master_field_definitions 
                            (master_id, field_name, data_type, max_length, display_order, is_required, input_constraints)
                            VALUES (%s, %s, %s, %s, %s, %s, %s)
                        """, (
                            master_id,
                            field.get('field_name') or field.get('column_name'),
                            field['data_type'],
                            field.get('max_length'),
                            field.get('display_order'),
                            field.get('is_required', True),
                            field.get('input_constraints')
                        ))
                    conn.commit()
                    return master_id
        except Exception as e:
            logging.exception("マスター追加エラー")
            raise e

    def update_master(self, master_id, data):
        try:
            with get_connection() as conn:
                with conn.cursor() as cursor:
                    cursor.execute("""
                        UPDATE web_ledger.master_types SET master_type = %s WHERE id = %s
                    """, (data['master_type'], master_id))
                    cursor.execute("""
                        DELETE FROM web_ledger.master_field_definitions WHERE master_id = %s
                    """, (master_id,))
                    for field in data['fields']:
                        cursor.execute("""
                            INSERT INTO web_ledger.master_field_definitions 
                            (master_id, field_name, data_type, max_length, display_order, is_required, input_constraints)
                            VALUES (%s, %s, %s, %s, %s, %s, %s)
                        """, (
                            master_id,
                            field.get('field_name') or field.get('column_name'),
                            field['data_type'],
                            field.get('max_length'),
                            field.get('display_order'),
                            field.get('is_required', True),
                            field.get('input_constraints')
                        ))
                    conn.commit()
        except Exception as e:
            logging.exception("マスター更新エラー")
            raise e

    def delete_master(self, master_id):
        try:
            with get_connection() as conn:
                with conn.cursor() as cursor:
                    cursor.execute("DELETE FROM web_ledger.master_types WHERE id = %s", (master_id,))
                    conn.commit()
        except Exception as e:
            logging.exception("マスター削除エラー")
            raise e

    def get_ledger_records(self, master_id):
        """
        unified_master_records テーブルから、指定された master_id のレコードを取得する。
        Ledger 以外でも同様に利用できる。
        """
        try:
            with get_connection() as conn:
                with conn.cursor(cursor_factory=RealDictCursor) as cursor:
                    cursor.execute("""
                        SELECT id, record_data, created_at, updated_at
                        FROM web_ledger.unified_master_records
                        WHERE master_id = %s
                        ORDER BY id
                    """, (master_id,))
                    records = cursor.fetchall()
                    for rec in records:
                        if isinstance(rec['record_data'], str):
                            rec['record_data'] = json.loads(rec['record_data'])
                    return records
        except Exception as e:
            logging.exception("台帳レコード取得エラー")
            raise e

    def get_fields(self, master_id):
        """
        GET /api/master/fields 用：指定された master_id に対する項目定義を取得する。
        """
        try:
            with get_connection() as conn:
                with conn.cursor(cursor_factory=RealDictCursor) as cursor:
                    cursor.execute("""
                        SELECT id, field_name, data_type, max_length, display_order, is_required, input_constraints, created_at
                        FROM web_ledger.master_field_definitions
                        WHERE master_id = %s ORDER BY display_order
                    """, (master_id,))
                    fields = cursor.fetchall()
                    return fields
        except Exception as e:
            logging.exception("フィールド定義取得エラー")
            raise e

    def add_field(self, master_id, field_data):
        try:
            with get_connection() as conn:
                with conn.cursor() as cursor:
                    cursor.execute("""
                        INSERT INTO web_ledger.master_field_definitions 
                        (master_id, field_name, data_type, max_length, display_order, is_required, input_constraints)
                        VALUES (%s, %s, %s, %s, %s, %s, %s) RETURNING id
                    """, (
                        master_id,
                        field_data.get('field_name') or field_data.get('column_name'),
                        field_data['data_type'],
                        field_data.get('max_length'),
                        field_data.get('display_order'),
                        field_data.get('is_required', True),
                        field_data.get('input_constraints')
                    ))
                    new_id = cursor.fetchone()[0]
                    conn.commit()
                    return new_id
        except Exception as e:
            logging.exception("項目追加エラー")
            raise e

    def update_field(self, field_id, field_data):
        try:
            with get_connection() as conn:
                with conn.cursor() as cursor:
                    cursor.execute("""
                        UPDATE web_ledger.master_field_definitions
                        SET field_name = %s, data_type = %s, max_length = %s, display_order = %s, is_required = %s, input_constraints = %s
                        WHERE id = %s
                    """, (
                        field_data.get('field_name') or field_data.get('column_name'),
                        field_data['data_type'],
                        field_data.get('max_length'),
                        field_data.get('display_order'),
                        field_data.get('is_required', True),
                        field_data.get('input_constraints'),
                        field_id
                    ))
                    conn.commit()
        except Exception as e:
            logging.exception("項目更新エラー")
            raise e

    def delete_field(self, field_id):
        try:
            with get_connection() as conn:
                with conn.cursor() as cursor:
                    cursor.execute("DELETE FROM web_ledger.master_field_definitions WHERE id = %s", (field_id,))
                    conn.commit()
        except Exception as e:
            logging.exception("項目削除エラー")
            raise e

    def get_column_structure(self, tag):
        """
        Ledgerマスターの場合の項目定義を取得する。
        tag は Ledger マスターの master_id として扱う。
        """
        try:
            with get_connection() as conn:
                with conn.cursor(cursor_factory=RealDictCursor) as cursor:
                    cursor.execute("""
                        SELECT id, field_name, data_type, max_length, display_order, is_required, input_constraints, created_at
                        FROM web_ledger.master_field_definitions
                        WHERE tag = %s ORDER BY display_order
                    """, (tag,))
                    fields = cursor.fetchall()
                    return fields
        except Exception as e:
            logging.exception("カラム定義取得エラー")
            raise e

    def create_record(self, master_id, record_data):
        """
        unified_master_records に新しいレコードを追加し、その id を返す
        """
        try:
            with get_connection() as conn:
                with conn.cursor() as cursor:
                    # record_data を JSON 文字列に変換
                    json_data = json.dumps(record_data, ensure_ascii=False)
                    cursor.execute("""
                        INSERT INTO web_ledger.unified_master_records
                            (master_id, record_data)
                        VALUES (%s, %s)
                        RETURNING id
                    """, (master_id, json_data))
                    new_id = cursor.fetchone()[0]
                    conn.commit()
                    return new_id
        except Exception as e:
            logging.exception("レコード新規作成エラー")
            raise e

    def update_record(self, record_id, record_data):
        """
        record_id の行を更新
        """
        try:
            with get_connection() as conn:
                with conn.cursor() as cursor:
                    json_data = json.dumps(record_data, ensure_ascii=False)
                    cursor.execute("""
                        UPDATE web_ledger.unified_master_records
                           SET record_data = %s,
                               updated_at = CURRENT_TIMESTAMP
                         WHERE id = %s
                    """, (json_data, record_id))
                    conn.commit()
        except Exception as e:
            logging.exception("レコード更新エラー")
            raise e

    def delete_record(self, record_id):
        """
        record_id の行を削除
        """
        try:
            with get_connection() as conn:
                with conn.cursor() as cursor:
                    cursor.execute("""
                        DELETE FROM web_ledger.unified_master_records
                         WHERE id = %s
                    """, (record_id,))
                    conn.commit()
        except Exception as e:
            logging.exception("レコード削除エラー")
            raise e
