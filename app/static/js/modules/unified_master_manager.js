// unified_master_manager.js

// 統合マスター管理用メッセージ定義（ヘッダー関連は除く）
const unifiedMessages = {
  ja: {
    add_new_master: "新規マスター追加",
    nonledger_master_label: "基本マスター",
    ledger_master_label: "台帳マスター",
    select_existing_ledger: "既存マスタータイプを選択",
    select_ledger_prompt: "マスタータイプを選択してください",
    existing_ledger_masters: "登録済マスタ一覧",
    ledger_name: "台帳名称",
    ledger_name_placeholder: "台帳名称を入力",
    column_settings: "設定項目",
    column_name: "項目名",
    column_name_placeholder: "項目名を入力",
    data_type: "データ型",
    text: "テキスト",
    number: "数値",
    real: "実数",
    date: "日付",
    code: "コード値",
    code_name: "コード名称",
    code_version: "バージョン",
    code_description: "説明",
    registered_master: "登録済マスター: ",
    max_length: "最大文字数",
    max_length_placeholder: "最大文字数を入力",
    display_order: "表示順序",
    display_order_placeholder: "表示順序を入力",
    actions: "操作",
    update: "更新",
    delete: "削除",
    add_column: "列追加",
    add_new_record: "レコード追加",
    save: "保存",
    close: "閉じる",
    confirm_delete: "このマスターを削除してよろしいですか？",
    ledger_master_added: "マスターが追加されました。",
    ledger_master_deleted: "マスターが削除されました。",
    ledger_master_update_success: "マスターが更新されました。",
    fetch_ledger_master_failed: "マスターの取得に失敗しました。",
    ledger_master_add_failed: "マスターの追加に失敗しました。",
    save_failed: "保存に失敗しました。",
    delete_failed: "削除に失敗しました。",
    create_master_prompt: "台帳マスター/各種マスターを作成",
    select_ledger_record: "台帳レコードを選択",
    select_ledger_record_prompt: "台帳レコードを選択してください",
    new_ledger_record: "【新規台帳追加】",
    unnamed: "Unnamed",
    no_records: "レコードがありません。",
    record_headers: "レコード一覧"
  },
  en: {
    add_new_master: "Add New Unified Master",
    nonledger_master_label: "Basic Master",
    ledger_master_label: "Ledger Master",
    select_existing_ledger: "Select Registered Master Type",
    select_ledger_prompt: "Please select a master type",
    existing_ledger_masters: "Registered Masters",
    ledger_name: "Ledger Name",
    ledger_name_placeholder: "Enter Ledger Name",
    column_settings: "Column Settings",
    column_name: "Column Name",
    column_name_placeholder: "Enter Column Name",
    data_type: "Data Type",
    text: "Text",
    number: "Number",
    real: "Real",
    date: "Date",
    code: "Code",
    code_name: "Name",
    code_version: "Version",
    code_description: "Description",
    registered_master: "Registered Master: ",
    max_length: "Max Length",
    max_length_placeholder: "Enter Max Length",
    display_order: "Display Order",
    display_order_placeholder: "Enter Display Order",
    actions: "Actions",
    update: "Update",
    delete: "Delete",
    add_column: "Add Column",
    add_new_record: "Add New Record",
    save: "Save",
    close: "Close",
    confirm_delete: "Are you sure you want to delete this master?",
    ledger_master_added: "Master has been added.",
    ledger_master_deleted: "Master has been deleted.",
    ledger_master_update_success: "Master has been updated.",
    fetch_ledger_master_failed: "Failed to fetch masters.",
    ledger_master_add_failed: "Failed to add master.",
    save_failed: "Failed to save.",
    delete_failed: "Failed to delete.",
    create_master_prompt: "Create Ledger/Various Master",
    select_ledger_record: "Select Ledger Record",
    select_ledger_record_prompt: "Please select a ledger record",
    new_ledger_record: "【Add New Ledger】",
    unnamed: "Unnamed",
    no_records: "No records available.",
    record_headers: "Record List"
  }
};

