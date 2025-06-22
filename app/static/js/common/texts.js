// texts.js

// ----------------------------------------------
// ヘッダー用固定文言（日本語版）
// ----------------------------------------------
window.headerTextsJa = {     
  app_name: 'Web台帳管理システム',     
  logout_button: 'ログアウト',     
  toggle_language: '言語切替',     
  confirm_logout: 'ログアウトしてもよろしいですか？',     
  logout_success: 'ログアウトしました。',     
  logout_failure: 'ログアウトに失敗しました。',     
  // 各メニュー項目の文言
  nav_links: {       
    ledger_input: '各種台帳',       
    dashboard: 'ダッシュボード',       
    user_management: 'ユーザー管理',       
    manual: 'マニュアル',       
    version_info: 'バージョン情報',       
    ai: '生成AI',       
    pivot: 'ピボット',       
    report: 'レポート',
    unified_master_manager: 'マスター管理'
  },
  // カテゴリ名の文言
  nav_categories: {
    ledger: '台帳類', 
    admin: '管理', 
    analysis: '分析',
    etc: 'その他',
  }
};

// ----------------------------------------------
// ヘッダー用固定文言（英語版）
// ----------------------------------------------
window.headerTextsEn = {     
  app_name: 'Web Ledger Manager',     
  logout_button: 'Log Out',     
  toggle_language: 'Toggle Language',     
  confirm_logout: 'Are you sure you want to log out?',     
  logout_success: 'Logged out successfully.',     
  logout_failure: 'Logout failed.',     
  // 各メニュー項目の文言
  nav_links: {       
    ledger_input: 'Ledgers',       
    dashboard: 'Dashboard',       
    user_management: 'User Management',       
    manual: 'Manual',       
    version_info: 'Version Information',       
    ai: 'Generative AI',       
    pivot: 'Pivot',       
    report: 'Report',
    unified_master_manager: 'Unified Master Management'
  },
  // カテゴリ名の文言
  nav_categories: {
    ledger: 'Ledger',
    admin: 'Administration',
    analysis: 'Analysis',
    etc: 'Other',
  }
};

// ----------------------------------------------
// ログインフォーム用固定文言（日本語版）
// ----------------------------------------------
window.loginTextsJa = {     
  app_name: 'Web台帳管理システム',     
  login_button: 'ログイン',     
  toggle_language: '言語切替',     
  username_placeholder: 'ユーザー名',     
  password_placeholder: 'パスワード',     
  login_failure: 'ログインに失敗しました。'   
};

// ----------------------------------------------
// ログインフォーム用固定文言（英語版）
// ----------------------------------------------
window.loginTextsEn = {     
  app_name: 'Web Ledger Manager',     
  login_button: 'Log In',     
  toggle_language: 'Toggle Language',     
  username_placeholder: 'Username',     
  password_placeholder: 'Password',     
  login_failure: 'Login failed.'   
};

// ----------------------------------------------
// ウェルカム用固定文言（日本語版）
// ----------------------------------------------
window.welcomeTextsJa = {
  welcome_title: 'ようこそ、Web台帳管理システムへ',
  welcome_body: '本システムは、台帳データの入力、管理、分析を一元化するための最新Web台帳管理システムです。システムの機能として、台帳入力、ダッシュボード、ユーザー管理、マニュアル、バージョン情報、生成AI、ピボットテーブルなどが含まれます。'
};

// ----------------------------------------------
// ウェルカム用固定文言（英語版）
// ----------------------------------------------
window.welcomeTextsEn = {
  welcome_title: 'Welcome to Web Ledger Manager',
  welcome_body: 'This system centralizes ledger data input, management, and analysis. It includes features such as ledger input, dashboard, user management, manuals, version information, generative AI, and pivot tables.'
};

// ----------------------------------------------
// 統合マスター管理用固定文言（日本語版）
// ----------------------------------------------
window.unifiedMasterTextsJa = {
  add_new_master: "新規マスター追加",
  master_type_label: "マスター種別",
  select_master_type: "種別を選択してください",
  input_fields: "項目入力",
  save: "保存",
  select_existing_master: "既存マスターの種別を選択",
  existing_masters: "既存マスター一覧",
  actions: "操作",
  update: "更新",
  delete: "削除"
};

// ----------------------------------------------
// 統合マスター管理用固定文言（英語版）
// ----------------------------------------------
window.unifiedMasterTextsEn = {
  add_new_master: "Add New Unified Master",
  master_type_label: "Master Type",
  select_master_type: "Select Master Type",
  input_fields: "Input Fields",
  save: "Save",
  select_existing_master: "Select Existing Unified Master",
  existing_masters: "Existing Unified Masters",
  actions: "Actions",
  update: "Update",
  delete: "Delete"
};

// ----------------------------------------------
// ★ユーザー管理画面用固定文言（日本語版）★
// ----------------------------------------------
window.userManagementTextsJa = {
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

// ----------------------------------------------
// ★ユーザー管理画面用固定文言（英語版）★
// ----------------------------------------------
window.userManagementTextsEn = {
  user_management: 'User Management',
  add_user: 'Add User',
  username: 'Username',
  username_placeholder: 'Username',
  password: 'Password',
  password_placeholder: 'Password',
  password_hint: 'Only enter if you wish to change the password.',
  role: 'Role',
  admin: 'Admin',
  manager: 'Manager',
  general_user: 'General User',
  actions: 'Actions',
  edit: 'Edit',
  delete: 'Delete',
  save: 'Save',
  cancel: 'Cancel',
  confirm_delete: 'Are you sure you want to delete this user?'
};

// バージョン履歴用文言（日本語版）
window.versionHistoryTextsJa = {
  version_history_title: "バージョン履歴",
  version_label: "バージョン: ",
  sprint_label: "スプリント ",
  updated_at: "更新日時:",
  no_version_history: "バージョン履歴がありません。",
  close_button: "閉じる"
};

// バージョン履歴用文言（英語版）
window.versionHistoryTextsEn = {
  version_history_title: "Version History",
  version_label: "Version: ",
  sprint_label: "Sprint ",
  updated_at: "Updated at:",
  no_version_history: "No version history found.",
  close_button: "Close"
};