import logging
from flask import Blueprint, request, jsonify
from typing import Dict, Any, List
from backend.api_util.api_util import get_connection
from backend.ledger_transaction.ledger_history import record_ledger_history
from backend.master_management.master_field_service import MasterFieldService

# エンドポイントは /api/ledger 以下に公開
ledger_bp = Blueprint('ledger', __name__, url_prefix='/api/ledger')
field_service = MasterFieldService()

class LedgerManager:
    """
    LedgerManager は、台帳レコードの CRUD およびデータ取得処理を管理します。
    各レコードは、master_type_id（台帳定義ID）と ledger_tag（例："LEDGER001" など）で特定され、
    master_field_definitions のフィールド定義と直接対応付けられます。
    """
    @staticmethod
    def get_manuals():
        """
        マニュアルを取得するメソッド
        """
        try:
            with get_connection() as conn:
                cursor = conn.cursor()
                cursor.execute("""
                    SELECT * FROM web_ledger.manuals ORDER BY id ASC
                """)
                rows = cursor.fetchall()
                return [dict(row) for row in rows]
        except Exception as e:
            logging.error("マニュアル取得エラー: %s", str(e))
            raise

    @staticmethod
    def add_ledger_record(master_type_id: int, ledger_tag: str, record: Dict[str, Any], updated_by: str) -> None:
        """
        新規台帳レコードを追加します。
        record は { field_name: value, ... } の形式とし、
        各フィールドに対応する master_field_definitions の id を
        master_id、field_name、tag（ledger_tag）で直接取得し、ledger_records に挿入します。
        """
        try:
            with get_connection() as conn:
                with conn.cursor() as cursor:
                    # ledger_definition_id は master_type_id をそのまま利用
                    cursor.execute(
                        "SELECT MAX(data_id) AS max_id FROM web_ledger.ledger_records WHERE ledger_definition_id = %s",
                        (master_type_id,)
                    )
                    row = cursor.fetchone()
                    data_id = (row["max_id"] + 1) if row and row["max_id"] is not None else 1

                    for field_name, value in record.items():
                        cursor.execute(
                            """
                            SELECT id
                            FROM web_ledger.master_field_definitions
                            WHERE master_id = %s
                              AND field_name = %s
                              AND tag = %s
                            """,
                            (master_type_id, field_name, ledger_tag)
                        )
                        col_row = cursor.fetchone()
                        if not col_row:
                            logging.warning("存在しないカラム: %s (master_id=%s, tag=%s)", field_name, master_type_id, ledger_tag)
                            continue
                        field_id = col_row["id"]
                        cursor.execute(
                            """
                            INSERT INTO web_ledger.ledger_records
                              (ledger_definition_id, data_id, column_id, data, created_at)
                            VALUES (%s, %s, %s, %s, CURRENT_TIMESTAMP)
                            """,
                            (master_type_id, data_id, field_id, str(value))
                        )
                conn.commit()
            record_ledger_history(master_type_id, data_id, updated_by, "レコード追加")
            logging.info("新規台帳レコードが追加されました: data_id=%s", data_id)
        except Exception as e:
            logging.error("台帳レコード追加エラー: %s", e)
            raise

    @staticmethod
    def update_ledger_record(master_type_id: int, ledger_tag: str, data_id: int, updates: Dict[str, Any], updated_by: str) -> None:
        """
        既存の台帳レコードを更新します。
        更新対象の各フィールドについて、master_field_definitions の id を
        master_id、field_name、tag（ledger_tag）で直接取得し、更新を行います。
        """
        try:
            with get_connection() as conn:
                with conn.cursor() as cursor:
                    for field_name, new_value in updates.items():
                        cursor.execute(
                            """
                            SELECT id
                            FROM web_ledger.master_field_definitions
                            WHERE master_id = %s
                              AND field_name = %s
                              AND tag = %s
                            """,
                            (master_type_id, field_name, ledger_tag)
                        )
                        col_row = cursor.fetchone()
                        if not col_row:
                            logging.warning("存在しないカラム: %s (master_id=%s, tag=%s)", field_name, master_type_id, ledger_tag)
                            continue
                        field_id = col_row["id"]
                        cursor.execute(
                            """
                            UPDATE web_ledger.ledger_records
                            SET data = %s, updated_at = CURRENT_TIMESTAMP
                            WHERE ledger_definition_id = %s AND data_id = %s AND column_id = %s
                            """,
                            (str(new_value), master_type_id, data_id, field_id)
                        )
                conn.commit()
            record_ledger_history(master_type_id, data_id, updated_by, "レコード更新")
            logging.info("台帳レコードが更新されました: data_id=%s", data_id)
        except Exception as e:
            logging.error("台帳レコード更新エラー: %s", e)
            raise

    @staticmethod
    def delete_ledger_record(master_type_id: int, data_id: int, updated_by: str) -> None:
        """
        指定された ledger_definition_id（master_type_id）と data_id の台帳レコードを削除します。
        """
        try:
            with get_connection() as conn:
                with conn.cursor() as cursor:
                    cursor.execute(
                        """
                        DELETE FROM web_ledger.ledger_records
                        WHERE ledger_definition_id = %s AND data_id = %s
                        """,
                        (master_type_id, data_id)
                    )
                conn.commit()
            record_ledger_history(master_type_id, data_id, updated_by, "レコード削除")
            logging.info("台帳レコードが削除されました: data_id=%s", data_id)
        except Exception as e:
            logging.error("台帳レコード削除エラー: %s", e)
            raise

    @staticmethod
    def get_ledger_records(ledger_tag: str) -> List[Dict[str, Any]]:
        """
        指定された master_type_id と ledger_tag に基づき、ledger_records と master_field_definitions を結合して台帳レコードを取得します。
        各レコードは data_id 単位で集約し、各フィールドの値と display_order を辞書形式でまとめたものを返します。
        """
        records = {}
        try:
            with get_connection() as conn:
                with conn.cursor() as cursor:
                    query = """
                        SELECT lr.data_id, mfd.field_name, mfd.data_type, lr.data, lr.created_at, lr.updated_at, mfd.display_order, mfd.tag
                        FROM web_ledger.ledger_records lr
                        JOIN web_ledger.master_field_definitions mfd
                        ON lr.column_id = mfd.id
                        WHERE mfd.tag = %s
                        ORDER BY lr.data_id, mfd.display_order
                    """
                    cursor.execute(query, (ledger_tag,))
                    rows = cursor.fetchall()
                    for row in rows:
                        data_id = row["data_id"]
                        if data_id not in records:
                            records[data_id] = {
                                "data_id": data_id,
                                "created_at": row["created_at"],
                                "updated_at": row["updated_at"],
                                "fields": {},
                                "field_orders": {}  # 追加：各フィールドの display_order を保持
                            }
                        records[data_id]["fields"][row["field_name"]] = row["data"]
                        records[data_id]["field_orders"][row["field_name"]] = row["display_order"]
            return list(records.values())
        except Exception as e:
            logging.error("台帳レコード取得エラー: %s", e)
            raise

    @staticmethod
    def _fetch_unified_master_records(master_id: int, ledger_tag: str, filters=None) -> list:
        """
        統合マスタレコードを、master_id、ledger_tag、filters に基づいて取得する。
        レコードは各行に id と record_data（JSONB）を含む。
        """
        try:
            with get_connection() as conn:
                cursor = conn.cursor()
                if filters:
                    base_query = """
                        SELECT id, record_data
                        FROM web_ledger.unified_master_records
                        WHERE master_id = %s
                          AND (record_data ->> 'code') = %s
                    """
                    params = [master_id, ledger_tag]
                    for key, filter_value in filters.items():
                        if key and filter_value:
                            base_query += " AND (record_data ->> %s) LIKE %s"
                            params.extend([key, f"%{filter_value}%"])
                    cursor.execute(base_query, params)
                    rows = cursor.fetchall()
                    logging.debug("フィルター適用後の統合マスタレコード件数: %d", len(rows))
                else:
                    cursor.execute("""
                        SELECT id, record_data
                        FROM web_ledger.unified_master_records
                        WHERE master_id = %s
                          AND (record_data ->> 'code') = %s
                        ORDER BY id ASC
                    """, (master_id, ledger_tag))
                    rows = cursor.fetchall()
                    logging.debug("統合マスタレコード取得件数: %d", len(rows))
            return rows
        except Exception as e:
            logging.error("統合マスタレコード取得エラー: %s", e)
            raise

    @staticmethod
    def _fetch_field_definitions(master_id: int, ledger_tag: str) -> list:
        """
        指定した master_id と ledger_tag に対応するフィールド定義（master_field_definitions）を取得する。
        """
        try:
            with get_connection() as conn:
                cursor = conn.cursor()
                cursor.execute("""
                    SELECT field_name, data_type, display_order
                    FROM web_ledger.master_field_definitions
                    WHERE master_id = %s AND tag = %s
                    ORDER BY display_order ASC
                """, (master_id, ledger_tag))
                field_info = cursor.fetchall()
                logging.debug("フィールド定義取得件数: %d", len(field_info))
                return [{"field_name": r["field_name"],
                         "data_type": r["data_type"],
                         "display_order": r["display_order"]} for r in field_info]
        except Exception as e:
            logging.error("フィールド定義取得エラー: %s", e)
            raise

    @staticmethod
    def transform_unified_records(records_array):
        """
        統合マスタレコードのリスト（各レコードは 'data_id', 'fields', 'field_orders' を持つ）
        を、pivot テーブルで利用できる形式に変換する。
        
        ※"操作" 列はデータ列ではないため、表示対象から除外します。
        
        :param records_array: 例
        [
            {
                "data_id": 1,
                "fields": {"ID": "1", "テーマ名": "テーマA", "年度": "2023", ... },
                "field_orders": {"ID": 101, "テーマ名": 102, "年度": 103, ... }
            },
            { ... }
        ]
        :return: {"columns": [列名のリスト], "records": [各レコードの辞書]}
        """
        if not records_array or len(records_array) == 0:
            return {"columns": [], "records": []}

        # 最初のレコードの field_orders から列順を決定
        first_record = records_array[0]
        if first_record.get("field_orders"):
            columns = sorted(first_record["field_orders"].keys(), key=lambda k: first_record["field_orders"][k])
        else:
            columns = list(first_record.get("fields", {}).keys())
            print("field_orders が存在しないため、fields のキー順を利用:", columns)

        # "操作" 列は表示対象から除外
        columns = [col for col in columns if col != "操作"]
        print("決定した列順 ('操作' 列除く):", columns)

        # 各レコードについて、fields をトップレベルに展開し "ID" を追加（"操作" 列は後から追加しない）
        transformed_records = []
        for rec in sorted(records_array, key=lambda r: r["data_id"]):
            row = {"ID": rec["data_id"]}
            for col in columns:
                row[col] = rec.get("fields", {}).get(col, "")
            transformed_records.append(row)
        
        return {"columns": columns, "records": transformed_records}

    @staticmethod
    def get_ledgers_with_advanced_filter(master_id: int, ledger_tag: str, filters=None) -> dict:
        """
        指定した master_id と ledger_tag に基づき、web_ledger.unified_master_records から
        record_data（JSONB）を取得し、fields と field_orders を利用して各レコードを整形する。
        該当レコードがなければ、フィールド定義のみを返します。

        :param master_id: master_types の id（例: 14）
        :param ledger_tag: 統合マスタの種類を示すコード（例："LEDGER001", "LEDGER002", "LEDGER003"）
        :param filters: 辞書形式のフィルター条件（例: {"年度": "2025", "テーマ名": "管理"}）
        :return: {"columns": [フィールド定義], "records": [整形済みレコード]}
        """
        # 1. 統合マスタレコードを取得
        unified_rows = LedgerManager._fetch_unified_master_records(master_id, ledger_tag, filters)
        # 2. 該当レコードがなければ、フィールド定義のみ返す
        if not unified_rows:
            fields = LedgerManager._fetch_field_definitions(master_id, ledger_tag)
            return {"columns": fields, "records": []}
        # 3. 統合マスタレコードを変換（列順と整形済みレコードを取得）
        columns_order, transformed_records = LedgerManager._transform_unified_records(unified_rows)
        # 4. フィールド定義情報を取得（※後の画面表示用に、フィールド定義の情報をそのまま利用）
        fields_with_types = LedgerManager._fetch_field_definitions(master_id, ledger_tag)
        # ログ出力：最終的なレコード件数
        logging.debug("最終的なレコード件数: %d", len(transformed_records))
        return {"columns": fields_with_types, "records": transformed_records}

