import { createRouter, createWebHashHistory } from 'vue-router'
import HomeView from '../views/home/HomeView.vue'

const routes = [
  {
    path: '/',
    name: 'home',
    component: HomeView
  },
  {
    path: '/login',
    name: 'login',
    // route level code-splitting
    // this generates a separate chunk (about.[hash].js) for this route
    // which is lazy-loaded when the route is visited.
    component: () => import(/* webpackChunkName: "about" */ '../views/login/Login.vue'),
    beforeEnter (to, from, next) {
      const { isLogin } = localStorage
      isLogin ? next({ name: 'home' }) : next()
    }
  },
  {
    path: '/register',
    name: 'register',
    component: () => import('../views/register/Register.vue'),
    beforeEnter (to, from, next) {
      const { isLogin } = localStorage
      isLogin ? next({ name: 'home' }) : next()
    }
  }
]

const router = createRouter({
  history: createWebHashHistory(),
  routes
})

// router.beforeEach((to, from, next) => {
//   const { isLogin } = localStorage
//   const { name } = to
//   const isLoginOrRegister = (name === 'login' || name === 'register');
//   (isLogin || isLoginOrRegister) ? next() : next({ name: 'Login' })
// })

export default router
