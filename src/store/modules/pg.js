import Vue from 'vue'
import axios from 'axios'

function initialState () {
  return {
    databases: [],
    customExercises: []
  }
}

const state = initialState()

export default {
  namespaced: true,
  state,
  mutations: {
    setData (state, payload) {
      Vue.set(state, 'databases', (payload.databases || []).sort((a, b) => a.id - b.id))
      Vue.set(state, 'customExercises', (payload.custom_exercises || []).sort((a, b) => a.added - b.added))
    }
  },
  actions: {
    loadPostgres ({state, commit, rootState}) {
      return new Promise(async (resolve, reject) => {
        let {data} = await axios.get('load-postgres/')
        commit('setData', data)
        resolve(true)
      })
    }
  }
}