# API エンドポイント

@ledger_bp.route('/ledger-types', methods=['GET'])
def api_get_ledger_types():
    """
    GET /api/ledger-types
    web_ledger.unified_master_records の record_data JSON から code と name を抽出し、
    unified_master_records.master_id と master_types をジョインして、
    master_types.master_type が "Ledger" のもののみを返します。
    結果は、master_id を master_type_id、record_data->>'code' を ledger_tag、
    record_data->>'name' を master_name として返却します。
    """
    try:
        with get_connection() as conn:
            with conn.cursor() as cursor:
                query = """
                    SELECT umr.master_id AS master_type_id,
                           umr.record_data->>'code' AS ledger_tag,
                           umr.record_data->>'name' AS master_name
                    FROM web_ledger.unified_master_records umr
                    JOIN web_ledger.master_types mt ON umr.master_id = mt.id
                    WHERE mt.master_type = 'Ledger'
                    ORDER BY umr.id
                """
                cursor.execute(query)
                rows = cursor.fetchall()
                ledger_types = [dict(row) for row in rows]
        return jsonify(ledger_types), 200
    except Exception as e:
        logging.error("台帳種類取得エラー: %s", e)
        return jsonify({"message": "台帳種類の取得に失敗しました。"}), 500

# --- 新規追加：ピボットテーブル用データ取得 API ---
@ledger_bp.route('/pivot-data', methods=['GET'])
def get_pivot_data():
    ledger_type = request.args.get('type', '')
    if not ledger_type:
        return jsonify({'message': '台帳タイプが必要です。'}), 400

    #ledger_master = LedgerManager.get_ledger_records(ledger_type)
    #if not ledger_master:
    #    return jsonify({'message': '指定された台帳が存在しません。'}), 400
    #print(ledger_master)
    #ledger_master_id = ledger_master['id']
    # 既存の高度なフィルタ処理を利用して全件取得（フィルターなし）
    #data = LedgerManager.get_ledgers_with_advanced_filter(14, ledger_type, None)
    data = LedgerManager.get_ledger_records(ledger_type)
    #print(data)
    return jsonify(data)

