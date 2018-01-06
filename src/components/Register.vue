<template lang="pug">
  .register
    input(v-model="newUser.username", placeholder="Username", type="text")
    input(v-model="newUser.password1", placeholder="Password", type="password")
    input(v-model="newUser.password2", placeholder="Confirm Password", type="password")
    input(v-model="newUser.email", placeholder="Email", type="text")
    br
    button(@click="registerUser(newUser)") Register
</template>

<script>
  import {mapActions} from 'vuex'

  export default {
    data () {
      return {
        newUser: {
          username: '',
          email: '',
          password1: '',
          password2: ''
        }
      }
    },
    methods: {
      ...mapActions({
        registerUser: 'registerUser'
      })
    }
  }
</script>
