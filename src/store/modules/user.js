import Vue from 'vue'
import VueCookies from 'vue-cookies'
import axios from 'axios'

function initialState () {
  return {
    user: {
      id: 0,
      firstName: '',
      lastName: '',
      username: '',
      email: ''
    },
    tokenKey: '',
    loggedIn: false
  }
}

const state = initialState()

export default {
  namespaced: true,
  state,
  getters: {
    userAndId (state) {
      return state.user.username + ': ' + state.user.id
    }
  },
  mutations: {
    setTokenKey (state, payload) {
      state.tokenKey = payload.key
      state.loggedIn = true
    },
    setUser (state, payload) {
      state.user.id = payload.pk
      state.user.firstName = payload.first_name
      state.user.lastName = payload.last_name
      state.user.username = payload.username
      state.user.email = payload.email
    },
    clearData (state, payload) {
      const iS = initialState()
      for (let item in state) {
        Vue.set(state, item, iS[item])
      }
    }
  },
  actions: {
    // send credentials; check response status; set a cookie with the user token;
    // send the mutation of the token; get user details;
    login ({commit, dispatch}, payload) {
      return new Promise(async (resolve, reject) => {
        const response = await axios.post('rest-auth/login/', {
          username: payload.username,
          password: payload.password
        })
        if (response.status === 200) {
          const {data} = response
          console.log(data)
          VueCookies.set('tokenKey', data.key, '5d', '/')
          commit('setTokenKey', data)
          dispatch('getUser')
          resolve(true)
        } else {
          console.log('response code ' + response.status)
          console.log('wrong credentials')
          resolve(false)
        }
      })
    },
    logout ({commit, dispatch}, payload) {
      return new Promise(async (resolve, reject) => {
        const response = await axios.post('rest-auth/logout/')
        console.log(response)
        VueCookies.remove('tokenKey', '/')
        commit('clearData')
      })
    },
    async getUser ({commit}) {
      const {data} = await axios.get('rest-auth/user/')
      commit('setUser', data)
    },
    async register ({commit, dispatch}, {username, email, password1, password2}) {
      return new Promise(async (resolve, reject) => {
        const response = await axios.post('rest-auth/registration/', {
          username,
          email,
          password1,
          password2
        })
        const {data} = response
        if (response.status === 201) {
          console.log('registered')
          resolve(true)
        } else {
          console.log('response code ' + response.status)
          console.log(data)
          resolve(false)
        }
      })
    }
  }
}
