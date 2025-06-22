// /frontend/manual/manual.js
(function(){
  new Vue({
    el: '#manualApp',
    data: {
      // ヘッダー用の文言（初期は日本語版）
      headerTexts: window.headerTextsJa,
      currentLang: 'ja'
    },
    methods: {
      // 現在のウィンドウを閉じる
      closeWindow() {
        window.close();
      },
      // ユーザー管理ページを別ウィンドウで開く
      openUserManagement() {
        window.open('/frontend/user_management/user_management.html', 'UserManagement', 'width=900,height=600');
      },
      // マニュアルページを別ウィンドウで開く
      openManual() {
        window.open('/frontend/manual/manual.html', 'Manual', 'width=900,height=600');
      },
      // バージョン情報ページを別ウィンドウで開く
      openVersionHistory() {
        window.open('/frontend/version_info/version_info.html', 'VersionHistory', 'width=900,height=600');
      },
      // 言語切替処理：ヘッダー用テキストを更新
      toggleLanguage() {
        if (this.currentLang === 'ja') {
          this.currentLang = 'en';
          this.headerTexts = window.headerTextsEn;
        } else {
          this.currentLang = 'ja';
          this.headerTexts = window.headerTextsJa;
        }
      },
      // ヘッダーからのログアウト成功イベント用ハンドラ
      handleLogoutSuccess() {
        console.log("Logout successful (manual page).");
        // 必要に応じた後処理をここに記述してください
      }
    }
  });
})();
