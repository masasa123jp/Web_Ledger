# backend/report_dashboard/export_utils.py

"""
export_utils.py - レポートデータを CSV、Excel、PDF などの形式でエクスポートするためのユーティリティ。
"""

import csv
import io
import pandas as pd

def export_to_csv(data):
    """
    レポートデータを CSV 形式に変換して返す
    """
    output = io.StringIO()
    if data and isinstance(data, list):
        keys = data[0].keys()
        dict_writer = csv.DictWriter(output, keys)
        dict_writer.writeheader()
        dict_writer.writerows(data)
    return output.getvalue()

def export_to_excel(data):
    """
    レポートデータを Excel ファイル形式に変換して返す
    """
    df = pd.DataFrame(data)
    output = io.BytesIO()
    df.to_excel(output, index=False)
    return output.getvalue()

def export_to_pdf(data):
    """
    レポートデータを PDF 形式に変換する（実際には ReportLab 等のライブラリを利用）
    ※ここではスタブとして実装
    """
    return "PDF export is not implemented yet."