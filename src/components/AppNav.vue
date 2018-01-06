<template lang="pug">
  .nav
    .nav__con
      .nav__con__page-up
        .nav__con__page-up__con(v-if=`layoutState !== 0`)
          img(src=`../assets/img/AppNav/home_arrow_compressed.png`, @click="navigateUp")
      .nav__con__quote “If you have dreams it is your responsibility to make them happen.” - Bel Pesce
      .nav__con__user(style="cursor: pointer;", @click="$emit('toggle-auth')")
        .nav__con__user__logged_in(v-if="loggedIn") Logged In {{userAndId}}
        .nav__con__user__logged_out(v-else) LOGIN | REGISTER
</template>

<script>
  import {mapState, mapGetters} from 'vuex'
  export default {
    data () {
      return {
        backActivated: false
      }
    },
    computed: {
      ...mapState({
        loggedIn: state => state.user.loggedIn,
        user: state => state.user.user,
        layoutState: state => state.app.layoutState
      }),
      ...mapGetters({
        userAndId: 'user/userAndId'
      })
    },
    methods: {
      navigateUp () {
        if (this.layoutState === 1) {
          this.$router.push({name: `home`})
        } else if (this.layoutState === 2) {
          this.$router.push({name: `postgres-home`})
        }
      }
    }
  }
</script>

<style lang="sass" scoped>
  @import '../assets/sass/vars'
  .nav
    z-index: 10
    position: fixed
    width: 100%
    height: 30px
    background-color: rgba(192,192,192,0.3)
    &__con
      position: relative
      margin: 0 auto
      max-width: 1200px
      padding: 0 10px
      height: 100%
      display: flex
      align-items: center
      & > div
        box-sizing: border-box
        flex: 1 1 auto
        +averia-font()
        &[class$=quote]
          flex: 3 1 auto
          +text-normal-white(0.8)
          font-size: 14px
          text-align: center
          padding: 0 9px
          letter-spacing: .02em
          @media (max-width: 900px)
            font-size: 13px
          @media (max-width: 767px)
            display: none
        &[class$=user], &[class$=page-up]
          min-width: 100px
        &[class$=user]
          font-size: 12px
          text-align: right
          +text-normal-white(1.0)
      &__page-up
        overflow: hidden
        img
          margin-top: 3px
          cursor: pointer
          width: 26px
</style>
