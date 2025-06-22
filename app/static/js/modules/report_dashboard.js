// /frontend/report_dashboard/report_dashboard.js
new Vue({
  el: '#reportDashboardApp',
  delimiters: ['[[', ']]'],
  data: {
    // 基本情報
    language: 'ja',
    texts: {
      toggle_language: "言語切替",
      enter_ai_model: "利用するモデル:",
      cancel: "キャンセル",
      submit: "送信"
    },
    // ログイン状態（画面全体共通）
    loggedIn: true,  // 例としてtrue。実際は認証後に更新。
    // フィルタ
    filters: {
      dateFrom: '',
      dateTo: ''
    },
    // レポートデータ
    reportData: {
      summary: {},
      chartData: {}
    },
    chart: null,
    // 台帳データ用 (Handsontable)
    hot: null,
    ledgerData: [],
    dataTypeMap: {},
    // モーダルフォーム用
    formTitle: "新規レコード追加",
    formRecord: {},
    // AIチャット用
    aiChatMessages: [],
    aiChatInput: '',
    selectedModel: "gpt-4o-mini",
    aiModels: [
      { id: 1, name: "gpt-4o-mini" },
      { id: 2, name: "o1-mini" },
      { id: 3, name: "o3-mini" },
      { id: 4, name: "o3-mini-high" },
      { id: 5, name: "o1" },
      { id: 6, name: "text-embedding-3-small" },
      { id: 7, name: "text-embedding-3-large" }
    ],
    // サイドバー状態
    isSidebarOpen: false
  },
  created() {
    this.fetchReport();
    this.loadLedgerData();
  },
  methods: {
    toggleLanguage() {
      if (this.language === 'ja') {
        this.language = 'en';
        this.texts.toggle_language = "Toggle Language";
        this.texts.enter_ai_model = "Select AI Model:";
      } else {
        this.language = 'ja';
        this.texts.toggle_language = "言語切替";
        this.texts.enter_ai_model = "利用するモデル:";
      }
      document.documentElement.lang = this.language;
    },
    fetchReport() {
      axios.get('/api/report/dashboard', {
        params: this.filters,
        withCredentials: true
      })
      .then(response => {
        this.reportData = response.data;
        this.renderChart();
      })
      .catch(error => {
        alert("レポート取得エラー: " + (error.response.data.message || error));
        console.error(error);
      });
    },
    renderChart() {
      const ctx = document.getElementById('reportChart').getContext('2d');
      if (this.chart) {
        this.chart.destroy();
      }
      this.chart = new Chart(ctx, {
        type: 'bar',
        data: this.reportData.chartData,
        options: {
          responsive: true,
          title: {
            display: true,
            text: 'レポートチャート'
          }
        }
      });
    },
    loadLedgerData() {
      // 例: 台帳データ取得 API を呼び出し、Handsontable 用データを取得
      axios.get('/api/ledgers', {
        params: { type: 'sampleLedger' },
        withCredentials: true
      })
      .then(response => {
        this.ledgerData = response.data.records || [];
        this.dataTypeMap = {};
        response.data.columns.forEach(col => {
          this.dataTypeMap[col.column_name] = col.data_type;
        });
        this.initHandsontable();
      })
      .catch(error => {
        console.error("台帳データ取得エラー:", error);
      });
    },
    initHandsontable() {
      const container = document.getElementById('hotContainer');
      const hfInstance = HyperFormula.buildEmpty();
      this.hot = new Handsontable(container, {
        data: this.ledgerData,
        formulas: { engine: hfInstance },
        rowHeaders: true,
        colHeaders: true,
        contextMenu: true,
        manualColumnResize: true,
        manualRowResize: true,
        dropdownMenu: true,
        licenseKey: 'non-commercial-and-evaluation'
      });
    },
    // AIチャット用メソッド
    sendAiChat() {
      if (!this.aiChatInput.trim()) return;
      this.aiChatMessages.push({ role: 'user', content: this.aiChatInput });
      const messageToSend = this.aiChatInput;
      this.aiChatInput = '';
      axios.post('/api/ai-integration/chat', { message: messageToSend }, { withCredentials: true })
      .then(response => {
        this.aiChatMessages.push({ role: 'assistant', content: response.data.ai_response });
      })
      .catch(error => {
        alert("AIチャット送信エラー: " + (error.response.data.message || error));
        console.error(error);
      });
    },
    resetChat() {
      axios.post('/api/ai-integration/chat', { message: "", reset: true }, { withCredentials: true })
      .then(response => {
        this.aiChatMessages = [];
      })
      .catch(error => {
        alert("チャットリセットエラー: " + (error.response.data.message || error));
        console.error(error);
      });
    },
    toggleSidebar() {
      this.isSidebarOpen = !this.isSidebarOpen;
    }
  },
  computed: {
    toggleButtonStyle() {
      return {
        right: this.isSidebarOpen ? '300px' : '10px',
        transition: 'right 0.3s ease-in-out'
      };
    }
  },
  watch: {
    // 台帳選択時の処理（必要に応じて）
    selectedLedgerType(newType) {
      this.fetchRecords();
    }
  }
});
