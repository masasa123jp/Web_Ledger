// /static/js/dataDashboardApp.js
import dataDashboardManager from './dataDashboardManager.js';
import exportUtil from './exportUtil.js';

/**
 * ApexCharts で利用できるすべて（主要）チャート
 * 参考: https://apexcharts.com/docs/chart-types/
 */
const APEX_CHART_TYPES = [
  { value: 'line',       labels: { ja: '折れ線(Line)', en: 'Line' } },
  { value: 'area',       labels: { ja: 'エリア(Area)', en: 'Area' } },
  { value: 'bar',        labels: { ja: '棒グラフ(Bar)', en: 'Bar' } },
  { value: 'stackedBar', labels: { ja: '積み上げ棒(Stacked Bar)', en: 'Stacked Bar' } },
  { value: 'histogram',  labels: { ja: 'ヒストグラム(Histogram)', en: 'Histogram' } }, // Apexに標準はなく自力実装
  { value: 'column',     labels: { ja: '縦棒(Column)', en: 'Column' } }, // apexでは bar==column だが名称違い
  { value: 'scatter',    labels: { ja: '散布図(Scatter)', en: 'Scatter' } },
  { value: 'bubble',     labels: { ja: 'バブル(Bubble)', en: 'Bubble' } },
  { value: 'pie',        labels: { ja: '円グラフ(Pie)', en: 'Pie' } },
  { value: 'donut',      labels: { ja: 'ドーナツ(Donut)', en: 'Donut' } },
  { value: 'radar',      labels: { ja: 'レーダー(Radar)', en: 'Radar' } },
  { value: 'heatmap',    labels: { ja: 'ヒートマップ(Heatmap)', en: 'Heatmap' } },
  { value: 'candlestick',labels: { ja: 'ローソク足(Candlestick)', en: 'Candlestick' } },
  { value: 'rangeBar',   labels: { ja: 'レンジバー(Range Bar)', en: 'Range Bar' } },
  { value: 'radialBar',  labels: { ja: 'ラジアルバー(Radial Bar)', en: 'Radial Bar' } },
];

/**
 * Plotly で利用できるすべて(主要)チャート
 * 参考: https://plotly.com/javascript/
 */
const PLOTLY_CHART_TYPES = [
  { value: 'bar',       labels: { ja: '棒グラフ(Bar)', en: 'Bar' } },
  { value: 'stackedBar',labels: { ja: '積み上げ棒(Stacked Bar)', en: 'Stacked Bar' } },
  { value: 'line',      labels: { ja: '折れ線(Line)', en: 'Line' } },
  { value: 'scatter',   labels: { ja: '散布図(Scatter)', en: 'Scatter' } },
  { value: 'bubble',    labels: { ja: 'バブル(Bubble)', en: 'Bubble' } }, // scatter+marker.size
  { value: 'histogram', labels: { ja: 'ヒストグラム(Histogram)', en: 'Histogram' } },
  { value: 'box',       labels: { ja: 'ボックス(Box)', en: 'Box' } },
  { value: 'pie',       labels: { ja: '円グラフ(Pie)', en: 'Pie' } },
  { value: 'donut',     labels: { ja: 'ドーナツ(Donut)', en: 'Donut' } },
  { value: 'heatmap',   labels: { ja: 'ヒートマップ(Heatmap)', en: 'Heatmap' } },
  { value: 'funnel',    labels: { ja: 'ファネル(Funnel)', en: 'Funnel' } },
  { value: 'waterfall', labels: { ja: 'ウォーターフォール(Waterfall)', en: 'Waterfall' } },
  { value: 'area',      labels: { ja: 'エリア(Area)', en: 'Area' } },
  { value: 'timeline',  labels: { ja: 'タイムライン(Timeline)', en: 'Timeline' } },
];

const CHART_TYPE_OPTIONS = {
  apex: APEX_CHART_TYPES,
  plotly: PLOTLY_CHART_TYPES
};

// ラベル集 (UI見出しなど)
const I18N_LABELS = {
  ja: {
    ledgerTitle:       "台帳を選択",
    fieldsTitle:       "参照したい項目を複数選択",
    chartSettings:     "チャート設定",
    libraryLabel:      "チャートライブラリ:",
    chartTypeLabel:    "チャート種類:",
    aggregatorLabel:   "集計方法:",
    xaxisLabel:        "X軸(カテゴリー):",
    subcatLabel:       "サブカテゴリー:",
    valueLabel:        "数値(指標):"
  },
  en: {
    ledgerTitle:       "Select Ledger",
    fieldsTitle:       "Select multiple fields",
    chartSettings:     "Chart Settings",
    libraryLabel:      "Chart Library:",
    chartTypeLabel:    "Chart Type:",
    aggregatorLabel:   "Aggregator:",
    xaxisLabel:        "X Axis:",
    subcatLabel:       "Sub Category:",
    valueLabel:        "Value (Measure):"
  }
};

