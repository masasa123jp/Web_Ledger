from flask import Blueprint, request, jsonify
import logging
from backend.master_management.master_field_service import MasterFieldService

master_bp = Blueprint('master', __name__, url_prefix='/api/master')
field_service = MasterFieldService()

@master_bp.route('/masters', methods=['GET'])
def get_all_masters():
    try:
        masters = field_service.get_all_masters()
        return jsonify(masters), 200
    except Exception as e:
        logging.error(f"マスター情報取得エラー: {e}")
        return jsonify({"message": "マスター情報の取得に失敗しました。"}), 500

@master_bp.route('/masters', methods=['POST'])
def add_master():
    data = request.get_json()
    if not data or 'master_type' not in data or 'fields' not in data:
        return jsonify({"message": "master_type と fields は必須です。"}), 400
    try:
        master_id = field_service.add_master(data)
        return jsonify({"message": "マスターが追加されました。", "master_id": master_id}), 201
    except ValueError as ve:
        logging.error(f"マスター追加バリデーションエラー: {ve}")
        return jsonify({"message": str(ve)}), 400
    except Exception as e:
        logging.error(f"マスター追加エラー: {e}")
        return jsonify({"message": "マスターの追加に失敗しました。"}), 500

@master_bp.route('/masters/<int:master_id>', methods=['PUT'])
def update_master(master_id):
    data = request.get_json()
    if not data:
        return jsonify({"message": "リクエストデータが無効です。"}), 400
    try:
        field_service.update_master(master_id, data)
        return jsonify({"message": "マスターが更新されました。"}), 200
    except ValueError as ve:
        logging.error(f"マスター更新バリデーションエラー: {ve}")
        return jsonify({"message": str(ve)}), 400
    except Exception as e:
        logging.error(f"マスター更新エラー: {e}")
        return jsonify({"message": "マスターの更新に失敗しました。"}), 500

@master_bp.route('/masters/<int:master_id>', methods=['DELETE'])
def delete_master(master_id):
    try:
        field_service.delete_master(master_id)
        return jsonify({"message": "マスターが削除されました。"}), 200
    except Exception as e:
        logging.error(f"マスター削除エラー: {e}")
        return jsonify({"message": "マスターの削除に失敗しました。"}), 500

# unified_master_records を取得する新エンドポイント（Ledger/非Ledger共通）
@master_bp.route('/records', methods=['GET'])
def get_records():
    master_id = request.args.get('master_id')
    if not master_id:
        return jsonify({"message": "master_id は必須です。"}), 400
    try:
        records = field_service.get_ledger_records(master_id)
        return jsonify(records), 200
    except Exception as e:
        logging.error(f"レコード取得エラー: {e}")
        return jsonify({"message": "レコードの取得に失敗しました。"}), 500

# 項目レベル操作エンドポイント
@master_bp.route('/fields', methods=['GET'])
def get_fields():
    master_id = request.args.get('master_id')
    if not master_id:
        return jsonify({"message": "master_id is required"}), 400
    try:
        fields = field_service.get_fields(master_id)
        return jsonify(fields), 200
    except Exception as e:
        logging.error(f"フィールド定義取得エラー: {e}")
        return jsonify({"message": "フィールド定義の取得に失敗しました。"}), 500

@master_bp.route('/fields', methods=['POST'])
def add_field():
    data = request.get_json()
    if not data or 'master_id' not in data or 'field_name' not in data:
        return jsonify({"message": "master_id と field_name は必須です。"}), 400
    try:
        new_field_id = field_service.add_field(data['master_id'], data)
        return jsonify({"message": "項目が追加されました。", "field_id": new_field_id}), 201
    except Exception as e:
        logging.error(f"項目追加エラー: {e}")
        return jsonify({"message": "項目の追加に失敗しました。"}), 500

@master_bp.route('/fields/<int:field_id>', methods=['PUT'])
def update_field(field_id):
    data = request.get_json()
    if not data:
        return jsonify({"message": "リクエストデータが無効です。"}), 400
    try:
        field_service.update_field(field_id, data)
        return jsonify({"message": "項目が更新されました。"}), 200
    except Exception as e:
        logging.error(f"項目更新エラー: {e}")
        return jsonify({"message": "項目の更新に失敗しました。"}), 500

@master_bp.route('/fields/<int:field_id>', methods=['DELETE'])
def delete_field(field_id):
    try:
        field_service.delete_field(field_id)
        return jsonify({"message": "項目が削除されました。"}), 200
    except Exception as e:
        logging.error(f"項目削除エラー: {e}")
        return jsonify({"message": "項目の削除に失敗しました。"}), 500

@master_bp.route('/column-structure', methods=['GET'])
def get_column_structure_api():
    # Ledgerの場合の項目定義取得。ledger_id は Ledger マスターの master_id として扱う。
    ledger_id = request.args.get('ledger_id')
    if not ledger_id:
        return jsonify({"message": "ledger_id is required"}), 400
    try:
        fields = field_service.get_column_structure(ledger_id)
        return jsonify(fields), 200
    except Exception as e:
        logging.exception("Column structure retrieval error")
        return jsonify({"message": "Column structure retrieval error"}), 500

# ★【新規】POST /api/master/records => レコード新規作成
@master_bp.route('/records', methods=['POST'])
def create_record():
    data = request.get_json()
    if not data or 'master_id' not in data or 'record_data' not in data:
        return jsonify({"message": "master_id と record_data は必須です。"}), 400

    master_id = data['master_id']
    record_data = data['record_data']
    try:
        new_record_id = field_service.create_record(master_id, record_data)
        return jsonify({
            "message": "レコードが追加されました。",
            "record_id": new_record_id
        }), 201
    except Exception as e:
        logging.error(f"レコード新規作成エラー: {e}")
        return jsonify({"message": "レコードの追加に失敗しました。"}), 500


# ★【新規】PUT /api/master/records/<int:record_id> => レコード更新
@master_bp.route('/records/<int:record_id>', methods=['PUT'])
def update_record(record_id):
    data = request.get_json()
    if not data or 'record_data' not in data:
        return jsonify({"message": "record_data が必須です。"}), 400

    try:
        field_service.update_record(record_id, data['record_data'])
        return jsonify({"message": "レコードが更新されました。"}), 200
    except Exception as e:
        logging.error(f"レコード更新エラー: {e}")
        return jsonify({"message": "レコードの更新に失敗しました。"}), 500


# ★【新規】DELETE /api/master/records/<int:record_id> => レコード削除
@master_bp.route('/records/<int:record_id>', methods=['DELETE'])
def delete_record(record_id):
    try:
        field_service.delete_record(record_id)
        return jsonify({"message": "レコードが削除されました。"}), 200
    except Exception as e:
        logging.error(f"レコード削除エラー: {e}")
        return jsonify({"message": "レコードの削除に失敗しました。"}), 500

# LedgerMasterManager クラス（外部利用用ラッパー）
class LedgerMasterManager:
    def __init__(self):
        self.service = MasterFieldService()

    def get_all_ledger_masters(self):
        return self.service.get_all_masters()

    def add_ledger_master(self, ledger_name: str, column_masters: list):
        data = {
            "master_type": ledger_name,
            "fields": column_masters
        }
        return self.service.add_master(data)

    def update_ledger_master(self, ledger_id: int, data: dict):
        return self.service.update_master(ledger_id, data)

    def delete_ledger_master(self, ledger_id: int):
        return self.service.delete_master(ledger_id)

    def get_column_structure(self, ledger_id: int):
        return self.service.get_column_structure(ledger_id)
