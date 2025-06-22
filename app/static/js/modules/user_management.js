// frontend/js/modules/user_management.js

new Vue({
    el: '#userApp',
    delimiters: window.DELIMITERS || ['[[', ']]'],
  
    data: function() {
      // window.currentLang が存在しない場合は 'ja' とする
      var lang = window.currentLang || 'ja';
  
      // ユーザー管理画面用のテキストを texts にセット
      // 指定がない場合は defaultTexts をフォールバック
      var defaultTexts = {
        user_management: 'ユーザー管理',
        add_user: 'ユーザー追加',
        username: 'ユーザー名',
        username_placeholder: 'ユーザー名',
        password: 'パスワード',
        password_placeholder: 'パスワード',
        password_hint: '編集時にパスワードを変更する場合のみ入力してください。',
        role: '役割',
        admin: '管理者',
        manager: 'マネージャー',
        general_user: '一般ユーザー',
        actions: '操作',
        edit: '編集',
        delete: '削除',
        save: '保存',
        cancel: 'キャンセル',
        confirm_delete: 'このユーザーを削除してもよろしいですか？'
      };
  
      // language が 'en' なら window.userManagementTextsEn、そうでなければ userManagementTextsJa を用いる
      var texts;
      if (lang === 'en') {
        texts = window.userManagementTextsEn || defaultTexts;
      } else {
        texts = window.userManagementTextsJa || defaultTexts;
      }
  
      // ヘッダー用テキストは headerTextsEn/Ja があれば利用
      var headerTexts = (lang === 'en') ? (window.headerTextsEn || {}) : (window.headerTextsJa || {});
  
      return {
        language: lang,
        texts: texts,
        users: [],
        showUserForm: false,
        userFormTitle: '',
        userForm: { id: null, username: '', password: '', role: 'General User' },
        headerTexts: headerTexts
      };
    },
  
    created: function() {
      this.fetchUsers();
    },
  
    methods: {
      fetchUsers: function() {
        axios.get('/api/user_management/allusers', { withCredentials: true })
          .then(response => {
            this.users = response.data;
          })
          .catch(error => {
            console.error("ユーザーの取得に失敗しました:", error);
            alert("ユーザーの取得に失敗しました。");
          });
      },
  
      showAddUserForm: function() {
        this.userFormTitle = this.texts.add_user || 'ユーザー追加';
        this.userForm = { id: null, username: '', password: '', role: 'General User' };
        this.showUserForm = true;
      },
  
      showEditUserForm: function(user) {
        this.userFormTitle = this.texts.edit || 'ユーザー編集';
        this.userForm = Object.assign({}, user);
        // 編集時にはパスワードを空に（変更する場合のみ入力）
        this.userForm.password = '';
        this.showUserForm = true;
      },
  
      submitUserForm: function() {
        if (this.userForm.id) {
          // 更新処理
          axios.put(`/api/user_management/${this.userForm.id}`, this.userForm, { withCredentials: true })
            .then(response => {
              alert(response.data.message);
              this.fetchUsers();
              this.showUserForm = false;
            })
            .catch(error => {
              console.error("ユーザー更新エラー:", error);
              alert((error.response && error.response.data && error.response.data.message) || "ユーザーの更新に失敗しました。");
            });
        } else {
          // 新規追加処理
          axios.post('/api/users', this.userForm, { withCredentials: true })
            .then(response => {
              alert(response.data.message);
              this.fetchUsers();
              this.showUserForm = false;
            })
            .catch(error => {
              console.error("ユーザー追加エラー:", error);
              alert((error.response && error.response.data && error.response.data.message) || "ユーザーの追加に失敗しました。");
            });
        }
      },
  
      cancelUserForm: function() {
        this.showUserForm = false;
      },
  
      deleteUser: function(userId) {
        if (confirm(this.texts.confirm_delete || "このユーザーを削除してもよろしいですか？")) {
          axios.delete(`/api/user_management/${userId}`, { withCredentials: true })
            .then(response => {
              alert(response.data.message);
              this.fetchUsers();
            })
            .catch(error => {
              console.error("ユーザー削除エラー:", error);
              alert((error.response && error.response.data && error.response.data.message) || "ユーザーの削除に失敗しました。");
            });
        }
      },
  
      toggleLanguage: function() {
        // 言語を交互に切り替える
        this.language = (this.language === 'ja') ? 'en' : 'ja';
  
        // userManagementTexts の更新
        var newTexts;
        if (this.language === 'en') {
          newTexts = window.userManagementTextsEn || {};
        } else {
          newTexts = window.userManagementTextsJa || {};
        }
        this.$set(this, 'texts', newTexts);
  
        // ヘッダー用テキストも更新
        var newHeaderTexts = (this.language === 'en') ? (window.headerTextsEn || {}) : (window.headerTextsJa || {});
        this.$set(this, 'headerTexts', newHeaderTexts);
  
        document.documentElement.lang = this.language;
      },
  
      handleLogout: function() {
        window.location.href = '/';
      },
  
      closeWindow: function() {
        window.close();
      }
    }
  });
  