window.addEventListener('DOMContentLoaded', async () => {
  // UI要素取得
  const ledgerSelectEl       = document.getElementById("ledgerTypeSelect");
  const fieldsSelectEl       = document.getElementById("fieldsSelect");
  const chartEngineSelectEl  = document.getElementById("chartEngineSelect");
  const chartTypeSelectEl    = document.getElementById("chartTypeSelect");

  const aggregatorSelectEl   = document.getElementById("aggregatorSelect");
  const xFieldSelectEl       = document.getElementById("xFieldSelect");
  const subFieldSelectEl     = document.getElementById("subFieldSelect");
  const valueFieldSelectEl   = document.getElementById("valueFieldSelect");

  const form = document.getElementById("data-selection-form");
  const exportExcelBtn = document.getElementById("export-excel");
  const exportCsvBtn   = document.getElementById("export-csv");
  const exportPdfBtn   = document.getElementById("export-pdf");

  // 1) 言語ラベルの初期設定
  populateI18nLabels();

  // 2) 台帳一覧を取得
  const ledgers = await dataDashboardManager.fetchLedgerTypes();
  ledgers.forEach(ledger => {
    const opt = new Option(ledger.master_name, ledger.ledger_tag);
    ledgerSelectEl.add(opt);
  });

  // 3) ライブラリ選択 => チャートタイプ候補を切り替え
  chartEngineSelectEl.addEventListener("change", () => {
    populateChartTypeSelect(chartEngineSelectEl.value);
  });
  // 初期は apex と仮定
  chartEngineSelectEl.innerHTML = `
    <option value="apex">ApexCharts</option>
    <option value="plotly">Plotly</option>
  `;
  chartEngineSelectEl.value = 'apex';
  populateChartTypeSelect('apex');

  // 4) 台帳変更 => フィールド一覧取得
  ledgerSelectEl.addEventListener("change", async () => {
    fieldsSelectEl.innerHTML     = "";
    xFieldSelectEl.innerHTML     = "";
    subFieldSelectEl.innerHTML   = "<option value=\"\">(なし)</option>";
    valueFieldSelectEl.innerHTML = "";

    if (!ledgerSelectEl.value) return;

    const fields = await dataDashboardManager.fetchLedgerFields(ledgerSelectEl.value);
    fields.forEach(f => {
      fieldsSelectEl.add(new Option(f.field_name, f.id));
      xFieldSelectEl.add(new Option(f.field_name, f.id));
      subFieldSelectEl.add(new Option(f.field_name, f.id));
      valueFieldSelectEl.add(new Option(f.field_name, f.id));
    });
  });

  // 5) 適用ボタン => データ取得 + 集計 + 描画
  form.addEventListener("submit", async (e) => {
    e.preventDefault();
    const ledgerType = ledgerSelectEl.value;
    const selectedFieldIds = Array.from(fieldsSelectEl.selectedOptions).map(opt => opt.value);
    if (!ledgerType || selectedFieldIds.length === 0) {
      alert("台帳と項目を選択してください。");
      return;
    }
    const chartEngine = chartEngineSelectEl.value;
    const chartType   = chartTypeSelectEl.value;
    const aggregator  = aggregatorSelectEl.value;
    const xFieldId    = xFieldSelectEl.value;
    const subFieldId  = subFieldSelectEl.value;
    const valueFieldId= valueFieldSelectEl.value;

    const { ledgerData } = await dataDashboardManager.fetchRawLedgerData(ledgerType, selectedFieldIds);
    const chartData = dataDashboardManager.aggregateRecords(ledgerData, xFieldId, subFieldId, valueFieldId, aggregator);
    dataDashboardManager.updateChart(chartData, chartType, chartEngine);
  });

  // エクスポート
  exportExcelBtn.onclick = () => { alert("Excel出力は未対応"); };
  exportCsvBtn.onclick   = () => { alert("CSV出力は未対応"); };
  exportPdfBtn.onclick   = () => { exportUtil.exportToPDF("dashboard-main"); };


  /**
   * ライブラリに応じて、チャートタイプのoptionを再構築
   */
  function populateChartTypeSelect(engineValue) {
    chartTypeSelectEl.innerHTML = "";
    const arr = CHART_TYPE_OPTIONS[engineValue] || [];
    arr.forEach(optInfo => {
      const label = (window.currentLang === 'ja')
        ? optInfo.labels.ja
        : optInfo.labels.en;
      chartTypeSelectEl.add(new Option(label, optInfo.value));
    });
  }

});

/**
 * 多言語ラベルを更新
 * window.currentLang = 'ja' or 'en' を参照
 */
export function populateI18nLabels() {
  const lang = window.currentLang || 'ja';
  const L = I18N_LABELS[lang];

  document.getElementById("title-ledger").textContent       = L.ledgerTitle;
  document.getElementById("title-fields").textContent       = L.fieldsTitle;
  document.getElementById("title-chart-settings").textContent = L.chartSettings;

  document.getElementById("label-engine").textContent       = L.libraryLabel;
  document.getElementById("label-chart-type").textContent   = L.chartTypeLabel;
  document.getElementById("label-aggregator").textContent   = L.aggregatorLabel;
  document.getElementById("label-xaxis").textContent        = L.xaxisLabel;
  document.getElementById("label-subcat").textContent       = L.subcatLabel;
  document.getElementById("label-value").textContent        = L.valueLabel;
}

window.currentLang = 'ja'; // デフォルト日本語とする
    
function switchLang() {
  window.currentLang = (window.currentLang === 'ja') ? 'en' : 'ja';
  // UI要素のラベル再描画
  if (typeof populateI18nLabels === 'function') {
    populateI18nLabels();
  }
}

new Vue({
  el: '#app',
  data: {
    headerTexts: window.headerTextsJa
  },
  methods: {
    // --- 多言語切り替え ---
    toggleLanguage() {
      this.language = (this.language === 'ja') ? 'en' : 'ja';
      // headerTexts も切り替え（texts.js に定義された内容と併用する場合は適宜マージしてください）
      if (this.language === 'ja') {
        this.headerTexts = Object.assign({}, window.headerTextsJa);
      } else {
        this.headerTexts = Object.assign({}, window.headerTextsEn);
      }
      document.documentElement.lang = this.language;
    },
    handleLogoutSuccess() {
      console.log("ログアウト成功");
    }
  },
  mounted() {
    console.log("Vueインスタンスがマウントされました");
  }
});