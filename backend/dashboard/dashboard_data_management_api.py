# backend/dashboard/dashboard_data_management_api.py
import logging
from flask import Blueprint, request, jsonify
from backend.dashboard.dashboard_data_management_service import dashboard_data_management_service

data_mgmt_bp = Blueprint('data_mgmt', __name__, url_prefix='/api/data_mgmt')

@data_mgmt_bp.route('/data', methods=['GET'])
def get_data_management_data():
    """
    GET /api/data_mgmt/data
    クエリパラメータ:
      - ledger_type: (例: "LEDGER001")
      - fields: カンマ区切りのID(例: "1,2,3")
      - limit: 取得件数(省略時50)
    """
    try:
        ledger_type = request.args.get("ledger_type")
        fields_param = request.args.get("fields")
        limit_param = request.args.get("limit", "50")
        
        if not ledger_type or not fields_param:
            return jsonify({"message": "ledger_type と fields のパラメータは必須です。"}), 400
        
        # カンマ区切り → list[int]
        field_ids = [int(f.strip()) for f in fields_param.split(",") if f.strip()]
        try:
            limit = int(limit_param)
        except ValueError:
            limit = 50
        
        result = dashboard_data_management_service.get_dynamic_data(ledger_type, field_ids, limit)
        # result 例:
        # {
        #   "kpi": {},
        #   "chartData": {},
        #   "sheetData": {
        #       "data": [...],
        #       "columns": [...]
        #   }
        # }
        return jsonify(result), 200
    except Exception as e:
        logging.error("Data management API error: %s", e)
        return jsonify({"message": "データマネジメントデータの取得に失敗しました。"}), 500