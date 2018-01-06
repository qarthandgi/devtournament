import Vuex from 'vuex'
import Vue from 'vue'
import axios from 'axios'
import VueCookies from 'vue-cookies'

import user from './modules/user'
import email from './modules/email'
import app from './modules/app'
import pg from './modules/pg'

Vue.use(Vuex)

function initialState () {
  return {
    tokenKey: '',
    profile: {
      id: '-1',
      firstName: '',
      lastName: '',
      email: ''
    }
  }
}

const state = initialState()

export const store = new Vuex.Store({
  strict: process.env['NODE_ENV'] !== 'production',
  modules: {
    user,
    email,
    app,
    pg
  },
  state,
  getters: {
    fullName (state, getters) {
      return state.profile.firstName + ' ' + state.profile.lastName
    }
  },
  mutations: {
    clearData (state, payload) {
      const iS = initialState()
      for (let item in state) {
        Vue.set(state, item, iS[item])
      }
    },
    setKey (state, payload) {
      state.tokenKey = payload.key
    },
    setName (state, payload) {
      state.profile.firstName = payload.first_name
      state.profile.lastName = payload.last_name
      state.profile.email = payload.email
    }
  },
  actions: {
    // async login ({commit, dispatch}, payload) {
    //   let {data} = await axios.post('rest-auth/login/', {
    //     username: payload.username,
    //     password: payload.password
    //   })
    //   VueCookies.set('tokenKey', data.key)
    //   commit('setKey', data)
    //   dispatch('getName')
    //   console.log(data)
    // },
    async logout ({commit}, payload) {
      await axios.post('rest-auth/logout/')
      VueCookies.remove('tokenKey')
      commit('clearData')
    },
    async getName ({commit}) {
      const {data} = await axios.get('rest-auth/user/')
      commit('setName', data)
    },
    async resetPassword ({commit, dispatch}, payload) {
      await axios.post('rest-auth/password/reset/', {
        email: payload.email
      })
      return 'ok'
    },
    async resetPasswordConfirm ({commit, dispatch}, {uid, token, newPassword1, newPassword2}) {
      await axios.post('rest-auth/password/reset/confirm/', {
        uid,
        token,
        new_password1: newPassword1,
        new_password2: newPassword2
      })
    },
    async changePassword ({commit, dispatch}, {newPassword1, newPassword2, oldPassword}) {
      await axios.post('rest-auth/password/change/', {
        new_password1: newPassword1,
        new_password2: newPassword2,
        old_password: oldPassword
      })
    },
    async verifyUser ({commit, dispatch}, payload) {
      const {data} = axios.post('rest-auth/registration/verify-email/')
      console.log(data)
    }
    // async registerUser ({commit, dispatch}, {username, email, password1, password2}) {
    //   const {data} = await axios.post('rest-auth/registration/', {
    //     username,
    //     email,
    //     password1,
    //     password2
    //   })
    //   VueCookies.set('tokenKey', data.key)
    //   commit('setKey', data)
    //   dispatch('getName')
    // }
  }
})

/*
  --documentation start--
  state
    tokenKey: - token key received from logging in or registering new user
              sent on every request by way of axios interceptor in `main.js`
              - not set as header on certain urls that don't require a token
*/
