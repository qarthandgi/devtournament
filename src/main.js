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

import {store} from './store/index'

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
  'profile-data/',
  'load-postgres/',
  'test-query/'
]

axios.interceptors.request.use(function (config) {
  if (NON_TOKEN_URLS.findIndex(x => x === config.url) === -1) {
    config.headers.common['Authorization'] = 'Token ' + store.state.user.tokenKey
  } else if (config.url === 'load-postgres/' && store.state.user.loggedIn) {
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

const tokenKey = VueCookies.get('tokenKey')
if (tokenKey) {
  store.commit('user/setTokenKey', {key: tokenKey})
  store.dispatch('user/getUser')
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
