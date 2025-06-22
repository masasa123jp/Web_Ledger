/**
 * pivot.js
 *
 * 参考: Qiita「Pivotテーブルを作る（Javascript版）」
 * https://qiita.com/nicco_mirai/items/49396b3ef573d00709bd
 *
 * ※ React (例: react-0.12.2.min.js) が orb.min.js より先に読み込まれている前提。
 */

// orb が利用可能になるまで待機する関数
function waitForOrb(callback) {
  if (window.orb && window.React) {
    console.log("orb および React が利用可能です。");
    window.orbLib = window.orb;
    callback(window.orb);
  } else {
    console.warn("orb または React が未定義のため待機中...");
    setTimeout(() => waitForOrb(callback), 50);
  }
}

// 台帳ごとのピボット設定保存用オブジェクト
const pivotConfigs = {};
let currentLedgerType = "";

/**
 * エラー表示用関数
 */
function showError(context, error) {
  console.error(`${context}エラー詳細:`, error);
  const message =
    (error?.response?.data?.message) ||
    error?.message ||
    '不明なエラー';
  alert(`${context}エラー: ${message}`);
}

/**
 * 台帳一覧データをパースして { id, name } を返す
 */
function parseLedgerItem(item) {
  let id = "", name = "";
  if (typeof item === "string") {
    const parts = item.split(':');
    if (parts.length >= 2) {
      id = parts[0];
      name = parts.slice(1).join(':');
    }
  } else if (item && typeof item === "object") {
    if (item.ledger_tag && item.master_name) {
      id = item.ledger_tag;
      name = item.master_name;
    } else if (item.ledgerTypeId && item.title) {
      id = item.ledgerTypeId;
      name = item.title;
    } else if (item.id && item.ledger_name) {
      id = item.id;
      name = item.ledger_name;
    }
  }
  console.log("parseLedgerItem:", { id, name });
  return { id, name };
}

/**
 * 台帳一覧を取得し、プルダウンに反映する
 */
function loadLedgerTypes() {
  console.log("loadLedgerTypes() を呼び出し");
  axios.get('/api/ledger/ledger-types', { withCredentials: true })
    .then(resp => {
      console.log("台帳一覧レスポンス:", resp.data);
      const ledgerSelectEl = document.getElementById("ledgerSelect");
      ledgerSelectEl.innerHTML = '<option value="">台帳を選択してください</option>';
      resp.data.forEach(item => {
        const { id, name } = parseLedgerItem(item);
        if (id && name) {
          const opt = document.createElement("option");
          opt.value = id;
          opt.textContent = name;
          ledgerSelectEl.appendChild(opt);
        }
      });
      console.log("台帳一覧反映完了");
    })
    .catch(err => {
      console.error("台帳一覧取得エラー:", err);
      showError("台帳一覧取得", err);
    });
}

/**
 * 取得した台帳レコードを orb 用に変換する
 * 数値データは、純粋な数値なら parseFloat() で変換する
 */
function transformLedgerRecords(recordsArray) {
  if (!recordsArray || recordsArray.length === 0) {
    console.warn("transformLedgerRecords: レコードが空です。");
    return { columns: [], records: [] };
  }
  const firstRec = recordsArray[0];
  let columns = [];
  if (firstRec.field_orders && Object.keys(firstRec.field_orders).length > 0) {
    columns = Object.keys(firstRec.field_orders)
                .sort((a, b) => firstRec.field_orders[a] - firstRec.field_orders[b]);
  } else {
    columns = Object.keys(firstRec.fields || {});
  }
  // "操作" 列は除外
  columns = columns.filter(c => c !== "操作");
  const transformed = recordsArray.map(r => {
    const row = { "ID": r.data_id };
    columns.forEach(col => {
      let v = (r.fields && r.fields[col]) ? r.fields[col] : "";
      // 数値のみの場合は数値変換（整数または小数）
      if (typeof v === "string" && v.trim() !== "" && /^\d+(\.\d+)?$/.test(v.trim())) {
        row[col] = parseFloat(v);
      } else {
        row[col] = v;
      }
    });
    return row;
  });
  console.log("transformLedgerRecords: columns =", columns);
  console.log("transformLedgerRecords: transformed records =", transformed);
  return { columns, records: transformed };
}

/**
 * onRefresh ハンドラ：orb の設定変更時に呼ばれ、設定を保存する
 */
function onRefreshHandler(config) {
  try {
    const configStr = JSON.stringify(config, (k, v) => {
      if (typeof v === "function") return undefined;
      return v;
    });
    pivotConfigs[currentLedgerType] = JSON.parse(configStr);
    console.log("onRefreshHandler: 保存設定 =>", pivotConfigs[currentLedgerType]);
  } catch (ex) {
    console.error("onRefreshHandler エラー:", ex);
  }
}

/**
 * pivot-data API から台帳レコードを取得する
 */
