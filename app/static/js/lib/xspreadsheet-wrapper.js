// xspreadsheet-wrapper.js
import '/static/js/xspreadsheet.js';  // side-effect によって window.x に設定される
const spreadsheet = window.x && window.x.spreadsheet;
if (typeof spreadsheet !== 'function') {
  throw new Error("xspreadsheet の spreadsheet 関数が見つかりません。");
}
export { spreadsheet };