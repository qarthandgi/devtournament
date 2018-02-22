import Vue from 'vue'
import Router from 'vue-router'
import axios from 'axios'
import VueCookies from 'vue-cookies'
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
import {bus} from '@/utils/bus'

Vue.use(Router)

const router = new Router({
  mode: 'history',
  routes: [
    {
      path: '/rest-auth/registration/account-confirm-email/:key/',
      name: 'verify-email',
      async beforeEnter (to, from, next) {
        await axios.post('rest-auth/registration/verify-email/', {
          key: to.params.key
        })
        // TODO: entering incorrect verify key
        store.commit('user/setFinishVerification', {finishVerification: true})
        router.replace({name: 'postgres-home'})
        // if (resp.data.status === 200) {
        //   const resp2 = await axios.post('verify-')
        // }
      }
    },
    {
      path: '/',
      name: 'home',
      component: HomePage
    },
    {
      path: '/postgresql',
      component: PostgresShell,
      name: 'postgres-base',
      children: [
        {
          path: '',
          name: 'postgres-home',
          component: PostgresHome,
          props: route => {
            let verified = false
            if (route.query.verified) {
              verified = route.query.verified === 'true'
            }
            return {verified: verified}
          }
        },
        {
          path: 'sandbox/:id/public/:publicId',
          name: 'postgres-sandbox-public',
          component: CodingShell,
          meta: {mode: 'sandbox', type: 'public'}
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
  if (to.matched.some(x => x.name === 'postgres-base')) {
    if (store.state.app.subject !== 'postgres') {
      store.commit('app/setSubject', {subject: 'postgres'})
    }
    if (VueCookies.isKey('bh')) {
    } else {
      VueCookies.set('bh', 1, Infinity, '/')
      store.commit('pg/setShowWelcome', {state: true})
    }
  }
  if (to.matched.some(x => x.meta && (x.meta.mode === 'exercise' || x.meta.mode === 'sandbox'))) {
    if (VueCookies.isKey('bhc')) {
    } else {
      VueCookies.set('bhc', 1, Infinity, '/')
      setTimeout(() => {
        bus.$emit('showHowTo')
      }, 2000)
    }
  }
  if (premiumNeeded.includes(to.name) && !isPremium()) {
    next(false)
  } else if (await denyCompanyExercise(to)) {
    bus.$emit('activate-auth-window', true)
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
