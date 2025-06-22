# backend/dashboard/dashboard_api.py
import logging
from flask import Blueprint, jsonify
from backend.dashboard.dashboard_data_service import dashboard_data_service

dashboard_bp = Blueprint('dashboard', __name__, url_prefix='/api/dashboard')

@dashboard_bp.route('/summary', methods=['GET'])
def get_dashboard_summary():
    """
    GET /api/dashboard/summary
    KPIデータ、チャートデータ、スプレッドシート用データをまとめて返却します。
    """
    try:
        kpi = dashboard_data_service.get_kpi_data()
        chartData = dashboard_data_service.get_chart_data()
        sheetData = dashboard_data_service.get_sheet_data()
        return jsonify({
            "kpi": kpi,
            "chartData": chartData,
            "sheetData": sheetData
        }), 200
    except Exception as e:
        logging.error("Dashboard summary error: %s", e)
        return jsonify({"message": "Error fetching dashboard data."}), 500

@dashboard_bp.route('/kpi', methods=['GET'])
def get_dashboard_kpi():
    """
    GET /api/dashboard/kpi
    KPIデータのみを返却します。
    """
    try:
        kpi = dashboard_data_service.get_kpi_data()
        return jsonify(kpi), 200
    except Exception as e:
        logging.error("Dashboard KPI error: %s", e)
        return jsonify({"message": "Error fetching KPI data."}), 500

@dashboard_bp.route('/chart', methods=['GET'])
def get_dashboard_chart():
    """
    GET /api/dashboard/chart
    チャート描画用のデータのみを返却します。
    """
    try:
        chartData = dashboard_data_service.get_chart_data()
        return jsonify(chartData), 200
    except Exception as e:
        logging.error("Dashboard chart error: %s", e)
        return jsonify({"message": "Error fetching chart data."}), 500

@dashboard_bp.route('/sheet', methods=['GET'])
def get_dashboard_sheet():
    """
    GET /api/dashboard/sheet
    スプレッドシート表示用の台帳データを返却します。
    """
    try:
        sheetData = dashboard_data_service.get_sheet_data()
        return jsonify(sheetData), 200
    except Exception as e:
        logging.error("Dashboard sheet error: %s", e)
        return jsonify({"message": "Error fetching sheet data."}), 500
