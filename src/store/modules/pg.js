import Vue from 'vue'
import axios from 'axios'

function initialState () {
  return {
    loaded: false,
    databases: [],
    customExercises: [],
    invitations: [],
    exercises: [],
    premiumExercises: 0,
    nonPremiumExercises: 0,
    showWelcome: false,
    showHowTo: false
  }
}

const state = initialState()

export default {
  namespaced: true,
  state,
  getters: {
    getInvitationById: (state) => (customExerciseId, invitationId) => {
      return state.customExercises.find(x => x.id === customExerciseId).invitation_set.find(x => x.id === invitationId)
    },
    getNoviceExercises: (state) => {
      return state.exercises.filter(x => x.difficulty === 'novice').sort((a, b) => a.position - b.position)
    },
    getIntermediateExercises: (state) => {
      return state.exercises.filter(x => x.difficulty === 'intermediate').sort((a, b) => a.position - b.position)
    },
    getAdvancedExercises: (state) => {
      return state.exercises.filter(x => x.difficulty === 'advanced').sort((a, b) => a.position - b.position)
    }
  },
  mutations: {
    addCustomExercise (state, payload) {
      state.customExercises.push(payload)
    },
    setShowHowTo (state, payload) {
      state.showHowTo = payload.state
    },
    setShowWelcome (state, payload) {
      state.showWelcome = payload.state
    },
    setData (state, payload) {
      Vue.set(state, 'databases', (payload.databases || []).sort((a, b) => a.id - b.id))
      Vue.set(state, 'customExercises', (payload.custom_exercises || []).sort((a, b) => a.added - b.added))
      Vue.set(state, 'invitations', (payload.invitations || []).sort((a, b) => a.added - b.added))
      Vue.set(state, 'exercises', (payload.exercises || []).sort((a, b) => a.position - b.position))
      state.premiumExercises = payload.premium_exercises
      state.nonPremiumExercises = payload.non_premium_exercises
      state.loaded = true
    },
    // replaceInvite will be the top level invitations, replaceInvitation will be those inside customExercises
    replaceInvite (state, payload) {
      const index = state.invitations.findIndex(x => x.id === payload.invitation.id)
      state.invitations.splice(index, 1, payload.invitation)
    },
    removeInvite (state, payload) {
      const index = state.invitations.findIndex(x => x.id === payload.invitationId)
      state.invitations.splice(index, 1)
    },
    replaceInvitation (state, payload) {
      const index = state.customExercises.findIndex(x => x.id === payload.customExerciseId)
      const idx = state.customExercises[index].invitation_set.findIndex(x => x.id === payload.invitation.id)
      state.customExercises[index].invitation_set.splice(idx, 1, payload.invitation)
    },
    removeInvitation (state, payload) {
      const index = state.customExercises.findIndex(x => x.id === payload.customExerciseId)
      const idx = state.customExercises[index].invitation_set.findIndex(x => x.id === payload.invitationId)
      state.customExercises[index].invitation_set.splice(idx, 1)
    },
    changeInvitationStatus (state, payload) {
      const idx = state.invitations.findIndex(x => x.id === payload.invitationId)
      Vue.set(state.invitations[idx], 'status', payload.status)
    },
    changeExerciseCompletion (state, payload) {
      const idx = state.exercises.findIndex(x => x.id === payload.exerciseId)
      Vue.set(state.exercises[idx], 'last_successful_completion', payload.lastSuccessfulCompletion)
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
