import Vue from 'vue'
import axios from 'axios'

function initialState () {
  return {
    databases: []
  }
}

const state = initialState()

export default {
  namespaced: true,
  state,
  mutations: {
    setData (state, payload) {
      Vue.set(state, 'databases', payload.databases.sort((a, b) => a.id - b.id))
    }
  },
  actions: {
    loadPostgres ({state, commit, rootState}) {
      return new Promise(async (resolve, reject) => {
        const {data} = await axios.get('load-postgres/')
        commit('setData', data)
        resolve(true)
      })
    }
  }
}
