// /static/js/dataDashboardManager.js
class DataDashboardManager {
  constructor() {
    this.apiBaseUrl = '/api/data_mgmt';
  }

  async fetchLedgerTypes() {
    const res = await axios.get('/api/ledger/ledger-types');
    return res.data;
  }

  async fetchLedgerFields(ledgerTag) {
    const res = await axios.get('/api/ledger/fields', {
      params: { ledger_type: ledgerTag }
    });
    return res.data;
  }

  async fetchRawLedgerData(ledgerTag, fieldIds, limit = 50) {
    const params = { ledger_type: ledgerTag, fields: fieldIds.join(','), limit };
    const res = await axios.get(`${this.apiBaseUrl}/data`, { params });
    const ledgerData = res.data.sheetData?.data || [];
    return { ledgerData };
  }

  aggregateRecords(ledgerData, xFieldId, subFieldId, valueFieldId, aggregator) {
    if (!xFieldId || !valueFieldId) {
      return { categories: [], series: [] };
    }
    const aggMap = {};
    ledgerData.forEach(r => {
      const xVal = r[xFieldId] || "N/A";
      const subVal= subFieldId ? (r[subFieldId]||"N/A") : "";
      let num = 0;
      if (aggregator==='count') {
        num=1;
      } else {
        num=parseFloat(r[valueFieldId]||"0")||0;
      }
      if (!aggMap[xVal]) {
        aggMap[xVal]={};
      }
      if (!aggMap[xVal][subVal]) {
        aggMap[xVal][subVal]=[];
      }
      aggMap[xVal][subVal].push(num);
    });
    function applyAgg(arr){
      if(!arr||arr.length===0)return 0;
      if(aggregator==='sum'||aggregator==='count'){
        return arr.reduce((a,b)=>a+b,0);
      }else if(aggregator==='avg'){
        const s=arr.reduce((a,b)=>a+b,0);
        return s/arr.length;
      }
      return 0;
    }
    const xVals=Object.keys(aggMap).sort();
    let subVals=[];
    xVals.forEach(x=> {
      subVals=subVals.concat(Object.keys(aggMap[x]));
    });
    subVals=[...new Set(subVals)];
    if(!subFieldId && subVals.length===1&&subVals[0]===""){
      subVals=[];
    }else{
      subVals.sort();
    }
    if(!subVals.length){
      const categories=xVals;
      const dataArr=xVals.map(x=>applyAgg(aggMap[x][""]));
      const series=[{name:'Data',data:dataArr}];
      return {categories,series};
    }else{
      const categories=xVals;
      const series=subVals.map(sub=>{
        const arr=xVals.map(x=>{
          return applyAgg(aggMap[x][sub]);
        });
        return {name:sub,data:arr};
      });
      return {categories,series};
    }
  }

  updateChart(chartData, chartType, chartEngine) {
    import('./dataDashboardCharts.js')
      .then(mod => {
        mod.default.updateChart(chartData, chartType, chartEngine);
      })
      .catch(err => console.error("chart load error:",err));
  }
}

export default new DataDashboardManager();
