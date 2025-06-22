// /static/js/exportUtil.js
class ExportUtil {
  exportToExcel(data, fileName = 'dashboard.xlsx') {
    const ws = XLSX.utils.aoa_to_sheet(data);
    const wb = XLSX.utils.book_new();
    XLSX.utils.book_append_sheet(wb, ws, 'Sheet');
    XLSX.writeFile(wb, fileName);
  }
  exportToCSV(data, fileName = 'dashboard.csv') {
    const ws = XLSX.utils.aoa_to_sheet(data);
    const csv = XLSX.utils.sheet_to_csv(ws);
    const blob = new Blob([csv], { type: 'text/csv' });
    const a = document.createElement('a');
    a.href = URL.createObjectURL(blob);
    a.download = fileName;
    a.click();
  }
  exportToPDF(elementId, fileName = 'dashboard.pdf') {
    const el = document.getElementById(elementId);
    const doc = new jsPDF('p', 'pt', 'a4');
    doc.html(el, {
      callback: function (doc) {
        doc.save(fileName);
      },
      x: 10, y: 10
    });
  }
}
export default new ExportUtil();
