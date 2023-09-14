import { createRouter, createWebHistory } from 'vue-router';
import MyComponent from './MyComponent.vue';
import InfoComponent from './InfoComponent.vue';

const routes = [
  { path: '/parlamentarier', component: MyComponent },
  { path: '/info', component: InfoComponent }
];

const router = createRouter({
  history: createWebHistory(),
  routes
});

export default router;
