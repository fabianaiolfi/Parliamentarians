import { createRouter, createWebHistory } from 'vue-router';
import LandingPage from './LandingPage.vue';
import MyComponent from './MyComponent.vue';
import SimpleComponent from './SimpleComponent.vue';

const routes = [
  {
    path: '/',
    name: 'LandingPage',
    component: LandingPage
  },
  { path: '/parliamentarian', component: MyComponent },
  {
    path: '/parliamentarian/:personId', // Dynamic segment for personId
    component: SimpleComponent
  },
];

const router = createRouter({
  history: createWebHistory('/'),
  routes
});

export default router;