@ledger_bp.route('/', methods=['POST'])
def api_add_ledger():
    data = request.get_json()
    master_type_id = data.get("master_type_id")
    ledger_tag = data.get("ledger_tag")
    record = data.get("record")
    updated_by = data.get("updated_by", "system")
    if not master_type_id or not record or not ledger_tag:
        return jsonify({"message": "master_type_id, ledger_tag, record は必須です。"}), 400
    try:
        LedgerManager.add_ledger_record(master_type_id, ledger_tag, record, updated_by)
        return jsonify({"message": "台帳レコードを追加しました。"}), 201
    except Exception as e:
        return jsonify({"message": "台帳レコードの追加に失敗しました。"}), 500

@ledger_bp.route('/<int:master_type_id>/<int:data_id>', methods=['PUT'])
def api_update_ledger(master_type_id: int, data_id: int):
    data = request.get_json()
    ledger_tag = data.get("ledger_tag")
    updates = data.get("updates")
    updated_by = data.get("updated_by", "system")
    if not updates or not ledger_tag:
        return jsonify({"message": "ledger_tag と updates は必須です。"}), 400
    try:
        LedgerManager.update_ledger_record(master_type_id, ledger_tag, data_id, updates, updated_by)
        return jsonify({"message": "台帳レコードを更新しました。"}), 200
    except Exception as e:
        return jsonify({"message": "台帳レコードの更新に失敗しました。"}), 500

