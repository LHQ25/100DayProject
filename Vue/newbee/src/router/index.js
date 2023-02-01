import { createRouter, createWebHashHistory } from 'vue-router'
import { Home } from '../views/Home.vue'

const routes = [
  // // 首页我们需要默认空路径重定向到 home 下，避免空页面
  {
    path: '/',
    name: 'home',
    redirect: 'home'
  },
  {
    path: '/home',
    name: 'home',
    component: Home,
    meta: {
      index: 1        // 添加 meta 属性，约定 1 为第一级
    }
  },
  {
    path: '/category',
    name: 'category',
    component: ()=> import('../views/Categroy.vue'),
    meta: {
      index: 1        // 添加 meta 属性，约定 1 为第一级
    },
  },
  {
    path: '/cart',
    name: 'cart',
    component: ()=> import('../views/Cart.vue'),
    meta: {
      index: 1        // 添加 meta 属性，约定 1 为第一级
    },
  },
  {
    path: '/user',
    name: 'user',
    component: ()=> import('../views/User.vue'),
    meta: {
      index: 1        // 添加 meta 属性，约定 1 为第一级
    },
  },
  {
    path: '/detail',
    name: 'detail',
    component: ()=> import('../views/Detail.vue'),
    meta: {
      index: 2        // 添加 meta 属性，约定 1 为第一级
    },
  },
  {
    path: '/login',
    name: 'login',
    component: ()=> import('../views/Login.vue'),
    meta: {
      index: 2        // 添加 meta 属性，约定 1 为第一级
    },
  }
]

const router = createRouter({
  history: createWebHashHistory(),
  routes
})

export default router
