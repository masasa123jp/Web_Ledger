#!/usr/bin/env python
"""
call_openai_api.py - OpenAI chat.completion API を呼び出し、生成された応答テキストを返す関数を実装します。
"""

import openai
import os
import logging
from typing import List, Dict, Optional

# OpenAI API キーは環境変数から取得するか、config.py等で設定してください
openai.api_key = os.environ.get("OPENAI_API_KEY")

def call_openai_api(messages: List[Dict[str, str]],
                    model_name: str,
                    max_tokens: int = 150) -> str:
    """
    OpenAI の chat.completion API を呼び出し、生成された応答テキストを返します。

    Args:
        messages (List[Dict[str, str]]): チャット履歴のメッセージリスト。各メッセージは {"role": "user"/"assistant", "content": "テキスト"} の形式。
        model_name (str): 利用するモデル名（例："gpt-4o-mini", "o3-mini-high" など）。
        max_tokens (int, optional): 応答生成時の最大トークン数。デフォルトは 150。

    Returns:
        str: 生成された応答テキスト（前後の空白は除去済み）。

    Raises:
        Exception: API 呼び出し時にエラーが発生した場合、そのエラーを再送出します。
    """
    try:
        if model_name == "o3-mini-high":
            # 例: "o3-mini-high" の場合は内部的に "o3-mini" モデルを利用し、reasoning_effort を "high" に設定
            response = openai.chat.completion.create(
                model="o3-mini",
                messages=messages,
                max_tokens=max_tokens,
                # ※ 以下のパラメータは例示です。実際のAPI仕様に合わせて適宜調整してください。
                reasoning_effort="high"
            )
        else:
            response = openai.chat.completion.create(
                model=model_name,
                messages=messages,
                max_tokens=max_tokens
            )
        # 応答テキストを取得して返す
        return response.choices[0].message.content.strip()
    except Exception as e:
        logging.error("Error calling OpenAI API: %s", str(e))
        raise e
