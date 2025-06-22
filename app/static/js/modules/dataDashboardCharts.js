// /static/js/dataDashboardCharts.js
import ApexCharts from 'https://cdn.jsdelivr.net/npm/apexcharts/dist/apexcharts.esm.js';

class DataDashboardCharts {
  constructor() {
    this.chartElement = document.getElementById('dashboard-chart');
    this.apexChart = null;
    this.plotlyCurrentData = null;
    this.plotlyCurrentLayout = null;
    this.currentEngine = null;
  }

  updateChart(chartData, chartType, chartEngine='apex') {
    this.destroyCharts();
    if(chartEngine==='apex'){
      this.renderApexChart(chartData, chartType);
      this.currentEngine='apex';
    }else{
      this.renderPlotlyChart(chartData, chartType);
      this.currentEngine='plotly';
    }
  }

  renderApexChart(chartData, chartType){
    // apex
    // e.g. if chartType==='stackedBar', => type='bar', stacked=true
    let realType=chartType;
    let stacked=false;
    if(chartType==='stackedBar'){
      realType='bar';
      stacked=true;
    }
    // apex does not truly have 'histogram' or 'bubble' out-of-box; user must replicate with scatter or bar
    // but we list them for completeness - real usage may differ
    if(chartType==='pie' || chartType==='donut'){
      const categories=chartData.categories||[];
      const seriesData=chartData.series[0]?.data||[];
      const apexOpts={
        chart:{ type:(chartType==='donut'?'donut':'pie'), height:350},
        labels:categories,
        series:seriesData,
        title:{ text:'Apex '+chartType }
      };
      this.apexChart=new ApexCharts(this.chartElement,apexOpts);
      this.apexChart.render();
    }else{
      const categories=chartData.categories||[];
      const series=chartData.series||[];
      const apexOpts={
        chart:{
          type:realType,
          stacked:stacked,
          height:350
        },
        xaxis:{ categories },
        series:series,
        title:{ text:'Apex '+chartType }
      };
      this.apexChart=new ApexCharts(this.chartElement,apexOpts);
      this.apexChart.render();
    }
  }

  renderPlotlyChart(chartData, chartType){
    // plotly 
    let data=[];
    let layout={ title:'Plotly '+chartType, height:350 };
    if(chartType==='pie' || chartType==='donut'){
      const categories=chartData.categories||[];
      const seriesData=chartData.series[0]?.data||[];
      data.push({
        type:'pie',
        labels:categories,
        values:seriesData,
        hole:(chartType==='donut'?0.4:0)
      });
    }else if(chartType==='stackedBar'){
      const cats=chartData.categories||[];
      (chartData.series||[]).forEach(s=>{
        data.push({ x:cats, y:s.data, name:s.name, type:'bar' });
      });
      layout.barmode='stack';
    }else if(chartType==='bar'){
      const cats=chartData.categories||[];
      (chartData.series||[]).forEach(s=>{
        data.push({ x:cats, y:s.data, name:s.name, type:'bar' });
      });
      layout.barmode='group';
    }else if(chartType==='line'){
      const cats=chartData.categories||[];
      (chartData.series||[]).forEach(s=>{
        data.push({ x:cats, y:s.data, mode:'lines', name:s.name, type:'scatter' });
      });
    }else if(chartType==='area'){
      const cats=chartData.categories||[];
      (chartData.series||[]).forEach(s=>{
        data.push({ x:cats, y:s.data, fill:'tozeroy', name:s.name, type:'scatter' });
      });
    }else if(chartType==='scatter' || chartType==='bubble'){
      const cats=chartData.categories||[];
      (chartData.series||[]).forEach(s=>{
        data.push({ x:cats, y:s.data, mode:'markers', name:s.name, type:'scatter' });
      });
      // bubble in plotly => marker.size is needed, omitted here for brevity
    }else if(chartType==='heatmap'){
      const xCat=chartData.categories||[];
      const yCat=(chartData.series||[]).map(ss=>ss.name);
      let z=[];
      (chartData.series||[]).forEach(ss=>{
        z.push(ss.data);
      });
      data.push({ x:xCat, y:yCat, z, type:'heatmap' });
      layout.yaxis={ autorange:'reversed' };
    }else if(chartType==='histogram'){
      // for real histogram, we'd pass raw data, not aggregated
      data.push({ x:[], type:'histogram' });
    }else if(chartType==='box'){
      // etc. 
      data.push({ y:[], type:'box', name:'Box1' });
    }else if(chartType==='funnel'){
      // ...
      data.push({ type:'funnel', x:[], y:[] });
    }else if(chartType==='waterfall'){
      data.push({ type:'waterfall', x:[], y:[] });
    }else if(chartType==='timeline'){
      // ...
      data.push({ type:'scatter', x:[], y:[] });
    }else{
      console.warn("Plotly: unsupported chartType:",chartType);
    }

    this.plotlyCurrentData=data;
    this.plotlyCurrentLayout=layout;
    Plotly.newPlot(this.chartElement, data, layout);
  }

  destroyCharts(){
    if(this.apexChart){
      this.apexChart.destroy();
      this.apexChart=null;
    }
    if(this.plotlyCurrentData){
      Plotly.purge(this.chartElement);
      this.plotlyCurrentData=null;
      this.plotlyCurrentLayout=null;
    }
    this.currentEngine=null;
  }
}

export default new DataDashboardCharts();
