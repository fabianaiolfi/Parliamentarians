import { createRouter, createWebHistory } from 'vue-router';
import LandingPage from './LandingPage.vue';
import MyComponent from './MyComponent.vue';

const routes = [
  {
    path: '/',
    name: 'LandingPage',
    component: LandingPage
  },
  { path: '/parliamentarian', component: MyComponent },
];

const router = createRouter({
  history: createWebHistory('/'),
  routes
});

export default router;
