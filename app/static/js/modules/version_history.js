new Vue({
    el: '#versionHistoryApp',
    delimiters: window.DELIMITERS || ['[[', ']]'],
    data: function() {
      // 現在の言語（window.currentLang がなければ 'ja' をデフォルト）
      var lang = window.currentLang || 'ja';
      
      // texts.js に定義されている versionHistoryTexts を利用
      var versionTexts = (lang === 'en') ? (window.versionHistoryTextsEn || {}) : (window.versionHistoryTextsJa || {});
      
      // ヘッダー用テキストも texts.js の headerTextsEn/Ja から取得
      var headerTexts = (lang === 'en') ? (window.headerTextsEn || {}) : (window.headerTextsJa || {});
      
      return {
        language: lang,
        versionHistoryTexts: versionTexts,
        headerTexts: headerTexts,
        // バージョン履歴リスト（初期は空配列。API 等から取得する前提）
        versionList: []
      };
    },
    created: function() {
      this.fetchVersionHistory();
    },
    methods: {
      fetchVersionHistory: function() {
        // ※ 実際の API エンドポイントに合わせて変更してください
        axios.get('/api/version_history', { withCredentials: true })
          .then(response => {
            this.versionList = response.data;
          })
          .catch(error => {
            console.error("バージョン履歴の取得に失敗しました:", error);
            alert("バージョン履歴の取得に失敗しました。");
          });
      },
      formatUpdateInfo: function(updateInfo) {
        if (typeof updateInfo === 'string') {
          return updateInfo.replace(/\r\n/g, '<br>').replace(/\n/g, '<br>');
        }
        return updateInfo;
      },
      closeWindow: function() {
        window.close();
      },
      toggleLanguage: function() {
        // 言語切替ロジック
        this.language = (this.language === 'ja') ? 'en' : 'ja';
        var newVersionTexts = (this.language === 'en') ? (window.versionHistoryTextsEn || {}) : (window.versionHistoryTextsJa || {});
        this.$set(this, 'versionHistoryTexts', newVersionTexts);
        var newHeaderTexts = (this.language === 'en') ? (window.headerTextsEn || {}) : (window.headerTextsJa || {});
        this.$set(this, 'headerTexts', newHeaderTexts);
        document.documentElement.lang = this.language;
      },
      handleLogout: function() {
        // ログアウト成功時の処理（例：トップページへ遷移）
        window.location.href = '/';
      }
    }
  });
  