function fetchPivotData(ledgerId, callback) {
  if (!ledgerId) {
    callback({ columns: [], records: [] });
    return;
  }
  axios.get('/api/ledger/pivot-data', {
    params: { type: ledgerId },
    withCredentials: true
  })
  .then(resp => {
    let rawRecords = [];
    if (resp.data && resp.data.fields) {
      rawRecords = resp.data.fields;
    } else if (Array.isArray(resp.data)) {
      rawRecords = resp.data;
    }
    console.log("fetchPivotData: rawRecords件数 =", rawRecords.length);
    const transformed = transformLedgerRecords(rawRecords);
    console.log("fetchPivotData: transform後件数 =", transformed.records.length);
    callback(transformed);
  })
  .catch(err => {
    console.error("fetchPivotData エラー:", err);
    showError("データ取得", err);
    callback({ columns: [], records: [] });
  });
}

/**
 * orb を利用してピボットグリッドを描画する
 */
function initPivotTable(records) {
  const output = document.getElementById("output");
  
  // 既存の React コンポーネントがあればアンマウントする
  if (window.React && output) {
    try {
      window.React.unmountComponentAtNode(output);
    } catch(e) {
      console.warn("React.unmountComponentAtNode エラー:", e);
    }
  }
  output.innerHTML = '';
  $(output).removeData("orbPivotOptions");
  console.log("initPivotTable: records件数 =", records.length);

  // transformLedgerRecords() で取得したカラム名を newColumns として算出
  let newColumns = [];
  if (records.length > 0) {
    newColumns = Object.keys(records[0]).filter(c => c !== "ID");
  }
  console.log("initPivotTable: newColumns =", newColumns);

  // orb に渡す config を設定
  const config = {
    dataSource: records,
    canMoveFields: true,
    dataHeadersLocation: 'columns',
    width: 1906,
    height: 900,
    theme: 'green',
    toolbar: { visible: true },
    grandTotal: { rowsvisible: true, columnsvisible: false },
    subTotal: { visible: true, collapsed: true, collapsible: true },
    rowSettings: { subTotal: { visible: true, collapsed: true, collapsible: true } },
    columnSettings: { subTotal: { visible: true, collapsed: true, collapsible: true } },
    fields: [],
    rows: [],
    columns: [],
    data: [],
    onRefresh: onRefreshHandler
  };

  // 自動的に fields にカラム名をセット
  if (newColumns.length > 0) {
    config.fields = newColumns.map(colName => ({ name: colName, caption: colName }));
  }
  console.log("config.fields:", config.fields);

  // 台帳切り替え時は、古い保存設定をクリアする
  delete pivotConfigs[currentLedgerType];

  // orb の pgridwidget (または pgrid / PGridWidget) を利用して描画
  const PGridConstructor = window.orbLib.pgridwidget || window.orbLib.pgrid || window.orbLib.PGridWidget;
  if (!PGridConstructor) {
    console.error("orbLib の pgridwidget/pgrid/PGridWidget が未定義です。依存ライブラリの読み込み順序を確認してください。");
    return;
  }
  console.log("PGridConstructor:", PGridConstructor);

  try {
    const gridInstance = new PGridConstructor(config);
    gridInstance.render(output);
    console.log("gridInstance:", gridInstance);
  } catch (e) {
    console.error("グリッド描画エラー:", e);
  }
}

/**
 * 台帳選択時に、データ取得後ピボットグリッドを再描画する
 */
function refreshPivotTable() {
  waitForOrb(() => {
    if (!currentLedgerType) {
      document.getElementById("output").innerHTML = '';
      return;
    }
    console.log("refreshPivotTable: currentLedgerType =", currentLedgerType);
    fetchPivotData(currentLedgerType, (data) => {
      initPivotTable(data.records);
    });
  });
}

/**
 * メインエントリポイント
 */
document.addEventListener('DOMContentLoaded', () => {
  console.log("pivot.js DOMContentLoaded: 開始");

  // 初期ロード時に台帳一覧を取得
  loadLedgerTypes();

  // イベントリスナー登録
  const ledgerSelectEl = document.getElementById("ledgerSelect");
  const displayModeEl = document.getElementById("displayMode");
  const labelRepeatEl = document.getElementById("labelRepeat");
  const saveSettingsBtn = document.getElementById("saveSettings");

  ledgerSelectEl.addEventListener('change', (ev) => {
    currentLedgerType = ev.target.value;
    console.log("ledgerSelect change =>", currentLedgerType);
    refreshPivotTable();
  });

  displayModeEl.addEventListener('change', () => {
    localStorage.setItem('pivot_displayMode', displayModeEl.value);
    refreshPivotTable();
  });
  labelRepeatEl.addEventListener('change', () => {
    localStorage.setItem('pivot_labelRepeat', labelRepeatEl.value);
    refreshPivotTable();
  });
  saveSettingsBtn.addEventListener('click', () => {
    localStorage.setItem('pivot_displayMode', displayModeEl.value);
    localStorage.setItem('pivot_labelRepeat', labelRepeatEl.value);
    alert("設定を保存しました。");
    refreshPivotTable();
  });

  console.log("pivot.js DOMContentLoaded: 終了");
});