@ledger_bp.route('/<int:master_type_id>/<int:data_id>', methods=['DELETE'])
def api_delete_ledger(master_type_id: int, data_id: int):
    updated_by = "system"  # 実際は認証情報などから取得
    try:
        LedgerManager.delete_ledger_record(master_type_id, data_id, updated_by)
        return jsonify({"message": "台帳レコードを削除しました。"}), 200
    except Exception as e:
        return jsonify({"message": "台帳レコードの削除に失敗しました。"}), 500

@ledger_bp.route('/<int:master_type_id>', methods=['GET'])
def api_get_ledger_records(master_type_id: int):
    """
    GET /api/ledger/<master_type_id>?ledger_tag=...
    指定された master_type_id と ledger_tag に基づき、ledger_records のレコードを取得します。
    各レコードは data_id 単位で、各フィールドの値をまとめた辞書形式で返されます。
    """
    ledger_tag = request.args.get("ledger_tag")
    if not ledger_tag:
        return jsonify({"message": "ledger_tag のクエリパラメータは必須です。"}), 400
    try:
        records = LedgerManager.get_ledger_records(ledger_tag)
        return jsonify(records), 200
    except Exception as e:
        return jsonify({"message": "台帳レコードの取得に失敗しました。"}), 500

@ledger_bp.route('/fields', methods=['GET'])
def api_get_ledger_fields():
    """
    GET /api/ledger/fields?ledger_type=LEDGER001
    指定された ledger_type（tag）に基づき、master_field_definitions テーブルからフィールド定義を取得して返却します。
    """
    ledger_type = request.args.get("ledger_type")
    if not ledger_type:
        return jsonify({"message": "ledger_type のクエリパラメータは必須です。"}), 400

    try:
        with get_connection() as conn:
            with conn.cursor() as cursor:
                query = """
                    SELECT id, field_name, data_type, max_length, display_order, is_required, input_constraints, tag
                    FROM web_ledger.master_field_definitions
                    WHERE tag = %s
                    ORDER BY display_order ASC
                """
                cursor.execute(query, (ledger_type,))
                rows = cursor.fetchall()
                fields = [dict(row) for row in rows]
        return jsonify(fields), 200
    except Exception as e:
        logging.error("台帳フィールド定義取得エラー: %s", e)
        return jsonify({"message": "台帳フィールド定義の取得に失敗しました。"}), 500
