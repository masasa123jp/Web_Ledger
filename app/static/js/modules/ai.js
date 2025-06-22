new Vue({
  el: '#aiApp',
  // global.js で定義された DELIMITERS を利用
  delimiters: window.DELIMITERS || ['[[', ']]'],
  data: {
    // ヘッダーコンポーネントへ渡すテキスト（初期は日本語版 texts.js を使用）
    headerTexts: window.headerTextsJa,
    // メインコンテンツ用テキスト（必要に応じて内容を変更してください）
    texts: {
      app_name: "Web台帳管理システム",
      analysis_gen_ai: "生成AI分析",
      enter_ledger_type: "台帳を選択してください",
      enter_ai_model: "利用するモデル:",
      prompt: "分析指示:",
      run_gen_ai: "実行",
      result_analysis: "解析結果",
      result_analysis_ai: "生成AI解析結果",
      toggle_language: "言語切替",
      report_dashboard: "レポート",
      ai_integration: "生成AI分析",
      pivot: "ピボット分析",
      anomaly_detection: "異常検知",
      ml_prediction: "機械学習",
      performance: "パフォーマンス",
      report_master_maintenance: "帳票マスターメンテナンス",
      chat_title: "生成AIチャット"
    },
    currentModule: 'analysis', // 'analysis' または 'chat'
    ledgerTypes: [],
    // 台帳選択用オブジェクト（APIレスポンスの形式に合わせ、ledger_tag と master_name を利用）
    selectedLedgerType: { ledger_tag: '', master_name: "台帳を選択してください" },
    selectedModel: "gpt-4o-mini",
    instruction: "",
    aiResult: "",
    aiModels: [
      { id: 1, name: "gpt-4o-mini" },
      { id: 2, name: "o1-mini" },
      { id: 3, name: "o3-mini" },
      { id: 4, name: "o3-mini-high" },
      { id: 5, name: "o1" },
      { id: 6, name: "text-embedding-3-small" },
      { id: 7, name: "text-embedding-3-large" }
    ],
    // チャット用データ
    aiChatMessages: [],
    aiChatInput: '',
    currentLang: 'ja'
  },
  computed: {
    // AI解析結果を marked.js で変換して表示
    parsedResult() {
      return marked(this.aiResult || '');
    }
  },
  methods: {
    // ヘッダーコンポーネントからのログアウト成功イベント用ハンドラ
    handleLogoutSuccess() {
      console.log("Logout successful.");
      // 必要に応じてリダイレクトなどの処理を追加してください
    },
    // 台帳種類を API から取得（レスポンスがオブジェクト配列の場合と文字列配列の場合に対応）
    fetchLedgerTypes() {
      axios.get('/api/ledger/ledger-types', { withCredentials: true })
        .then(response => {
          if (response.data.length > 0 && typeof response.data[0] === 'object') {
            this.ledgerTypes = response.data;
          } else {
            this.ledgerTypes = response.data.map(item => {
              let parts = item.split(':');
              return { ledger_tag: parts[0], master_name: parts[1] };
            });
          }
        })
        .catch(error => {
          console.error("台帳種類の取得に失敗しました:", error);
        });
    },
    handleLedgerTypeChange() {
      console.log("選択された台帳:", this.selectedLedgerType);
    },
    // AI解析実行
    runAI() {
      if (!this.selectedLedgerType || !this.selectedLedgerType.ledger_tag) {
        alert(this.texts.enter_ledger_type);
        return;
      }
      axios.get('/api/ledgers', {
        params: { type: this.selectedLedgerType.ledger_tag },
        withCredentials: true
      })
      .then(response => {
        let ledgerDataObj = response.data;
        let records = ledgerDataObj.records;
        if (!records || records.length === 0) {
          alert("選択された台帳にデータが存在しません。");
          return;
        }
        axios.post('/api/ai/analysis', {
          ledger_records: records,
          instruction: this.instruction,
          model: this.selectedModel
        }, { withCredentials: true })
        .then(res => {
          this.aiResult = JSON.stringify(res.data.analysis, null, 2);
        })
        .catch(err => {
          alert("AI解析エラー: " + (err.response.data.message || err));
          console.error(err);
        });
      })
      .catch(error => {
        alert("台帳データの取得に失敗しました: " + (error.response.data.message || error));
        console.error(error);
      });
    },
    // チャット送信処理
    sendAiChat() {
      if (!this.aiChatInput.trim()) return;
      this.aiChatMessages.push({ role: 'user', content: this.aiChatInput });
      const messageToSend = this.aiChatInput;
      this.aiChatInput = '';
      axios.post('/api/ai/chat', {
        message: messageToSend,
        model: "o3-mini-high",
        format: "plain"
      }, { withCredentials: true })
      .then(response => {
        this.aiChatMessages.push({ role: 'assistant', content: response.data.ai_response });
      })
      .catch(error => {
        alert("AIチャットの送信に失敗しました。");
        console.error(error);
      });
    },
    resetChat() {
      axios.post('/api/ai/chat', {
        message: "",
        reset: true
      }, { withCredentials: true })
      .then(response => {
        this.aiChatMessages = [];
      })
      .catch(error => {
        alert("チャットリセットに失敗しました。");
        console.error(error);
      });
    },
    // 言語切替処理（ヘッダーおよびメインテキストを切り替え）
    toggleLanguage() {
      if (this.currentLang === 'ja') {
        this.currentLang = 'en';
        // メインテキストの英語版更新
        this.texts.app_name = "Web Ledger Manager";
        this.texts.analysis_gen_ai = "Analysis Gen-AI";
        this.texts.enter_ledger_type = "Please select a ledger";
        this.texts.enter_ai_model = "Please select a Gen-AI model:";
        this.texts.prompt = "Please input prompt:";
        this.texts.run_gen_ai = "Run Gen-AI";
        this.texts.result_analysis = "Result Analysis";
        this.texts.result_analysis_ai = "Result Analysis By Gen-AI";
        this.texts.toggle_language = "Toggle Language";
        this.texts.report_dashboard = "Reports";
        this.texts.ai_integration = "Gen-AI Analysis";
        this.texts.pivot = "Pivot Table";
        this.texts.anomaly_detection = "Anomaly Detection";
        this.texts.ml_prediction = "Machine Learning";
        this.texts.performance = "Performance";
        this.texts.report_master_maintenance = "Report Master Maintenance";
        this.texts.chat_title = "Gen-AI Chat";
        // ヘッダー用テキストの英語版更新（texts.js の内容を利用）
        this.headerTexts = window.headerTextsEn;
      } else {
        this.currentLang = 'ja';
        // メインテキストの日本語版更新
        this.texts.app_name = "Web台帳管理システム";
        this.texts.analysis_gen_ai = "生成AI分析";
        this.texts.enter_ledger_type = "台帳を選択してください";
        this.texts.enter_ai_model = "利用するモデル:";
        this.texts.prompt = "分析指示:";
        this.texts.run_gen_ai = "実行";
        this.texts.result_analysis = "解析結果";
        this.texts.result_analysis_ai = "生成AI解析結果";
        this.texts.toggle_language = "言語切替";
        this.texts.report_dashboard = "レポート";
        this.texts.ai_integration = "生成AI分析";
        this.texts.pivot = "ピボット分析";
        this.texts.anomaly_detection = "異常検知";
        this.texts.ml_prediction = "機械学習";
        this.texts.performance = "パフォーマンス";
        this.texts.report_master_maintenance = "帳票マスターメンテナンス";
        this.texts.chat_title = "生成AIチャット";
        // ヘッダー用テキストの日本語版更新
        this.headerTexts = window.headerTextsJa;
      }
    }
  },
  mounted() {
    this.fetchLedgerTypes();
  }
});
