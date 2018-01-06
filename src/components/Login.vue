<template lang="pug">
  .login
    h1 login
    input(v-model="username", placeholder="Username")
    input(v-model="password", placeholder="Password", type="password")
    br
    span {{profile.email}}
    br
    button.login-button(@click="login({username, password})") Login
    button.login-button(@click="logout") Logout
    br
    button.login-button(@click="resetPassword({email: 'admin@master.com'})") Forgot Password?
    br
    br
    input(v-model="changePass.oldPassword", placeholder="Old Password", type="password")
    input(v-model="changePass.newPassword1", placeholder="New Password", type="password")
    input(v-model="changePass.newPassword2", placeholder="Confirm New Password", type="password")
    button.login-button(@click="changePassword(changePass)") Change Password

</template>

<script>
  import {mapActions, mapState} from 'vuex'

  export default {
    data () {
      return {
        username: '',
        password: '',
        changePass: {
          oldPassword: '',
          newPassword1: '',
          newPassword2: ''
        }
      }
    },
    computed: {
      ...mapState({
        profile: 'profile'
      })
    },
    methods: {
      ...mapActions({
        login: 'login',
        logout: 'logout',
        resetPassword: 'resetPassword',
        changePassword: 'changePassword'
      })
    }
  }

  /*
    --documentation start--
  */
</script>
