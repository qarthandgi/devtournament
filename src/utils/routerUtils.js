import {store} from '@/store/index'

export function isPremium () {
  if (store.state.user.loggedIn) {
    if (store.state.user.user.subscription === 'premium') {
      return true
    }
    return false
  }
  return false
}

export function denyCompanyExercise (to) {
  return new Promise((resolve, reject) => {
    if (to.name !== 'postgres-exercise') {
      resolve(false)
      return
    }
    let deny = false
    function proceed () {
      const userSubscription = store.state.user.user.subscription
      const subscriptionNeeded = store.state.pg.exercises.find(x => x.id === parseInt(to.params.id)).needed_subscription
      if (subscriptionNeeded === null) {
        deny = false
      } else if (userSubscription === 'none' && subscriptionNeeded === null) {
        deny = false
      } else if (userSubscription === 'basic' && subscriptionNeeded === 'basic') {
        deny = false
      } else if (userSubscription === 'premium' && subscriptionNeeded === 'premium') {
        deny = false
      } else if (subscriptionNeeded === 'basic' && userSubscription === 'none') {
        deny = true
      } else if (subscriptionNeeded === 'premium' && userSubscription === 'none') {
        deny = true
      } else if (subscriptionNeeded === 'premium' && userSubscription === 'basic') {
        deny = true
      } else {
        deny = false
      }
      return deny
    }

    if (store.state.pg.loaded === true && store.state.user.loaded === true) {
      resolve(proceed())
    } else {
      // store.watch((state, getters) => state.pg.loaded, loaded => {
      if (store.state.pg.loaded) {
        // if (loaded === true) {
        if (store.state.user.loaded === true) {
          resolve(proceed())
        } else {
          store.watch(state => state.user.loaded, userLoaded => {
            if (userLoaded === true) {
              resolve(proceed())
            }
          })
        }
        // }
      }
      // })
    }
  })
}
