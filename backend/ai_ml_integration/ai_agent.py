#!/usr/bin/env python
"""
ai_agent.py - AIエージェントモジュール
台帳データの簡易分析をシミュレートします。
各台帳レコードから "budget_amount" を集計し、統計情報と推奨事項を返します。

【利用例】
    from backend.ai_analysis.ai_agent import AIAgent, analyze_ledgers_sample
    analysis = analyze_ledgers_sample(ledger_records)
"""

from typing import List, Dict, Any
import logging

class AIAgent:
    def analyze_ledgers(self, ledgers: List[Dict[str, Any]]) -> Dict[str, Any]:
        """
        台帳データに対する簡易分析を実施します。
        各レコードから "budget_amount" を取得して集計し、統計情報と推奨事項を返します。

        Args:
            ledgers (List[Dict[str, Any]]): 台帳データのリスト

        Returns:
            Dict[str, Any]: 分析結果の辞書（例:
                {
                    "総レコード数": 10,
                    "総金額": 123456,
                    "平均金額": 12345.6,
                    "推奨事項": "異常は検出されませんでした。"
                }
            )
        """
        total_records: int = len(ledgers)
        total_amount: float = 0.0

        for ledger in ledgers:
            try:
                # "budget_amount" を数値として取得（例：欠損値の場合は 0 とする）
                amount = float(ledger.get("budget_amount", 0))
            except (ValueError, TypeError):
                amount = 0.0
            total_amount += amount

        average_amount: float = total_amount / total_records if total_records > 0 else 0.0

        if total_records == 0:
            recommendation: str = "分析対象のデータがありません。"
        else:
            recommendation: str = "異常は検出されませんでした。" if total_amount >= 0 else "負債のある取引を確認してください。"

        analysis: Dict[str, Any] = {
            "総レコード数": total_records,
            "総金額": total_amount,
            "平均金額": round(average_amount, 2),
            "推奨事項": recommendation
        }
        logging.info("台帳分析完了: %s", analysis)
        return analysis

def analyze_ledgers_sample(ledger_records: List[Dict[str, Any]]) -> Dict[str, Any]:
    """
    台帳データの簡易分析を実施するユーティリティ関数。
    AIAgent クラスを利用して、ledger_records を解析し、結果を返します。

    Args:
        ledger_records (List[Dict[str, Any]]): 台帳データのリスト

    Returns:
        Dict[str, Any]: 分析結果の辞書
    """
    agent = AIAgent()
    result = agent.analyze_ledgers(ledger_records)
    return result
