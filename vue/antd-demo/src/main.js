import { createApp } from 'vue';
import App from './App';
import Antd from 'ant-design-vue';
import router from './router';
import 'ant-design-vue/dist/reset.css';
import 'material-icons/iconfont/material-icons.css';

const app = createApp(App);
app.use(router);
app.use(Antd).mount('#app');

// Remove the loading element when the app is ready
const loadingElement = document.getElementById('loading');
if (loadingElement) {
  loadingElement.style.display = 'none';
}