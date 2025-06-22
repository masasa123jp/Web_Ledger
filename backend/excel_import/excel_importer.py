# backend/excel_import/excel_importer.py

"""
excel_importer.py - モジュール: Excelインポーター
Excelファイルから台帳レコードをインポートします。
重複検出機能および必須カラムの存在チェックを実施します。

本モジュールは、Flask Blueprint (excel_bp) を介して API エンドポイントとして利用できます。
例:
    from backend.excel_import.excel_importer import excel_bp
"""

import pandas as pd
import logging
from flask import Blueprint, request, jsonify
from backend.master_management.master_field_service import MasterFieldService
from backend.ledger_transaction.ledger_manager import LedgerManager
from backend.api_util.api_util import get_connection
from typing import Set

# Flask Blueprint の定義
excel_bp = Blueprint('excel', __name__, url_prefix='/api/excel')

class ExcelImporter:
    """
    ExcelImporter クラスは、アップロードされた Excel ファイルから台帳レコードをインポートする機能を提供します。
    """
    def __init__(self):
        self.field_service = MasterFieldService()

    def validate_file(self, file_obj) -> bool:
        """
        ファイルフォーマットの検証
        Args:
            file_obj: アップロードされたファイルオブジェクト
        Returns:
            bool: 検証結果
        """
        if not file_obj:
            logging.error("ファイルがありません。")
            return False
        if not file_obj.filename.lower().endswith(('.xls', '.xlsx')):
            logging.error("サポートされていないファイル形式です。")
            return False
        return True

    def validate_required_columns(self, df: pd.DataFrame, required_columns: Set[str]) -> bool:
        """
        必須カラムの存在チェック
        Args:
            df (pd.DataFrame): 読み込まれたデータフレーム
            required_columns (Set[str]): 必須カラムのセット
        Returns:
            bool: チェック結果
        """
        missing_columns = required_columns - set(df.columns)
        if missing_columns:
            logging.error(f"欠如している必須カラム: {missing_columns}")
            return False
        return True

    def import_excel(self, file_obj, ledger_manager, ledger_type: str) -> int:
        """
        Excelファイルから台帳レコードをインポートする。
        Args:
            file_obj: アップロードされた Excel ファイルオブジェクト
            ledger_manager: 台帳管理のマネージャーインスタンス
            ledger_type (str): 台帳の種類（IDまたは名称）
        Returns:
            int: 正常にインポートされたレコード数
        Raises:
            ValueError: 必須カラムが不足している場合
            Exception: インポート処理中に発生したその他のエラー
        """
        try:
            if not self.validate_file(file_obj):
                raise ValueError("不正なファイル形式です。Excelファイルをアップロードしてください。")

            df = pd.read_excel(file_obj)
            master = self.field_service.get_column_structure(int(ledger_type))
            if not master:
                raise ValueError("指定された台帳が存在しません。")
            required_columns = {col['field_name'] for col in master if col['is_required']}
            if not self.validate_required_columns(df, required_columns):
                raise ValueError("Excelファイルに必要な列が欠けています。")

            imported_count = 0
            records = df.to_dict(orient="records")
            for record in records:
                # 重複チェック（例: data_id が重複していないか）
                # 実際の重複チェックロジックに応じて調整
                if ledger_manager.record_exists(ledger_type, record):
                    continue
                LedgerManager.add_ledger_record(int(ledger_type), record, updated_by="system")
                imported_count += 1

            return imported_count
        except Exception as e:
            logging.error(f"Excelインポートエラー: {e}")
            raise

@excel_bp.route('/import', methods=['POST'])
def import_excel_route():
    """
    POST /api/excel/import
    Excelファイルのインポートエンドポイント。

    リクエストパラメータ:
      - file: アップロードされた Excel ファイル（multipart/form-data）
      - ledger_type: 台帳の種類（フォームフィールド）

    戻り値:
      - 正常時: {"imported_records": 登録されたレコード数}
      - 異常時: {"error": エラーメッセージ}
    """
    if 'file' not in request.files or 'ledger_type' not in request.form:
        return jsonify({'error': 'ファイルと台帳の種類が必要です。'}), 400

    file_obj = request.files['file']
    ledger_type = request.form.get('ledger_type')
    if not ledger_type:
        return jsonify({'error': '台帳の種類が指定されていません。'}), 400

    ledger_manager = LedgerManager()
    importer = ExcelImporter()
    try:
        imported_count = importer.import_excel(file_obj, ledger_manager, ledger_type)
        return jsonify({'imported_records': imported_count}), 200
    except ValueError as ve:
        return jsonify({'error': str(ve)}), 400
    except Exception as e:
        logging.error(f"Excelインポートルートエラー: {e}")
        return jsonify({'error': 'Excelファイルのインポートに失敗しました。'}), 500