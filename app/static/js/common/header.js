(function(){
  const delimiters = window.DELIMITERS || ['[[', ']]'];
  
  Vue.component('app-header', {
    delimiters: delimiters,
    props: {
      texts: {
        type: Object,
        default: function(){ 
          return window.headerTextsJa || { app_name: "Web Ledger Manager" };
        }
      },
      links: {
        type: Object,
        default: function(){
          return {
            home: '/',
            categories: {
              ledger: {
                items: {
                  ledger_input: '/ledger_form/ledger_form.html',
                  dashboard: '/dashboard/dashboard.html',
                }
              },
              analysis: {
                items: {
                  ai: '/ai/ai.html',
                  pivot: '/pivot/pivot.html',
                  report: '/report_dashboard_ui/dashboard.html'
                }
              },
              admin: {
                items: {
                  unified_master_manager: '/unified_master_manager/unified_master_manager.html',
                  user_management: '/user_management/user_management.html'
                }
              },
              etc:{
                items: {
                  manual: '/manual/manual.html',
                  version_info: '/version_history/version_history.html',
                }
              }
            }
          };
        }
      }
    },
    computed: {
      navLabels() {
        return this.texts.nav_links || {};
      },
      navCategories() {
        return this.texts.nav_categories || {};
      }
    },
    template: `
      <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
        <div class="container-fluid">
          <a class="navbar-brand" :href="links.home">[[ texts.app_name ]]</a>
          <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#commonNavbar" aria-expanded="false">
            <span class="navbar-toggler-icon"></span>
          </button>
          <div class="collapse navbar-collapse" id="commonNavbar">
            <ul class="navbar-nav me-auto mb-2 mb-lg-0">
              <li class="nav-item dropdown" v-for="(category, catKey) in links.categories" :key="catKey">
                <a class="nav-link dropdown-toggle" 
                  href="#" 
                  @click.prevent 
                  :id="'dropdown-' + catKey" 
                  role="button" 
                  data-bs-toggle="dropdown" 
                  aria-expanded="false">
                  [[ navCategories[catKey] ]]
                </a>
                <ul class="dropdown-menu" :aria-labelledby="'dropdown-' + catKey">
                  <li v-for="(url, itemKey) in category.items" :key="itemKey">
                    <a class="dropdown-item" :href="url">[[ navLabels[itemKey] ]]</a>
                  </li>
                </ul>
              </li>
            </ul>
            <div class="d-flex">
              <button class="btn btn-outline-light me-2" @click="logout">[[ texts.logout_button ]]</button>
              <button class="btn btn-outline-light me-2" @click="toggleLanguageInternal">[[ texts.toggle_language ]]</button>
            </div>
          </div>
        </div>
      </nav>
    `,
    methods: {
      logout() {
        if (confirm(this.texts.confirm_logout)) {
          axios.post('/api/auth/logout', {}, { withCredentials: true })
            .then(response => {
              alert(this.texts.logout_success);
              this.$emit('logout-success');
            })
            .catch(error => {
              alert(this.texts.logout_failure);
              console.error(error);
            });
        }
      },
      toggleLanguageInternal() {
        this.$emit('toggle-language');
      }
    },
    mounted() {
      if (this.$el && typeof this.$el.querySelectorAll === 'function') {
        const dropdownElements = this.$el.querySelectorAll('.dropdown-toggle');
        dropdownElements.forEach(el => {
          if (window.bootstrap && window.bootstrap.Dropdown) {
            window.bootstrap.Dropdown.getOrCreateInstance(el);
          }
        });
      } else {
        console.error("header.js mounted: this.$el is not a valid DOM element", this.$el);
      }
    }
  });
})();
