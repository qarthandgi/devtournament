import Vue from 'vue'
import Router from 'vue-router'
// import Hello from '@/components/Hello'
// import Login from '@/components/Login'
import PasswordReset from '@/components/PasswordReset'
import Register from '@/components/Register'
import HomePage from '@/components/HomePage'
import PostgresShell from '@/components/PostgresShell'
import PostgresHome from '@/components/PostgresHome'
import CodingShell from '@/components/CodingShell'

import {store} from '../store/index'

Vue.use(Router)

const router = new Router({
  mode: 'history',
  routes: [
    {
      path: '/',
      name: 'home',
      component: HomePage
    },
    {
      path: '/postgres',
      name: 'postgres',
      component: PostgresShell,
      children: [
        {
          path: '',
          name: 'postgres-home',
          component: PostgresHome
        },
        {
          path: 'sandbox/:id',
          name: 'postgres-sandbox',
          component: CodingShell,
          meta: {mode: 'sandbox'}
        },
        {
          path: 'exercise/:id',
          name: 'postgres-exercise',
          component: CodingShell,
          meta: {mode: 'exercise'}
        }
      ]
    },
    {
      path: '/reset/:uid/:token',
      name: 'passwordReset',
      component: PasswordReset
    },
    {
      path: '/register',
      name: 'register',
      component: Register
    },
    {
      path: 'rest'
    }
  ]
})

router.beforeEach((to, from, next) => {
  const LAYOUT_ONE = [
    'postgres-home'
  ]
  if (to.name === `home`) {
    store.commit('app/setLayoutState', {state: 0})
  } else if (LAYOUT_ONE.includes(to.name)) {
    store.commit('app/setLayoutState', {state: 1})
  } else {
    store.commit('app/setLayoutState', {state: 2})
  }
  if (to.matched.some(x => x.name === 'postgres')) {
    if (store.state.app.subject !== 'postgres') {
      store.commit('app/setSubject', {subject: 'postgres'})
    }
  }
  next()
})

export default router
