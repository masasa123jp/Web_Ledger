(function() {
  // --------------------------------------------------------------------
  // 1) 多言語用メッセージ定義（台帳入力フォーム専用）
  // --------------------------------------------------------------------
  const ledgerMessages = {
    ja: {
      app_name: "台帳管理システム",
      logout_button: "ログアウト",
      toggle_language: "言語切替",
      confirm_logout: "ログアウトしてもよろしいですか？",
      logout_success: "ログアウトしました。",
      logout_failure: "ログアウトに失敗しました。",
      ledger_form_title: "台帳入力フォーム",
      select_ledger: "台帳を選択してください",
      filter_reset: "フィルターリセット",
      new_record: "新規追加",
      operation: "操作",
      filter_placeholder: "Filter",
      no_data: "台帳データが存在しません。",
      not_selected: "台帳が選択されていません。",
      delete: "削除",
      close: "閉じる",
      cancel: "キャンセル",
      submit: "送信",
      confirm_delete: "このレコードを削除してもよろしいですか？",
      confirm_save: "変更を保存しますか？",
      // ナビゲーションメニュー例
      nav_links: {
        ledger_input: "各種台帳確認",
        dashboard: "ダッシュボード",
        user_management: "ユーザー管理",
        manual: "マニュアル",
        version_info: "バージョン情報",
        ai: "生成AI",
        pivot: "ピボット",
        report: "レポート",
        unified_master_manager: "統合マスター管理"
      },
      nav_categories: {
        ledger: "台帳",
        admin: "管理",
        analysis: "分析"
      },
      // 生成AIチャット用テキスト
      enter_ai_model: "利用するAIモデルを選択"
    },
    en: {
      app_name: "Web Ledger Manager",
      logout_button: "Logout",
      toggle_language: "Toggle Language",
      confirm_logout: "Are you sure you want to log out?",
      logout_success: "Logged out successfully.",
      logout_failure: "Logout failed.",
      ledger_form_title: "Ledger Input Form",
      select_ledger: "Please select a ledger",
      filter_reset: "Reset Filters",
      new_record: "Add New",
      operation: "Operation",
      filter_placeholder: "Filter",
      no_data: "No ledger data.",
      not_selected: "No ledger selected.",
      delete: "Delete",
      close: "Close",
      cancel: "Cancel",
      submit: "Submit",
      confirm_delete: "Are you sure you want to delete this record?",
      confirm_save: "Save changes?",
      nav_links: {
        ledger_input: "Ledgers",
        dashboard: "Dashboard",
        user_management: "User Management",
        manual: "Manual",
        version_info: "Version Information",
        ai: "Generative AI",
        pivot: "Pivot",
        report: "Report",
        unified_master_manager: "Unified Master Management"
      },
      nav_categories: {
        ledger: "Ledger",
        admin: "Administration",
        analysis: "Analysis"
      },
      enter_ai_model: "Select AI model to use"
    }
  };

  // --------------------------------------------------------------------
  // 2) ledger-form-header コンポーネント定義（台帳入力画面専用ヘッダー）
  // --------------------------------------------------------------------
  const DELIMITERS = window.DELIMITERS || ['[[', ']]'];

  Vue.component('ledger-form-header', {
    delimiters: DELIMITERS,
    props: {
      ledgerTypes: {
        type: Array,
        default: () => []
      },
      value: {
        type: Object,
        default: () => ({ key: '', master_type_id: null, value: '' })
      },
      texts: {
        type: Object,
        default: () => ({
          ledger_form_title: "台帳入力フォーム",
          select_ledger: "台帳を選択してください",
          filter_reset: "フィルターリセット",
          new_record: "新規追加"
        })
      }
    },
    template: `
      <header class="container my-3">
        <div class="row align-items-center">
          <div class="col-md-6">
            <h4>[[ texts.ledger_form_title ]]</h4>
          </div>
          <div class="col-md-6 text-end">
            <select v-model="selected" @change="onChange" class="form-select form-select-lg w-auto d-inline-block">
              <option :value="{ key: '', master_type_id: null, value: '' }">[[ texts.select_ledger ]]</option>
              <option v-for="item in ledgerTypes" :key="item.master_type_id + '-' + item.key" :value="item">
                [[ item.value ]]
              </option>
            </select>
            <button @click="$emit('reset-filters')" class="btn btn-warning btn-lg ms-2">[[ texts.filter_reset ]]</button>
            <button @click="$emit('show-add-form')" class="btn btn-success btn-lg ms-2" data-bs-toggle="modal" data-bs-target="#addRecordModal">
              [[ texts.new_record ]]
            </button>
          </div>
        </div>
      </header>
    `,
    data() {
      return { selected: this.value };
    },
    methods: {
      onChange() {
        this.$emit('input', this.selected);
        this.$emit('ledger-type-changed', this.selected);
      }
    },
    watch: {
      value(newVal) {
        this.selected = newVal;
      }
    }
  });

  // --------------------------------------------------------------------
  // 3) メインの Vue インスタンス (台帳入力フォーム＋生成AIチャットサイドバー)
  // --------------------------------------------------------------------
  new Vue({
    el: '#ledger-form-app',
    delimiters: DELIMITERS,
    template: `
      <div id="ledger-container" class="ledger-container">
        <!-- ヘッダー部分 -->
        <div class="ledger-header">
          <app-header :texts="headerTexts" :links="headerLinks" @toggle-language="toggleLanguage" @logout-success="onLogoutSuccess"></app-header>
          <ledger-form-header :ledger-types="ledgerTypes" v-model="selectedLedger" @reset-filters="resetFilters" @show-add-form="showAddForm" :texts="texts"></ledger-form-header>
        </div>
        <!-- 台帳本体（テーブル＋モーダル） -->
        <div class="ledger-body">
          <section class="ledger-content">
            <div class="table-responsive">
              <table v-if="filteredLedgers.length || showEmptyTable" class="table ledger-table table-striped table-hover">
                <thead class="table-dark ledger-table">
                  <tr>
                    <th class="sticky-col" style="position: sticky; left: 0; z-index: 51;">[[ texts.operation ]]</th>
                    <th v-for="(col, index) in ledgerFields" :key="col" v-if="col !== 'data_id'" @click="sortBy(col)" style="cursor:pointer">
                      [[ col ]]
                      <span v-if="sortKey === col">[[ sortOrder === 1 ? '↑' : '↓' ]]</span>
                    </th>
                  </tr>
                  <tr class="filter-row">
                    <th style="position: sticky; left: 0; z-index: 51;"></th>
                    <th v-for="(col, index) in ledgerFields" :key="col" v-if="col !== 'data_id'">
                      <input type="text" v-model="filters[col]" class="form-control" :placeholder="texts.filter_placeholder + ' ' + col">
                    </th>
                  </tr>
                </thead>
                <tbody>
                  <tr v-for="record in filteredLedgers" :key="record.data_id">
                    <td class="sticky-col">
                      <button @click="deleteRecord(record.data_id)" class="btn btn-danger btn-sm">[[ texts.delete ]]</button>
                    </td>
                    <td v-for="(col, index) in ledgerFields" :key="col" v-if="col !== 'data_id'" @click="startEditing(record.data_id, col, record.fields[col])">
                      <template v-if="isEditing(record.data_id, col)">
                        <div class="input-group">
                          <input :type="isDateField(col) ? 'date' : (isNumericField(col) ? 'number' : 'text')" v-model="editingValue"
                                 @blur="finishEditing(record)" @keyup.enter="finishEditing(record)" @keyup.esc="cancelEditing"
                                 class="form-control" :placeholder="getPlaceholder(col)">
                        </div>
                      </template>
                      <template v-else>
                        <span v-if="isNumericField(col)">[[ formatNumber(record.fields[col], col) ]]</span>
                        <span v-else>[[ record.fields[col] ]]</span>
                      </template>
                    </td>
                  </tr>
                </tbody>
              </table>
              <div v-else-if="selectedLedger && selectedLedger.master_type_id" class="alert alert-info">[[ texts.no_data ]]</div>
              <div v-else class="alert alert-info">[[ texts.not_selected ]]</div>
            </div>
          </section>
        </div>
        <!-- モーダルフォーム：新規レコード追加 -->
        <div class="modal fade" id="addRecordModal" tabindex="-1" aria-labelledby="addRecordModalLabel" aria-hidden="true">
          <div class="modal-dialog">
            <div class="modal-content">
              <div class="modal-header">
                <h5 class="modal-title" id="addRecordModalLabel">[[ formTitle ]]</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" :aria-label="texts.close"></button>
              </div>
              <div class="modal-body">
                <form>
                  <div class="mb-3" v-for="(value, key) in formRecord" :key="key">
                    <label :for="key" class="form-label">[[ key ]]</label>
                    <input :type="isDateField(key) ? 'date' : (isNumericField(key) ? 'number' : 'text')" v-model="formRecord[key]"
                           class="form-control" :placeholder="getPlaceholder(key)" required>
                  </div>
                </form>
              </div>
              <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">[[ texts.cancel ]]</button>
                <button type="button" class="btn btn-primary" @click="submitForm" data-bs-dismiss="modal">[[ texts.submit ]]</button>
              </div>
            </div>
          </div>
        </div>
        <!-- 生成AIチャットサイドバー -->
        <div id="sidebar-container" v-if="loggedIn">
          <div id="aiSidebar" :class="{ open: isSidebarOpen }">
            <!-- モデル選択 -->
            <div class="mb-3">
              <h5>
                <label for="ledgerSelect" class="form-label">
                  台帳情報の分析ができます。
                </label>
              </h5>
              <h4>
                <label for="modelSelect" class="form-label">[[ texts.enter_ai_model ]]</label>
              </h4>
              <select id="modelSelect" v-model="selectedModel" class="form-select form-select-lg">
                <option v-for="model in aiModels" :key="model.id" :value="model.name">
                  [[ model.name ]]
                </option>
              </select>
            </div>
            <!-- 注意文：AI応答は全角100文字以内に制限 -->
            <div class="ai-notice mb-2" style="font-size: 0.9rem; color: #856404; background-color: #ffeeba; padding: 5px; border: 1px solid #ffeeba; border-radius: 4px;">
              ※ AI応答は全角100文字以内です。
            </div>
            <!-- チャット履歴表示 -->
            <div id="chat-history" class="d-flex flex-column">
              <div v-for="(msg, index) in aiChatMessages" :key="index"
                   :class="['chat-message', msg.role === 'user' ? 'chat-user' : 'chat-assistant']">
                [[ msg.content ]]
              </div>
            </div>
            <!-- チャット入力エリア -->
            <div id="chat-input-area" class="mt-2">
              <textarea v-model="aiChatInput" class="form-control mb-2" rows="3" placeholder="メッセージを入力"></textarea>
              <div class="d-flex">
                <button class="btn btn-primary flex-grow-1" @click="sendAiChat">送信</button>
                <button class="btn btn-secondary ms-2" @click="resetChat">リセット</button>
              </div>
            </div>
          </div>
          <!-- 付箋タブボタン -->
          <button class="sidebar-toggle" @click="toggleSidebar" :style="toggleButtonStyle">
            [[ isSidebarOpen ? '折りたたむ' : '生成AIチャット展開' ]]
          </button>
        </div>
      </div>
    `,
    data() {
      return {
        // --- 多言語関連 ---
        language: 'ja',
        texts: Object.assign({}, ledgerMessages['ja']),
        // ※ header.js の固定文言（headerTexts）は texts.js の内容（window.headerTextsJa/En）を利用可能としています
        headerTexts: Object.assign({}, window.headerTextsJa),
        /*headerLinks: {
          home: '/',
          categories: {
            ledger: {
              items: {
                ledger_input: '/ledger_form/ledger_form.html',
                dashboard: '/dashboard/dashboard.html'
              }
            },
            analysis: {
              items: {
                ai: '/ai/ai.html',
                pivot: '/pivot/pivot.html',
                report: '/report_dashboard_ui/dashboard.html'
              }
            },
            admin: {
              items: {
                unified_master_manager: '/unified_master_manager/unified_master_manager.html',
                user_management: '/user_management/user_management.html'
              }
            },
            other: {
              items: {
                manual: '/manual/manual.html',
                version_info: '/version_history/version_history.html',
              }
            }
          }
        }*/

        // --- 台帳関連 ---
        ledgerTypes: [],
        selectedLedger: { key: '', master_type_id: null, value: '' },
        ledgerFields: [],
        ledgers: [],
        filters: {},
        showEmptyTable: false,
        formTitle: "新規レコード追加",
        formRecord: {},
        dataTypeMap: {},
        editingCell: { id: null, key: '' },
        editingValue: '',
        editingOriginal: '',
        sortKey: "",
        sortOrder: 1,

        // --- 生成AIチャットサイドバー関連 ---
        loggedIn: true,
        isSidebarOpen: false,
        aiChatMessages: [],
        aiChatInput: "",
        selectedModel: "",
        // aiModels を更新したリスト
        aiModels: [
          { id: 1, name: "gpt-4o-mini" },
          { id: 2, name: "o1-mini" },
          { id: 3, name: "o3-mini" },
          { id: 4, name: "o3-mini-high" },
          { id: 5, name: "o1" },
          { id: 6, name: "text-embedding-3-small" },
          { id: 7, name: "text-embedding-3-large" }
        ]
      };
    },
    computed: {
      filteredLedgers() {
        let result = this.ledgers;
        Object.keys(this.filters).forEach(key => {
          if (this.filters[key]) {
            const lowerVal = String(this.filters[key]).toLowerCase();
            result = result.filter(rec => {
              const cellVal = String(rec.fields[key] || '').toLowerCase();
              return cellVal.includes(lowerVal);
            });
          }
        });
        if (this.sortKey) {
          result = result.slice().sort((a, b) => {
            const valA = a.fields[this.sortKey] || "";
            const valB = b.fields[this.sortKey] || "";
            const numA = parseFloat(valA);
            const numB = parseFloat(valB);
            if (!isNaN(numA) && !isNaN(numB)) {
              return (numA - numB) * this.sortOrder;
            } else {
              if (valA > valB) return 1 * this.sortOrder;
              if (valA < valB) return -1 * this.sortOrder;
              return 0;
            }
          });
        }
        this.showEmptyTable = (result.length === 0 && this.selectedLedger.master_type_id);
        return result;
      },
      // サイドバーが展開している場合は toggle ボタンはサイドバーの左端（right:300px）、閉じている場合は画面右端から10pxに配置
      toggleButtonStyle() {
        return {
          right: this.isSidebarOpen ? '300px' : '10px',
          transition: 'right 0.3s ease-in-out'
        };
      },
    },
    watch: {
      selectedLedger(newVal) {
        if (newVal && newVal.master_type_id) {
          this.fetchRecords();
        } else {
          this.ledgers = [];
          this.ledgerFields = [];
          this.dataTypeMap = {};
          this.showEmptyTable = false;
        }
      }
    },
    created() {
      this.fetchLedgerTypes();
      document.documentElement.lang = this.language;
    },
    methods: {
      // --- 多言語切り替え ---
      toggleLanguage() {
        this.language = (this.language === 'ja') ? 'en' : 'ja';
        this.texts = ledgerMessages[this.language];
        // headerTexts も切り替え（texts.js に定義された内容と併用する場合は適宜マージしてください）
        if (this.language === 'ja') {
          this.headerTexts = Object.assign({}, window.headerTextsJa);
        } else {
          this.headerTexts = Object.assign({}, window.headerTextsEn);
        }
        document.documentElement.lang = this.language;
      },
      onLogoutSuccess() {
        alert("ログアウトが完了しました（サンプル）");
      },
      // --- 台帳情報取得 ---
      fetchLedgerTypes() {
        axios.get('/api/ledger/ledger-types', { withCredentials: true })
          .then(resp => {
            this.ledgerTypes = resp.data.map(item => ({
              key: item.ledger_tag,
              master_type_id: item.master_type_id,
              value: item.master_name
            }));
          })
          .catch(err => {
            console.error("台帳種類の取得失敗:", err);
          });
      },
      fetchRecords() {
        if (!this.selectedLedger || !this.selectedLedger.master_type_id || !this.selectedLedger.key) {
          this.ledgers = [];
          this.ledgerFields = [];
          this.dataTypeMap = {};
          this.showEmptyTable = false;
          return;
        }
        axios.get(`/api/ledger/${this.selectedLedger.master_type_id}`, {
            params: { ledger_tag: this.selectedLedger.key },
            withCredentials: true
          })
          .then(resp => {
            this.ledgers = resp.data;
            if (this.ledgers.length > 0) {
              const firstRecord = this.ledgers[0];
              if (firstRecord.field_orders) {
                const fieldsArr = [];
                for (const field in firstRecord.field_orders) {
                  fieldsArr.push({
                    field_name: field,
                    display_order: parseInt(firstRecord.field_orders[field])
                  });
                }
                fieldsArr.sort((a, b) => a.display_order - b.display_order);
                this.ledgerFields = fieldsArr.map(item => item.field_name);
                this.ledgerFields.unshift("data_id");
              } else {
                this.ledgerFields = Object.keys(firstRecord.fields);
                this.ledgerFields.unshift("data_id");
              }
            } else {
              this.ledgerFields = [];
            }
            this.dataTypeMap = {};
            this.showEmptyTable = (this.ledgers.length === 0);
          })
          .catch(err => {
            console.error("台帳データの取得失敗:", err);
          });
      },
      // --- フィルタ・ソート ---
      resetFilters() {
        Object.keys(this.filters).forEach(k => {
          this.filters[k] = '';
        });
        this.fetchRecords();
      },
      sortBy(col) {
        if (this.sortKey === col) {
          this.sortOrder = -this.sortOrder;
        } else {
          this.sortKey = col;
          this.sortOrder = 1;
        }
      },
      // --- レコード削除 ---
      deleteRecord(data_id) {
        if (!confirm(this.texts.confirm_delete)) return;
        axios.delete(`/api/ledger/${this.selectedLedger.master_type_id}/${data_id}`, { withCredentials: true })
          .then(resp => {
            alert(resp.data.message);
            this.fetchRecords();
          })
          .catch(err => {
            alert("削除に失敗しました。");
            console.error(err);
          });
      },
      // --- セル編集 ---
      startEditing(data_id, key, val) {
        this.editingCell = { id: data_id, key };
        this.editingValue = val;
        this.editingOriginal = val;
      },
      isEditing(data_id, key) {
        return this.editingCell.id === data_id && this.editingCell.key === key;
      },
      finishEditing(record) {
        if (this.editingValue === this.editingOriginal) {
          this.cancelEditing();
          return;
        }
        if (!confirm(this.texts.confirm_save)) {
          this.cancelEditing();
          return;
        }
        const fieldKey = this.editingCell.key;
        const payload = {
          ledger_tag: this.selectedLedger.key,
          updates: { [fieldKey]: this.editingValue },
          updated_by: "system"
        };
        axios.put(`/api/ledger/${this.selectedLedger.master_type_id}/${record.data_id}`, payload, { withCredentials: true })
          .then(resp => {
            alert(resp.data.message);
            this.fetchRecords();
            this.cancelEditing();
          })
          .catch(err => {
            alert("更新に失敗しました。");
            console.error(err);
            this.cancelEditing();
          });
      },
      cancelEditing() {
        this.editingCell = { id: null, key: '' };
        this.editingValue = '';
        this.editingOriginal = '';
      },
      // --- レコード追加 (モーダル) ---
      showAddForm() {
        this.formTitle = this.texts.new_record;
        this.formRecord = {};
        this.ledgerFields.forEach(col => {
          if (col !== 'data_id') {
            this.$set(this.formRecord, col, '');
          }
        });
      },
      submitForm() {
        if (!this.selectedLedger.master_type_id || !this.selectedLedger.key) {
          alert(this.texts.not_selected || "台帳が選択されていません。");
          return;
        }
        const payload = {
          master_type_id: this.selectedLedger.master_type_id,
          ledger_tag: this.selectedLedger.key,
          record: this.formRecord,
          updated_by: "system"
        };
        axios.post('/api/ledger', payload, { withCredentials: true })
          .then(resp => {
            alert(resp.data.message);
            this.fetchRecords();
          })
          .catch(err => {
            alert("保存に失敗しました。");
            console.error(err);
          });
      },
      // --- フィールド種別判定 ---
      isDateField(key) {
        return this.dataTypeMap[key] === 'date';
      },
      isNumericField(key) {
        return this.dataTypeMap[key] === 'number' || this.dataTypeMap[key] === 'real';
      },
      getPlaceholder(key) {
        if (this.isDateField(key)) {
          return "YYYY-MM-DD形式で入力";
        } else if (this.isNumericField(key)) {
          return "数値を入力";
        } else {
          return "入力してください";
        }
      },
      formatNumber(value, key) {
        if (!this.isNumericField(key)) return value;
        const num = parseFloat(value);
        return isNaN(num) ? value : num.toLocaleString('ja-JP');
      },
      // --- 生成AIチャット用メソッド ---
      sendAiChat() {
        if (!this.aiChatInput.trim()) return;
        this.aiChatMessages.push({ role: "user", content: this.aiChatInput });
        const messageToSend = this.aiChatInput;
        this.aiChatInput = "";
        axios.post('/api/ai-integration/chat', { message: messageToSend }, { withCredentials: true })
          .then(response => {
            const reply = response.data.ai_response;
            this.aiChatMessages.push({ role: "assistant", content: reply });
          })
          .catch(error => {
            alert("AIチャットエラー: " + (error.response.data.message || error));
          });
      },
      resetChat() {
        axios.post('/api/ai-integration/chat', { message: "", reset: true }, { withCredentials: true })
          .then(() => {
            this.aiChatMessages = [];
          })
          .catch(error => {
            alert("チャットリセットエラー: " + (error.response.data.message || error));
          });
      },
      toggleSidebar() {
        this.isSidebarOpen = !this.isSidebarOpen;
      }
    }
  });
})();
