<template lang="pug">
  .reset-box
    input(v-model="passReset.newPassword1", placeholder="New Password", type="password")
    input(v-model="passReset.newPassword2", placeholder="Confirm New Password", type="password")
    button(@click="confirmResetPassword") Reset Password
</template>

<script>
import {mapActions} from 'vuex'
export default {
  data () {
    return {
      passReset: {
        newPassword1: '',
        newPassword2: '',
        uid: '',
        token: ''
      }
    }
  },
  methods: {
    ...mapActions({
      resetPasswordConfirm: 'resetPasswordConfirm'
    }),
    async confirmResetPassword () {
      await this.resetPasswordConfirm(this.passReset)
    }
  },
  created () {
    console.log('ROUTE CREATION')
    this.passReset.uid = this.$route.params.uid
    this.passReset.token = this.$route.params.token
  }
}
</script>

<style lang="sass" scoped>
  .reset-box
    background-color: gray

</style>
