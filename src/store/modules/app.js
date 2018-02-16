function initialState () {
  return {
    layoutState: 0,
    subject: '',
    loadingOverlay: false
  }
}

const state = initialState()

export default {
  namespaced: true,
  state,
  mutations: {
    setLayoutState (state, payload) {
      state.layoutState = payload.state
    },
    setSubject (state, payload) {
      state.subject = payload.subject
    },
    setLoadingOverlay (state, payload) {
      state.loadingOverlay = payload.state
    }
  }
}