// Vue インスタンス生成
new Vue({
  el: '#unifiedMasterApp',
  delimiters: window.DELIMITERS || ['[[', ']]'],
  data: {
    // 言語：window.currentLang がなければ 'ja' を既定値
    language: window.currentLang || 'ja',
    // texts は、unifiedMessages の該当言語を利用
    texts: unifiedMessages[window.currentLang || 'ja'],
    masters: [],
    selectedLedgerId: "",
    selectedMaster: null,
    newMaster: {
      master_type: "",  // 例: 'ledger' or 'nonledger'
      ledger_name: ""
    },
    newMasterColumns: [],
    ledgerRecords: [],
    selectedLedgerRecordId: "",
    newLedgerName: "",
    selectedLedgerColumns: [],
    existingRecords: [],
    headerTexts: (window.currentLang === 'en') ? (window.headerTextsEn || {}) : (window.headerTextsJa || {}),
  },
  computed: {
    recordHeaders() {
      // 必要に応じ texts から参照も可能。今回は固定文字列で
      return ["Code", "Name", "Version", "Description"];
    }
  },
  created() {
    this.loadMasters();
    document.documentElement.lang = this.language;
  },
  methods: {
    loadMasters() {
      axios.get('/api/master/masters', { withCredentials: true })
        .then(response => {
          this.masters = response.data;
          console.log("Masters loaded:", this.masters);
        })
        .catch(error => {
          alert(this.texts.fetch_ledger_master_failed || "Failed to fetch masters.");
          console.error(error);
        });
    },
    addMaster() {
      if (!this.newMaster.master_type) {
        alert(this.texts.select_existing_ledger || "Please select a master type.");
        return;
      }
      if (!this.newMaster.ledger_name) {
        alert(this.texts.ledger_name_placeholder || "Please enter a ledger name.");
        return;
      }
      axios.post('/api/master/masters', {
        master_type: this.newMaster.master_type,
        ledger_name: this.newMaster.ledger_name,
        fields: this.newMasterColumns
      }, { withCredentials: true })
      .then(response => {
        alert(this.texts.ledger_master_added || response.data.message);
        this.newMaster.master_type = "";
        this.newMaster.ledger_name = "";
        this.newMasterColumns = [];
        this.loadMasters();
      })
      .catch(error => {
        alert(this.texts.ledger_master_add_failed || "Failed to add master.");
        console.error(error);
      });
    },
    onMasterTypeChange() {
      this.newMasterColumns = [];
      this.newMaster.ledger_name = "";
    },
    handleLedgerSelection() {
      if (!this.selectedLedgerId) {
        this.selectedMaster = null;
        this.ledgerRecords = [];
        this.existingRecords = [];
        return;
      }
      const master = this.masters.find(item => String(item.master_id) === String(this.selectedLedgerId));
      if (!master) {
        this.selectedMaster = null;
        this.ledgerRecords = [];
        this.existingRecords = [];
        return;
      }
      this.selectedMaster = master;
      if (master.master_type.trim().toLowerCase() === "ledger") {
        this.loadLedgerRecords(master.master_id);
        this.existingRecords = [];
        if (master.fields && master.fields.length > 0) {
          this.selectedLedgerColumns = JSON.parse(JSON.stringify(master.fields));
        } else {
          axios.get('/api/master/fields', {
            params: { master_id: master.master_id },
            withCredentials: true
          })
          .then(response => {
            this.selectedLedgerColumns = response.data;
            console.log("Field definitions loaded for Ledger master", master.master_id, response.data);
          })
          .catch(error => {
            alert(this.texts.fetch_field_failed || "Failed to load field definitions.");
            console.error(error);
          });
        }
      } else {
        this.selectedLedgerColumns = [];
        this.loadRecords(master.master_id);
      }
    },
    loadRecords(master_id) {
      axios.get('/api/master/records', {
        params: { master_id: master_id },
        withCredentials: true
      })
      .then(response => {
        this.existingRecords = response.data;
        console.log("NonLedger records loaded:", this.existingRecords);
      })
      .catch(error => {
        alert(this.texts.fetch_records_failed || "Failed to load records.");
        console.error(error);
      });
    },
    loadLedgerRecords(masterId) {
      axios.get('/api/master/records', {
        params: { master_id: masterId },
        withCredentials: true
      })
      .then(response => {
        this.ledgerRecords = response.data;
        console.log("Ledger records loaded:", this.ledgerRecords);
      })
      .catch(error => {
        alert(this.texts.fetch_ledger_records_failed || "Failed to load ledger records.");
        console.error(error);
      });
    },
    handleLedgerRecordSelection() {
      if (this.selectedLedgerRecordId === "new") {
        this.selectedLedgerColumns = [];
        return;
      }
      axios.get('/api/master/column-structure', {
        params: { ledger_id: this.selectedLedgerRecordId },
        withCredentials: true
      })
      .then(response => {
        this.selectedLedgerColumns = response.data;
      })
      .catch(error => {
        console.error(error);
      });
    },
    getColumnStructure(ledger_code) {
      axios.get('/api/master/column-structure', {
        params: { ledger_id: ledger_code },
        withCredentials: true
      })
      .then(response => {
        this.selectedLedgerColumns = response.data;
        console.log("Column structure loaded for ledger code=", ledger_code, response.data);
      })
      .catch(error => {
        alert(this.texts.fetch_columns_failed || "Failed to load column structure.");
        console.error(error);
      });
    },
    addNewLedgerRecord() {
      if (!this.newLedgerName) {
        alert(this.texts.ledger_name_placeholder || "Please enter a ledger name.");
        return;
      }
      axios.post('/api/master/ledger/ledger-master', {
        master_id: this.selectedMaster.master_id,
        record_data: { name: this.newLedgerName }
      }, { withCredentials: true })
      .then(response => {
        alert(this.texts.new_record_added || "New ledger added.");
        this.newLedgerName = "";
        this.loadLedgerRecords(this.selectedMaster.master_id);
      })
      .catch(error => {
        alert(this.texts.add_record_failed || "Failed to add new ledger.");
        console.error(error);
      });
    },
    addColumn() {
      this.newMasterColumns.push({
        code: "",
        name: "",
        version: "",
        description: "",
        display_order: this.newMasterColumns.length + 1
      });
    },
    removeNewMasterRecord(index) {
      this.newMasterColumns.splice(index, 1);
    },
    removeColumn(index) {
      this.newMasterColumns.splice(index, 1);
    },
    addColumnToSelected() {
      this.selectedLedgerColumns.push({
        field_name: "",
        data_type: "text",
        max_length: null,
        display_order: this.selectedLedgerColumns.length + 1,
        is_required: true,
        input_constraints: ""
      });
    },
    deleteColumn(index) {
      this.selectedLedgerColumns.splice(index, 1);
    },
    updateField(column) {
      if (!column.id) {
        alert(this.texts.save_first || "This field is not saved yet. Please add it first.");
        return;
      }
      axios.put('/api/master/fields/' + column.id, {
        field_name: column.field_name,
        data_type: column.data_type,
        max_length: column.max_length,
        display_order: column.display_order,
        is_required: column.is_required || true,
        input_constraints: column.input_constraints || ""
      }, { withCredentials: true })
      .then(response => {
        alert(this.texts.field_update_success || "Field updated.");
      })
      .catch(error => {
        alert(this.texts.field_update_failed || "Failed to update field.");
        console.error(error);
      });
    },
    deleteField(fieldId, index) {
      axios.delete('/api/master/fields/' + fieldId, { withCredentials: true })
      .then(response => {
        alert(this.texts.field_delete_success || "Field deleted.");
        this.selectedLedgerColumns.splice(index, 1);
      })
      .catch(error => {
        alert(this.texts.field_delete_failed || "Failed to delete field.");
        console.error(error);
      });
    },
    saveNewField(index) {
      const field = this.selectedLedgerColumns[index];
      if (!this.selectedMaster || !this.selectedMaster.master_id) {
        alert(this.texts.select_existing_ledger || "No master selected.");
        return;
      }
      axios.post('/api/master/fields', {
        master_id: this.selectedMaster.master_id,
        field_name: field.field_name,
        data_type: field.data_type,
        max_length: field.max_length,
        display_order: field.display_order,
        is_required: field.is_required || true,
        input_constraints: field.input_constraints || ""
      }, { withCredentials: true })
      .then(response => {
        this.$set(this.selectedLedgerColumns[index], 'id', response.data.field_id);
        alert(this.texts.field_add_success || "Field added.");
      })
      .catch(error => {
        alert(this.texts.field_add_failed || "Failed to add field.");
        console.error(error);
      });
    },
    saveColumns() {
      if (!this.selectedMaster) {
        alert(this.texts.select_existing_ledger || "Please select a master.");
        return;
      }
      axios.put('/api/master/masters/' + this.selectedMaster.master_id, {
        master_type: this.selectedMaster.master_type,
        fields: this.selectedLedgerColumns
      }, { withCredentials: true })
      .then(response => {
        alert(this.texts.ledger_master_update_success || response.data.message);
        this.loadMasters();
      })
      .catch(error => {
        alert(this.texts.save_failed || "Failed to save.");
        console.error(error);
      });
    },
    addNewRecord() {
      this.existingRecords.push({
        id: null,
        record_data: {
          code: "",
          name: "",
          version: "",
          description: ""
        }
      });
    },
    saveNonLedgerRecords() {
      let promises = this.existingRecords.map(record => {
        if (record.id) {
          return axios.put(`/api/master/records/${record.id}`, record, { withCredentials: true });
        } else {
          return axios.post(`/api/master/records`, {
            master_id: this.selectedMaster.master_id,
            record_data: record.record_data
          }, { withCredentials: true });
        }
      });
      Promise.all(promises)
        .then(results => {
          alert(this.texts.records_save_success || "All records saved.");
          this.loadRecords(this.selectedMaster.master_id);
        })
        .catch(err => {
          alert(this.texts.records_save_failed || "Failed to save records.");
          console.error(err);
        });
    },
    addExistingNonLedgerRecord() {
      this.existingRecords.push({
        id: null,
        record_data: {
          code: "",
          name: "",
          version: "",
          description: ""
        }
      });
    },
    saveNewExistingRecord(idx) {
      const rec = this.existingRecords[idx];
      if (!rec) return;
      axios.post('/api/master/records', {
        master_id: this.selectedMaster.master_id,
        record_data: rec.record_data
      }, { withCredentials: true })
      .then(response => {
        const newId = response.data.record_id;
        if (newId) {
          rec.id = newId;
        }
        alert(this.texts.record_add_success || "New record saved.");
      })
      .catch(error => {
        alert(this.texts.record_add_failed || "Failed to save new record.");
        console.error(error);
      });
    },
    updateExistingRecord(idx) {
      const rec = this.existingRecords[idx];
      if (!rec || !rec.id) {
        alert(this.texts.invalid_record || "Invalid record for update.");
        return;
      }
      axios.put(`/api/master/records/${rec.id}`, rec, { withCredentials: true })
        .then(response => {
          alert(this.texts.record_update_success || "Record updated.");
        })
        .catch(error => {
          alert(this.texts.record_update_failed || "Failed to update record.");
          console.error(error);
        });
    },
    deleteRecord(index) {
      const rec = this.existingRecords[index];
      if (!rec) return;
      if (rec.id) {
        if (!confirm(this.texts.confirm_delete || "Are you sure you want to delete this record?")) return;
        axios.delete(`/api/master/records/${rec.id}`, { withCredentials: true })
          .then(response => {
            alert(this.texts.record_delete_success || "Record deleted.");
            this.existingRecords.splice(index, 1);
          })
          .catch(error => {
            alert(this.texts.record_delete_failed || "Failed to delete record.");
            console.error(error);
          });
      } else {
        this.existingRecords.splice(index, 1);
      }
    },
    deleteMaster(masterId) {
      if (confirm(this.texts.confirm_delete || "Are you sure you want to delete this master?")) {
        axios.delete('/api/master/masters/' + masterId, { withCredentials: true })
        .then(response => {
          alert(this.texts.ledger_master_deleted || response.data.message);
          this.loadMasters();
          if (this.selectedMaster && String(this.selectedMaster.master_id) === String(masterId)) {
            this.selectedMaster = null;
            this.selectedLedgerColumns = [];
            this.selectedLedgerId = "";
            this.existingRecords = [];
          }
        })
        .catch(error => {
          alert(this.texts.delete_failed || "Failed to delete master.");
          console.error(error);
        });
      }
    },
    updateMaster(record) {
      axios.put('/api/master/masters/' + record.master_id, {
        master_type: record.master_type,
        fields: record.fields
      }, { withCredentials: true })
      .then(response => {
        alert(this.texts.ledger_master_update_success || response.data.message);
        this.loadMasters();
      })
      .catch(error => {
        alert(this.texts.save_failed || "Failed to update master.");
        console.error(error);
      });
    },
    toggleLanguage() {
      this.language = this.language === 'ja' ? 'en' : 'ja';
      this.texts = (unifiedMessages && unifiedMessages[this.language]) ? unifiedMessages[this.language] : {};
      document.documentElement.lang = this.language;
    },
    handleLogout() {
      window.location.href = '/';
    },
    closeWindow() {
      window.close();
    },
    groupFieldsByTag(fields) {
      if (!fields || !Array.isArray(fields)) {
        return {};
      }
      const groups = {};
      fields.forEach(field => {
        const tag = field.tag || 'default';
        if (!groups[tag]) {
          groups[tag] = [];
        }
        groups[tag].push(field);
      });
      return groups;
    },
    getLedgerNameByTag(master, tag) {
      if (master.unified_master_records && master.unified_master_records.length > 0) {
        const record = master.unified_master_records.find(rec => rec.record_data.code === tag);
        if (record && record.record_data.name) {
          return record.record_data.name;
        }
      }
      return tag;
    },
    getDisplayValue(rec) {
      if (rec && rec.record_data) {
        const { code, name } = rec.record_data;
        if (typeof name === "string" && name.trim()) {
          return name.trim();
        }
      }
      return this.texts.unnamed || "Unnamed";
    }
  }
});
