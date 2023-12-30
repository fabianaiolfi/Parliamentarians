import { createRouter, createWebHistory } from 'vue-router';
import MyComponent from './MyComponent.vue';


const routes = [
  { 
    path: '/parliamentarian',
    component: MyComponent 
  },
  
];

const router = createRouter({
  history: createWebHistory(),
  routes
});

export default router;
