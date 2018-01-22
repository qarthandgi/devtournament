import Vue from 'vue'
import Router from 'vue-router'
import axios from 'axios'
// import Hello from '@/components/Hello'
// import Login from '@/components/Login'
import PasswordReset from '@/components/PasswordReset'
import Register from '@/components/Register'
import HomePage from '@/components/HomePage'
import PostgresShell from '@/components/PostgresShell'
import PostgresHome from '@/components/PostgresHome'
import CodingShell from '@/components/CodingShell'
import InvitationInfo from '@/components/InvitationInfo'

import {store} from '../store/index'
import {isPremium, denyCompanyExercise} from '@/utils/routerUtils'

Vue.use(Router)

const router = new Router({
  mode: 'history',
  routes: [
    {
      path: '/rest-auth/registration/account-confirm-email/:key',
      name: 'verify-email',
      async beforeEnter (to, from, next) {
        console.log(to.params.key)
        const resp = await axios.post('rest-auth/registration/verify-email/', {
          key: to.params.key
        })
        console.log('THIS IS RESPONSE')
        console.log(resp)
        router.replace({name: 'postgres-home'})
      }
    },
    {
      path: '/',
      name: 'home',
      component: HomePage
    },
    {
      path: '/postgres',
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
          path: 'exercise/:id/invitation',
          component: CodingShell,
          name: 'postgres-invitation',
          meta: {mode: 'exercise', type: 'invitation'}
        },
        {
          path: 'exercise/:id/custom',
          component: CodingShell,
          name: 'postgres-custom',
          meta: {mode: 'exercise', type: 'custom'},
          children: [
            {
              path: ':inviteId/invitation',
              name: 'postgres-custom-invitation',
              component: InvitationInfo,
              meta: {mode: 'exercise', type: 'custom'}
            }
          ]
        },
        {
          path: 'exercise/new',
          name: 'postgres-new',
          component: CodingShell,
          meta: {mode: 'exercise', type: 'company'}
        },
        {
          path: 'exercise/:id',
          name: 'postgres-exercise',
          component: CodingShell,
          meta: {mode: 'exercise', type: 'company'}
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

router.beforeEach(async (to, from, next) => {
  const premiumNeeded = [
    'postgres-new',
    'postgres-custom',
    'postgres-invitation',
    'postgres-custom-invitation'
  ]
  const LAYOUT_ONE = [
    'postgres-home'
  ]
  if (to.matched.some(x => x.name === 'postgres')) {
    if (store.state.app.subject !== 'postgres') {
      store.commit('app/setSubject', {subject: 'postgres'})
    }
  }
  console.log('FROM ROUTE: ', await denyCompanyExercise(to))
  if (premiumNeeded.includes(to.name) && !isPremium()) {
    next(false)
  } else if (await denyCompanyExercise(to)) {
    console.log('IN HERE OK GOOOOO383833')
    // next(false)
    router.push({name: 'postgres-home'})
    next(false)
  } else if (to.name === `home`) {
    store.commit('app/setLayoutState', {state: 0})
    next()
  } else if (LAYOUT_ONE.includes(to.name)) {
    store.commit('app/setLayoutState', {state: 1})
    next()
  } else {
    store.commit('app/setLayoutState', {state: 2})
    next()
  }
})

export default router
