// app/static/js/app.js
// global.js, texts.js, header.js はすでに読み込まれている前提

// ログインフォームコンポーネント
Vue.component('login-form', {
  delimiters: window.DELIMITERS,
  props: {
    texts: {
      type: Object,
      default: function() { return window.loginTextsJa; }
    }
  },
  data() {
    return {
      username: '',
      password: '',
      loginError: ''
    };
  },
  template: `
    <div class="card shadow login-card">
      <div class="card-body">
        <h2 class="card-title text-center mb-4">[[ texts.app_name ]]</h2>
        <div class="mb-4">
          <input type="text" v-model="username" class="form-control" :placeholder="texts.username_placeholder">
        </div>
        <div class="mb-4">
          <input type="password" v-model="password" class="form-control" :placeholder="texts.password_placeholder">
        </div>
        <div class="d-grid gap-3">
          <button type="button" @click="handleLogin" class="btn btn-primary btn-lg">[[ texts.login_button ]]</button>
          <button type="button" @click="toggleLanguageInternal" class="btn btn-secondary btn-lg">[[ texts.toggle_language ]]</button>
        </div>
        <p v-if="loginError" class="text-danger mt-3 text-center">[[ loginError ]]</p>
      </div>
    </div>
  `,
  methods: {
    handleLogin() {
      // 簡易デモ: ユーザー名とパスワードが入力されればログイン成功とする
      if (this.username && this.password) {
        this.$emit('login-success', { username: this.username });
      } else {
        this.loginError = this.texts.login_failure;
      }
    },
    toggleLanguageInternal() {
      this.$emit('toggle-language');
    }
  }
});

// ウェルカムメッセージコンポーネント
Vue.component('welcome-message', {
  delimiters: window.DELIMITERS,
  props: {
    texts: {
      type: Object,
      default: function() { return window.welcomeTextsJa; }
    }
  },
  template: `
    <div class="container mt-4">
      <h1>[[ texts.welcome_title ]]</h1>
      <p>[[ texts.welcome_body ]]</p>
    </div>
  `
});

// 親側の Vue インスタンス生成
new Vue({
  el: '#app',
  delimiters: window.DELIMITERS,
  data: {
    loggedIn: false,
    loggedUser: {},
    currentLang: 'ja',
    // ヘッダー用文言（階層型メニュー対応済み）
    headerTexts: window.headerTextsJa,
    // ログインフォーム用文言
    loginTexts: window.loginTextsJa,
    // ウェルカム用文言
    welcomeTexts: window.welcomeTextsJa,
    // ヘッダー用のリンクは、カテゴリ毎の階層構造に変更
    /*commonLinks: {
      home: '/',
      categories: {
        ledger: {
          items: {
            ledger_input: '/ledger_form/ledger_form.html',
            unified_master_manager: '/unified_master_manager/unified_master_manager.html'
          }
        },
        admin: {
          items: {
            dashboard: '/dashboard/dashboard.html',
            user_management: '/user_management/user_management.html'
          }
        },
        analysis: {
          items: {
            manual: '/manual/manual.html',
            version_info: '/version_history/version_history.html',
            ai: '/ai/ai.html',
            pivot: '/pivot/pivot.html',
            report: '/report_dashboard_ui/dashboard.html'
          }
        }
      }
    }*/
  },
  methods: {
    onLoginSuccess(user) {
      this.loggedIn = true;
      this.loggedUser = user;
    },
    onLogoutSuccess() {
      this.loggedIn = false;
      this.loggedUser = {};
    },
    toggleLanguage() {
      if (this.currentLang === 'ja') {
        this.currentLang = 'en';
        this.headerTexts = window.headerTextsEn;
        this.loginTexts = window.loginTextsEn;
        this.welcomeTexts = window.welcomeTextsEn;
      } else {
        this.currentLang = 'ja';
        this.headerTexts = window.headerTextsJa;
        this.loginTexts = window.loginTextsJa;
        this.welcomeTexts = window.welcomeTextsJa;
      }
    }
  },
  template: `
    <div>
      <div v-if="!loggedIn" class="login-container d-flex justify-content-center align-items-center vh-100">
        <login-form :texts="loginTexts" @login-success="onLoginSuccess" @toggle-language="toggleLanguage"></login-form>
      </div>
      <div v-else>
        <app-header :texts="headerTexts" @toggle-language="toggleLanguage" @logout-success="onLogoutSuccess"></app-header>
        <welcome-message :texts="welcomeTexts"></welcome-message>
      </div>
    </div>
  `
});
