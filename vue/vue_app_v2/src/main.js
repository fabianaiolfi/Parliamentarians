import { createApp } from 'vue';
import Vuex from 'vuex';
import App from './App.vue';
import store from './store'; // The Vuex store
import Vue from 'vue';
import Antd from 'ant-design-vue';
import router from './router';
import 'ant-design-vue/dist/reset.css';
import 'material-icons/iconfont/material-icons.css';

new Vue({
  store,
  render: h => h(App)
}).$mount('#app');

// // Create a new store instance
// const store = Vuex.createStore({
//   state() {
//     return {
//       // Define your state here
//     };
//   },
//   // Add mutations, actions, getters, etc.
// });

const app = createApp(App);
app.use(router);
app.use(store);
app.use(Antd).mount('#app');

// Remove the loading element when the app is ready
const loadingElement = document.getElementById('loading');
if (loadingElement) {
  loadingElement.style.display = 'none';
}
