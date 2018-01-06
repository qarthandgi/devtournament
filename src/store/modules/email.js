export default {
  namespaced: true,
  state: {
    to: '',
    from: '',
    message: `To whom it may concern,\n\nBlah, blah, blah, I'm the best`
  },
  mutations: {
    addFooter (state, payload) {
      state.message += payload.footer
    },
    setMessage (state, payload) {
      state.message = payload.message
    }
  },
  actions: {
    getFooter ({state, commit, rootState}) {
      const footer = '\n\n\nWarm regards,\nNiles Brandon'
      setTimeout(() => {
        commit('addFooter', {footer: footer})
      }, 1000)
    }
  }
}
