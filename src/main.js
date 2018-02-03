// The Vue build version to load with the `import` command
// (runtime-only or standalone) has been set in webpack.base.conf with an alias.
import Vue from 'vue'
import App from './App'
import router from './router'
import Vuelidate from 'vuelidate'
import axios from 'axios'
import VueCookies from 'vue-cookies'
import lodash from 'lodash'
import VueLodash from 'vue-lodash'
import VueConfetti from 'vue-confetti'
import 'vue2-toast/lib/toast.css'
import Toast from 'vue2-toast'

import {store} from './store/index'
import {stripe as stripeProd} from '@/private'

require('vue2-toast/lib/toast.css')

Vue.prototype.$axios = axios
if (process.env['NODE_ENV'] === 'production' || process.env['NODE_ENV'] === 'testing') {
  axios.defaults.baseURL = 'http://104.131.20.153/'
} else {
  axios.defaults.baseURL = 'http://localhost:8000/'
}
axios.defaults.headers.post['Content-Type'] = 'application/x-www-form-urlencoded'
axios.defaults.xsrfHeaderName = 'X-CSRFTOKEN'
axios.defaults.xsrfCookieName = 'csrftoken'

const NON_TOKEN_URLS = [
  'rest-auth/login/',
  'rest-auth/password/reset/',
  'rest-auth/password/reset/confirm/',
  'rest-auth/registration/',
  'rest-auth/registration/verify-email/',
  'profile-data/',
  'load-postgres/',
  'sandbox-test-query/',
  'custom-test-query/',
  'company-test-query/'
]

axios.interceptors.request.use(function (config) {
  if (NON_TOKEN_URLS.findIndex(x => x === config.url) === -1) {
    config.headers.common['Authorization'] = 'Token ' + store.state.user.tokenKey
  } else if (config.url === 'load-postgres/' && store.state.user.loggedIn) {
    config.headers.common['Authorization'] = 'Token ' + store.state.user.tokenKey
  } else if (config.url === 'company-test-query/' && store.state.user.loggedIn) {
    config.headers.common['Authorization'] = 'Token ' + store.state.user.tokenKey
  }
  return config
})

axios.defaults.validateStatus = function (status) {
  return (status >= 200 && status < 300) || ([400, 401].indexOf(status) > -1)
}

Vue.use(VueCookies)
Vue.use(Vuelidate)
Vue.use(VueLodash, lodash)
Vue.use(VueConfetti)
Vue.use(Toast, {
  defaultType: 'bottom',
  duration: 3200,
  wordWrap: false,
  width: 'auto'
})

Vue.prototype.$log = function (...args) {
  console.log(...[...args || []].map(val => val ? JSON.parse(JSON.stringify(val)) : undefined))
  return args
}

if (process.env['NODE_ENV'] === 'production') {
  // eslint-disable-next-line
  Vue.prototype.$stripe = Stripe(stripeProd)
} else {
  // eslint-disable-next-line
  Vue.prototype.$stripe = Stripe('pk_test_S3VXP6uRGyjayGm8zfmLJT0a')
}
// eslint-disable-next-line
Vue.prototype.$elements = Vue.prototype.$stripe.elements()

const tokenKey = VueCookies.get('tokenKey')
if (tokenKey) {
  store.commit('user/setTokenKey', {key: tokenKey})
  store.dispatch('user/getUser')
  store.dispatch('user/getUserDetails')
}

Vue.config.productionTip = process.env['NODE_ENV'] === 'development'

/* eslint-disable no-new */
new Vue({
  el: '#app',
  router,
  store,
  template: '<App/>',
  components: { App }
})

/*
  --documentation start--
  NON_TOKEN_URLS  - these urls should not have the Authorization header placed on the request
                  - these endpoints are specifically not expecting an Authorization header and will error out if they get one
*/
